+++
title = "1to10: doom-emacs and org-roam, gpg"
date = 2020-08-02T08:00:00+05:30
description = "Note your thoughts with least friction!"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "emacs", "org-mode", "productivity", "0to1"]
+++

Already setup `doom-emacs` and started with `org-mode`? If not, read my
previous article on [0to1: doom-emacs and org-mode](/blog/doom_emacs_org_0_to_1/).

Since then, I've also started using `org-roam`, which is an emacs implementation
of roamresearch.com's note taking tool. Following are my notes on how to get this going.
Also, how to encrypt part of your notes using `gpg`.

<!-- more -->

## Installation

Once you've `doom-emacs` setup, next steps are as below. Note that `gpg` or `crypt` are optional
unless you want to encrypt some notes.

1. In `~/.doom.d/init.el`:
   1. Uncomment `deft` package. That gives a nice way to navigate notes.
   2. Scroll down to `org` package and change it to `(org +roam +crypt)`
   3. Run `~/.emacs.d/bin/doom sync`
2. Install `gpg` command line.  `brew install gpg` will do in Mac and `sudo apt install gpg` in Ubuntu based Linux.

## Setup
1. Let us setup our `gpg` key for encryption.
   ```sh
   gpg --full-generate-key
   # Follow the prompts; you should give a passphrase you can remember.
   # I gave my name as "Satheesh Vattekkat" for key name - use your own name. 
   # That is what you should put in next step "YOUR KEY NAME HERE"

   # Now let us test if key is there. You should see it with the name
   gpg --list-secret-keys
   ```
   Now, I get an output like below.
   ```
   /home/*****/.gnupg/pubring.kbx
   -------------------------------
   pub   rsa2048 2020-??-?? [SC]
         ***********************************
   uid           [ unknown] Satheesh Vattekkat (SV) <vsbabu@********.***>
   sub   rsa2048 2020-??-?? [E]
   ```
2. In `~/.doom.d/config.el`:
   ```lisp
   (setq org-crypt-key "YOUR KEY NAME HERE")
   (setenv "GPG_AGENT_INFO" nil)

   ;; I keep my files under ~/Dropbox/org. Roam files, I will put in 
   ;; a directory under that.
   (setq org-roam-directory "~/Dropbox/org/roam")
   ;; Let deft search files under root org directory.
   ;; We could use the org-directory variable instead of duplicating values
   (setq deft-directory "~/Dropbox/org/"
      deft-recursive t
      ;; I don't like any summary, hence catch-all regexp. need to see if
      ;; an option to hide summary is there instead of this one.
      deft-strip-summary-regexp ".*$"
   )
   ```
3. That is it. If you want to take this key and deploy it in other machines, just export it and import it.
   ```sh
   gpg --armor --export-secret-keys YOUR KEY NAME HERE > /tmp/mykey.asc
   scp /tmp/mykey.asc someothermachine:/tmp/mykey.asc
   ssh someothermachine
   gpg --import /tmp/mykey.asc
   gpg --edit-key "YOUR KEY NAME HERE"
   ```

   Reminder -> You lose the passphrase, you lose the key and stuff encrypted with that.

## Note Taking Workflow

> "Notes aren’t a record of my thinking process. They are my thinking process". 
> – Richard Feynman.

* `M-x org-roam-find-file` or `M-x org-roam-capture` can be used to just start noting things down.
  `SPC n r f` will work too. It will show a list of file topic and will filter according to the name.
  As you type the name, if no file is there, a new one will be created with this as the title.
* Let us give file name as *Org Roam* and hit enter.
* You have a *Capture* buffer opened up. Just keep typing your content and when you are done, `C-c C-c`
* Now the file will open up in the main window. 
* Let us try `SPC n r f` again. You can see the entry *Org Roam*. Select it to edit it. Or, type
  in another name and create another one.

## Interlinking

