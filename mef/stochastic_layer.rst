.. _stochastic_layer:

################
Stochastic Layer
################

Description
===========

The stochastic layer is populated with failure probabilities or failure
probability distributions associated with basic events (in the event
tree linking approach, functional events also can be associated with
such a distribution). Probability distributions are described by
(stochastic) expressions, which are terms, according to the terminology
of Chapter :ref:`mef_anatomy`. These expressions may depend on
parameters (variables), so the stochastic layer can be seen a set of
stochastic equations.

Stochastic equations associated with basic events play actually two
roles:

- They are used to calculate probability distributions of each basic
  event, i.e., for a given mission time t, the probability Q(t) that the
  given basic event occurs before t. The probability distribution
  associated with a basic event is typically a negative exponential
  distribution of parameter *λ*:

Note that, for the sake of the clarity, the Model Exchange Format
represents explicitly the mission time as a parameter of a special type.

- Parameters are sometimes not known with certainty. Sensitivity
  analyses, such as Monte-Carlo simulations, are thus performed to
  study the change in risk due to this uncertainty. Expressions are
  therefore used to describe distributions of parameters. Typically,
  the parameter *λ* of a negative exponential distribution will be itself
  distributed according to a lognormal law of mean 0.001 and error
  factor 3.

Stochastic expressions are made of the following elements:

- Boolean and numerical constants
- Stochastic variables, i.e., parameters,
  including the special variable to represent the mission time
- Boolean and arithmetic operations (sums, differences, products...)
- Built-in expressions that can be seen as macro-expressions that are
  used to simplify and shorten the writing of probability distributions
  (e.g., exponential, Weibull...)
- Primitives to generate numbers at pseudo-random according to some
  probability distribution. The base primitive makes it possible to
  generate random deviates with a uniform probability distribution.
  Several other primitives are derived from this one to generate random
  deviates with normal, lognormal, or other distributions.
  Moreover, it is possible to define discrete distributions "by hand"
  through the notion of histogram.
- Directives to test the status of initial and functional events

:numref:`bnf_stochastic_layer` sketches the Backus-Naur
form for the constructs of the stochastic layer. Note that, conversely
to variables (events) of the Fault Tree layer, parameters have to be
defined (there is no equivalent to Basic Events).

.. code-block:: bnf
    :name: bnf_stochastic_layer
    :caption: Backus-Naur form for the constructs of the stochastic layer (sketch)

    basic-event-declaration ::= basic-event = expression
    parameter-declaration ::= parameter = expression
    expression ::=
        constant | parameter | operation | built-in | random-deviate | test-event
    constant ::= bool | integer | float
    parameter ::= regular-parameter | system-mission-time
    operation ::=
         and expression+
        | or expression+
        | not expression
        | eq expression expression
        | df expression expression
        ...
        | neg expression
        | add expression+
        | sub expression+
        | mul expression+
        | div expression+
        | pow expression expression
        ...
        | if expression then expression else expression

    built-in ::=
          exponential expression expression
        | Weibull expression expression expression expression
        ...

    random-deviate ::=
          uniform-deviate expression expression
        | lognormal-deviate expression expression expression
        | histogram
        ...

    test-event ::=
          test-initiating-event name
        | test-functional-event name state

The XML representation of the stochastic layer just reflects these
different constructs.

.. code-block:: bnf
    :caption: Backus-Naur grammar for XML representation of expressions (main)

    parameter-definition ::=
        <define-parameter name="identifier"
            [ role="private|public" ] [ unit="unit" ]>
            [ label ] [ attributes ]
            expression
        </define-parameter>

    unit ::= bool | int | float | hours | hours-1 | years | years-1| demands | fit

    expression ::=
        constant | parameter | operation | built-in | random-deviate | test-event

    constant ::=
          <bool value="Boolean-value" />
        | <int value="integer" />
        | <float value="float" />

    parameter ::=
          <parameter name="identifier" [ unit="unit" ] />
        | <system-mission-time [ unit="unit" ] />

    operation ::=
        numerical-operation | Boolean-operation | conditional-operation

