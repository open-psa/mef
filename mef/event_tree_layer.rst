.. _event_tree_layer:

****************
Event Tree Layer
****************

Preliminary Discussion
======================

The first three layers are rather straightforward to describe
since there is a general agreement
on how to interpret fault trees and probability distributions.
The Event Tree layer is much more delicate to handle.
The reason stands in the dynamic nature of event trees
and the lack of common interpretation for this formalism.
To illustrate this point, we shall consider the toy example
pictured in :numref:`fig_small_event_tree`.

.. figure:: ../images/small_event_tree.*
    :name: fig_small_event_tree
    :align: center

    A Small Event Tree

This event tree is made of the following elements.

- An initiating event I
- Three functional events F, G, and H
- Six sequences ending in six (a priori) different states S1 to S6

The numbered black dots should be ignored for now.
We added them only for the convenience of the forthcoming discussion.

The expected interpreted interpretation of this event tree is as follows.
A fault tree is associated with each functional event.
This fault tree describes how the functional event may occur.
For the sake of the simplicity,
we may assume that its top-event has the same name as the functional event itself.
Upper branches represent a success of the corresponding safety mission,
while lower branches represent its failure.
Applying the so-called fault tree linking approach,
we obtain the following interpretation for the sequences.

.. math::

    S1& = I \land \lnot F \land \lnot H\\
    S2& = I \land \lnot F \land H\\
    S3& = I \land F \land \lnot G \land \lnot H\\
    S4& = I \land F \land \lnot G \land H\\
    S5& = I \land F \land G \land \lnot F\\
    S6& = I \land F \land G \land H

In practice, things are less simple:

- There may be more that one initiating event
  because the same event tree can be used with different flavors.
- Values of house events may be changed at some points along the branches
  to give flavors to fault trees.
  The value of a house event may be changed either locally to a fault tree,
  or for all the fault trees encountered after the setting point.
- The flavoring mechanism may be even more complex:
  some gates or basic events may be negated;
  some parameters of probability distributions may be impacted.
- The flavor given to a fault tree may depend on what has happened so far in the sequence:
  initiating event, value of house events, etc.
- Some success branches may not be interpreted as the negation of the associated fault tree
  but rather as a bypass.
  This interpretation of success branches is typically tool-dependent:
  some tools (have options to) ignore success branches;
  therefore, modelers use this "possibility" to "factorize" models.
- Branching may have more than two alternatives,
  or represent multi-states, not just success and failure,
  each alternative being labeled with a different fault tree.
- In the event tree linking approach, branching may involve no fault tree at all,
  but rather a multiplication by some factor of the current probability of the sequence.
- It is sometimes convenient to replace a sub-tree by a reference to a previously defined sub-tree.
  For instance, if we identify end-states S1 and S3 one the one hand, S2 and S4 on the other hand,
  we can merge the two corresponding sub-trees rooted.
  It saves space (both in computer memory and onto the display device)
  to replace the latter by a reference to the former.

In a word, event trees cannot be seen as a static description formalism like fault trees.
Rather, they should be seen as a kind of graphical programming language.
This language is used to collect and modify data when walking along the sequences,
and even to decide when to stop to walk a sequence (in the event tree linking approach).
The Model Exchange Format should thus reflect this programming nature of event trees.

Structure of Event Trees
========================

Description
-----------

The Model Exchange Format distinguishes the structure of the event trees,
i.e., the set of sequences they encode,
from what is collected along the sequences and how it is collected.
Let us consider for now only the structural view point.
With that respect, an event tree is made of the following components.

- One or more initiating events
- An ordered set of functional events (the columns)
- A set of end-states (so called sequences)
- A set of branches to describe sequences

Branches end up either with a sequence name
or with a reference to another branch (such references are sometimes called transfers).
They contain forks.
Each fork is associated with a functional event.
The initiating event could also be seen as a special fork
(between the occurrence of this event and the occurrence of no event).
In the Model Exchange Format, alternatives of the fork are called paths.
Paths are labeled by the state of the functional event that labels the fork.

