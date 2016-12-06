.. _meta_logical_layer:

******************
Meta-Logical Layer
******************

The meta-logical layer is populated constructs
like common cause groups, delete terms, recovery rules,
and exchange events that are used to give flavors to fault trees.
This chapter reviews all these constructs.

Common Cause Groups
===================

Description
-----------

From a theoretical view point,
one of the basic assumptions of the fault tree technique
is that occurrences of basic events are independent from a statistical viewpoint.
However, most of the PSA models include, to a large extent, so-called common cause groups.
Common cause groups are groups of basic events
whose failure are not independent from a statistical view point.
They may occur either independently or dependently due to a common cause failure.
So far, existing tools embed three models for common cause failures (CCF):
the beta-factor model, the Multiple Greek letters (MGL) model and the alpha-factor model.
Alpha-factor and MGL models differ only in the way
the factors for each level (2 components fail, 3 components fail, etc.) are given.
The Model Exchange Format proposes the three mentioned models plus a fourth one,
so-called phi-factor, which is a more direct way to set factors.

Beta-factor
    The :math:`\beta`-factor model assumes
    that if a common cause occurs,
    then all components of the group fail simultaneously.
    Components can fail independently.
    Multiple independent failures are neglected.
    The :math:`\beta`-factor model assumes, moreover,
    that all the components of the group
    have the same probability distribution.
    It is characterized by this probability distribution
    and the conditional probability :math:`\beta`
    that all components fail, given that one component failed.

    Let :math:`BE_1, BE_2, \ldots, BE_n` be the :math:`n` basic events of a common cause group
    with a probability distribution :math:`Q` and a beta-factor :math:`\beta`.
    Applying the beta-factor model on the fault tree consists in following operations.

    #. Create new basic events :math:`BE_{CCF_i}` for each :math:`BE_i`
       to represent the independent occurrence of :math:`BE_i`
       and :math:`BE_{CCF_i}` to represent the occurrence of all :math:`BE_i` together.
    #. Substitute a gate :math:`G_i = BE_{CCF_i} \lor BE_i`
       for each basic event :math:`BE_i`.
    #. Associate the probability distribution (e.g., :math:`\beta \times Q`)
       with the event :math:`BE_{CCF_i}`.

Multiple Greek Letters
    The Multiple Greek Letters (MGL) model generalizes the beta-factor model.
    It considers the cases
    where sub-groups of :math:`1, 2, \ldots, n-1` components of the group fail together.
    This model is characterized by the probability distribution of failure of the components,
    and :math:`n-1` factors :math:`\rho_2, \ldots, \rho_n`,
    :math:`\rho_k` denotes the conditional probability
    that :math:`k` components of the group fail given that :math:`k-1` failed.

    Let :math:`BE_1, BE_2, \ldots, BE_n` be the :math:`n` basic events of a common cause group
    with a probability distribution :math:`Q` and factors :math:`\rho_2, \ldots, \rho_n`.
    Applying the MGL model on the fault tree consists in following operations.

    #. Create a basic event for each combination of basic events of the group
       (there are :math:`2^n-1` such combinations).
    #. Transform each basic event :math:`BE_i` into an OR-gate :math:`G_i`
       over all newly created event basic events
       that represent a group that contains :math:`BE_i`.
    #. Associate the following probability distribution
       with each newly created basic event representing a group of :math:`k` components
       (with :math:`\rho_{n+1} = 0`).

    .. math::

        Q_k = \frac{1}{\binom{n-1}{k-1}} \times \left(\prod_{i=2}^{k}\rho_i \right) \times
            (1 - \rho_{k+1}) \times Q

    For instance, for a group of 4 basic events: A, B, C and D,
    the basic event A is transformed into a gate
    :math:`G_A = A \lor AB \lor AC \lor AD \lor ABC \lor ABD \lor ACD \lor ABDC`
    and the :math:`Q_k`'s are as follows.

    .. math::

        Q_1 = (1 - \rho_2) \times Q

        Q_2 = \frac{1}{3} \times \rho_2 \times (1 - \rho_3) \times Q

        Q_3 = \frac{1}{3} \times \rho_2 \times \rho_3  \times (1 - \rho_4) \times Q

        Q_4 = \rho_2 \times \rho_3 \times \rho_4 \times Q

    Note that if :math:`\rho_k = 0`,
    then :math:`Q_k, Q_{k+1}, \ldots` are null as well.
    In such a case it is not necessary to create the groups with k elements or more.

