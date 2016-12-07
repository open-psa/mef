.. _mef_anatomy:

************************************
Anatomy of the Model Exchange Format
************************************

This chapter presents the anatomy of the Model Exchange Format,
i.e., the main components of a model and their relationships.
We assume the reader is familiar with the fault tree/event tree methodology.

Elements of a Model
===================

Variables, Terms and Containers
-------------------------------

Elements of a model are, as expected, components of fault trees/event trees,
namely basic events, gates, house events, probability distributions,
initiating events, safety systems, consequences, etc.
Conceptually, it is convenient to arrange most of these elements
into one of the three categories: terms, variables, and containers.

Variables
    Variables are named elements.
    Gates, basic events, house events, stochastic parameters, functional events,
    initiating events, and consequences are all variables.
    A variable is always defined, i.e., associated with a term.

Terms
    Terms are built over variables, constants, and operators.
    For instance, the Boolean formula "primary-motor-failure or no-current-to-motor"
    is a term built over the basic event "primary-motor-failure",
    the gate "no-current-to-motor", and the Boolean operator "or".
    Similarly, the probability distribution "1-exp(-lambda\*t)"
    is a term built over the numerical constant "1",
    the failure rate "lambda", the time "t",
    and the three arithmetic operators "-", "exp", and "\*"
    ("lambda" and "t" are variables).
    Note that variables are terms.

Containers
    According to our terminology,
    a model is nothing but a set of definitions of variables.
    Since a brute list of such definitions would lack of structure,
    the Model Exchange Format makes it possible to group them into containers.
    Containers have names and can be themselves grouped into higher level containers.
    For instance, a fault tree is a container
    for definitions of gates, house-events,
    basic events, and parameters of probability distributions.
    Similarly, an event tree is a container
    for definitions of initiating events, functional events, sequences, etc.

We are now ready to list the main elements of a model.
The exact content and role of these different elements
will be detailed in the subsequent chapters.

Stochastic Layer
----------------

Stochastic variables and terms
    Stochastic expressions are terms
    that are used to define probability distributions (associated with basic events).
    Stochastic variables are called parameters.
    For instance, "1-exp(-lambda\*t)" is a stochastic expression
    built over the two parameters "lambda" and "t".

From a programming viewpoint,
it is convenient to group definitions of parameters into (stochastic) containers.
The stochastic layer is populated with stochastic parameters, expressions, and containers.

Fault Tree Layer
----------------

Boolean formulae, Basic Events, House Events, and Gates
    Boolean formulae, or formulae for short, are terms built over the usual set of
    constants (true, false), connectives (and, or, not, etc.), and Boolean variables,
    i.e., Basic Events, Gates, and House Events.
    Boolean variables are called events,
    for that is what they represent in the sense of the probability theory.
    Basic events are associated with probability distributions,
    i.e., with (stochastic) expressions.
    Gates are defined as Boolean formulae.
    House events are special gates
    that are defined as Boolean constants only.

Fault Trees
    According to what precedes, a fault tree is container for
    definitions of parameters, basic events, house events, and gates.

The fault tree layer is populated with all elements we have seen so far.

Meta-Logical Layer
------------------

The meta-logical layer contains extra-logical constructs in addition to fault trees.
These extra-logical constructs are used to handle issues
that are not easy to handle in a purely declarative and logical way.

Common Cause Groups
    Common cause groups are sets of basic events
    that are not statistically independent.
    Several models can be used to interpret common cause groups.
    All these models consist in splitting each event of the group
    into a disjunction of independent basic events.

Substitutions
    Delete terms, exchange events, and recovery rules
    are global and extra-logical constraints
    that are used to describe situations
    such as physical impossibilities, technical specifications,
    or to modify the probability of a scenario
    according to some physical rules or judgments about human actions.
    In the Model Exchange Format, these extra-logical constructs
    are all modeled by means of the generic notion of substitution.

Event Tree Layer
----------------

As we shall see, event trees must be seen
as a (semi-)graphical language to describe and to combine sequences.
Elements of this language are the following.

Event Trees
    Event Trees define scenarios
    from an Initiating Event (or an Initiating Event Group) to different end-states.
    In the Model Exchange Format, end-states are called Sequences.
    The same event tree can be used for different Initiating Events.
    Along the scenarios, "flavored" copies of fault trees are collected
    and/or values are computed.
    Flavors are obtained by changing values of house events and parameters
    while walking along the tree.
    Event Trees are containers according to our terminology.
    They contain definition of functional events and states.

Initiating Events, Initiating Event Groups
    Initiating Events describe the starting point of an accidental sequence.
    They are always associated with an event tree,
    although they are in general declared outside of this event tree.
    The Model Exchange Format makes it possible to chain event trees.
    Therefore, the end-state of a sequence of an event tree
    may be the initiating event of another event tree.
    Initiating Events are variables, according to our terminology.
    Initiating event groups are sets of initiating events.
    Despite of their set nature, initiative events are also variables
    because an initiating event group may contain another one
    (the initiating terms are set operations).

Functional Events
    Functional Events describe actions
    that are taken to prevent an accident or to mitigate its consequences
    (usually by means of a fault tree).
    Depending on the result of such an action,
    the functional event may be in different, e.g., "success" or "failure".
    Functional Events label the columns the graphical representation of Event Trees.

Sequences, Branches
    Sequences are end-states of branches of event trees.
    Branches are named intermediate states.