Let us consider again the event tree pictured in :numref:`fig_small_event_tree`.
Assume that end states S1 and S3 on the one hand, S2 and S4 on the other hand, are identical,
and that we merge the corresponding sub-trees.
Assume moreover that the lowest success branch of the functional event H is actually a bypass.
Then, the structure of the tree is pictured in :numref:`fig_event_tree_structure`.
On this figure, nodes of the tree are numbered from 1 to 8.
The initiating event is represented as a fork.
Finally, the branch (the sub-tree) rooted by the node 2 is named B1.

.. figure:: ../images/event_tree_structure.*
    :name: fig_event_tree_structure
    :align: center

    Structure of an Event Tree

Components of the event tree pictured in :numref:`fig_event_tree_structure` are the following.

- The initiating event I
- The three functional events F, G, and H
- The end states S1, S2, S5, and S6
- The branch B1
- The tree rooted by the initial node (here the node 1)

Forks decompose the current branch according to the state of a functional event.
Usually, this state is either "success" or "failure".
It may be "bypass" as well (as in our example for the path from node 6 to node 7).
In the case of multiple branches, the name of state is defined by the user.

Instructions to collect and to modify fault trees and probability distributions
are applied at the different nodes.
Instructions to be applied
may depend on the initiating event and the states of functional events.

The states of functional events at a node depend on the path
that has been followed from the root node to this node.
By default, functional events are in an unspecified state,
i.e., that the predicate "test-functional-event" (see :numref:`test_event`)
returns false in any case.
:numref:`table_event_tree_structure_paths` gives the states of functional events
for all the possible paths starting from the root node of the event tree
pictured in :numref:`fig_event_tree_structure`.
Empty cells correspond to unspecified states.

.. table:: States of Functional Events for the different paths
           of the Event Tree in :numref:`fig_event_tree_structure`
    :name: table_event_tree_structure_paths

    +---------+---------+---------+---------+
    | path    | F       | G       | H       |
    +=========+=========+=========+=========+
    | 1       |         |         |         |
    +---------+---------+---------+---------+
    | 1-2     | success |         |         |
    +---------+---------+---------+---------+
    | 1-2-3   | success |         | success |
    +---------+---------+---------+---------+
    | 1-2-4   | success |         | failure |
    +---------+---------+---------+---------+
    | 1-5     | failure |         |         |
    +---------+---------+---------+---------+
    | 1-5-2   | failure | success |         |
    +---------+---------+---------+---------+
    | 1-5-2-3 | failure | success | success |
    +---------+---------+---------+---------+
    | 1-5-2-4 | failure | success | failure |
    +---------+---------+---------+---------+
    | 1-5-6   | failure | failure |         |
    +---------+---------+---------+---------+
    | 1-5-6-7 | failure | failure | bypass  |
    +---------+---------+---------+---------+
    | 1-5-6-8 | failure | failure | failure |
    +---------+---------+---------+---------+

As mentioned above, an event tree may be parametric:
the same tree can be used for several initiating events.
To implement this idea,
the Model Exchange Format provides the analyst with the notion of group of initiating events.
Such a group has a name and may contain sub-groups.
Groups of initiating events may be freely defined inside or outside event trees.
There is one condition, however:
an initiating event can be used in only one tree.


.. _event_tree_structure_xml_representation:

XML Representation
------------------

We are now ready to explicitly define the XML grammar of the structure of event trees.
Its RNC schema is given in :numref:`schema_initiating_events` and :numref:`schema_event_tree`.
In these figures, we leave instructions unspecified,
for they do not concern the structure of the tree and are the subject of the next section.
Note that branches and functional events cannot be declared (nor referred to) outside event trees,
for there would be no meaning in doing so.