Alpha-Factor
    The alpha-factor model is the same as the MGL model
    except in the way the factors are given.
    Here :math:`n` factors :math:`\alpha_1, \ldots, \alpha_n` are given.
    :math:`\alpha_k` represents the fraction of the total failure probability
    due to common cause failures that impact exactly :math:`k` components.
    The distribution associated with a group of size :math:`k` is as follows:

    .. math::

        Q_k = \frac{k}{\binom{n-1}{k-1}} \times \frac{\alpha_k}{\sum_{i=1}^{n}i\alpha_i} \times Q

Phi-Factor
    The phi-factor model is the same as MGL and alpha-factor models
    except that factors for each level are given directly.

    Indeed, the sum of the :math:`\phi_i`'s should equal 1.

XML representation
------------------

The Backus-Naur form for the XML description of Common Cause Failure Groups
is given in :numref:`bnf_ccf_groups`.
Note that the number of factors depends on the model.
Tools are in charge of checking that there is the good number of factors.
Note also that each created basic event is associated with a factor
that depends on the model and the level of the basic event.
The sum of the factors
associated with basic events of a member of the CCF group should be equal to 1;
although, this is not strictly required by the Model Exchange Format.

.. code-block:: bnf
    :name: bnf_ccf_groups
    :caption: Backus-Naur form for the XML representation of CCF-groups

    CCF-group-definition ::=
        <define-CCF-group name="identifier" model="CCF-model" >
            [ label ]
            [ attributes ]
            members
            distribution
            factors
        </define-CCF-group>

    members ::=
        <members>
            <basic-event name="identifier" />+
        </members>

    factors ::=
          <factors> factor+ </factors>
        | factor

    factor ::=
        <factor [ level="integer" ] >
            expression
        </factor>

    distribution ::=
        <distribution>
            expression
        </distribution>

    CCF-model ::= beta-factor | MGL | alpha-factor | phi-factor


Example
~~~~~~~

Here follows a declaration of a CCF-group with four elements under the MGL model.

.. code-block:: xml

    <define-CCF-group name="pumps" model="MGL">
        <members>
            <basic-event name="pumpA"/>
            <basic-event name="pumpB"/>
            <basic-event name="pumpC"/>
            <basic-event name="pumpD"/>
        </members>
        <factors>
            <factor level="2">
                <float value="0.10"/>
            </factor>
            <factor level="3">
                <float value="0.20"/>
            </factor>
            <factor level="4">
                <float value="0.30"/>
            </factor>
        </factors>
        <distribution>
            <exponential>
                <parameter name="lambda"/>
                <system-mission-time/>
            </exponential>
        </distribution>
    </define-CCF-group>

Delete Terms, Recovery Rules and Exchange Events
================================================

Description
-----------

Delete Terms
    Delete Terms are groups of pairwise exclusive basic events,
    used to model impossible configurations.
    A typical example is the case where:

    - The basic event a can only occur when the equipment A is in maintenance.
    - The basic event b can only occur when the equipment B is in maintenance.
    - Equipment A and B are redundant and cannot be simultaneously in maintenance.

    In most of the tools, delete terms are considered as a post-processing mechanism:
    minimal cut sets containing two basic events of a delete terms are discarded.
    In order to speed-up calculations,
    some tools use basic events to discard minimal cut sets on the fly, during their generation.

    Delete Terms can be handled in several ways.
    Let :math:`G = \{e_1, e_2, e_3\}` be a Delete Term (group).

    - A first way to handle :math:`G`, is to use it to post-process minimal cut sets,
      or to discard them on the fly during their generation.
      If a minimal cut set contains at least two of the elements of :math:`G`,
      it is discarded.

    - A global constraint :math:`C_G = \text{not 2-out-of-3}(e_1, e_2, e_3)` is introduced,
      and each top event (or event tree sequences) "top" is rewritten as :math:`top \land C_G`.

    - As for Common Causes Groups, the :math:`e_i`'s are locally rewritten in as gates:

        * :math:`e_1` is rewritten as
          a gate :math:`ge_1 = e_1 \land \lnot e_2 \land \lnot e_3`
        * :math:`e_2` is rewritten as
          a gate :math:`ge_2 = e_2 \land \lnot e_1 \land \lnot e_3`
        * :math:`e_3` is rewritten as
          a gate :math:`ge_3 = e_3 \land \lnot e_1 \land \lnot e_2`

