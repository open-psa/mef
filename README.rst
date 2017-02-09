##################################
The Open-PSA Model Exchange Format
##################################

.. image:: https://travis-ci.org/open-psa/mef.svg?branch=master
    :target: https://travis-ci.org/open-psa/mef

|

This repository hosts source text files for the Open-PSA Model Exchange Format.


Building
========

Note that no dependency is required to edit the text source of the standard;
a basic text editor suffices to work with the source files.
All building is done automatically on Travis-CI upon your pull request
to verify successful generations in various target formats.

A list of dependencies:

====================   ===============
Package                Minimum Version
====================   ===============
Python                 2.7 or 3.4
Sphinx                 1.5
sphinx_rtd_theme       0.1.10
LaTeX
Inkscape
git
====================   ===============

To install all the dependencies with ``apt`` and ``pip``
(assuming already installed Python and git):

.. code-block:: bash

    sudo apt-get install texlive{,-{fonts-recommended,latex-extra,xetex}} inkscape
    sudo pip install sphinx sphinx_rtd_theme


The repository includes the schemas as a submodule,
so it must be initialized/updated:

.. code-block:: bash

    git submodule update --init --recursive

To generate HTML files (the website at the *gh-pages* branch):

.. code-block:: bash

    make html

To generate a PDF document:

.. code-block:: bash

    make latexpdf


reST Style
==========

- `Semantic Linefeeds`_ (i.e., one sentence per line)
- No UTF-8 math characters or symbols (use inline LaTeX math instead)
- Part ``#`` overlined and underlined
- Chapter ``*`` overlined and underlined
- Section underlining and order ``=``, ``-``, ``~``, ``^``, ``+``
- Point nesting and order ``-``, ``*``, ``+``
- 4-space indentation
- 100 character line limit
  (except for links and paths)
- No trailing whitespace characters
- No tabs (spaces only)
- No excessive blank lines at the end of files
- One blank line after a header before its body
- Prefer two blank lines between sections with bodies

.. _Semantic Linefeeds: http://rhodesmill.org/brandon/2012/one-sentence-per-line/


Reference Naming Conventions
----------------------------

Prepend a reference name with the type of the object (a la the Hungarian notation)
for clarity and consistency of in-text references.
If there's no prefix in a reference,
the target is assumed to be the specification or section itself.

For example, an image (figure), table, XML description,
BNF description of the fault tree specification:

.. code-block:: rst

    .. figure:: images/fault_tree.svg
        :name: fig_fault_tree

        Fault tree diagram


    .. table:: The fault tree specifiction
        :name: table_fault_tree

        +-------+------+
        | Fault | Tree |
        +=======+======+


    .. code-block:: bnf
        :name: bnf_fault_tree

        fault_tree ::= graph


    .. code-block:: xml
        :name: xml_fault_tree

        <define-fault-tree/>


To reference the fault tree specification itself:

.. code-block:: rst

    .. _fault_tree:

    **********
    Fault Tree
    **********

    The fault tree specification, description, text, ...


Helpful Resources
-----------------

- `Sphinx reStructuredText Primer <http://www.sphinx-doc.org/en/stable/rest.html>`_
- `Spinx reST Miscellaneous <http://www.sphinx-doc.org/en/stable/markup/misc.html>`_
- `reStructuredText User Documentation <http://docutils.sourceforge.net/rst.html>`_
- `reST Cheat Sheet <http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt>`_
- `reST Quick Reference <http://docutils.sourceforge.net/docs/user/rst/quickref.html>`_
- `Short Math Guide for LaTeX <http://www.math.ucsd.edu/~jeggers/latex/short-math-guide.pdf>`_


Workflow
========

#. Start by forking this repository and setting it as the upstream repository.
#. Create your **topic** branch from the **master** branch.
#. Keep in sync your **origin** master branch with the **upstream** master branch.
#. Keep your **topic** branch in sync with the **master** branch
   by merging or rebasing your **topic** branch on top of the **master**.
   Rebasing is highly recommended for streamlining the history.
   However, **DO NOT** rebase any commits
   that have been pulled/pushed anywhere else other than your own fork.
#. Submit your `pull request`_ from **your topic** branch to the **upstream master** branch.
#. Your pull request will be reviewed by another editor before merging.

.. _pull request: https://help.github.com/articles/using-pull-requests/


Git Resources and Best Practices
--------------------------------

- `Git SCM <http://git-scm.com/>`_
- `Writing Good Commit Messages <https://github.com/erlang/otp/wiki/Writing-good-commit-messages>`_
- `On Commit Messages <http://who-t.blogspot.com/2009/12/on-commit-messages.html>`_
- `Atomic Commit <https://en.wikipedia.org/wiki/Atomic_commit#Atomic_commit_convention>`_
- `Branching Model <http://nvie.com/posts/a-successful-git-branching-model/>`_
