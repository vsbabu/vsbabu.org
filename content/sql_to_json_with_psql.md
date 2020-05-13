+++
title = "Generate JSON from PostgreSQL"
date = 2020-05-13T14:00:00+05:30
description = "You can easily format your query output as JSON!"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "datascience", "database", "api"]
+++

So, you have a *postgresql* production database with a 
slave instance being used for reports and ad-hoc queries. Every
now and then you get the same kind of data requests, but for
different customers, orders etc. Instead of sharing SQL templates
to different users and  getting them setup to query, it is very
easy to make quick shell scripts that output JSON formatted data.  Then, you can easily have your web developers build UI for search and display. 

Read on to install local database using docker, fill it up with sample
data, script psql, then enhance it to wrap with JSONification and 
finally hooking up script to be an API.
<!-- more -->

## PostgreSQL JSON functions

### row_to_json()

This converts each row in the list to a JSON k:v pair. Very useful
if you want to get the records to be processed as a stream, for example, posting to a queue one by one.

```sql
select row_to_json(x) as records from (
select first_name, last_name, email from customer 
order by customer_id
desc limit 5
) as x;
```

This will output 5 individual JSON documents.

However, for a real API, we will need one JSON document that has 5
nodes inside it. 

### array_to_json()

This function converts an array into a JSON list. So, first we need to
merge all our output records to a single array. We can use *array_agg()*
for that.

```sql
select array_to_json(array_agg(x)) as records from (
select first_name, last_name, email from customer 
order by customer_id
desc limit 5
) as x;
```

This gives one single JSON document which has 5 items inside. Perfect!