Operations, built-ins and random deviates will be described in the
following sections.

We believe that the formalism to define stochastic equations should be
as large and as open as possible for at least two reasons: first,
available tools already propose a large set of distributions; second
this is a easy and interesting way to widen the spectrum of PSA. The
Model Exchange Format proposes a panoply of Boolean and arithmetic
operators. More operations can be added on demand. A major step would be
to introduce some algorithmic concepts like loops and functions. At this
stage, it does seem useful to introduce such advanced concepts in the
Model Exchange Format.

Operations
==========

Numerical Operation
-------------------

:numref:`table_numerical_operations` gives the list of arithmetic
operators proposed by the Model Exchange Format. Their XML
representation is given :numref:`bnf_numerical_operations`.

.. table:: Numerical Operations, their number of arguments and their semantics
    :name: table_numerical_operations

    +-----------+------------+-----------------------------------------+
    | Operator  | #arguments | Semantics                               |
    +===========+============+=========================================+
    | **neg**   | 1          | unary minus                             |
    +-----------+------------+-----------------------------------------+
    | **add**   | >1         | addition                                |
    +-----------+------------+-----------------------------------------+
    | **sub**   | >1         | subtraction                             |
    +-----------+------------+-----------------------------------------+
    | **mul**   | >1         | multiplication                          |
    +-----------+------------+-----------------------------------------+
    | **div**   | >1         | division                                |
    +-----------+------------+-----------------------------------------+
    | **pi**    | 0          | 3.1415926535...                         |
    +-----------+------------+-----------------------------------------+
    | **abs**   | 1          | absolute value                          |
    +-----------+------------+-----------------------------------------+
    | **acos**  | 1          | arc cosine of the argument in radians   |
    +-----------+------------+-----------------------------------------+
    | **asin**  | 1          | arc sine of the argument in radians     |
    +-----------+------------+-----------------------------------------+
    | **atan**  | 1          | arc tangent of the argument in radians  |
    +-----------+------------+-----------------------------------------+
    | **cos**   | 1          | cosine                                  |
    +-----------+------------+-----------------------------------------+
    | **cosh**  | 1          | hyperbolic cosine                       |
    +-----------+------------+-----------------------------------------+
    | **exp**   | 1          | exponential                             |
    +-----------+------------+-----------------------------------------+
    | **log**   | 1          | (Napierian) logarithm                   |
    +-----------+------------+-----------------------------------------+
    | **log10** | 1          | decimal logarithm                       |
    +-----------+------------+-----------------------------------------+
    | **mod**   | 2          | modulo                                  |
    +-----------+------------+-----------------------------------------+
    | **pow**   | 1          | power                                   |
    +-----------+------------+-----------------------------------------+
    | **sin**   | 1          | sine                                    |
    +-----------+------------+-----------------------------------------+
    | **sinh**  | 1          | hyperbolic sine                         |
    +-----------+------------+-----------------------------------------+
    | **tan**   | 1          | tangent                                 |
    +-----------+------------+-----------------------------------------+
    | **tanh**  | 1          | hyperbolic tangent                      |
    +-----------+------------+-----------------------------------------+
    | **sqrt**  | 1          | square root                             |
    +-----------+------------+-----------------------------------------+
    | **ceil**  | 1          | first integer greater than the argument |
    +-----------+------------+-----------------------------------------+
    | **floor** | 1          | first integer smaller than the argument |
    +-----------+------------+-----------------------------------------+
    | **min**   | >1         | minimum                                 |
    +-----------+------------+-----------------------------------------+
    | **max**   | >1         | maximum                                 |
    +-----------+------------+-----------------------------------------+
    | **mean**  | >1         | mean                                    |
    +-----------+------------+-----------------------------------------+

