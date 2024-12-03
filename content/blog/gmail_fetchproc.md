+++
title = "Gmail : GUI for your backend!"
date = 2020-03-27T08:00:00+05:30
description = "Why build an app if you can use GMAIL to get data?"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "unix", "utilities",  "snippet"]
+++

Often, we have a need to collect data from customers. Immediate thinking is to
make an app change, push it up to store, get people to upgrade (doesn't
happen!) and then pray. A little more savvy version of this is making a web app
and then send the links with a uuid based customer identification.

Why not just ask users to email you the data? People know how to use email! Following snippet shows  how easy
it is to automate fetching the data and then sending to a script to process.
<!-- more -->
## How?

Two venerable unix utilities.

- [fetchmail](https://www.fetchmail.info) supports a wide variety of protocols
  to get email from a remote email server.
- [procmail](https://wiki.archlinux.org/index.php/Procmail) do something with
  your email. Including routing to specific mailboxes or _commands_.

## Setup

If you are in recent _ubuntu_ or its derivates, just install these two.

```sh
sudo apt-get install fetchmail fetchmailconf procmail
```

## Config

Let us create a _fetchmail_ config file to get data from gmail.

### Gmail
First, [Configure gmail to support
imap](https://support.google.com/a/answer/9003945?hl=en&ref_topic=4456189).

To make things easier, you should also setup a gmail filter to move
emails matching your criteria to a label, from inbox. This way, we can
have multiple configs for multiple use cases all using same gmail account.

For example, I have one gmail account called _myemail@mydomain.com_. So, for
usecase A, I ask people to email to _myemail_+a@mydomain.com_ and for usecase
B, they send to myemail_+B@mydomain.com_. In gmail, you simply add filters
based on _To:_ field in the incoming mail.

### Fetchmail
fetchmail.rc is below.
```
poll imap.gmail.com protocol IMAP
   user "myemail@mydomain.com" is localuser here
   password 'whateveritis'
   folder 'mygmaillabel'
   fetchall
   keep
   ssl
```
- `fetchall` indicates we should get all unread mails from this folder.
- `keep` ensures mails are left on the server and not deleted. You can 
  use `nokeep` if you want to delete the mails we've downloaded.


### Procmail
procmail.rc is below.

```
VERBOSE=0
:0
! `/full/path/to/processemail.py`
```

What this is doing is that every email that comes to _procmail_ will be passed
to this script _processemail.py_ via stdin. There are many samples out there -
for example, [download attachments](https://gist.github.com/baali/2633554)
  using the cool _walk_ method.

Most of the examples also have code for reading from gmail directly, but I
prefer keeping _getting data_ and _processing data_ as separate things. 

Note that the configuration above is completely reliant on the script - if your
script has an error and threw out the content, then _fetchmail_ would have
marked the mail as read and you would've lost the content from local.

## Integration

Just execute a command as below.

```sh
fetchmail -f fetchmail.rc \
  --mda "procmail ${PWD}/procmail.rc"
```

Straight forward,  isn't it? Get the mail and send to mail delivery agent,
which is _procmail_ using your config.

Add this to a cron and you are done. _fetchmail_ comes with its own daemon mode
too if you prefer that route.

I like to cron things on my own since for different use cases, I have different
config files. It is far easier that way than  adding multiple filters in
procmail to direct to different scripts.

