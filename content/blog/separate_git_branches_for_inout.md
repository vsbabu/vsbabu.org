+++
title = "Git branches for content and output"
date = 2025-02-06T08:00:00+05:30
description = "Noting down a command snippet for my workflow. I maintain my markdown/org files in a main branch and publish the generated ones to gh-pages branch."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["tools"]
tags = [ "tools","publish"]
+++


[Github](https://www.github.com/) supports static website publishing of gh-pages branch in your repository. It can even support CNAME entries to point your domain to it. This idea is pretty good if you want to maintain content and output in two separate branches. The following note explains the flow of commands to set this up in a local repository. You will need to add a _push to remote step_ for Github repositories.

> [linked.in copy](https://www.linkedin.com/pulse/git-branches-content-output-satheesh-babu-vattekkat-7mmvc/) 
<!-- more -->

Essentially, the steps are:

1.  Create a git repository.
2.  Add a main branch.
3.  Add a gh-pages branch.
4.  Add some content in _main_ branch and run some transformation to create an output file.
5.  Switch to _gh-pages_ and commit output files.

The _main_ branch has content only and _gh-pages_ have generated output only.

Note that I use this to convert my org-mode files to _html_. Since _org_ may not be as widely used as _markdown_ sharing the examples with _markdown_ instead. If you do want to use _org_, just fix the makefile below for extensions and the pandoc invocation.

After I wrote this, I found out [Sean Coughlin’s blog on npm gh-pages](https://blog.seancoughlin.me/deploying-to-github-pages-using-gh-pages). This is very informative and explains setting up your [Github repository to enable pages](https://blog.seancoughlin.me/building-a-personal-website-with-github-pages) and subsequent automation.

### Commands

We will assume we are using pandoc to convert _markdown_ to _html_.

```sh
#setup basic folder and main branch
mkdir gh-ex
git init
git branch -m master main

#create output branch
git checkout -b gh-pages

#setup complementary gitignores
git checkout -b main
cat > .gitignore <<EOF
\*.html
\*\*/\*.html
EOF
git add .gitgnore
git commit -m "Content gitignore"
git checkout -b gh-pages
cat > .gitignore <<EOF
\*.md
\*\*/\*.md
EOF
git add .gitignore
git commit -m "Output gitignore"

#Let us create content
git checkout main
echo "Some stuff" > sample01.md
pandoc sample01.md -o sample01.html #fix if any errors
git add sample01.md
git commit -m "First content"

git checkout gh-pages
git add sample01.html
git commit -m "First output"

#Repeat
git checkout main
echo "Some more stuff" > sample02.md
pandoc sample02.md -o sample02.html #fix if any errors
git add sample02.md
git commit -m "Second content"

git checkout gh-pages
git add sample02.html
git commit -m "Second output"
```

Or we can use a Makefile to make the process of generation easier. This can be added to the main branch. Whenever you update content, simply run make, test and then switch to _gh-pages_ branch to commit generated files.

```makefile
SRCS = $(wildcard \*.md)
OUTS = $(SRCS:.md=.html)

all: $(OUTS)

%.html: %.md
        pandoc $< -o $@

clean:
        rm -f $(OUTS)

.PHONY: all clean
```

Here is how the folder looks after all this.

```sh
% git checkout main; ls -a
.git  .gitignore  Makefile  sample01.md  sample02.md
% git checkout gh-pages; ls -a
.git  .gitignore  sample01.html  sample02.html
```

As you can see, the two branches have different files.

### Issues

**Testing generated content**

If you want to add assets like _css_ to support generated content, you can add that to _gh-pages_ individually - however, this will require switching to that branch to fully test generated output. I prefer it that way because then _main_ branch will have pure generated pages only which is much easier to debug without added styles.

**Additional branching and merging**

These are parallel branches without overlapping files. So, if you want to support multiple authors and their branches with their own merging, it is little bit easier to manage merges to main branch only and one person generates gh-pages.