.. code-block:: bnf
    :name: bnf_numerical_operations
    :caption: Backus-Naur grammar for XML representation of numerical operations

    numerical-operation ::=
          <neg> expression </neg>
        | <add> expression+ </add>
        | <sub> expression+ </sub>
        | <mul> expression+ </mul>
        | <div> expression+ </div>
        | <pi />
        | <abs> expression </abs>
        | <acos> expression </acos>
        | <asin> expression </asin>
        | <atan> expression </atan>
        | <cos> expression </cos>
        | <cosh> expression </cosh>
        | <exp> expression </exp>
        | <log> expression </log>
        | <log10> expression </log10>
        | <mod> expression expression </mod>
        | <pow> expression expression </pow>
        | <sin> expression </sin>
        | <sinh> expression </sinh>
        | <tan> expression </tan>
        | <tanh> expression </tanh>
        | <sqrt> expression </sqrt>
        | <ceil> expression </ceil>
        | <floor> expression </floor>
        | <min> expression+ </min>
        | <max> expression+ </max>
        | <mean> expression+ </mean>

Example
~~~~~~~

Assume for instance we want to associate a negative
exponential distribution with a failure rate *λ*\ =1.23e-4/h to the basic
event "pump-failure". Using primitives defined above, we can encode
explicitly such probability distribution as follows.

.. code-block:: xml

    <define-basic-event name="pump-failure">
        <sub>
            <float value="1.0"/>
            <exp>
                <mul>
                    <neg>
                        <parameter name="lambda"/>
                    </neg>
                    <system-mission-time/>
                </mul>
            </exp>
        </sub>
    </define-basic-event>
    <define-parameter name="lambda">
        <float value="1.23e-4"/>
    </define-parameter>

Boolean Operations
------------------

:numref:`table_boolean_operators` gives the list of Boolean
operators proposed by the Model Exchange Format. Their XML
representation is given :numref:`bnf_boolean_operations`.

.. table:: Boolean operators, their number of arguments and their semantics
    :name: table_boolean_operators

    +----------+------------+-------------+
    | Operator | #arguments | Semantics   |
    +==========+============+=============+
    | **and**  | > 1        | Boolean and |
    +----------+------------+-------------+
    | **or**   | >1         | Boolean or  |
    +----------+------------+-------------+
    | **not**  | 1          | Boolean not |
    +----------+------------+-------------+
    | **eq**   | 2          | =           |
    +----------+------------+-------------+
    | **df**   | 2          |  ≠          |
    +----------+------------+-------------+
    | **lt**   | 2          | <           |
    +----------+------------+-------------+
    | **gt**   | 2          | >           |
    +----------+------------+-------------+
    | **leq**  | 2          |  ≤          |
    +----------+------------+-------------+
    | **geq**  | 2          |  ≥          |
    +----------+------------+-------------+

.. code-block:: bnf
    :name: bnf_boolean_operations
    :caption: Backus-Naur grammar for XML representation of Boolean operations

    Boolean-operation ::=
          <not> expression </not>
        | <and> expression+ </and>
        | <or> expression+ </or>
        | <eq> expression expression </eq>
        | <df> expression expression </df>
        | <lt> expression expression </lt>
        | <gt> expression expression </gt>
        | <leq> expression expression </leq>
        | <geq> expression expression </geq>

Conditional Operations
----------------------

The Model Exchange Format proposes two conditional operations: an
"if-then-else" operation and a "switch/case" operation. The latter is a
list of pairs of expressions, introduced by the tag "case". The first
expression of the pair should be a Boolean condition. If this condition
is realized, then the second expression is evaluated and its value
returned. Otherwise, the next pair is considered.

The list ends with an expression, in order to be sure that the switch
has always a possible value. The XML representation for conditional
operation is given :numref:`bnf_conditional_operations`.