Recovery Rules
    Recovery Rules are an extension of Delete Terms.
    A Recovery Rule is a couple :math:`(H, e)`,
    where :math:`H` is a set of basic events and :math:`e` is a (fake) basic event.
    It is used to post-process minimal cut sets:
    if a minimal cut set :math:`C` contains :math:`H`, the :math:`e` is added to :math:`C`.
    Recovery Rules are used to model actions taken in some specific configurations
    to mitigate the risk (hence their name).

    Here several remarks can be made.

    - It is possible to mimic Delete Terms by means of recovery rules.
      To do so, it suffices to assign the basic event e to the value "false" or the probability 0.0.
    - As for Delete Terms,
      it is possible to give purely logical interpretation to Recovery Rules.
      The idea is to add a global constraint :math:`H \Rightarrow e`, i.e., :math:`\lnot H \lor e`,
      for each Recovery Rule :math:`(H, e)`.
    - Another definition of Recovery Rules as a post-processing
      is that the event :math:`e` is substituted for subset :math:`H` in the minimal cut set.
      This definition, however, has the major drawback
      by being impossible to interpret with a Boolean logic.
      No Boolean formula can withdraw events from a configuration.

Exchange Events
    Exchange Events are very similar to Recovery Rules.
    An Exchange Event (Rule) is a triple :math:`(H, e, e')`,
    where :math:`H` is a set of basic events,
    and :math:`e` and :math:`e'` are two basic events.
    Considered as a post-processing of minimal cut sets,
    such a rule is interpreted as follows.
    If the minimal cut set contains both the set :math:`H` and the basic event :math:`e`,
    then the basic event :math:`e'` is substituted for :math:`e` in the cut set.
    For the same reason as above,
    Exchange Events cannot be interpreted with a Boolean logic.

All Extra-Logical Constructs in One: the Notion of Substitution
---------------------------------------------------------------

Constructs that cannot be interpreted with a Boolean logic
should be avoided for at least two reasons.
First, models containing such constructs are not declarative.
Second, and more importantly,
they tighten assessment tools to one specific type of algorithms.
The second interpretation of Recovery Rules and Exchange Events
tighten the models to be assessed by means of the minimal cut sets approach.

Nevertheless, Recovery Rules and Exchange Events are useful and broadly used in practice.
Fortunately, Exchange Events (considered as a post processing mechanism)
can be avoided in many cases by using the instructions
that give flavors to fault trees while walking along event tree sequences:
in a given sequence, one may decide to substitute the event :math:`e'` for the event :math:`e`
(or the parameter :math:`p'` for the parameter :math:`p`) in the Fault Trees collected so far.
This mechanism is perfectly acceptable
because it applies while creating the Boolean formula to be assessed.

It is not yet possible to decide
whether Recovery Rules (under the second interpretation) and Exchange Events
can be replaced by purely declarative constructs or by instructions of event trees.
This has to be checked on real-life models.
To represent Delete Term, Recovery Rules and Exchange Events,
the Model Exchange Format introduces a unique construct: the notion of substitution.

A substitution is a triple :math:`(H, S, t)` where:

- :math:`H`, the hypothesis, is a (simple) Boolean formula built over basic events.
- :math:`S`, the source, is also a possibly empty set of basic events.
- :math:`t`, the target, is either a basic event or a constant.

Let :math:`C` be a minimal cut set, i.e., a set of basic events.
The substitution :math:`(H, S, t)` is applicable on :math:`C`
if :math:`C` satisfies :math:`H` (i.e., if :math:`H` is true when :math:`C` is realized).
The application of :math:`(H, S, t)` on :math:`C` consists
in removing from :math:`C` all the basic events of :math:`S`
and in adding to :math:`C` the target :math:`t`.

Note that if t is the constant "true",
adding t to :math:`C` is equivalent to adding nothing.
If :math:`t` is the constant "false",
adding :math:`t` to :math:`C` is equivalent to discard :math:`C`.

