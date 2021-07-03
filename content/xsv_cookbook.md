+++
title = "XSV Cookbook"
date = 2021-07-03T08:00:00+05:30
description = "Recipes I usually use with XSV - swiss army knife for field separated files"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "unix", "utilities",  "snippet"]
+++

[XSV](https://github.com/BurntSushi/xsv) is an extremely fast CLI utility to process csv/tsv/psv files. Extremely helpful to <u>*automate*</u> data extraction, format conversions, filters etc. 

It comes with an extensive man page and website also has great documentation. Still, noting down some of the common ways I use it below.

<!-- more -->
First, download from the tool's [site](https://github.com/BurntSushi/xsv) at  or `brew install xsv`

### Inspect file

```bash
#field type, statistics
xsv stats sample.csv 

#count records
xsv count sample.csv 

#flatten file and show record by record
xsv flatten sample.csv

#nicely readable flat output for statistics
xsv stats sample.csv|xsv flatten
#or show as nicely aligned table
xsv stats sample.csv|xsv table

#create an index file for fast processing. Very useful on large files. Not needed for smaller files
#and when you update the file, you need recreate the index file too.
xsv index sample.csv
```

### File format conversion

Best part is that you don't have to worry about header rows, escaping characters etc.

```bash
#csv to psv (pipe separated)
xsv fmt -t \| sample.csv
#tab separated to csv
xsv fmt -d "^I" sample.tsv
#tsv to psv
xsv fmt -d \| -t "^I" sample.psv 
```

Note that `"^I"` indicates a TAB character - you can type that in terminal by CTRL-V-I. 

### Split & Merge files

```bash
# split file into multiple files by a column - aka partition
#   adds one file per value of office field in directory t/
xsv partition office t/ employees.csv  

#split the file every 1000 records into directory t/
xsv split -s 1000 t/ employees.csv

#merge rows from multiple files without duplicating header record
xsv cat rows t/*.csv 
```

### Select Data

```bash
#random select 4 records
xsv sample 4 employees.csv

# select two columns by name
xsv select department,empid employees.csv
# select first and third column
xsv select 1,3 employees.csv
# select first to second column
xsv select 1-2 employee.csv 
# select first and third column in another order
xsv select 3,1 employees.csv

# and sort output in reverse order of department
xsv select 3,1 employees.csv.csv|xsv sort -R -s department 

# extract 2nd row to 4th row
xsv slice -s 2 -e 5 employees.csv
# extract 3 rows starting from second row
xsv slice -s 2 -l 3 employees.csv

# filter by regex "galore" ignoring case
xsv search -i "galore" employees.csv
# filter by regex NOT "galore" ignoring case
xsv search -i -v "galore" employees.csv
```

### Joins

```bash
# inner join on cities.city = employees.office
xsv join city cities.csv office employees.csv
# left and right joins
xsv join --left city cities.csv office employees.csv
xsv join --right city cities.csv office employees.csv
```
