+++
title = "Generate fake data to test performance"
date = 2020-09-21T08:00:00+05:30
description = "I can't really test for scale because we don't have enough data"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "mysql", "docker", "performance", ]
+++

Often when we develop, we end up testing on our local machines with very few records
in the database. Performance testing, re-architecting your solution for scale etc needs lot of data
*already present in the db* - concurrently adding or updating 1000 records to an empty table is very different
from doing it when table already has few million records.

It is actually quite simple to generate fake data and load it into a database. To simulate
extreme stress, you don't need to generate obscene loads - you can reduce your available capacity
to small CPU/RAM and get the same effect with moderate loads.

Read below to see snippet code on how to do the first part - getting a database up (`docker + mariadb`), generating data (`python`), loading it (`usql`) and then changing database capacity  (`docker`) to see what you need to tune.

<!-- more -->

## Installation

### python 3.8
Based on your OS, install Python 3.8. I use [PyEnv](https://github.com/pyenv/pyenv) because it makes it very
easy to switch to a different version later.

### docker
[Get and install docker](https://docs.docker.com/get-docker/). It is pretty straight forward. You may need
a reboot of your machine post installation. 

Post all that, open command line and see if you can run `docker` and `docker-compose`. Both should run and print
their own error messages.

### mariadb

[MariaDB](https://mariadb.org/) is an open source fork of MySQL. Let us see which all versions are available
in docker repositories.

```sh
docker search mariadb
```

This should give a list of various images available. Pick one. Below, I am using version 10.1 of the
server.

```sh
docker pull mariadb/server:10.1
```

### usql

Oracle has SQL*Plus, PostgreSQL has psql, MySQL has mysql etc as command line clients for their databases. While
they are all good for specific databases, if you have the need to work with multiple databases, it is
better to pick one that works on all of them. I've been using [usql](https://github.com/xo/usql), a universal CLI.
Been very happy with that.

Go to the link above and install. It is very easy if you use HomeBrew.

## Generate Data

I usually generate data in CSV and keep it zipped up for reuse. 

In Python world, [Faker](https://github.com/joke2k/faker) and [Mimesis](https://mimesis.readthedocs.io/) are two
good libraries. If your objective is to create a Pandas dataframe, then see [Farsante](https://github.com/MrPowers/farsante) which works very well with Mimesis; though it seems to take more resources due to its usage of PySpark. Loading to a dataframe makes it easier for you to manipulate generated data (sorting, running sum etc) before persisting
into a file.

For now, we will use *Faker* and generate files that aren't sorted.

```sh
pip install faker dotmap
```

Let us create two files.
1. `Customer` with fields `(full_name, email, telephone, city, state, join_date)`
2. `Order` with fields `(customer_id, order_date, product)`

We can load these into two database tables viz., `customer` and `customer_order`, each with an auto-incremented integer
id as primary key. One benefit with this is that we don't need to keep looking at customer file to identify a valid customer id to fill in order, but can simply take an integer between 1 and max number of records in the customer file.

#### **`order_data_faker.py`**
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import csv
from faker import Faker
from dotmap import DotMap

#DotMap enables accessing a dictionary with dot notation.
_CUSTOMER = DotMap(
    {
        "filename": "./data/customer_data.csv",
        "max": 1000000,
        "start_date": "-2y", 
        "end_date": "-1y",
        "headers": ["full_name", "email", "telephone", "city", "state", "join_date"],
    }
) #join_date is between last 2 years
_ORDER = DotMap(
    {
        "filename": "./data/order_data.csv",
        "max": 10000000,
        "start_date": "-1y",
        "end_date": "-1d",
        "skus": ["samsung", "apple", "nokia", "sony"],
        "headers": ["customer_id", "order_date", "product"],
    }
) #order_date is between last year and yesterday

# Initialize our faker
fake = Faker("es_MX") #let us pick a locale! en_US, en_IN etc are all there

# generate customer records
# TODO: output ideally should be sorted by date
with open(_CUSTOMER.filename, "wt") as csvf:
    writer = csv.writer(csvf)
    writer.writerow(_CUSTOMER.headers)
    for i in range(_CUSTOMER.max):
        writer.writerow(
            [
                fake.name(),
                fake.free_email().replace("@", f""".{i}@"""), #ensure unique email
                fake.phone_number(),
                fake.city(),
                fake.state(),
                fake.date_between(
                    start_date=_CUSTOMER.start_date, end_date=_CUSTOMER.end_date,
                ).strftime("%Y-%m-%d %H:%M"),
            ]
        )
with open(_ORDER.filename, "wt") as csvf:
    writer = csv.writer(csvf)
    writer.writerow(_ORDER.headers)
    for i in range(_ORDER.max):
        writer.writerow(
            [
                fake.random_int(1, _CUSTOMER.max),
                fake.date_time_between(
                    start_date=_ORDER.start_date, end_date=_ORDER.end_date,
                ).strftime("%Y-%m-%d %H:%M"),
            fake.random_choices(elements=_ORDER.skus, length=1)[0],
            ],
        )
```

In the script above, we are generating 1 million customer records and 10 million order records. Depending upon
your hardware, it might take some time - say 15-30 minutes.

Note : create a sub-directory called `data` before running this script. That is where output files are written to.

## Set up MariaDB

Let us setup a database using `docker-compose`.

Create a file `stack.mariadb.yml` with content like below.

Note that if you move this to a different folder and run, another new database container will be created.
So, please decide on a folder structure first. My structure is below and I `cd` into *dbsetup* folder before executing
commands.

```
.
└── dbsetup
    ├── data
    │   ├── customer_data.csv
    │   └── order_data.csv
    ├── order_data_faker.py
    ├── order_data_loader.sql
    └── stack.mariadb.yml
```

#### **`stack.mariadb.yml`**
```yml
version: '3.1'

services:

  db:
    image: mariadb/server:10.1 #we already pulled this image
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: changeme
      MYSQL_DATABASE: mariadbtest
      MYSQL_USER: scott              #additional user if you need
      MYSQL_PASSWORD: tiger
    ports:
      - 3306:3306 #internal 3306 is exposed to you as 3306
    volumes:
      - ./data:/tmp/data  #your subdir `data` will be visible inside container as `/tmp/data`. 
    deploy:
      resources: #you can shutdown machine, change these values and restart to experiment
        limits:
          cpus: 1
          memory: 200M
        reservations:
          cpus: 1
          memory: 100M

```

It is now fairly easy to start the database machine. Just *up* it!

```sh
docker-compose -f stack.mariadb.yml up
```

It will take a while the first time. Then onwards it should be ready to serve within seconds.

Test if you can connect to it by running:

```sh
usql my://root:changeme@localhost:3306/mariadbtest
```

You should get the database prompt.

## Load Data

#### **`order_data_loader.sql`**
```sql
-- basic tables; no indexes other than those created by primary keys and constraints.
drop table if exists customer_order;
drop table if exists customer;
create table customer (
  id int not null auto_increment primary key,
  full_name varchar(100) not null,
  email varchar(100),
  telephone varchar(20),
  city varchar(32) not null,
  state varchar(32) not null,
  join_date datetime not null,
  constraint uc_email unique(email)
) engine = innodb;

create table customer_order (
  id int not null auto_increment primary key,
  customer_id int not null,
  order_date datetime not null,
  product varchar(16) not null,
  constraint fk_customer foreign key (customer_id) references customer(id) on update cascade on delete cascade
) engine = innodb;

-- load the files generated. we need to mask
--  date field to right format for correct load.
load data infile '/tmp/data/customer_data.csv' ignore
  into table customer
  fields terminated by ','
  optionally enclosed by '"'
  lines terminated by '\n'
  ignore 1 rows
  (full_name, email, telephone, city, state, @join_date)
  set join_date = str_to_date(@join_date, '%Y-%m-%d %H:%i');

load data infile '/tmp/data/order_data.csv' ignore
  into table customer_order
  fields terminated by ','
  optionally enclosed by '"'
  lines terminated by '\n'
  ignore 1 rows
  (customer_id, @order_date, product)
  set order_date = str_to_date(@order_date, '%Y-%m-%d %H:%i');

-- -- let us try some queries
-- who are the customers who ordered most items in what duration?
select customer_id, count(1), min(order_date), max(order_date) from customer_order group by 1 order by 2 desc limit 10;
```

You can load it from within `usql` prompt or like below.

```sh
usql my://root:changeme@localhost:3306/mariadbtest -f order_data_loader.sql
```

On a docker container to which I allocated 2GB memory, it took about 5 minutes to load these files.

Now you can shutdown the container (CTRL-C), change the `stack.mariadb.yml` file to have lesser/more memory and CPU
and bring it up again. Test it for speed for different queries.