This notion of substitution generalizes
the notions of Delete Terms, Recovery Rules and Exchange Events:

- Let :math:`D = \{e_1, e_2, \ldots, e_n\}`
  be a group of pairwise exclusive events (a Delete Term).
  Then :math:`D` is represented as the substitution
  :math:`(2-out-of-n(e_1, e_2, \ldots, e_n), \varnothing, \text{false})`.
- Let :math:`(H, e)` be a Recovery Rule, under the first interpretation,
  where :math:`H = \{e_1, e_2, \ldots, e_n\}`.
  Then, :math:`(H, e)` is represented by the substitution
  :math:`(e_1 \land e_2 \land \ldots \land e_n, \varnothing, e)`.
- Let :math:`(H, e)` be a Recovery Rule, under the second interpretation,
  where :math:`H = \{e_1, e_2, \ldots, e_n\}`.
  Then :math:`(H, e)` is represented by the substitution
  :math:`(e_1 \land e_2 \land \ldots \land e_n, H, e)`.
- Finally, let :math:`(H, e, e')` be an Exchange Event Rule,
  where :math:`H = \{e_1, e_2, \ldots, e_n\}`.
  Then :math:`(H, e, e')` is represented by the substitution
  :math:`(e_1 \land e_2 \land \ldots \land e_n \land e, {e}, e')`.

Note that a substitution :math:`(H, \varnothing, t)`
can always be interpreted as the global constraint :math:`H \Rightarrow t`.

XML Representation
------------------

The Backus-Naur form for the XML description of substitutions
is given in :numref:`bnf_substitution`.
The optional attribute "type" is used to help tools that implement "traditional" substitutions.

.. code-block:: bnf
    :name: bnf_substitution
    :caption: Backus-Naur form for the XML representation of exclusive-groups

    substitution-definition ::=
        <define-substitution [ name="identifier" ] [ type="identifier" ] >
            [ label ] [ attributes ]
            <hypothesis> Boolean-formula </hypothesis>
            [ <source> basic-event+ </source> ]
            <target> basic-event+ | Boolean-constant </target>
        </define-substitution>


Example
~~~~~~~

Assume that Basic Events "failure-pump-A", "failure-pump-B" and "failure-pump-C"
are pairwise exclusive (they form a delete term)
because they can only occur
when, respectively, equipment A, B and C are under maintenance
and only one equipment can be in maintenance at once.
The representation of such a delete term is as follows.

.. code-block:: xml

    <define-substitution name="pumps" type="delete-terms">
        <hypothesis>
            <atleast min="2">
                <basic-event name="failure-pump-A"/>
                <basic-event name="failure-pump-B"/>
                <basic-event name="failure-pump-C"/>
            </atleast>
        </hypothesis>
        <target>
            <constant value="false"/>
        </target>
    </define-substitution>

Example
~~~~~~~

Assume that if the valve V is broken and an overpressure is detected in pipe P,
then a mitigating action A is performed.
This is a typical Recovery Rule (under the first interpretation),
where the hypothesis is the conjunction of Basic Events "valve-V-broken" and "overpressure-pipe-P",
and the added Basic Event is "failure-action-A".
It is encoded as follows.

.. code-block:: xml

    <define-substitution name="mitigation" type="recovery-rule">
        <hypothesis>
            <and>
                <basic-event name="valve-V-broken"/>
                <basic-event name="overpressure-pipe-P"/>
            </and>
        </hypothesis>
        <target>
            <basic-event name="failure-action-A"/>
        </target>
    </define-substitution>

Example
~~~~~~~

Assume that if magnitude of the earthquake is 5, 6 or 7,
the size of a leak of a given pipe P gets large,
while it is small for magnitudes below 5.
We can use an exchange event rule to model this situation.

.. code-block:: xml

    <define-substitution name="magnitude-impact" type="exchange-event">
        <hypothesis>
            <or>
                <basic-event name="magnitude-5"/>
                <basic-event name="magnitude-6"/>
                <basic-event name="magnitude-7"/>
            </or>
        </hypothesis>
        <source>
            <basic-event name="small-leak-pipe-P"/>
        </source>
        <target>
            <basic-event name="large-leak-pipe-P"/>
        </target>
    </define-substitution>
