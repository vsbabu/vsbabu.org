+++
title = "Generate docs - the unix way"
date = 2020-06-22T08:00:00+05:30
description = "Or connecting tools with make"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "unix", "utilities",  "snippet"]
+++

As programmers, lot of us find it easier to just type content using text based formats
like `markdown`. However, we need to often share these as *pdf*, *Word* etc to our colleagues.

Quite often, we may need to create several documents that have same content across the documents. A
simple example is a *copyright footer* or even an *intro paragraph about your work*.

A short walkthrough using venerable tools like `make`, `m4` and `pandoc` to get this done follows.
<!-- more -->
## Tools

- [m4](https://www.gnu.org/software/m4/manual/m4-1.4.15/html_node/index.html) is a macro
  processor. It reads text, parses it for *macros* and expands macros and outputs the mix. A cheap
  way to think about this is considering this as expanding abbreviations. However, `m4` is lot more
  than that and gives you lot of flexibilities. What we need really for current problem is only
  one built-in macro called [include](https://www.gnu.org/software/m4/manual/m4-1.4.15/html_node/Include.html) which helps us include contents from other files into ours.

  ```
  include(`header.txt')
  blah blah my content
  include(`footer.txt')
  ```
  
  Will replace the contents of *header.txt* and *footer.txt* to the output.

- [make](https://www.gnu.org/software/make/) is a classic graph based automator.

- [pandoc](https://pandoc.org/) is a swiss-army knife for converting documents from one format to another.

All of these packages can be installed using regular package managers or *homebrew*.

## Project Structure

```
.
├── Makefile
└── src
    ├── inc_footer.md
    ├── inc_header.md
    ├── intro_chapter_one.md
    └── intro_chapter_two.md
```

Let us look at `inc_header.md`. Just straight forward markdown.

```markdown
## About us

We are the kindest souls in the universe!
```

Now, if we look at `intro_chapter_one.md`:

```markdown
changequote(`{{', `}}')

include({{inc_header.md}})

# Chapter 01 - The Great Story

LA la la..

include({{inc_footer.md}})
```

All it is doing is including the files. Note that I've also [changed the quoting](https://www.gnu.org/software/m4/manual/m4-1.4.15/html_node/Changequote.html)
structure from back-tick and straight-tick to double flowery braces. This helps
in markdown where back-tick means something when it comes to syntax highlighting
editors.

## Makefile

```make
SRCDIR = src
OUTDIR = share
SRCF  = $(wildcard $(SRCDIR)/intro_*.md)
DEPF  = $(wildcard $(SRCDIR)/inc_*.md)
DOCX = $(subst $(SRCDIR),$(OUTDIR),$(SRCF:.md=.docx))

.PHONY: all clean

all: directories $(DOCX)

directories:
	mkdir -p $(OUTDIR)

$(OUTDIR)/%.docx: $(SRCDIR)/%.md $(DEPF)
	$(shell m4 -I $(SRCDIR) $< | pandoc -s --quiet -f markdown -o $@ -)
	@echo "$< ==> $@"

clean:
	rm -fR $(OUTDIR)

# vim: set noexpandtab:
```

- First two lines set the source and output directories
- `SRCF` is a list of markdown files we want to convert to MS Word formats. (Wildcard)[https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html] function helps in getting the list.
- `DEPF` is similar and I follow a convention that all files starting with *inc_* are for includes.
- `DOCX` is generating a list of output file names in *OUTDIR* from *SRCF*. The inner one makes filename
  extension from *.md* to *.docx* and the `subst` function replaces source directory name with output directory name.
- `$(DOCX)` in *all* target expands to this list of output docs. 
- The main action is in the generic target that says to generate a *.docx*, you need a similarly named
  *.md* (in appropriate directories of course) and the include files.
- `$<` variable has the first dependency (the *src/intro_whatever.md* file) and `$@` has the output file.
- The `$(shell...)` line runs `m4` with include file path as *source* directory and output is piped to
  `pandoc` (- says read from stdin) as forced *markdown* format and output is written to the desired output
  file name (`$@`).

Go ahead and run `make`.

```
mkdir -p share
src/intro_chapter_one.md ==> share/intro_chapter_one.docx
src/intro_chapter_two.md ==> share/intro_chapter_two.docx
```

Let us also see how `make` is efficient. If we change only one file, it should
build only the docx corresponding to that.

```sh
touch src/intro_chapter_one.md 
make
#  mkdir -p share
#  src/intro_chapter_one.md ==> share/intro_chapter_one.docx
```

Well, if we modify an include file, then all files need to be regenerated.

```sh
touch src/inc_header.md 
make
#  mkdir -p share
#  src/intro_chapter_one.md ==> share/intro_chapter_one.docx
#  src/intro_chapter_two.md ==> share/intro_chapter_two.docx
```

Objective of this short article was to demonstrate how command line tools are
much easier when we've to generate stuff. Things like [yq](https://kislyuk.github.io/yq/)
coupled with these kind of tools even give you ability to have a database of 
`yml` files which can generate say question papers, resume, job descriptions etc!

And if you keep your layout and common boiler plate text in `m4` files, it is a
simple job when you want to make changes and re-generate content again.