.. code-block:: bnf
    :name: bnf_conditional_operations
    :caption: Backus-Naur grammar for XML representation of conditional operations

    conditional-operation ::=
        if-then-else-operation | switch-operation

    if-then-else-operation ::=
        <ite> expression expression expression </ite>

    switch-operation ::=
        <switch>
            case-operation*
            expression
        </switch>

    case-operation ::= <case> expression expression </case>

Example
~~~~~~~
Assume for instance we want to give different values to the
failure rate "lambda" depending on a global parameter "stress-level":

::

    "lambda"=1.0e-4/h if "stress-level"=1,
    "lambda"=2.5e-4/h if "stress-level"=2, and finally
    "lambda"=1.0e-3/h if "stress-level"=3.

The value of "stress-level" will be modified while walking along the
sequences of events trees or depending on the initiating event. Using
primitives defined so far, we can encode the definition of "lambda" as
follows.

.. code-block:: xml

    <define-parameter name="lambda">
        <switch>
            <case>
                <eq>
                    <parameter name="stress-level"/>
                    <int value="1"/>
                </eq>
                <float value="1.0e-4"/>
            </case>
            <case>
                <eq>
                    <parameter name="stress-level"/>
                    <int value="2"/>
                </eq>
                <float value="2.5e-4"/>
            </case>
            <float value="1.0e-3"/>
        </switch>
    </define-parameter>


Built-Ins
=========

Description
-----------

Built-ins can be seen as macro arithmetic expressions. They are mainly
used to simplify the writing of probability distributions. A special
built-in "extern-function" makes it possible to define externally
calculated built-ins. As for arithmetic operators, more built-ins can be
added on demand to the Model Exchange Format.
Here follows a preliminary list of built-ins.
:numref:`table_built_ins` summarizes this preliminary list.

Exponential with two parameters
    This built-in implements the negative exponential distribution.
    The two parameters are the hourly failure rate, usually called *λ*, and the time *t*.
    Its definition is as follows.

Exponential with four parameters (GLM)
    This built-in generalizes the previous one.
    It makes it possible to take into account repairable
    components (through the hourly repairing rate *µ*) and failures on
    demand (through the probability *γ* of such an event). It takes four
    parameters, *γ*, the hourly failure rate *λ*, *µ* and the time *t* (in
    this order). Its definition is as follows.

Weibull
    This built-in implements the Weibull distribution. It takes
    four parameters: a scale parameter *α*, a shape parameter *β*, a
    time shift *t*\ :sub:`0`, and the time *t* (in this order). Its definition
    is as follows.

Periodic test
    In several applications, it is of interest to introduce
    some specific distributions to describe periodically tested components.
    A further investigation is certainly necessary on this topic. We
    tentatively give here a candidate definition (that is extracted from one
    of the tools we considered).

The "periodic-test" built-in would take the following parameters (in order).

+---------------+---------------------------------------------------------------------------------------+
| **Parameter** | **Description**                                                                       |
+===============+=======================================================================================+
| **λ**         | failure rate when the component is working.                                           |
+---------------+---------------------------------------------------------------------------------------+
| **λ**\*       | failure rate when the component is tested.                                            |
+---------------+---------------------------------------------------------------------------------------+
| **µ**         | repair rate (once the test showed that the component is failed).                      |
+---------------+---------------------------------------------------------------------------------------+
| **τ**         | delay between two consecutive tests.                                                  |
+---------------+---------------------------------------------------------------------------------------+
| **θ**         | delay before the first test.                                                          |
+---------------+---------------------------------------------------------------------------------------+
| **γ**         | probability of failure due to the (beginning of the) test.                            |
+---------------+---------------------------------------------------------------------------------------+
| **π**         | duration of the test.                                                                 |
+---------------+---------------------------------------------------------------------------------------+
| **x**         | indicator of the component availability during the test (1 available, 0 unavailable). |
+---------------+---------------------------------------------------------------------------------------+
| **σ**         | test covering: probability that the test detects the failure, if any.                 |
+---------------+---------------------------------------------------------------------------------------+
| **ω**         | probability that the component is badly restarted after a test or a repair.           |
+---------------+---------------------------------------------------------------------------------------+
| **t**         | the mission time.                                                                     |
+---------------+---------------------------------------------------------------------------------------+