Instructions, Rules
    Instructions are used to describe the different paths of an event tree,
    to set the states of functional events,
    to give flavors of fault trees that are collected,
    and to communicate with the calculation engine.
    Rules are (named) groups of Instructions.
    They generalize split-fractions of the event tree linking approach,
    and boundary condition sets of the fault tree linking approach.

Consequences, Consequence groups
    Consequences are couples made of an initiating event and a sequence (an event tree end-state).
    Consequences are named and defined.
    They are variables according to our terminology.
    Like Initiating Events, Consequences can be grouped to study a particular type of accident.
    Consequence Groups are also variables (the consequence terms are set operations).

Missions, Phases
    In some cases, the mission of the system is split into different phase.
    The Model Exchange Format provides constructs to reflect this situation.


Structure of a Model
====================

Relationships between elements of a model
-----------------------------------------

The elements of a model, their layer, and their dependencies
are pictured in :numref:`fig_mef_anatomy`.
This schema illustrates the description given in the previous section.
Term categories are represented by rectangles.
Variables categories are represented by rounded rectangles.
A variable category is always included in a term category (for variables are terms).
The three container categories, namely models, event trees, and fault trees,
are represented by dashed rectangles.
Dependencies among categories are represented by arrows.

.. figure:: ../images/anatomy.*
    :name: fig_mef_anatomy
    :align: center

    The main elements of a model, their layers, and their dependencies

Giving more structure to a model
--------------------------------

A model (like a fault tree or an event tree) is a list of declarations.
The Model Exchange Format does not require structuring these declarations:
they can be given in any order,
provided that the type of an object can be decided prior to any use of this object.
Fault trees and event trees provide a first mean to organize models.
This may be not sufficient, especially when models are big.
In order to structure models,
the Model Exchange Format provides the analyst with two mechanisms.

First, declarations can be grouped together by means of user defined containers.
Such a container is just a XML tag.
It has no semantics for the model.
It just makes it possible to delimit a set of objects of the model
that are physically or functionally related
(for instance, the different failure modes of a physical component).

Second, the Model Exchange Format makes it possible
to associate user defined attributes to the main components.
For instance, we may define an attribute "zone" with a value "room33"
for all constructs describing components located in the room 33.
This indirect mean is very powerful.
It can be used extensively to perform calculations or changes on a particular subset of elements.

Containers as name spaces
-------------------------

Once declared, elements are visible and accessible everywhere in the model.
This visibility means in turn that an object of a given type,
e.g., parameter or event, is unique.
No two distinct objects of the same type can have the same name.
This constraint seems to be fine and coherent.
However, some tools do not obey the rule:
two gates of two different fault trees and representing two different functions
may have the same name.
It is not possible to reject this possibility (as a bad modeling practice),
because when models are large and several persons are working in collaboration,
such name conflicts are virtually impossible to avoid.

To solve this problem, the Model Exchange Format considers containers,
i.e., not only fault trees and event trees but also user defined containers, as name spaces.
By default, objects defined in a container are global,
but it is possible to declare them as local to the container as well.
In that case, they are not visible outside the container,
and tools are in charge of solving potential name conflicts.


.. _definitions_labels_attributes:

Definitions, Labels, and Attributes
-----------------------------------

Here follows some additional useful elements about the Model Exchange Format.

Definitions versus references
    For the sake of the clarity (and for XML specific reasons),
    it is important to distinguish the declaration/definition of an element
    from references to that element.
    For instance, we have to distinguish the definition of the gate "motor-fails-to-start"
    (as the Boolean formula "primary-motor-failure or no-current-to-motor"),
    from references to that gate into definitions of other gates.

    In the Model Exchange Format, the definition of a variable or a container,
    for instance a gate, is in the following form.

    .. code-block:: xml

        <define-gate name="motor-fails-to-start">
            ...
        </define-gate>

    References to that gate are in the following form.

    .. code-block:: xml

        ...
        <gate name="motor-fails-to-start"/>
        ...

    So, there are two tags for each element (variable or container) of the Model Exchange Format:
    the tag "define-element" to define this element
    and the tag "element" to refer this element.
    Note that the attribute "name" is systematically used to name elements.

Labels
    It is often convenient to add a comment to the definition of an object.
    The Model Exchange Format defines a special tag "label" to do so.
    The tag label can contain any text.
    It must be inserted as the first child of the definition of the object.

    .. code-block:: xml

        <define-gate name="motor-fails-to-start">
            <label>Warning: secondary motor failures are not taken into account here.</label>
            ...
        </define-gate>

Attributes
    Attributes can be associated with each element
    (variable or container) of the Model Exchange Format.
    An attribute is a pair (name, value),
    where both name and value are normally short strings.
    Values are usually scalars, i.e., they are not interpreted.
    In order to allow tools to interpret values,
    a third field "type" can be optionally added to attributes.
    The tags "attributes" and "attribute" are used to set attributes.
    The former is mandatory, even when only one attribute is defined.
    It must be inserted as the first child of the definition of the object,
    or just after the tag label, if any.

    .. code-block:: xml

        <define-gate name="motor-fails-to-start">
            <label>Warning: secondary motor failures are not taken into account here.</label>
            <attributes>
                <attribute name="zone" value="room33" />
                ...
            </attributes>
            ...
        </define-gate>

The Backus-Naur form for the XML representation of labels and attributes is as follows.

.. code-block:: bnf

    label ::= <label> any text </label>
    attributes ::= <attributes> attribute+ </attributes>
    attribute ::= <attribute name="identifier" value="string" [ type="string" ] />
