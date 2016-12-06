************
Report Layer
************

Preliminary Discussion
======================

The report layer is populated with constructs to save results of calculations.
These constructs fall into two categories:

- Constructs to tell which software, algorithm(s) and option(s) were used to produce the results
- The results themselves

It is almost impossible and probably not even desirable to normalize fully the report layer.
Tools are very different from one another and produce a wide variety of results.
New calculation methods are regularly proposed.
To normalize everything would lead to a huge and anyway incomplete format.
Moreover, the way results are arranged into reports depends on the study.
It is also, at least to some extent, a matter of taste.

If the Model Exchange Format cannot give a formal structure for the report layer,
it can at least suggest a style to describe
what has been calculated and how it has been calculated.
It can also provide a check-list
of what should be included as information
to make results truly exportable and importable.
The existence of such report style
would be very useful for reporting tools (whether they are graphic or textual):
it would be much easier for these tools to extract the information
they need from the XML result files.

Information about calculations
==============================

Here follows a non-exhaustive list of information
about how the results have been obtained that can be relevant
and other special or unique features of the model.

- Software

    * Version
    * Contact organization (editor, vendor, ...)
    * ...

- Calculated quantities

    * Name
    * Mathematical definition
    * Approximations used
    * ...

- Calculation method(s)

    * Name
    * Limits (e.g., number of basic events, of sequences, of cut sets)
    * Preprocessing techniques (modularization, rewritings, ...)
    * Handling of success terms
    * Cutoffs, if any (absolute, relative, dynamic, ...)
    * Are delete terms, recovery rules or exchange events applied?
    * Extra-logical methods used
    * Secondary software necessary
    * Warning and caveats
    * Calculation time
    * ...

- Features of the model

    * Name
    * Number of: gates, basic events, house events, fault trees, event
      trees, functional events, initiating events

- Feedback

    * Success or failure reports
    * ...

Format of Results
=================

PSA tools produce many kinds of results.
Some are common to most of the tools,
e.g., probability/frequency of some group of consequences, importance factors, sensitivity analyses.
They fall into different categories.
The following three categories are so frequent
that is it worth to normalize the way they are stored into XML files.

- Minimal cut sets (and prime implicants)
- Statistical measures (with moments)
- Curves

Minimal Cut Sets
----------------

A first (and good) way to encode minimal cut sets
consists in using the representation of formulae defined by the Model Exchange Format.
However, it is often convenient to attach some information to each product,
which is not possible with the formulae of the Model Exchange Format.
An alternative XML representation for sums of products
(sets of minimal cut sets are a specific type of sums of products)
is given in :numref:`bnf_sum_of_products`.
More attributes can be added to tags "sum-of-products" and "product"
to carry the relevant information.

.. code-block:: bnf
    :name: bnf_sum_of_products
    :caption: Backus-Naur form for the XML representation of sums-of-products

    sum-of-products ::=
        <sum-of-products
            [ name="identifier" ]
            [ description="text" ]
            [ basic-events="integer" ]
            [ products="integer" ]
        >
            product*
        </sum-of-products>

    product ::=
        <product [ order="integer" ] >
            literal*
        </product>

    literal ::=
          <basic-event name="identifier" />
        | <not> <basic-event name="identifier" /> </not>


Statistical measures
--------------------

Statistical measures are typically produced by sensitivity analyses.
They are the result, in general, of Monte-Carlo simulations on the values of some parameter.
Such a measure can come with
moments (mean, standard deviation), confidence ranges, error factors, quantiles, ...
The XML representation for statistical measure is given in :numref:`bnf_statistical_measure`.

.. code-block:: bnf
    :name: bnf_statistical_measure
    :caption: Backus-Naur form for the XML representation of statistical measures

    measure ::=
        <measure
            [ name="identifier" ]
            [ description="text" ]
        >
            [ <mean value="float" /> ]
            [ <standard-deviation value="float" /> ]
            [ <confidence-range
                percentage="float"
                lower-bound="float"
                upper-bound="float" /> ]
            [ <error-factor percentage="float" value="float" /> ]
            [ quantiles ]
        </measure>

    quantiles ::=
        <quantiles number="integer" >
            quantile+
        </quantiles>

    quantile ::=
        <quantile number="integer"
            [ mean="float" ]
            [ lower-bound="float" ]
            [ upper-bound="float" ] />

Curves
------

Two or three dimensional curves are often produced in PSA studies.
A typical example is indeed
to study the evolution of the system unavailability through the time.
The XML representation of curves suggested by the Model Exchange Format
is given in :numref:`bnf_curves`.

.. code-block:: bnf
    :name: bnf_curves
    :caption: Backus-Naur for the XML representation of curves

    curve ::=
        <curve
            [ name="identifier" ]
            [ description="text" ]
            [ X-title="string" Y-title="string" [ Z-title="string" ] ]
            [ X-unit="unit" Y-unit="unit" [ Z-unit="unit" ] ]
        >
            <point X="float" Y="float" [ Z="float" ] />*
        </curve>

    unit ::= seconds | hours | ...
