+++
title = "0to1: doom-emacs and org-mode"
date = 2020-06-15T08:00:00+05:30
description = "Heard about org-mode, but afraid of emacs? I was. Here is how to get going!"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "emacs", "org-mode", "productivity", "0to1"]
+++

Are you like me?
- Know VIM/VI enough
- Heard about emacs and org-mode
- Tried it and got turned off by so many commands
- Read too much documentation
- Spent hours configuring these :)
- Thumb started aching with C and M multi-key combinations
- Tried [Spacemacs](https://www.spacemacs.org/)
- Went back to VIM

If yes, this is how I crossed over to actually using org-mode productively to maintain my notes, projects and todo.
[doom-emacs](https://github.com/hlissner/doom-emacs) is the framework I used. It is superfast, has sane keys and UX
and configuration does not need you to read and practice emacs.

Following is a 0to1 guide that  ideally should've been more interesting with screenshots, but keeping it as copy-pastable text!

<!-- more -->
Note - I am not going into what all can be done using [Org Mode](https://orgmode.org/)!

## Installation

1. Get `Emacs 26+`. For Ubuntu, follow this [write up to use kelleyk/emacs](http://ubuntuhandbook.org/index.php/2019/02/install-gnu-emacs-26-1-ubuntu-18-04-16-04-18-10/) repository. *Note that there is a good chance that emacs will not start 
   under GTK; so make a shortcut to a script that has the following content*.
   ```sh
   /usr/bin/env  XLIB_SKIP_ARGB_VISUALS=1 /usr/bin/emacs26 "$@"
   ```
2. Install `git` command line.
3. Follow [instructions to install doom-emacs](https://github.com/hlissner/doom-emacs#prerequisites). This will take some time 
   to download and install the packages. 
   ```
   Say "Y" when it asks to create an ENV file
   Say "Y" when it asks to install additional fonts 
     this makes your config quite nice
   ```

## Setup

1. Start `emacs`
2. On the first page, you will see some options. Use arrow keys (or j/k like VI) to navigate and Choose *Open private configuration*. You can see that it says *SPC f p* next to it. That is the short cut to go to that option later.
3. Now you can see that configuration is all in `~/.doom.d/`. You really need to edit only *config.el*. Use mouse or arrow keys to select. Or just start typing *con* followed by ***TAB** to autocomplete and **ENTER***. This is a common pattern in doom-emacs world. This kind of command windows all support autocompletion.
    ```
    Find file: ~/.doom.d/
    --------------------------------------------------------------
    ./
    ../
    config.el
    init.el
    packages.el
    ```
4. Now that `config.el` is open, edit it. It is good to update your name and email address at the top.
5. Scroll down (arrow keys or j) and edit the value for *doom-font*. I've tried this in 3 different laptops and default size is always too small for me. Increase it. This is how mine looks - I really liked [Iosevka fonts](https://github.com/be5invis/Iosevka) and had installed it.
   ```lisp
   (setq doom-font (font-spec :family "Iosevka Term SS04 Extended" :size 18 )
      doom-variable-pitch-font (font-spec :family "sans" :size 15))
    ```
6. `org-directory` is set to *~/org/*. I changed it to *~/Dropbox/org/* to not worry about backups. This is where all your default org files will go to. We will get to what is *default* files later.
7. Save it. `:w` will work just like in VI.
8. Let us see if you want to change the default theme from `doom-one`. Type **M-x (ie meta-x which is Alt-x in Win/Linux and Cmd-x in Mac)**. Whole bunch of commands show up. Type *load-theme* and you can see that auto-complete is in action. This command has a menu which lists all the themes. *doom-one-light* is a neat light theme. It will ask you to run that lisp code and mark it as safe for later too - you can answer y.
9. If you liked this theme and want to make it permanent, edit *doom-theme* in *config.el* to set this value.
10. Exit! Yeah - `:x`.

## Basic org-mode bindings
1. Open *emacs*
2. Let us create a */tmp/scratch.org* to play with it. Yes, `:e /tmp/scratch.org` will work like in VI.
3. I am not going into org-mode basics here, but suffice it to say that lines prefixed with one asterisk is top level headline; with two is second level and so on.
4. Add a line `* headline 1`
5. Let us add another top level headline. Just hit `Ctrl-Enter` and type ` headline 2`. You got it!
   ```
   Ctrl-Enter => Create a sibling below
   Ctrl-Shift-Enter => Create a sibling above

   Ctrl is usually referred to as C only
   ```
   This is a great key to remember. Works for all semantic levels.
6. Now let us add some content to *headline 1*. Navigate to that and do *O*. Just like VI, *O*, it adds a new line. Edit away!
7. Let us navigate back to the headline. 
   ```
   TAB - collapses (fold) and expands (unfold) the headline. Try it!
   Shift-TAB - will collapse all headlines
   ```
8. You want to focus on one headline and work on that? Something like workflowy.com navigation? Following commands will toggle the visibility like that. Very useful and it is useful to remember the shortcut for this.
   ```
   M-x org-narrow-to-subtree
   M-x widen
   ```
9. By the way, did you notice that **`M-x` remembers your command history** too!
10. How do you rearrange headlines with their content? There are commands for that, but what I find easier to do is to fold the headline and then use cut (*dd*) and paste (*p*) if I need to move it to some other area; or indent (*>*) or dedent (*<*) to promote and demote. VIM keys are more familiar to me!
11. Note that if you want to use these VIM commands, you've to keep the headline collapsed. If it is not, then those commands work only on that headline line and not on the entire content under that - which is usually what you don't want.
12. VIM's split buffer (*:sp* or *:vs*) also works just the same.

## Org capture
This is similar to [GTD Capture](https://gettingthingsdone.com/insights/step-1-capture/). 

1. Hit `SPC X` (that is Space bar and capital X). You get a menu.
   ```
   Select a capture template
   =========================
   [t] Personal todo
   [n] Personal note
   [j] Journal
   ...
   ```
2. Let us add a *note*. Hit `n`. A split opens up and you can nicely start typing your
   headline and content there. Once done `C-c` will close it. These go to your *org-directory* under a file `notes.org`. 
3. Similarly, *Journal* goes to `journal.org` and *Personal todo* goes to `todo.org`.
4. I use *Journal* a lot. One nice thing about using these files is that when you want to
   open another org file, you can simply do `:e notes.org` for example and it will open it up without you needing to enter full path.
5. The `SPC X` menu also gives an option for project based templates in `o`. If you are
   doing multiple projects, those are all in `projects.org` with each Project as a top level headline.
6. When you enter a todo/note/journal, you also get an option to `refile`. This will give you a list of org files plus their headlines to move this captured content to. Makes it very easy to just capture first and file after.
7. `projects.org` has a default project called "-". If you want to add another project so that you can file things under that, create it as a sibling to this one. Sample below.
   ```
   * -
   ** Notes
   *** [yyyy-mm-dd day hh:mi] what i typed as note headline
   * My Project 1
   ```
8. **Tagging** is very easy. Navigate to a section/headline and do `SPC m q`. Type in one tag. If that org file had other tags before you get a picklist to choose from too!
9. **Linking** is a bit painful with the command `M-x org-insert-link`. I simply type in content like `[[link url][link text]]`. If you want to edit an existing link, navigate to that and do `M-x org-insert-link`. 

   To link to another org doc and it's headline, chose url like `file:notes.org::*heading text` - in this example, this is for *notes.org*.

   To follow the link, just place your cursor there and *Enter*. To navigate back, `M-x org-mark-ring-goto`. I need to figure out how to map this to `Alt left-arrow`.

10. Pasting will work with *p* like in VI. If you've copied text from another application and wants to paste here, *p* works in normal mode.

## Checklists

While org-mode has a very elaborate system using *TODO* prefix'ed headlines for tracking your todos and even build agenda from it,
I find quick checklists a great way to ensure things are thought through.

```
- [ ] Write an Article
  - [ ] Make an outline
  - [ ] Add content
  - [ ] Add tags
  - [ ] Preview and edit
  - [ ] Publish
  - [ ] Tweet about it with link
```

That's it. Checklist items are simply list items with an empty **[ ]** square brackets. Once you add one, to quickly keep adding
siblings, *C-Enter* will work too!

To mark each one as in progress or done, just go to the item and hit **ENTER**. Each hit will cycle through *-, X, blank*. 

If you want to add a progress status to the outline, just add **[/]** to the headline after your text. It will automatically get
updated to **[n/m]** when you check off each item inside it. If you want to recompute manually, there is a command. Do `M-x` and type `stat` and find out the right one :)

Naturally, if you prefer `%`, you can add **[%]** instead. Here is how it looks after I did some ENTERs. Again, I didn't 
type in *3/6* or *0%* - org did it automatically; I just had to tell it that I need n/m and % by adding an empty [/] and [%].

   ```
   - [-] Write an Article [3/6]
      - [X] Make an outline
      - [X] Add content
      - [X] Add tags
      - [-] Preview and edit
      - [ ] Publish
      - [ ] Tweet about it with link
   - [-] Viral campaign [0%]
      - [-] Pay million$ during super-bowl
  ```

## Closing thoughts

- To extract data from org-mode files, [python orgparse](https://orgparse.readthedocs.io/en/latest/) is quite nice. 
- Since this is all text, emacs doesn't even break a sweat to load up 100K lines org files. ie., Really, you don't 
  need to make things like `project1.org`, `project2.org` etc (unless you want to keep it in different folders). Another advantage
  in maintaining one large file each is that usual search (*/*) in VIM works just as well!
- Creating [ascii tables](https://orgmode.org/manual/Built_002din-Table-Editor.html) is too good. You get perfect alignment and you can
  even have formula for computed fields if you must. Of course, there is a command to convert a selected region to tables (paste csv and use it
  to see what I mean. Which command? Try `M-x org-table` and auto-complete a guess.
- `M-x doom/reload` helps you re-init the environment if you change some config; I usually just exit and restart emacs.
- If you prefer video tutorialss, I found [Doomcasts](https://www.youtube.com/playlist?list=PLhXZp00uXBk4np17N39WvB80zgxlZfVwj) by 
  *Zaiste Programming* on youtube.com as the best resource on the topic. E09 to E17 covers org-mode; If you choose to use this, 
  my advice is to start from E01. The content and presentation is brilliant and each episode is only 10 minutes long.
- org-agenda is also fantastic; but I found it a bit difficult to focus and learn. Keeping notes, todos and journal in split windows
  is good enough for me. See a sample for [maintaining an agenda for your life](https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html)!