:numref:`fig_periodic_test` illustrates the meaning of the parameters *τ*, *θ* and *π*.

.. figure:: ../images/periodic_test.png
    :name: fig_periodic_test
    :align: center

    Meaning of parameters *τ*, *θ* and *π* of the "periodic-test" built-in

There are three phases in the behavior of the component. The first
phase corresponds to the time from 0 to the date of the first test, i.e. *θ*.
The second phase is the test phase.
It spreads from times *θ*\ +n.\ *τ* to *θ*\ +n.\ *τ*\ +\ *π*, with n any positive integer.
The third phase is the functioning phase.
It spreads from times *θ*\ +n.\ *τ*\ +\ *π* from *θ*\ +(n+1).\ *τ*.

In the first phase, the distribution is a simple exponential law of parameter *λ*.

The component may enter in the second phase in three states, either
working, failed or in repair. In the latter case, the test is not
performed. The Markov graphs for each of these cases are pictured
:numref:`fig_multi_phase_markov_graph`.

.. figure:: ../images/multi_phase_markov_graph.png
    :name: fig_multi_phase_markov_graph
    :align: center

    Multi-phase Markov graph for the "periodic-test" built-in

Ai's, Fi's, Ri's states correspond respectively to states where the
component is available, failed and in repair. Dashed lines correspond to
immediate transitions. Initial states are respectively A1, F1 and R1.

The situation is simpler in the third phase. If the component enters
available this phase, the distribution follows an exponential law of
parameter *λ*. If the component enters failed in this phase, it remains
phase up to the next test. Finally, the Markov graph for the case where
the component is in repair is the same as in the second phase.

The Model Exchange Format could provide also two simplified forms for
the periodic test distribution.

Periodic-test with 5 arguments
    The first one takes five parameters: *λ*, *µ*, *τ*, *θ* and *t*.
    In that case, the test is assumed to be instantaneous.
    Therefore, parameters *λ*\* (the failure rate during the test) and x
    (indicator of the component availability during the test) are
    meaningless. There other parameters are set as follows.

    - *γ* (the probability of failure due to the beginning of the test) is set to 0.
    - *σ* (the probability that the test detects the failure, if any) is set to 1.
    - *ω* (the probability that the component is badly restarted after a test or a repair)
      is set to 0.

Periodic-test with 4 arguments
    The second one takes only four parameters: *λ*, *τ*, *θ* and t.
    The repair is assumed to be instantaneous (or equivalently the repair rate µ = +∞).

Extern functions
    The Model Exchange Format should provide a mean to
    call extern functions. This makes it extensible and allows the link the
    PSA assessment tools with complex tools to calculate physical behavior
    (like fire propagation or gas dispersion). This call may take any number
    of arguments and return a single value at once (some interfacing glue
    can be used to handle the case where several values have to be
    returned). It has been also suggested that extern function calls take
    XML terms as input and output. This is probably the best way to handle
    communication between tools, but it would be far too complex too embed
    XML into stochastic expressions.


.. table:: Built-ins, their number of arguments and their semantics
    :name: table_built_ins

    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+
    | Built-in            | #arguments | Semantics                                                                                                                 |
    +=====================+============+===========================================================================================================================+
    | **exponential**     | 2          | negative exponential distribution with hourly failure rate and time                                                       |
    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+
    | **exponential**     | 4          | negative exponential distribution with probability of failure on demand, hourly failure rate, hourly repair rate and time |
    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+
    | **Weibull**         | 4          | Weibull distribution with scale and shape parameters, a time shift and the time                                           |
    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+
    | **periodic-test**   | 11, 5 or 4 | Distributions to describe periodically tested components                                                                  |
    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+
    | **extern-function** | any        | call to an extern routine                                                                                                 |
    +---------------------+------------+---------------------------------------------------------------------------------------------------------------------------+


