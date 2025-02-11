+++
title = "VS Code as Git GUI"
date = 2020-04-29T08:00:00+05:30
description = "Why search for that perfect git gui? Use VS Code!"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "work", "productivity", "git"]
+++

Though I prefer *VIM*, I've been using *Visual Studio Code* also a lot for a year. It is quite fast,
has a great *python* code/debug environment and has beautiful font rendering on linux. I also use *git*
a lot and often look for different UIs to deal with it rather than remember all the commands. *gitk*, *gitg*,
*tig*, *git-cola* etc are some of the things I've used before. However, *VSCode* supports a very useful environment
right out of the box. Add a small extension *git-graph*, and I am all set.

Following is a quick screenshot tour that explains various features.

![basics](01.png)
<!-- more -->

1. This is what you get on a vanilla install. Works right-away after you open a folder that is cloned from a repo.
2. The "..." menu is pretty comprehensive.

![git-graph](02.png)

1. Install [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph) extension and you get
   the icon for that. It is also there in the bottom status bar.

![git-graph-log](03.png)

Click on that and you get a pretty beautiful graphical representation of the log.

![git-graph-log-actions](04.png)

1. Right click on any row gives you a whole range of options.

- If you simply click, that commit expands to give more info and you can also do diffs there. Very useful for code review.
- If you click on the "gear" icon, you get a bunch of settings for this repository, including setting your name and email.

![git-branch](05.png)

Coming back to the main view, see how easy it is to switch branch.

1. Current branch is shown. Click on that to...
2. Switch or create a branch.

I actually used to keep a cheatsheet of git commands for branching and merging because I keep forgetting those. No more!

There are very powerful extensions like [git lens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
and [git history](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory). I used to use those, but
decided that I don't need all those bells and whistles 90% of the time.