.. literalinclude:: schema/initiating_events.rnc
    :name: schema_initiating_events
    :caption: The RNC schema of the XML representation of initiating events
    :language: rnc

.. literalinclude:: schema/event_tree.rnc
    :name: schema_event_tree
    :caption: The RNC schema of the XML representation of event trees and sequences
    :language: rnc

Example
~~~~~~~

Consider again the event tree pictured in :numref:`fig_event_tree_structure`.
The XML description for this example is given in :numref:`xml_event_tree_structure`.

.. code-block:: xml
    :name: xml_event_tree_structure
    :caption: XML representation for the structure
              of the Event Tree pictured in :numref:`fig_event_tree_structure`

    <define-event-tree name="my-first-event-tree">
        <define-functional-event name="F"/>
        <define-functional-event name="G"/>
        <define-functional-event name="H"/>
        <define-sequence name="S1"/>
        <define-sequence name="S2"/>
        <define-sequence name="S5"/>
        <define-sequence name="S6"/>
        <define-branch name="sub-tree7">
            <fork functional-event="H">
                <path state="success">
                    <sequence name="S1"/>
                </path>
                <path state="failure">
                    <sequence name="S2"/>
                </path>
            </fork>
        </define-branch>
        <initial-state>
            <fork functional-event="F">
                <path state="success">
                    <branch name="sub-tree7"/>
                </path>
                <path state="failure">
                    <fork functional-event="G">
                        <path state="success">
                            <branch name="sub-tree7"/>
                        </path>
                        <path state="failure">
                            <fork functional-event="H">
                                <path state="success">
                                    <sequence name="S5"/>
                                </path>
                                <path state="failure">
                                    <sequence name="S6"/>
                                </path>
                            </fork>
                        </path>
                    </fork>
                </path>
            </fork>
        </initial-state>
    </define-event-tree>


.. _instructions:

Instructions
============

Description
-----------

:numref:`fig_event_tree_structure` gives the XML representation for the structure of an event tree.
This structure makes it possible to walk along the sequences,
but not to construct the Boolean formulae associated with each sequences.
To do so, we need to fill the structure with instructions.
Instructions are actually used for two main purposes:

- To collect formulae or stochastic expressions
- To define flavors of fault trees and probability distributions,
  i.e., to set values of house events and flag parameters

The collection of a top event consists in a Boolean product of the formula
associated with the sequence and a copy of the fault tree rooted with the top event.
In the Model Exchange Format,
the operation is performed by means of the instruction "collect-formula".
The collection of an expression
multiplies the current probability of the sequence by the value of this expression.
In the Model Exchange Format,
the operation is performed by means of the instruction "collect-expression".

To give flavors to fault trees,
i.e., to change the values of gates, house events, basic events, and parameters,
the Model Exchange Format introduces the four corresponding instruction:
"set-gate", "set-house-event", "set-basic-event", and "set-parameter".

Sequences are walked from left to right.
Therefore, when a value of an element is changed,
this change applies on the current environment and propagates to the right.
This default behavior can be changed by using the flag "direction",
which can take either the value "forward" (the default), "backward" or "both".
This feature should be handled with much care.

The flavor given to fault trees, as well as what is collected,
may depend on the initial event and the current state of functional events.
To do so, the Model Exchange Format provides
an if-then-else instruction (the "else" part is optional)
and the two expressions "test-initiating-event" and "test-functional-event".
These two instructions have been introduced in :numref:`test_event`.
Since the then- and else-branches of the "if-then-else" may contain several instructions,
the Model Exchange Format introduces the notion of block of instructions.

Finally, some models require linking event trees.
A special instruction "event-tree" is introduced for this purpose.
It should be used only in sequence definitions, i.e., in end-state.

It is sometimes the case
that the same values of house events and parameter flags are used at several places.
Such a configuration is called a split-fraction in the event tree linking approach.
The Model Exchange Format refers it as a rule, for it is a sequence of instructions.