XML Representation
------------------

The Backus-Naur grammar for the XML representation of built-ins is given
:numref:`bnf_built_ins`.

.. code-block:: bnf
    :name: bnf_built_ins
    :caption: Backus-Naur grammar for XML representation of Built-ins

    built-in ::=
          <exponential> [ expression ]:2 </exponential>
        | <GLM> [ expression ]:4 </GLM>
        | <Weibull> [ expression ]:3 </Weibull>
        | <periodic-test> [ expression ]:11 </periodic-test>
        | <periodic-test> [ expression ]:5 </periodic-test>
        | <periodic-test> [ expression ]:4 </periodic-test>
        | <extern-function name="name" > expression* </extern-function>


.. admonition:: Positional versus Named Arguments

    We adopted a positional definition of arguments.
    For instance, in the negative exponential distribution,
    we assumed that the failure rate is always the first argument
    and the mission time is always the second.
    An alternative way would be to name arguments,
    i.e., to enclose them into tags explicating their role.
    For instance, the failure rate would be enclosed in a tag "failure-rate",
    the mission time in a tag "time" and so on...
    The problem with this second approach is that many additional tags must be defined,
    and it is not sure that it helps a lot the understanding of the built-ins.
    Nevertheless, we may switch to this approach
    if the experience shows that the first one proves to be confusing.


Example
~~~~~~~

The negative exponential distribution can be encoded in a simple way as follows.

.. code-block:: xml

    <define-basic-event name="pump-failure">
        <exponential>
            <parameter name="lambda"/>
            <system-mission-time/>
        </exponential>
    </define-basic-event>

Primitive to Generate Random Deviates
=====================================

Description
-----------

Primitives to generate random deviates are the real stochastic part of
stochastic equations. They can be used in two ways: in a regular context
they return a default value (typically their mean value). When used to
perform Monte-Carlo simulations, they return a number drawn at
pseudo-random according their type. The Model Exchange Format includes
two types of random deviates: built-in deviates like uniform, normal or
lognormal, and histograms that are user defined discrete distributions. A
preliminary list of distributions is summarized in :numref:`table_random_deviates`.
As for arithmetic operators and built-ins, this
list can be extended on demand.

.. table:: Primitive to generate random deviates, their number of arguments and their semantics
    :name: table_random_deviates

    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | Distribution          | #arguments | Semantics                                                                                                  |
    +=======================+============+============================================================================================================+
    | **uniform-deviate**   | 2          | uniform distribution between a lower and an upper bounds                                                   |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | **normal-deviate**    | 2          | normal (Gaussian) distribution defined by its mean and its standard deviation                              |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | **lognormal-deviate** | 3          | lognormal distribution defined by its mean, its error factor and the confidence level of this error factor |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | **gamma-deviate**     | 2          | gamma distributions defined by a shape and a scale factors                                                 |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | **beta-deviate**      | 2          | beta distributions defined by two shape parameters *α* and *β*                                             |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+
    | **histograms**        | any        | discrete distributions defined by means of a list of pairs                                                 |
    +-----------------------+------------+------------------------------------------------------------------------------------------------------------+

Uniform Deviates
    These primitives describe uniform distributions in a
    given range defined by its lower- and upper-bounds. The default value of
    a uniform deviate is the mean of the range, i.e., (lower-bound + upper-bound)/2.

Normal Deviates
    These primitives describe normal distributions
    defined by their mean and their standard deviation (refer to text book
    for a more detailed explanation). By default, the value of a normal
    distribution is its mean.

