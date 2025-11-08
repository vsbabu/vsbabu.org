+++
title = "Google Appsheet to build a quick journal app"
date = 2025-11-08T11:30:00+05:30
description = "Discovered Google Appsheet and built a super quick app for journalling."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "app", "journal", "data"]
+++
{{ admonition(type="tip", text="<ul>
   <li>Personal Apps</li>
   <li>Build prototypes than text heavy PRDs</li>
   <li>Team Apps for quick data entry and view</li>
   <li>CxO dashboard apps</li>
   </ul>") }}


Only recently I learned about Google [appsheet](https://www.appsheet.com). Very quick, no-code way to build responsive web apps with automatic Google authentication. Perfect for building apps for intranet users. I took about 3 hours to build a personal app that helps me maintain a journal. First 2 hours were spent in reading docs and building the app and one hour to beautify it. Data is backed into a Google sheet. This is a screenshot tour of the app. There are plenty of tutorials, examples and videos on Appsheet site - so not repeating all those here. Only the specific things I ended up doing and things I still need to figure out are going to be here.


<!-- more -->

## App Requirements

1. Should be very quick to enter an entry. I needed something that is like a personal twitter log. Just type in stuff with _@_ and _#_ prefixed as tags. Autocomplete would have been nice, but not needed. Google Keyboard with voice entry support is super useful. Quick way to record mood (reg, yellow, green) and optional GPS location.
1. Timestamp is auto captured and should be editable on new entry.
1. Should be able to select an entry and edit everything except original timestamp.
1. Should be able to select an entry and duplicate it with timestamp alone defaulting to new time. Others are copied and editable.
1. Should be able to select one or more entries and delete.
1. Tags entered should be parsed out and available for filter.
1. Visualization by latest 30 days as a list, calendar, mood and location.
1. Should be able to edit Google Sheet standalone and data refreshed in the app.
1. Offline data entry and sync should be nice

All of these except one are available with no code in Appsheet. For parsing tags alone, I had to add a Google Sheets formula.

### Landing Page
![Home Screen](01_home.png) 

### "+" Add Entry
![Add](02_add.png) 

Edit is similar. It has an additional action to duplicate selected entry.

![Edit](02_edit.png) 


### Calendar
![Calendar](03_cal.png) 

Mood is a simple doughnut chart.

![Mood](04_mood.png) 


### Map
![Map](04_map.png) 

### Search

All views from the bottom bar filters automatically to the search given. Here is the filtered map view.
![Search](05_search.png) 

### Tag list
![Menu](06_menu.png) 

Clicking on a tag will take you to filtered tag list. 
![Tags](06_tags.png) 

I'd have preferred that it fills the search form at the top and then filters. That is still to be figured out. 


## App Settings

Appsheet is not free to use. I had to go to app settings and mark category as *Personal Solution* and choose *Personal Use Only* checkbox. 
Because of that, I can't distribute this. However, for Google Workspace users, monthly billing rates are reasonable to distribute to your own users especially considering super fast way to build apps with responsiveness and offline capability.

Since you can refresh backing data independent of appsheet, your data warehouse jobs can augment the data behind the scenes to provide hybrid functionality apps that support real time, offline and large data summarized.


## Data Settings

### Filtering
Appsheet supports _data sources_ and _data slices_ within those sources. My data source  was a Google Sheet and I created a slice with expression `[Date] > (TODAY() - 30)` where _[Date]_ is my column name to make a slice of latest 30 days of data.

### Formula
For parsing out tags, I had a column named _[Tags]_ for which I added following formula in _Auto Compute_ settings.
```
trim(regexreplace(regexreplace(lower(RC[-4]),"([#@][a-z0-9_]+)|(.)","$1 "),"\s+"," "))
```
This formula is copied to backing Google Sheet whenever a record is created. The formula is a regular expression that
removes everything other than words starting with _@_ or _#_. Inner one replaces other words by spaces and outer one
squeezes spaces to just one space. So you get a space separated tag list in the _[Tag]_ column.

### Tag list
For building the Tag List, a new tab called _Tags_ in the backing Sheet was created. A formula was added to _A2_ to
get sorted unique list of tags (column F) from the sheet that stores journal entries.

```
=SORT(UNIQUE(FLATTEN(ARRAYFORMULA(IFERROR(SPLIT('JournalEntries'!F2:F, " ", TRUE, TRUE),"")))))
```

In this tab, column B has the count - that is a simpler formula which takes value from tag column and does
a wildcard count on column F (_Tag_) on entries sheet to check if tag is contained there. Since I don't expect to have more than 
100 tags ever, just copied this cell formula to 100 rows.


```
=IF(A2<>"", COUNTIF('JournalEntries'!F:F, "*"&A2&"*"),"")
```

## What Next

1. Adding a mobile desktop icon. Currently I just navigate to this page and leave it open in a tab on the mobile browser. Mobile desktop icon automatically links only to overall appsheet site editor and not to particular app. Also, it somehow seems to loose my Google login, forcing me to login every time.
2. The Map entry when you are recording an entry later is a bit difficult to use. Two finger scrolling doesn't work on the map widget. So one has to zoom out, move the pin around, zoom in, place the pin etc. It seems to be designed specifically for "get current location" only. Workaround is to copy lat/long from Google Maps and  paste it.
3. I am using timestamp as primary key - not good taste! Appsheet provides `UNIQUEID()` function which I should've used - too lazy to fix existing data with that.
4. To distribute with an ability for people to create their own backing Google Sheet. This is critical for personal apps.
5. It supports events and actions. Technically, that should be enough for me to schedule reminders too as a future journal - should be fun to implement.

Overall, this is a fantastic platform.