Reference: [PostgreSQL JSON functons](https://www.postgresql.org/docs/12/functions-json.html)

## Testing it all out

We can quickly setup a sample PostgreSQL server using *docker*. I prefer native installation, but
using *docker* here so that I can quickly delete it once I am done.

Installing *docker* on Ubuntu or variants is very easy. Just follow 
[the instructions](https://docs.docker.com/engine/install/ubuntu/) and
then [post install to run as regular user](https://docs.docker.com/engine/install/linux-postinstall/).

Now, let us create a *docker* machine to host our sample.

```sh
# Fetch the image and keep it available for reusing for later
docker create -v /var/lib/postgresql/data \
    --name postgres-database postgres:latest
# Now, let us run a machine named local-postgres on port 5432
# with password as password, and using the image and volume from above
docker run --name local-postgres -p 5432:5432 \
    -e POSTGRES_PASSWORD=password \
    -d --volumes-from postgres-database \
    postgres:latest
```
This should start the server. Now, to connect and for further development,
we need a good, scriptable command line interface. `psql` works best for me
and that can be installed in Ubuntu using:

```sh
sudo apt install postgresql-client postgresql-client-common
```

We can connect to our database using:

```sh
PGPASSWORD=password psql -h localhost -p 5432 -U postgres -d postgres
```

---

Let us install some sample data. There is this famous [MySQL Sakila schema](https://dev.mysql.com/doc/sakila/en/sakila-structure.html) which is ported as [Pagila in PostgreSQL](https://github.com/devrimgunduz/pagila).

Download/clone the *Pagila* database into some folder and then from that folder,
connect to our database using *psql* command above. From the *psql* prompt, we can
load up the database with following scripts.

```sql
\i pagila-schama.sql
\i pagila-insert-data.sql
```

Note that this will take some time to complete. After that is done, try using `\dt` to
see the tables that are loaded and also query some data - the examples in the beginning
of this article will work.

### Scripting psql

You would've noticed that *psql* prints a banner, some settings and timing information for
the queries you executed. All of these will interfere with a valid JSON format you want to
output.

Let us fix that.

```
PGPASSWORD=password psql -qtA -h localhost -p 5432 -U postgres -d postgres "$@" | sed '$d'
```

- *-qtA* will make the command quieter, print tuples-only (ie. only data and no header)
  and remove alignment.
- *sed* will remove the last line which is the timing information

Let us create a file called `csql` with this content above and make it executable (`chmod +x csql`).

Now, let us test out our one liner with a query.

```sh
echo 'select * from customer where customer_id in (269,270);'|./csql
```

We should get

```
269|1|CASSANDRA|WALTERS|CASSANDRA.WALTERS@sakilacustomer.org|274|t|2017-02-14|2017-02-15 09:57:20+00|1
270|1|LEAH|CURTIS|LEAH.CURTIS@sakilacustomer.org|275|t|2017-02-14|2017-02-15 09:57:20+00|1
```

No heading, no timing etc.

Let us try adding JSON stuff. I've added *jq* to get formatted output.

```sh
echo "select array_to_json(array_agg(x)) as records from 
   (select * from customer where 
   customer_id in (269,270)) as x"|./csql | jq "."
```

Works great! Here is the output.

```json
[
  {
    "customer_id": 269,
    "store_id": 1,
    "first_name": "CASSANDRA",
    "last_name": "WALTERS",
    "email": "CASSANDRA.WALTERS@sakilacustomer.org",
    "address_id": 274,
    "activebool": true,
    "create_date": "2017-02-14",
    "last_update": "2017-02-15T09:57:20+00:00",
    "active": 1
  },
  {
    "customer_id": 270,
    "store_id": 1,
    "first_name": "LEAH",
    "last_name": "CURTIS",
    "email": "LEAH.CURTIS@sakilacustomer.org",
    "address_id": 275,
    "activebool": true,
    "create_date": "2017-02-14",
    "last_update": "2017-02-15T09:57:20+00:00",
    "active": 1
  }
]
```

---

Let us make a `jcsql` that surrounds a SQL with JSON'ification!

```sh
#!/bin/bash
t=`mktemp`
awk 'BEGIN {print("select array_to_json(array_agg(x)) as records from ("); }
    { print($0); }
     END { print(") as x");}' > $t
cat $t| \
    PGPASSWORD=password psql -qtA -h localhost -p 5432 -U postgres -d postgres  \
    | sed '$d' \
    | jq -r "."
rm -f $t
```

Now we can simply do `echo "select * from customer limit 5;"|./jcsql`!

### Nested/Complex JSONs

The sample db also has payments done by customers. For a given list of customers, if you
want to get their latest 5 payments also in the object, it is a bit tricky. We have to
add child records jsonification ourselves in the SQL.

```sql
select c.*,  
(
  select array_to_json(array_agg(t)) as txns from (
    select * from
    payment t where t.customer_id = c.customer_id
    order by payment_date desc limit 5
  )
  as t)  as payments
from 
customer c where c.customer_id in (269,270)
```

Truncated output is below.

```json
[
  {
    "customer_id": 269,
    "store_id": 1,
    "first_name": "CASSANDRA",
    "last_name": "WALTERS",
    "email": "CASSANDRA.WALTERS@sakilacustomer.org",
    ...
    "payments": [
      {
        "payment_id": 31920,
        "customer_id": 269,
        "staff_id": 2,
        "rental_id": 12610,
        "amount": 0,
        "payment_date": "2017-05-14T13:44:29.996577+00:00"
      },
      {
        "payment_id": 31919,
        "customer_id": 269,
        "staff_id": 1,
        "rental_id": 13025,
        "amount": 3.98,
        "payment_date": "2017-05-14T13:44:29.996577+00:00"
      },
      ...
    ]
    ...
  }
]
```

### API'zing your Selects

This is now very easy

- Write a `getcustomer.sh` that takes customer_id as a command line argument.
- It then generates a SQL file which is passed to `jcsql` which simply prints the JSON output.
- To make this shell script to an API, read about 
  [cooking your scripts to APIs in 5 minutes](http://vsbabu.org/twenties/node_red_api/)!
- If you want authentication to your company employees only, proxy node-red with
  [oauth2_proxy](https://oauth2-proxy.github.io/oauth2-proxy/)
- Now build a web UI using this!

It might sound a little too much work; but note that you will spend time only for the initial
setup. Once all done, for new kind of data requirements, all you will do is to:

- Write a SQL to get the data. You have to do it anyway.
- Wrap it in a shell script to pass arguments.
- Drag and drop an endpoint in node-red to make an API.
- Deploy.

I actually find it very useful to quickly whip up APIs for demos as well.

In fact, I built a portal for authorized colleagues to look at certain data for customers
who raised support tickets. For a weekend project, it has been heavily used since 2016 and number
of users have grown to 100.