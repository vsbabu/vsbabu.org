<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2"/>
<globals/>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="vsbabu.20200331094306.1"><vh>Startup</vh>
<v t="vsbabu.20200331095900.1"><vh>@settings</vh>
<v t="vsbabu.20200331095918.1"><vh>@string target_language = rest</vh></v>
<v t="vsbabu.20200331095944.1"><vh>@shortcuts</vh></v>
<v t="vsbabu.20200331100025.1"><vh>rst3 options</vh>
<v t="vsbabu.20200331100025.2"><vh>@bool rst3_call_docutils = False</vh></v>
<v t="vsbabu.20200331100025.3"><vh>@bool rst3_code_mode = False</vh></v>
<v t="vsbabu.20200331100025.4"><vh>@bool rst3_debug = False</vh></v>
<v t="vsbabu.20200331100025.5"><vh>@bool rst3_format_headlines = True</vh></v>
<v t="vsbabu.20200331100025.6"><vh>@bool rst3_generate_rst = True</vh></v>
<v t="vsbabu.20200331100025.7"><vh>@bool rst3_http_server_support = False</vh></v>
<v t="vsbabu.20200331100025.8"><vh>@bool rst3_massage_body = False</vh></v>
<v t="vsbabu.20200331100025.9"><vh>@bool rst3_show_headlines = True</vh></v>
<v t="vsbabu.20200331100025.10"><vh>@bool rst3_show_leo_directives = True</vh></v>
<v t="vsbabu.20200331100025.11"><vh>@bool rst3_show_organizer_nodes = True</vh></v>
<v t="vsbabu.20200331100025.12"><vh>@bool rst3_silent = True</vh></v>
<v t="vsbabu.20200331100025.13"><vh>@bool rst3_verbose = False</vh></v>
<v t="vsbabu.20200331100025.14"><vh>@bool rst3_write_intermediate_file = True</vh></v>
<v t="vsbabu.20200331100025.15"><vh>@string rst3_default_path = </vh></v>
<v t="vsbabu.20200331100025.17"><vh>@string rst3_write_intermediate_extension = .txt</vh></v>
</v>
</v>
<v t="vsbabu.20200331094333.1"><vh>@button make-sphinx</vh></v>
</v>
<v t="vsbabu.20200331095527.1"><vh>Documentation</vh>
<v t="vsbabu.20200330211220.2"><vh>@rst index</vh></v>
<v t="vsbabu.20200330211157.2"><vh>@rst idea</vh>
<v t="vsbabu.20200330211157.4"><vh>Stories</vh></v>
<v t="vsbabu.20200330211157.5"><vh>Actors</vh></v>
<v t="vsbabu.20200330211157.6"><vh>Constraints</vh></v>
</v>
<v t="vsbabu.20200330211240.2"><vh>@rst design</vh>
<v t="vsbabu.20200330211240.4"><vh>Customers</vh></v>
<v t="vsbabu.20200330211240.5"><vh>Products</vh></v>
<v t="vsbabu.20200330211240.6"><vh>Orders</vh></v>
<v t="vsbabu.20200330211240.7"><vh>Shipments</vh></v>
<v t="vsbabu.20200330211240.8"><vh>Invoices</vh></v>
<v t="vsbabu.20200330211240.9"><vh>Payments</vh></v>
</v>
<v t="vsbabu.20200330230751.1"><vh>@rst code</vh>
<v t="vsbabu.20200330231155.1"><vh>APIs</vh></v>
<v t="vsbabu.20200331165011.1"><vh>Entities</vh></v>
<v t="vsbabu.20200331165018.1"><vh>Events</vh></v>
</v>
</v>
</vnodes>
<tnodes>
<t tx="vsbabu.20200330211157.2">@language rest
@tabwidth -4

###################################
Idea
###################################

.. toctree::
   :maxdepth: 2
</t>
<t tx="vsbabu.20200330211157.4">#. My brilliant user story item
#. My second user story
</t>
<t tx="vsbabu.20200330211157.5">#. Who all use this?
#. Any more?
</t>
<t tx="vsbabu.20200330211157.6">#. Can't we deal with this?
#. Oops I didn't know!
</t>
<t tx="vsbabu.20200330211220.2">@language rest
@tabwidth -4


