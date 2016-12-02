##########
Appendices
##########

*************************
Extended Backus-Naur Form
*************************

The following presentation is inspired from the article about the
Backus-Naur form in Wikipedia.

The Backus-Naur form (also known as BNF, the Backus-Naur formalism or
Backus normal form) is a meta-syntax used to express context-free
grammars: that is, a formal way to describe formal languages. BNF is
widely used as a notation for the grammars of computer programming
languages. Most textbooks for programming language theory and/or
semantics document the programming language in BNF.

A BNF specification is a set of derivation rules, written as

.. code-block:: bnf

    symbol ::= <expression with symbols>

where *symbol* is a nonterminal, and the expression consists of
sequences of symbols and/or sequences separated by the vertical bar,
'\|', indicating a choice, the whole being a possible substitution for
the symbol on the left. Symbols that never appear on a left side are
terminals.

As an example, consider this possible BNF for a U.S. postal address:

.. code-block:: bnf

    postal-address ::= name-part street-address zip-part
    name-part ::=
      personal-part last-name [ jr-part ] EOL
      | personal-part name-part EOL

    personal-part ::= first-name | initial .
    jr-part ::= Jr | Sr | dynastic-number
    street-address ::= [ apartment-number ] house-number street-name EOL
    zip-part ::= town-name , state-code ZIP-code EOL

This translates into English as:

- A postal address consists of a name-part, followed by a
  street-address part, followed by a zip-code part.
- A name-part consists of either:

    * A personal-part followed by a last name
      followed by an optional "jr-part" (Jr., Sr., or dynastic number)
      and end-of-line
    * A personal part followed by a name part
      (this rule illustrates the use of recursion in BNFs, covering the case of people
      who use multiple first and middle names and/or initials)

- A personal-part consists of either a first name or an initial followed by a dot.
- A street address consists of an optional apartment specifier,
  followed by a house number, followed by a street name, followed by an
  end-of-line.
- A zip-part consists of a town-name, followed by a comma, followed by
  a state code, followed by a ZIP-code followed by an end-of-line.

Note that many things (such as the format of a first-name, apartment
specifier, or ZIP-code) are left unspecified here. If necessary, they
may be described using additional BNF rules.

There are many variants and extensions of BNF, generally either for the
sake of simplicity and succinctness, or to adapt it to a specific
application. One common feature of many variants is the use of regular
expressions repetition operators such as \* and +. The Extended
Backus-Naur form we shall use is as follows.

- Non terminal symbols are *italicized*, terminal symbols are written
  in regular font.
- Optional items are enclosed in square brackets, e.g., [ *item-x* ].
- Items repeating 1 or more times are followed by a '+'.
- Items repeating 0 or more times are followed by a '\*'.
- Items repeating k times are enclosed in square brackets followed by
  ':k', e.g., [ *item-x* ]:3.
- Items repeating n or more times are followed by 'n'.
- Where items need to be grouped they are enclosed in simple
  parenthesis.
- Comments start with a '#' and spread until the end of the line


*********************************************
The DTD of the Open-PSA Model Exchange Format
*********************************************

The schemas in various formats can be found at https://github.com/open-psa/schemas

.. include:: mef_ebnf.rst
