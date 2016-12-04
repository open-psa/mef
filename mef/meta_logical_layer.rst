.. _meta_logical_layer:

##################
Meta-Logical Layer
##################

The meta-logical layer is populated constructs like common cause groups,
delete terms, recovery rules, and exchange events that are used to give
flavors to fault trees. This chapter reviews all of these constructs.

Common Cause Groups
===================

Description
-----------

From a theoretical view point, one of the basic assumptions of the fault
tree technique is that occurrences of basic events are independent from
a statistical viewpoint. However, most of the PSA models include, to a
large extent, so-called common cause groups. Common cause groups are
groups of basic events whose failure are not independent from a
statistical view point. They may occur either independently or
dependently due to a common cause failure. So far, existing tools embed
three models for common cause failures (CCF): the beta-factor model, the
multiple Greek letters (MGL) model and the alpha-factor model.
Alpha-factor and MGL models differ only from the way the factors for
each level (2 components fail, 3 components fail...) are given. The Model
Exchange Format proposes the three mentioned models plus a fourth one,
so-called phi-factor, which is a more direct way to set factors.

Beta-factor
    The *β*-factor model assumes that if a common cause
    occurs then all components of the group fail simultaneously. Components
    can fail independently. Multiple independent failures are neglected.
    The *β*-factor model assumes, moreover, that all of the components of the
    group have the same probability distribution. It is characterized by
    this probability distribution and the conditional probability *β* that
    all components fail, given that one component failed.

    Let BE\ :sub:`1`, BE\ :sub:`2`... BE\ :sub:`n` be the *n* basic events
    of a common cause group with a probability distribution Q and a
    beta-factor *β*. Applying the beta-factor model on the fault tree consists
    in following operations.

    #. Create new basic events BE\ :sub:`CCFi` for each BE\ :sub:`i` to
       represent the independent occurrence of BE\ :sub:`i` and
       BE\ :sub:`CCFi` to represent the occurrence of all BE\ :sub:`i`
       together.
    #. Substitute a gate "G\ :sub:`i` = BE\ :sub:`CCFi` or BE\ :sub:`i`\ "
       for each basic event BE\ :sub:`i`.
    #. Associate the probability distribution (e.g., *β*\ ×Q) with the event BE\ :sub:`CCFi`.

Multiple Greek Letters
    The Multiple Greek Letters (MGL) model
    generalizes the beta-factor model. It considers the cases where
    sub-groups of 1, 2..., n-1 components of the group fail together. This
    model is characterized by the probability distribution of failure of the
    components, and n-1 factors *ρ*\ :sub:`2`..., *ρ*\ :sub:`n`.
    *ρ*\ :sub:`k` denotes the conditional probability that k components of
    the group fail given that k-1 failed.

    Let BE\ :sub:`1`, BE\ :sub:`2`... BE\ :sub:`n` be the *n* basic events
    of a common cause group with a probability distribution Q and factors
    *ρ*\ :sub:`2`..., *ρ*\ :sub:`n`. Applying the MGL model on the fault
    tree consists in following operations.

    #. Create a basic event for each combination of basic events of the
       group (there are 2\ :sup:`*n*`-1 such combinations).
    #. Transform each basic event BE\ :sub:`i` into a OR-gate G\ :sub:`i`
       over all newly created event basic events that represent a group that
       contains BE\ :sub:`i`.
    #. Associate the following probability distribution with each newly
       created basic event representing a group of *k* components
       (with *ρ*\ :sub:`n+1`\ =0).

    For instance, for a group of 4 basic events: A, B, C and D, the basic
    event A is transformed into a gate G\ :sub:`A` = A or AB or AC or AD or
    ABC or ABD or ACD or ABDC and the Q\ :sub:`k`\ 's are as follows.

    Note that if *ρ*\ :sub:`k`\ =0 then Q\ :sub:`k`, Q\ :sub:`k+1`...are null
    as well. In such a case it is not necessary to create the groups with k
    elements or more.

Alpha-Factor
    the alpha-factor model is the same as the MGL model
    except in the way the factors are given. Here *n* factors
    *α*\ :sub:`1`...\ *α*\ :sub:`n` are given. *α*\ :sub:`k` represents the
    fraction of the total failure probability due to common cause failures
    that impact exactly *k* components. The distribution associated with a
    group of size *k* is as follows:

Phi-Factor
    the phi-factor model is the same as MGL and alpha-factor
    models except that factors for each level are given directly.

    Indeed the sum of the *ϕ*\ :sub:`i`'s should equal 1.

XML representation
------------------

The Backus-Naur form for the XML description of Common Cause Failure
Groups is given :numref:`bnf_ccf_groups`. Note
that the number of factors depends on the model. Tools are in charge of
checking that there is the good number of factors. Note also that each
created basic event is associated with a factor that depends on the
model and the level of the basic event. The sum of the factors
associated with basic events of a member of the CCF group should be
equal to 1, although this is not strictly required by the Model Exchange
Format.

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

Here follows a declaration of a CCF-group with four elements
under the MGL model.

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
    Delete Terms are groups of pair wisely exclusive basic
    events. They are used to model impossible configurations. A typical
    example is the case where:

    - The basic event a can only occur when the equipment A is in maintenance.
    - The basic event b can only occur when the equipment B is in maintenance.
    - Equipment A and B are redundant and cannot be simultaneously in maintenance.

    In most of the tools, delete terms are considered as a post-processing
    mechanism: minimal cut sets containing two basic events of a delete terms
    are discarded. In order to speed-up calculations, some tools use basic
    events to discard minimal cut sets on the fly, during their generation.

    Delete Terms can be handled in several ways. Let G = {e\ :sub:`1`,
    e\ :sub:`2`, e\ :sub:`3`} be a Delete Term (group).

    - A first way to handle G, is to use it to post-process minimal
      cut sets, or to discard them on the fly during their generation. If a
      minimal cut sets contains at least two of the elements of G, it is
      discarded.

    - A global constraint "C\ :sub:`G` = not 2-out-of-3(e\ :sub:`1`,
      e\ :sub:`2`, e\ :sub:`3`)" is introduced and each top event (or event
      tree sequences) "top" is rewritten as "top and C\ :sub:`G`\ ".

    - As for Common Causes Groups, the e\ :sub:`i`\ 's are locally
      rewritten in as gates:

        * e\ :sub:`1` is rewritten as a gate ge\ :sub:`1` = e\ :sub:`1` and
          (not e\ :sub:`2`) and (not e\ :sub:`3`)
        * e\ :sub:`2` is rewritten as a gate ge\ :sub:`2` = e\ :sub:`2` and
          (not e\ :sub:`1`) and (not e\ :sub:`3`)
        * e\ :sub:`3` is rewritten as a gate ge\ :sub:`3` = e\ :sub:`3` and
          (not e\ :sub:`1`) and (not e\ :sub:`2`)

Recovery Rules
    Recovery Rules are an extension of Delete Terms.
    A Recovery Rule is a couple (H, e), where H is a set of basic events and e
    is a (fake) basic event. It is used to post-process minimal cut sets: if
    a minimal cut set C contains H, the e is added to C. Recovery Rules are
    used to model actions taken in some specific configurations to mitigate
    the risk (hence their name).

    Here several remarks can be made.

    - It is possible to mimics Delete Terms by means of recovery rules. To
      do so, it suffices to assign the basic event e to the value "false"
      or the probability 0.0.
    - As for Delete Terms, it is possible to give purely logical
      interpretation to Recovery Rules. The idea is to add a global
      constraint "H → e", i.e., "not H or e", for each Recovery Rule (H, e).
    - Another definition of Recovery Rules as a post-processing is that the
      event e is substituted for subset H in the minimal cut set. This
      definition has however the major drawback to be impossible to
      interpret in a logical way. No Boolean formula can withdraw events
      from a configuration.