Lognormal distribution
    These primitives describe lognormal
    distributions defined by their mean µ and their error factor EF. A
    random variable is distributed according to a lognormal distribution if
    its logarithm is distributed according to a normal distribution. If µ
    and *σ* are respectively the mean and the standard deviation of the
    distribution, the probability density of the random variable is as follows.

    Its mean, *E(x)* is defined as follows.

    The confidence intervals [X\ :sub:`0,05`, X\ :sub:`0,95`] associated
    with a confidence level of *0.95* and the median X\ :sub:`0,50` are the following:

    The error factor *EF* is defined as follows:

    with and .

    Once the mean and the error factor are known, it is then possible to
    determine the confidence interval and thereby the parameters of the
    lognormal law.

Gamma Deviates
    These primitives describe Gamma distributions defined
    by their shape parameter k and their scale parameter *θ*. If k is an
    integer then the distribution represents the sum of k exponentially
    distributed random variables, each of which has mean *θ*.

    The probability density of the gamma distribution can be expressed in
    terms of the gamma function:

    The default value of the gamma distribution is its mean, i.e., k.\ *θ*.

Beta Deviates
    These primitives describe Beta distributions defined by
    two shape parameters *α* and *β*.

    The probability density of the beta distribution can be expressed in
    terms of the B function:

    The default value of the gamma distribution is its mean, i.e., *α*/(*α*\ +\ *β*).

Histograms
    Histograms are lists of pairs (x\ :sub:`1`, E\ :sub:`1`)...
    (x\ :sub:`n`, E\ :sub:`n`) where the x\ :sub:`i`'s are numbers such that
    x\ :sub:`i` < x\ :sub:`i+1` for i=1...n-1 and the E\ :sub:`i`'s are
    expressions.

    The x\ :sub:`i`'s represent upper bounds of successive intervals. The
    lower bound of the first interval x\ :sub:`0` is given apart.

    The drawing of a value according to a histogram is a two steps process.
    First, a value z is drawn uniformly in the range [x\ :sub:`0`,
    x\ :sub:`n`]. Then, a value is drawn at random by means of the
    expression E\ :sub:`i`, where i is the index of the interval such
    x\ :sub:`i-1` < z ≤ x\ :sub:`i`.

    By default, the value of a histogram is its mean, i.e.,

    Both Cumulative Distribution Functions and Density Probability
    Distributions can be translated into histograms.

    A Cumulative Distribution Function is a list of pairs (p\ :sub:`1`,
    v\ :sub:`1`)... (p\ :sub:`n`, v\ :sub:`n`), where the p\ :sub:`i`'s are such
    that p\ :sub:`i` < p\ :sub:`i+1` for i=1... n and p\ :sub:`n`\ =1. It
    differs from histograms in two ways. First, X axis values are normalized
    (to spread between 0 and 1) and second they are presented in a
    cumulative way. The histogram that corresponds to a Cumulative
    Distribution Function (p\ :sub:`1`, v\ :sub:`1`)... (p\ :sub:`n`, v\ :sub:`n`)
    is the list of pairs (x\ :sub:`1`, v\ :sub:`1`)... (x\ :sub:`n`, v\ :sub:`n`),
    with the initial value x\ :sub:`0` is 0, x\ :sub:`1` = p\ :sub:`1` and
    x\ :sub:`i` = p\ :sub:`i` - p\ :sub:`i-1` for all i>1.

    A Discrete Probability Distribution is a list of pairs (d\ :sub:`1`,
    m\ :sub:`1`)... (d\ :sub:`n`, m\ :sub:`n`). The d\ :sub:`i`'s are
    probability densities. They could be however any kind of values. The
    m\ :sub:`i`'s are midpoints of intervals and are such that m\ :sub:`1` <
    m\ :sub:`2` < ... < m\ :sub:`n` < 1. The histogram that corresponds to a
    Discrete Probability Distribution (d\ :sub:`1`, m\ :sub:`1`)... (d\ :sub:`n`,
    m\ :sub:`n`) is the list of pairs (x\ :sub:`1`, d\ :sub:`1`)... (x\ :sub:`n`,
    d\ :sub:`n`), with the initial value x\ :sub:`0` = 0, x\ :sub:`1` =
    2.m\ :sub:`1` and x\ :sub:`i` = x\ :sub:`i-1` + 2.(m\ :sub:`i`-x\ :sub:`i-1`).