* Ideally, each note should have self contained info about one topic only. 
  [Zettelkasten method](https://en.wikipedia.org/wiki/Zettelkasten) is a good
  read about this.
* Now, how do you make sense of the notes like that? Interlinking. Whenever you
  open a note or edit a note, search for other notes that are possibily related to it.
* Go to the end of your new note and do `SPC n r i` (yes, i for insert) and again the
  list of roam files will pop up. Choose as many as you want and you can see those
  links getting added automatically.
* Next time when you open the note, you will see possible back links to this on the
  side window to get the context. Makes navigation very easy. That buffer can be toggled
  by `SPC n r r`
* For example, I have two notes below, viz., *Org Roam* and *Zettelkasten System*. From 
  the latter, I interlinked to former. You can see that when I am on *Org Roam*, the side
  buffer shows what other content links to this.

  ![screenshot](01.png)


## Deft - file navigation
We also installed `deft` which can be invoked by `SPC n d`. Gives a nice list of all org
files sorted by modified timestamp in descending order. You can navigate using arrow keys
and open the file.

  ```
  Deft: 

  Zettelkasten System                                              2020-08-02 07:52
  Org Roam                                                         2020-08-02 07:50
  SV                                                               2020-06-07 17:29
  ```

Note that `deft` is for navigating an file tree; not particularly linked to org-mode and roam. I find
it very useful to check the recently modified notes.

## Key Combos to Remember

   ```
   SPC n r f => Type a topic name and edit note. Just like Notational Velocity.
   SPC n r i => Inside the note, use this to add links to possibly related topics.
   SPC n r r => Toggle the org-roam buffer. Shows backlinks.
   SPC n d   => Deft
   ```

That's it. You just need to remember first two key combinations. Other two are useful as well.


## Encryption
Here is my sample org file.

```
#+title: Org Roam

This is my notes about Org Roam.

* Encrypted Section

Now, this is a super secret sensitive topic I don't
want others to see!

** Subheading As Well

This is also sensitive
```

Now, let us encrypt the entire section under *Encrypted Section*. Navigate to that and
run `M-x org-encrypt-entry`. That's it and our document changed to this below!

```
#+title: Org Roam

This is my notes about Org Roam.

* Encrypted Section
-----BEGIN PGP MESSAGE-----

hQEMA96l+q9aMVDXAQf/dUC28z9qATyfH9zxJJPcM0/3qn7/wCAA4LnpmkPW0nMn
hRNqTQlwOIuKK1ULT7Ls6/zZtPCMS3i97LF0gEB+n9MrcokVnUV5bIeGYzR0rIXX
Fs7BJPaEV63VfLFxGvkXBqnCpjb8bYyX7yrmhfkEehNcY/3yE3LMpMArIeh1vH1/
F6nfdOSXdNgo9tIkGxs/mHpglZswsB/P7+Ygeuv/92ibR8x7v8+6nmVcuO8fJ6HZ
G+isYTJxosADox+nX8RLC8BKIKH3aZjqb+xSpbl3boV6EzItDg8hsJ4Hf/+CUSzf
NzuohJ53HSSD23USjjgdFIY/o4IQLMacECxkPl9u8tKlAcIWt0Fv8WCVsrrtWyLr
KSsc/1fK4y81J5mXxIQ2mqUbiLBnOn1eK8Az0PdCvH8ms1ch78wCZX7ktEgVicDf
ZPc0f+WAHjzjptybnb4aK/unuLkmps6ao1CwcwIbkBJCVLO8ifMvefAkjCznnKOZ
c3j/gzn1Ey0sk1KL2q7F1f3AzCKd+7LXjox4m0mhGBjDnhbkIkX9tKgeG6yaIcyP
Natf9E0L
=ITjw
-----END PGP MESSAGE-----

```

How to decrypt? Couldn't be simpler. Navigate to the heading and run
`M-x org-decrypt-entry`. Now it will ask for the passphrase for your
key though. 

Note that you've to save it (`:w`) manually. You can do
tricks like file-save hook to automatically encrypt sections that has
a particular tag, but I am not an emacs expert to do that. [Org mode documentation](https://www.gnu.org/software/emacs/manual/html_node/org/org_002dcrypt.html) explains how to do that,
but I didn't try it.

## References

* [Org Roam documentation](https://org-roam.readthedocs.io/en/master/)
* [Deft Emacs package](https://jblevins.org/projects/deft/)
* [Keeping Secrets in Emacs with GPG](https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources)
* [Part 1 of this series](/twenties/doom_emacs_org_0_to_1/)

## Other Points
* If you manually rename or delete any roam file, you need to run `M-x org-roam-db-build-cache`
* You need to do this if you change the title outside emacs as well.
* `M-x org-roam-doctor` is a nice command you might want to run once in a while when you really get going with notes.