###################################
My Project's Title
###################################

Lorem ipsum....



.. toctree::
   :maxdepth: 1

   idea
   design
   code
   



</t>
<t tx="vsbabu.20200330211240.2">@language rest
@tabwidth -4

###################################
Design
###################################


.. toctree::
   :maxdepth: 2


This section looks at various domains in our business
as modules. </t>
<t tx="vsbabu.20200330211240.4">
</t>
<t tx="vsbabu.20200330211240.5">
</t>
<t tx="vsbabu.20200330211240.6">
</t>
<t tx="vsbabu.20200330211240.7">
</t>
<t tx="vsbabu.20200330211240.8">
</t>
<t tx="vsbabu.20200330211240.9">
</t>
<t tx="vsbabu.20200330230751.1">@language rest
@tabwidth -4


###################################
Code
###################################

.. toctree::
   :maxdepth: 2

How is our code going to be? Let us see.



</t>
<t tx="vsbabu.20200330231155.1"></t>
<t tx="vsbabu.20200331094306.1">This section contains settings for this file.

It also has to be named *Startup* by convention.</t>
<t tx="vsbabu.20200331094333.1">@language python
import os

def lprint(s:str):
    g.es(s)

trace = True
g.cls()
c.setComplexCommand('make-sphinx')
c.save()
aList = c.rstCommands.rst3()
if aList:
    path = os.getcwd()
    if len(aList) &gt; 1: 
        g.execute_shell_commands('make clean',trace=trace)
    g.execute_shell_commands('make html',trace=trace)
    fn = aList[0].h.strip() if len(aList) == 1 else 'index.html'
    fn = g.os_path_finalize_join(path,'_build','html',g.os_path_basename(fn))
    if g.os_path_exists(fn):
        # Don't wait for this command to exit!
        g.execute_shell_commands(['&amp;%s' % (fn)],trace=trace)
</t>
<t tx="vsbabu.20200331095527.1">All the docs written go under this.

The button `make-sphinx` will have to be pressed while 
focus is on this node. It will scan through all tree from
here and then any @rst node will be converted to .txt files.

Ensure that the python3 environment leo is working with has

:: 
    pip install -U Sphinx
    pip install -U sphinx_rtd_theme

Already run successfully.</t>
<t tx="vsbabu.20200331095900.1"></t>
<t tx="vsbabu.20200331095918.1">The default language if no @language or @comment is in effect.

Valid values are (case is ignored):

actionscript,c,csharp,css,cweb,elisp,html,java,latex,
pascal,perl,perlpod,php,plain,plsql,python,rapidq,rebol,shell,tcltk.</t>
<t tx="vsbabu.20200331095944.1">make-sphinx = Alt-4
</t>
<t tx="vsbabu.20200331100025.1"></t>
<t tx="vsbabu.20200331100025.10"></t>
<t tx="vsbabu.20200331100025.11"></t>
<t tx="vsbabu.20200331100025.12"># True: suppress all output from rst.report()</t>
<t tx="vsbabu.20200331100025.13"># True: rst.report() sends output to log pane and the console pane.</t>
<t tx="vsbabu.20200331100025.14"># Used only if generate_rst is True.</t>
<t tx="vsbabu.20200331100025.15"></t>
<t tx="vsbabu.20200331100025.17"></t>
<t tx="vsbabu.20200331100025.2"></t>
<t tx="vsbabu.20200331100025.3"># True: generate rst markup from @code and @doc parts.</t>
<t tx="vsbabu.20200331100025.4"></t>
<t tx="vsbabu.20200331100025.5">Used differently.  See rst2_pure_document.
</t>
<t tx="vsbabu.20200331100025.6"># True: generate rst markup. False: generate plain text.</t>
<t tx="vsbabu.20200331100025.7"></t>
<t tx="vsbabu.20200331100025.8">True: call body_filter to massage text.

Removes @ignore, @nocolor, @wrap directives.
</t>
<t tx="vsbabu.20200331100025.9"># Can be set by @rst-no-head headlines.</t>
<t tx="vsbabu.20200331165011.1"></t>
<t tx="vsbabu.20200331165018.1"></t>
</tnodes>
</leo_file>