XML Representation
------------------

The Backus-Naur grammar for the XML representation of random deviates is given

.. code-block:: bnf
    :caption: Backus-Naur grammar for XML representation of random deviates

    random-deviate ::=
          <uniform-deviate> [ expression ]:2 </uniform-deviate>
        | <normal-deviate> [ expression ]:2 </normal-deviate>
        | <lognormal-deviate> [ expression ]:3 </lognormal-deviate>
        | <gamma-deviate> [ expression ]:2 </gamma-deviate>
        | <beta-deviate> [ expression ]:2 </beta-deviate>
        | histogram

    histogram ::= <histogram > expression /bin/+ </histogram>

    bin ::= <bin> expression expression </bin>

Example
~~~~~~~

Assume that the parameter "lambda" of a negative exponential
distribution is distributed according to a lognormal distribution of
mean 0.001 and error factor 3 for a confidence level of 95%. The
parameter "lambda" is then defined as follows.

.. code-block:: xml

    <define-parameter name="lambda">
        <lognormal-deviate>
            <float value="0.001"/>
            <float value="3"/>
            <float value="0.95"/>
        </lognormal-deviate>
    </define-parameter>

Example
~~~~~~~

Assume that the parameter "lambda" has been sampled outside
of the model and is distributed according to the following histogram.

.. image:: ../images/lambda_histogram.svg
    :align: center

The XML encoding for "lambda" is as follows.

.. code-block:: xml

    <define-parameter name="lambda">
        <histogram>
            <float value="100"/>
            <bin> <float value="170"/> <float value="0.70e-4"/> </bin>
            <bin> <float value="200"/> <float value="1.10e-4"/> </bin>
            <bin> <float value="210"/> <float value="1.30e-4"/> </bin>
            <bin> <float value="230"/> <float value="1.00e-4"/> </bin>
            <bin> <float value="280"/> <float value="0.50e-4"/> </bin>
        </histogram>
    </define-parameter>


.. _test_event:

Directives to Test the Status of Initiating and Functional Events
=================================================================

Description
-----------

The Model Exchange Format provides two special directives to test
whether a given initiating event occurred and whether a given functional
event is in a given state. The meaning of these directives will be
further explained in Section :ref:`instructions`.

:numref:`table_test_event` presents these directives and their arguments.

.. table:: Directives to test the status of initiating and functional events
    :name: table_test_event

    +---------------------------+------------+-----------------------------------------------------------------------------------------------------------------------------------+
    | Built-in                  | #arguments | Semantics                                                                                                                         |
    +===========================+============+===================================================================================================================================+
    | **test-initiating-event** | 1          | <test-initiating-event name="name" /> returns true if the initiating event of the given name occurred.                            |
    +---------------------------+------------+-----------------------------------------------------------------------------------------------------------------------------------+
    | **test-functional-event** | 2          | <test-functional-event name="name" state="state" /> returns true if the functional event of the given name is in the given state. |
    +---------------------------+------------+-----------------------------------------------------------------------------------------------------------------------------------+

XML Representation
------------------

The XML representation for directives to test the status of initiating
and functional events is given :numref:`bnf_test_event`.

.. code-block:: bnf
    :name: bnf_test_event
    :caption: Backus-Naur grammar for XML representation of directives
              to test the status of initiating and functional events

    test-event ::=
          <test-initiating-event name="name" />
        | <test-functional-event name="name" state="identifier" />
