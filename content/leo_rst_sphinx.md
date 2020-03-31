+++
title = "Leo + Sphinx = painless documentation"
date = 2020-03-31T08:00:00+05:30
description = "Awesome combination to make it easier to write documentation."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "unix", "utilities",  "snippet"]
+++

Writing documentation, be it for your user manual or for design, is a black and white
task. Either you love it or you hate it!

If you love it, chances are that you prefer coding it in a distraction free environment
with simple markup, rather than using Word processing tools. Here is how you can do
it very easily.

<!-- more -->

Teaser -> This is the sample output!
![Sample generated doc](../leo_rst_sphinx_02.png)

Often, you might end up using markdown. While that is quite easy and convenient for
single page documents and blogs, it is a [bit limiting when you want to make multipage
documentation](https://www.ericholscher.com/blog/2016/mar/15/dont-use-markdown-for-technical-docs/).

## Tools

[Sphinx](https://www.sphinx-doc.org/en/master/) is an excellent tool to generate
well structured documentation. Nice themes, search, syntax highlighting etc are all there.

[reStructuredText](https://docutils.sourceforge.io/rst.html), aka *rst*, is a reasonably simple
format that has enough things over and above markdown for very strong formatting.

So what is the problem? **Structure**. If you are writing a longish document, you will need
an outline view to see where what content is and how to reorder these. Either in markdown
or in rst, this is not very naturally evident. That is a side effect of headers being done
in simple markup characters.

Enter [leo outliner](http://leoeditor.com/). It is an IDE, PIM, outliner, literate programming tool etc.
Essentially, something that helps you map your brain. It in fact comes with a great module for *rst*, aptly
called ``rst3``.

## Setup

- Install ``python3`` and ``pip``
- Install *Sphinx* with ``pip install -U Sphinx``
- I love the _readthedocs.org_ theme, so get that as well with ``pip install -U sphinx_rtd_theme``.
  There are many other themes available, feel free to choose what works for you.
- Installing leo involves little more work. Jump to [installation docs](http://leoeditor.com/installing.html)
- Ensure ``make`` command is available

## Starting a project

Best starter tutorials I found about Sphinx is from [Audrey Tavares](https://techwritingmatters.com/documenting-with-sphinx-tutorial-intro-overview). She has nice videos also you can see.

My two line quick start is below.
```sh
mkdir my-sample-doc
sphinx-quicstart my-sample-doc
cd my-sample-doc
```

## Configuration
Let us see the ``conf.py``. Edit the lines that match.
```python
source_suffix = '.txt'
html_theme = 'sphinx_rtd_theme'
# this theme has some customization options.
# let us use one to make background orange instead of blue.
html_theme_options = {
    'style_nav_header_background': '#de6616',
}
```

## Writing Content

Let us create a leo outliner. Reading the [leo tutorial](http://leoeditor.com/tutorial-basics.html) on 
how to edit and navigate is going to be useful.

- **Download [sample outline - leo_rst_sphinx.leo](../leo_rst_sphinx.leo)** I created.
- Put it into the project folder you created in the quickstart step before.
- Open it in leo. This is how it should look.

![How does it look?](../leo_rst_sphinx_01.png)

Just keep editing it. Note that whenever you add a new ``@rst`` node, you have to add it under the
``toctree`` in ``index`` also, so that it can come up in the sidebar.

Leo takes out the pain of visualizing structure - it also can do a whole lot more things, but I am
not getting into that now.

## Generating doc

Couldn't be easier. Just focus on the 
_Documentation_ node and click on the _make-sphinx_ button. After that, go to
*_build/html/* folder and open _index.html_. You will see what was there in teaser
screenshot. 


If you want to generate additional formats, see the documentation for Sphinx. You
can call ``make`` with different targets to generate those.
