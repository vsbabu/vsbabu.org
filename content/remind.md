+++
title = "Remind - it does what it's name says!"
date = 2020-03-03T06:00:00+05:30
description = "Just don't forget anything - use this wonderful little Unix tool that runs on plain text."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "cli", "productivity", ]
+++
`remind` is a classic command line unix utility. A very simple collection of text
files hold all your reminders in a readable format. Let us make a quick cron job
using this to send daily notification emails.

<!-- more -->

[roaringpenguin.com's project page](https://dianne.skoll.ca/projects/remind/) is
a good starter. However, to dive right into the capabilities, [Diane Skoll's  article](https://www.linuxjournal.com/article/3529) is a must read. 

## Key Features
* Fantastic DSL. Just check the [cookbook](https://www.roaringpenguin.com/wiki/index.php/Remind_Cookbook) to get a flavour!
* Not just regular reminders, but repeated ones too.
* Include files. You can have multiple reminder files and custom combinations of those included into other files.
* You can run `remind` on any specific file. This makes it incredibily powerful to create custom usecases.

General principle is very simple - you add reminders with a very generous English like DSL to a file. Run 
`remind` to print applicable reminders from that file.

## Fun - Daily Mail

Most companies have someone who sends emails on employee's anniversaries. This is such a piece of 
cake with `remind`.

Let us say the input data is a CSV file like below.

 empid | name             | gender | joined_on   | manager   | department 
-------|------------------|--------|-------------|-----------|------------
 1     | Superman Clark   | Male   | 20 OCT 2010 | Lois Lane | krypton    
 2     | Spiderman Parker | Male   | 03 MAR 2016 | Mary Jane | rooftop   

We can easily create a `joindates.rem` reminder file from this like so.
```
REM Oct 20 MSG ANNIVERSARY Superman Clark (krypton) since 2010 %b %
REM MAR 03 MSG ANNIVERSARY Spiderman Parker (rooftop) since 2016 %b %
```

Now, when I run `remind joindates.rem`, I get the nice output like below.
```sh
Reminders for Tuesday, 3rd March, 2020 (today):

ANNIVERSARY Spiderman Parker (rooftop) since 2016 today 
```

By now, you would've figured out that the last _%b_ in the reminder entry is for 
relative date (today in this case). We can also add a _+3_ after MSG to start 
reminding from 3 days prior - in that case _%b_ will go like _in 2 days_, _tomorrow_, _today_ etc.

We can easily write a quick _python3_ script to parse the CSV to generate the reminder file.

```python
#!/usr/bin/env python3
with open("EmployeeData.csv") as tsvfile:
	tsvreader = csv.reader(tsvfile)
	lines = []
	for line in tsvreader:
  	(empid, name, gender, dt, mgr, dept) = line
		if empid == 'empid':
			continue
		try:
			joindt = datetime.datetime.strptime(dt, '%d %b %Y').date()
		except:
			continue
		lines.append([name, joindt, dept])
		reminder_date = joindt.strftime("%b %d")
		reminder_year = joindt.strftime("%Y")
		print("REM %s MSG ANNIVERSARY %s (%s) since %s %%b %%" % (reminder_date, name,  dept, reminder_year))
```

All we need now is a cron job that runs once a day.

```sh
#!/bin/bash
t=`mktemp`
remind joindates.rem > $t
SENDIT=`grep -c "No reminders." $t`
if [ $SENDIT -ne 1 ]; then
  cat $t | mailer #mailer is a script that uses mutt/mailx to mail the info
fi
rm -f $t
```
Instead of CSV, have a Google sheet that has up to date employee information, we can 
easily download that and generate the reminder files every day.

## Onboarding Stuff
Similarly, there can be lot more quick usecases. Typically, organizations have some X
weeks for completion of probation period - that also can easily be handled by a remind entry
like below. Let us say probation period is 1 month.
```
REM 2016-04-03 MSG 1mo completion Spiderman Parker (rooftop) since 2016-03-03 %b %
```

This will remind exactly once because we are giving a full date here; unlike ANNIVERSARY where we are not specifying year.

## Adventurous?

`remind` can also run programs! 
```
REM MAR 03 RUN order_flowers.sh "Spiderman Parker" %
```

I will leave it to you to write an `order_flowers.sh` script to order and ship it :)

And a lot more. If you've free time, now is a good time to go do a `man
remind`.

[discuss on linked.in](https://www.linkedin.com/posts/vsbabu_remind-it-does-what-its-name-says-activity-6640407375289376768-Epcb/)