XML Representation
------------------

The RNC schema for the XML representation of instructions
is given in :numref:`schema_instructions`.

.. literalinclude:: schema/instructions.rnc
    :name: schema_instructions
    :caption: The RNC schema for the XML representation of instructions
    :language: rnc

Example
~~~~~~~

Consider again the event tree pictured in :numref:`fig_event_tree_structure`.
The XML representation for the structure of this tree
has been given in :numref:`xml_event_tree_structure`.
Assume that the success branch of the lower fork on system H is a bypass.
The XML description for the branches of this example is given in :numref:`xml_event_tree_branches`.
It is easy to verify by traversing this tree by hand so that it produces the expected semantics.

.. code-block:: xml
    :name: xml_event_tree_branches
    :caption: XML representation of the branches
              of the event tree pictured in :numref:`fig_event_tree_structure`

    <define-event-tree name="my-first-event-tree">
        ...
        <initial-state>
            <fork functional-event="F">
                <path state="success">
                    <collect-formula> <not> <gate name="F"/> </not> </collect-formula>
                    <branch name="sub-tree7"/>
                </path>
                <path state="failure">
                    <collect-formula> <gate name="F"/> </collect-formula>
                    <fork functional-event="G">
                        <path state="success">
                            <collect-formula> <not> <gate name="G"/> </not> </collect-formula>
                            <branch name="sub-tree7"/>
                        </path>
                        <path state="failure">
                            <collect-formula> <gate name="G"/> </collect-formula>
                            <fork functional-event="H">
                                <path state="bypass">
                                    <!-- here nothing is collected -->
                                    <sequence name="S5"/>
                                </path>
                                <path state="failure">
                                    <collect-formula> <gate name="H"/> </collect-formula>
                                    <sequence name="S6"/>
                                </path>
                            </fork>
                        </path>
                    </fork>
                </path>
            </fork>
        </initial-state>
    </define-event-tree>

This example does not set any house events or flag parameters.
To set a house event for all subsequent sub-tree exploration
(including the next fault tree to be collected),
it suffices to insert an instruction "set" in front of the instruction "collect".

.. code-block:: xml

    <set-house-event name="h1"> <bool value="true"/> </set-house-event>
    <collect-formula> <gate name="G"/> </collect-formula>

To set the same house event locally for the next fault tree to be collected,
it suffices to set back its value to "false" after gathering of the fault tree.

.. code-block:: xml

    <set-house-event name="h1"> <bool value="true"/> </set-house-event>
    <collect-formula> <gate name="G"/> </collect-formula>
    <set-house-event name="h1"> <bool value="false"/> </set-house-event>

The same principle applies to parameters.

Assume now that we want
to set the parameters "lambda1" and "lambda2" of some probability distributions to "0.001"
if the initiating event was "I1" and the functional event "G" is in the state failure
and to "0.002", otherwise.
This goal is achieved by means of
an "if-then-else" construct and the "test-initiating-event" expression.

.. code-block:: xml

    <if>
        <and>
            <test-initiating-event name="I1"/>
            <test-functional-event name="G" state="failure"/>
        </and>
        <block>
            <set-parameter name="lambda1"> <float value="0.001"/> </set-parameter>
            <set-parameter name="lambda2"> <float value="0.001"/> </set-parameter>
        </block>
        <block>
            <set-parameter name="lambda1"> <float value="0.002"/> </set-parameter>
            <set-parameter name="lambda2"> <float value="0.002"/> </set-parameter>
        </block>
    </if>

Finally, we could imagine that the sequence S1 is linked to an event tree ET2
if the initiating event was I1
and to another event tree ET3, otherwise.
The definition of the sequence S1 would be as follows.

.. code-block:: xml

    <define-sequence name="S1">
        <if>
            <test-initiating-event name="I1"/>
            <event-tree name="ET2"/>
            <event-tree name="ET3"/>
        </if>
    </define-sequence>
