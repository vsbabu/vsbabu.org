+++
title = "SQLite3 CTE for Calmap visualization"
date = 2025-02-21T06:00:00+05:30
description = "Data grouped by dates can easily be printed like GitHup contribution maps by weeks."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "visualization", "database"]
+++
If you are new to [sqlite3](https://www.sqlite.org) or to CTEs, check the [first part, timeseries analysis with CTEs](/blog/sqlite3-cte-tricks-for-time-series-analysis/).
Now, let us assume that you've a table that has some metrics. If you don't have one, you can checkout [meterite](https://github.com/vsbabu/meterite), my project to log
metrics into a sqlite3 table :). For this article, we will assume a simple one.

<!-- more -->

## Basics

Let us create a new database and add a table that has just three columns, viz., a primary key, a date in yyyy-mm-dd format and some meter value. 

```sh
sqlite3 metrics.db
> CREATE TABLE meter (id TEXT NOT NULL PRIMARY KEY,  dt TEXT, metric NUMERIC);
> CREATE INDEX idx_dt ON meter(dt);
>.q
```
Fill it up with some fake data. There are many ways to do it. Here is one from my blog about [generating large fake datasets](/blog/docker_mysql_data).

## Querying with CTEs

Now, let us build a CTE query. See below how different CTEs are below step-by-step.

```sql
WITH RECURSIVE
  -- [1] ideally, these parameters come from some form to 
  --     define a date range
  params AS (SELECT date('2024-07-04') as begin_cal, 
                    date('2024-08-10') as end_cal),
  -- [2] now expand the range to include preceding sunday
  --     and ending saturday
  bounds AS (SELECT begin_cal, end_cal,
              date(begin_cal, 'weekday 0', '-7 days') begin_sun,
              date(end_cal, 'weekday 6') end_sat FROM params),
  -- [3] This is the recursive CTE to generate all dates between bounds 
  all_dates AS (
    -- week is formatted as yyyy-week_number
    SELECT strftime('%Y-%U', begin_sun) as week, begin_sun dt
    FROM bounds
     UNION ALL
    SELECT
        -- recursively add 1 day to generate dates
        strftime('%Y-%U', date(dt, '+1 day')) as week,
        date(dt, '+1 day') dt
  FROM bounds, all_dates where  dt < bounds.end_sat
  ),
  -- [4] THIS IS YOUR CTE FOR GETTING METRICS 
  meter_summary AS (
    -- In this one, I am grouping meter by day into daily values as sums.
    SELECT
    date(x.dt) AS dt, SUM(x.metric) val FROM params p, meter x
    WHERE date(x.dt) BETWEEN p.begin_cal AND p.end_cal
    GROUP BY x.dt
  ),
  -- [5] This CTE fills up dates with corresponding metric data if it exists
  all_dates_metric AS (
    SELECT ad.week, ad.dt, m.val from all_dates ad LEFT JOIN meter_summary  m
    ON ad.dt = m.dt
  )
  -- [6] Now fold the metrics by date into weeks as calendar visualization
  --     Note: this max is just to remove repetition of rows. You can use min also 
  --     to get the same values.
  SELECT adm.week, min(adm.dt) as starting,
    max(iif('0'=strftime('%w',adm.dt), adm.val, null)) sun,
    max(iif('1'=strftime('%w',adm.dt), adm.val, null)) mon,
    max(iif('2'=strftime('%w',adm.dt), adm.val, null)) tue,
    max(iif('3'=strftime('%w',adm.dt), adm.val, null)) wed,
    max(iif('4'=strftime('%w',adm.dt), adm.val, null)) thu,
    max(iif('5'=strftime('%w',adm.dt), adm.val, null)) fri,
    max(iif('6'=strftime('%w',adm.dt), adm.val, null)) sat
FROM bounds, all_dates_metric adm
GROUP BY adm.week
;
```

And the output is exactly what I need!

|  week   |  starting  |  sun    |  mon  |   tue   |   wed  |    thu    |    fri   |   sat   |
|--------:|-----------:|--------:|------:|--------:|-------:|----------:|---------:|--------:|
| 2024-26 | 2024-06-30 |         |       |         |        | 1270      | 1024     | 1292    |
| 2024-27 | 2024-07-07 | 2426    | 1303  | 680     | 529    | 1648      | 3459     | 2538    |
| 2024-28 | 2024-07-14 | 1145    |       | 640     |        | 7694      | 5693     | 3277    |
| 2024-29 | 2024-07-21 | 7504    | 1559  | 1000    | 4181   | 2972      | 1888     | 480     |
| 2024-30 | 2024-07-28 | 1778    | 7850  | 2643    | 1700   | 3767      | 2111     | 5596    |
| 2024-31 | 2024-08-04 | 6533    | 6608  | 1464    | 830    | 5405      | 6502     | 6875    |


{{ admonition(type="info", text="Calmap usually have weekdays as rows. Fixed columns are much easier in SQL - hence my choice of query above.") }}
