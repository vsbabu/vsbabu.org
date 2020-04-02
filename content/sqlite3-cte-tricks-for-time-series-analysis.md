+++
title = "SQLite3 CTE tricks for time series analysis"
date = 2018-10-25T06:00:00+05:30
description = "Hands on analyze git log data with SQLite3 CTEs!"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "cli", "productivity", "database"]
+++
SQL has been there for ages. [sqlite3](https://www.sqlite.org) gives you a
phenomenal tool to quickly load and analyse data in a  language meant for that.
While I’ve used it for a long time, only recently did I know about support for
[CTE](https://www.sqlite.org/lang_with.html) aka Common Table Expressions.
<!-- more -->

![sample session](01.png)
this has everything; or you just read below :)

Quick (and overly simplified) definition of CTE? This is where you can park
sub-queries  into expressions and use those expressions in your query. Kind of
like defining views on the fly.

## Basics
* Go to the site and download the executable; put it somewhere in the path.
* Read the [CLI manual](https://www.sqlite.org/cli.html).

Let us create a new database and add a table that has just two columns, one for date and one for some entry.
```sh
sqlite3 log.db
> create table journal (dt text, tx text);
> -- exit
>.q
```
Let us prepare some data first. I’ve chosen to generate a two column tab
separated file from _git log_ output of [one of my personal
repositories](https://github.com/vsbabu/configs).

```sh
git log --date=format:'%Y-%m-%d' --pretty=format:'%ad%x09%s'  > git.log
```
If you are wondering, that _%x09_ is the tab character.
To load this into our _journal_ table is a piece of cake.

```sh
sqlite3 log.db
>.mode tabs
>.import git.log journal
>.q
```
`.import` is extremely good that if table is not there, it creates one using the
first row’s columns as field names. Since I didn’t massage the `git log` output
to add a header column, I pre-created the table. Here is an easy way to add a
header row.

```sh
git log  --date=format:'%Y-%m-%d' --pretty=format:'%ad%x09%s'  |sed '1 i\dt\ttx' > git.log
```

Let us say we want to make a
[project-hub](https://24ways.org/2013/project-hubs/) from a time-series data;
well not as pretty as it is there in the article. This is a fairly simple thing
to just query for date and text and displaying it.

```sql
select dt, tx from journal order by dt desc;
```

Now, let us say we can also print the date as “how many days” ago. Even that is equally simple.

```sql
select dt, tx, julianday('now', dt) as ago from journal order by dt desc;
```

## How do I compare with previous record?

Making things harder, I also want another column called _gap_, which shows how
many days elapsed between current record’s date and previous record’s date. This
is so useful to quickly give an idea about how many days have elapsed with no
work.

Now, let us make a CTE to hold the output.

```sql
with cte as (select row_number() over (order by dt) as rownum, dt, tx from journal)
```

Joining this with itself gives us exactly what we need. I’ve added some cast and
round functions as illustrations to reduce the floating points to integers.

```sql
with cte as (select row_number() over (order by dt) as rownum, dt, tx from journal)
select
  cur.dt, 
  cast(round(julianday('now', 'start of day')
            -julianday(cur.dt),0) as integer) as ago,
  cast(round(julianday(cur.dt)
            -julianday(prev.dt),0) as integer) as gap,
  cur.tx
from cte cur
inner join cte prev on prev.rownum = cur.rownum - 1
order by 1 desc;
```

And the output is exactly what I need!
```
dt          ago         gap         tx                  
----------  ----------  ----------  --------------------
2018-10-21  4           114         Added Basil-X-Darker
2018-06-29  118         473         Steps post installat
2017-03-13  591         70          Added tmux config   
2017-01-02  661         13          Simple script to che
2016-12-20  674         27          Added post install s
2016-11-23  701         8           Split into mint-x an
2016-11-15  709         0           Create README.md    
2016-11-15  709         0           Initial commit      
2016-11-15  709         0           Initial commit
```

As you can see, if you take the 2nd row from top, it says that was 118 days ago
as of this writing; and it was 473 days AFTER the commit before that. Looks like
I didn’t play with configs for pretty much of 2017 :)

Add a `.mode html` before running the SQL, and you get the output as an html
table that can be viewed in a browser or emailed.

Every single thing that worked in the `sqlite3` shell can be put into a file and
piped in to easily make this as a script.

SQLite also supports subqueries in `from` clause; this gives you even more power
to make CTEs that hold just latest/max values etc from some queries with group
by, and then compare it against others. For example, if you are taking your
cloud hosting provider’s bill 3 times a day; and you just want to take the
latest value in that for a day and compare with latest value in a previous day,
this becomes quite useful.

More to learn… and more to post as I discover :)

PS: This was [posted in
medium.com](https://medium.com/@vsbabu/sqlite3-cte-tricks-for-time-series-analysis-196dbf3ffdf9)
as well.