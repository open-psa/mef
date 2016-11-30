##################################
The Open-PSA Model Exchange Format
##################################

.. image:: https://travis-ci.org/open-psa/mef.svg?branch=master
    :target: https://travis-ci.org/open-psa/mef

|

This repository hosts source text files for the Open-PSA Model Exchange Format.


Building
========

A list of dependencies:

====================   ===============
Package                Minimum Version
====================   ===============
Python                 2.7 or 3.3+
Sphinx                 1.4.3
sphinx_rtd_theme       0.1.8
LaTeX
DVI-to-PNG             1.14
git
====================   ===============

To install all the dependencies with ``apt`` and ``pip``
(assuming already installed Python and git):

.. code-block:: bash

    sudo apt-get install dvipng texlive texlive-fonts-recommended texlive-latex-extra
    sudo pip install sphinx sphinx_rtd_theme

To generate HTML files (the website at the *gh-pages* branch):

.. code-block:: bash

    make html

To generate a PDF document:

.. code-block:: bash

    make latexpdf


reST Style
==========

- Title ``#`` overlined and underlined
- Chapter ``*`` overlined and underlined
- Section underlining and order ``=``, ``-``, ``~``, ``^``, ``+``
- Point nesting and order ``-``, ``*``, ``+``
- 4-space indentation
- 100 character line limit
  (except for links and paths)
- No trailing whitespace characters
- No tabs (spaces only)
- No excessive blank lines at the end of files
- Prefer two blank lines between sections with bodies
- One blank line after a header before its body