Exchange Events
    Exchange Events are very similar to Recovery Rules.
    An Exchange Event (Rule) is a triple (H, e, e'), where H is a set of
    basic events and e and e' are two basic events. Considered as a
    post-processing of minimal cut sets, such a rule is interpreted as
    follows. If the minimal cut set contains both the set H and the basic
    event e, then the basic event e' is substituted for e in the cut set.
    For the same reason as above,
    Exchange Events cannot be interpreted in a logical way.

All Extra-Logical Constructs in One: the Notion of Substitution
---------------------------------------------------------------

Constructs that cannot be interpreted in a logical way should be avoided
for at least two reasons. First, models containing such constructs are
not declarative. Second and more importantly, they tighten assessment
tools to one specific type of algorithms. The second interpretation of
Recovery Rules and Exchange Events tighten the models to be assessed by
means of the minimal cut sets approach.

Nevertheless, Recovery Rules and Exchange Events are useful and broadly
used in practice. Fortunately, Exchange Events (considered as a post
processing mechanism) can be avoided in many cases by using the
instructions that give flavors to fault trees while walking along event
tree sequences: in a given sequence, one may decide to substitute the
event e' for the event e (or the parameter p' for the parameter p) in
the Fault Trees collected so far. This mechanism is perfectly acceptable
because it applies while creating the Boolean formula to be assessed.

It is not yet possible to decide whether Recovery Rules (under the
second interpretation) and Exchange Events can be replaced by purely
declarative constructs or by instructions of event trees. This has to be
checked on real-life models. To represent Delete Term, Recovery Rules
and Exchange Events, the Model Exchange Format introduces a unique
construct: the notion of substitution.

A substitution is a triple (H, S, t) where:

- H, the hypothesis, is a (simple) Boolean formula built over basic events.
- S, the source, is also a possibly empty set of basic events.
- t, the target, is either a basic event or a constant.

Let C be a minimal cut set, i.e., a set of basic events. The substitution
(H, S, t) is applicable on C if C satisfies H (i.e., if H is true when C
is realized) . The application of (H, S, t) on C consists in removing
from C all the basic events of S and in adding to C the target t.

Note that if t is the constant "true", adding t to C is equivalent to
add nothing. If t is the constant "false" adding t to C is equivalent to
discard C.

This notion of substitution generalizes the notions of Delete Terms,
Recovery Rules and Exchange Events:

- Let D = {e\ :sub:`1`, e\ :sub:`2`\ ..., e\ :sub:`n`} be a group of pair
  wisely exclusive events (a Delete Term). Then D is represented as the
  substitution (2-out-of-n(e\ :sub:`1`, e\ :sub:`2`\ ..., e\ :sub:`n`), ∅,
  false).
- Let (H, e) a Recovery Rule, under the first interpretation, where H =
  {e\ :sub:`1`, e\ :sub:`2`\ ..., e\ :sub:`n`}. Then, (H, e) is represented
  by the substitution (e\ :sub:`1` and e\ :sub:`2` and...and e\ :sub:`n`,
  ∅, e).
- Let (H, e) a Recovery Rule, under the second interpretation, where H
  = {e\ :sub:`1`, e\ :sub:`2`\ ..., e\ :sub:`n`}. Then (H, e) is
  represented by the substitution (e\ :sub:`1` and e\ :sub:`2` and...and
  e\ :sub:`n`, H, e).
- Finally, let (H, e, e') be an Exchange Event Rule, where H =
  {e\ :sub:`1`, e\ :sub:`2`\ ..., e\ :sub:`n`}. Then (H, e, e') is
  represented by the substitution (e\ :sub:`1` and e\ :sub:`2` and...and
  e\ :sub:`n` and e, {e}, e').

Note that a substitution (H, ∅, t) can always be interpreted as the
global constraint "H → t".

XML Representation
------------------

The Backus-Naur form for the XML description of substitutions is given
:numref:`bnf_substitution`. The optional attribute
"type" is used to help tools that implement "traditional" substitutions.

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

Assume that Basic Events "failure-pump-A", "failure-pump-B"
and "failure-pump-C" are pair wisely exclusive (they form a delete
term) because they can only occur when respectively equipment A, B and C
are under maintenance and only one equipment can be in maintenance at
once. The representation of such a delete term is as follows.

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

Assume that if the valve V is broken and an overpressure is
detected in pipe P, then a mitigating action A is performed. This is a
typical Recovery Rule (under the first interpretation), where the
hypothesis is the conjunction of Basic Events "valve-V-broken" and
"overpressure-pipe-P" and the added Basic Event is "failure-action-A".
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

Assume that if magnitude of the earthquake is 5, 6 or 7, the
size of a leak of a given pipe P get large, while it was small for
magnitudes below 5. We can use an exchange event rule to model this
situation.

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
