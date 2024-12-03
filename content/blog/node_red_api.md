+++
title = "Cook your Scripts to APIs in 5 minutes"
date = 2019-08-27T06:00:00+05:30
description = "node-red is a fantastic tool for various stuff; here a super useful unconventional usecase for it."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "api", "productivity", ]
+++
[`node-red`](https://nodered.org/) can be used to quickly convert your shell scripts
into functioning APIs. 

<!-- more -->

We all have those scripts that grow over time and does incredibly useful things
for internal use. Often, more than the core logic of those, we end up spending
time to make emails, batch processing etc.

Useful things usually get to a point where people want to build additional
systems on top of these.

APIs that generate JSON are pretty much the default standard for consuming
reusable microservices. When concurrent load is controllable like in an
intranet, node-red makes it very easy to build APIs. What started as fun project
has been proving incredibly powerful and useful for various use cases.

Following is a screenshot tour on how to make a simple bash script that adds n
days to current date and gives the new date; to a JSON API.

```sh
$cat /tmp/responder.sh
#!/bin/bash
n=${1:-0}
d=`date -d “+$n days”`
echo “{‘n’:$n,’date’:’$d’}”
```

## Getting setup - 2 min

1. Install [node-red](https://nodered.org/)
1. Start node-red server and login to http://localhost:1880/admin/
1. Read up a bit about [creating http end point from cookbook](https://cookbook.nodered.org/http/create-an-http-endpoint).

## Building your flow — 2 min

![overall flow](01.png)

Overall flow

Drag and drop _http-in, function, exec and http-out_ components from left side bar. Connect these. Note that for _exec_, it has 3 outputs and the top one is the _stdout_. Use that to connect out.

Now, double click on each of these to configure as below.

![Get http-in; url is /dateafter/variable](02.png)

Get http-in; url is /dateafter/variable

![Let us get the parameter n from request and set it as payload](03.png)

Let us get the parameter n from request and set it as payload

![Exec points to our shell script](04.png)

Exec points to our shell script

Just hit that red button on top right called *“Deploy”* and you are done! You don’t need to configure _http-out_ node at all.

## Let us test drive — 1 min
```sh
$ curl http://127.0.0.1:1880/dateafter/6
  {‘n’:6,’date’:’Mon Sep 2 07:27:36 IST 2019'}
$ curl http://127.0.0.1:1880/dateafter/-1
  {‘n’:-1,’date’:’Mon Aug 26 07:27:39 IST 2019'}
```
Isn’t it easy? Easier than cooking instant noodles :)

## Ok so what, we don’t need to have a service to compute dates!

Come on, imagine what all you can do:

1. For fun, change the script to call psql/mysql with a parameterized SQL that
   fetches data in JSON format from a db. PostgreSQL comes with JSON functions
   to convert a query output to json by simply wrapping your query into a
   sub-query with a function. Do that and give the URL to your super-duper web
   programmer to build a front end to your APIs!
1. Let us say you are an architect who needs to design complex flows
   (“orchestration” — if you want a complex word for this) and get engineers to
   understand the componentry. Just draw it up here and using the _function_
   component, you can even code the pseudo-code inside. Guess what, while proper
   code is getting built, front-end engineers can use your little node-red
   server to code the UX assuming you are giving mocked responses.
1. You want to parse parts of log files and load it into a analytics db from a
   production server; and you don’t have time to invest in kafka or other such
   things. Just do a regular cron that greps for patterns in the log files and
   send it to a node-red API as a post that simply reads the input and a script
   that appends to the analytics db.

If you go through various components available on default palette on the left;
or node-red site, I am sure you can come up with many different use cases for
helping your customers and colleagues.

PS: This article was [posted in medium.com](https://medium.com/@vsbabu/cook-your-scripts-to-apis-in-5-minutes-26844957193b) as well.