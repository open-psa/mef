.. _fault_tree_layer:

****************
Fault Tree Layer
****************

The Fault Tree layer is populated with logical components of Fault Trees.
It includes the stochastic layer,
which contains itself the probabilistic data.
The stochastic layer will be presented in the next section.

Description
===========

Constituents of fault trees are
Boolean variables (gates, basic events, and house events),
Boolean constants (true and false)
and connectives (and, or, k-out-of-n, not, etc.).
Despite of their name,
fault trees have in general a directed acyclic graph structure (and not a tree-like structure)
because variables can be referenced more than once.
The simplest way to describe a fault tree
is to represent it as a set of equations
in the form "variable = Boolean-formula".
Variables that show up as left hand side of an equation are gates.
Variables that show up only in right hand side formulae are basic events.
Finally, variables that show up only as left hand side of an equation are top events.
Such a representation imposes two additional conditions:
first, the set of equations must contain no loop,
i.e., that the Boolean formula at the right hand side of an equation
must not depend, even indirectly (recursively), on the variable at the left hand side.
Second, a variable must not show up more than once at the left hand side of an equation,
i.e., gates must be uniquely defined.
:numref:`fig_fault_tree` shows a Fault Tree.
The corresponding set of equations is as follows.

.. math::

    TOP& = G1 \lor G2\\
    G1& = H1 \land G3 \land G4\\
    G2& = \lnot H1 \land BE2 \land G4\\
    G3& = BE1 \lor BE3\\
    G4& = BE3 \lor BE4

On the figure, basic events are surrounded with a circle.
Basic events are in general associated with a probability distribution
(see :numref:`Chapter %s <stochastic_layer>`).

House events (surrounded by a house shape frame on the figure)
are represented as variables but are actually constants:
when the tree is evaluated house events are always interpreted by their value,
which is either true or false.
By default, house events take the value false.
Negated house events (gates, basic events)
are represented by adding a small circle over their symbol.

A formal description of constructs of Fault Trees
is given under the RNC schema in :numref:`schema_fault_tree`.
This description allows loops (in the sense defined above),
multiple definitions and trees with multiple top events.
The presence of loops must be detected by a specific check procedure.
If a variable or a parameter is declared more than once,
tools should emit a warning
and consider only the last definition as the good one (the previous ones are just ignored).
In some circumstances, it is of interest to define several fault trees at once
by means of a unique set of declarations.
Therefore, the presence of multiple top events should not be prevented.
We shall see what parameters and expressions are in the next chapter.

.. figure:: ../images/fault_tree.*
    :name: fig_fault_tree
    :align: center

    A Fault Tree

The semantics of connectives is given in :numref:`table_boolean_connectives`.
Note that connectives "and", "or", "xor", "iff", "nand", and "nor" are associative.
Therefore, it suffices to give their semantics when they take two arguments,
i.e., two Boolean formulae F and G.

.. tabularcolumns:: |l|L|
.. table:: Semantics of Boolean connectives
    :name: table_boolean_connectives

    +-----------------+-----------------------------------------------------------------------------------------------+
    | Connective      | Semantics                                                                                     |
    +=================+===============================================================================================+
    | **and**         | F and G is true if both F and G are true, and false otherwise                                 |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **or**          | F or G is true if either F or G is true, and false otherwise                                  |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **not**         | not F is true if its F is false, and false otherwise                                          |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **xor**         | F xor G is equivalent to (F and not G) or (not F and G)                                       |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **iff**         | F iff G is equivalent to (F and G) or (not F and not G)                                       |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **nand**        | F nand G is equivalent to not (F and G)                                                       |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **nor**         | F nor G is equivalent to not (F or G)                                                         |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **atleast**     | true if at least **k** out of the Boolean formulae given as arguments are true,               |
    |                 | and false otherwise. This connective is also called *k-out-of-n*,                             |
    |                 | where **k** is the integer and **n** is the Boolean formulae given in arguments               |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **cardinality** | true if at least **l** and at most **h** of the Boolean formulae given as arguments are true, |
    |                 | and false otherwise. **l** and **h** are the two integers (in order) given as arguments.      |
    +-----------------+-----------------------------------------------------------------------------------------------+
    | **imply**       | F implies G is equivalent to (not F or G)                                                     |
    +-----------------+-----------------------------------------------------------------------------------------------+


.. raw:: latex

    \begin{minipage}{\textwidth}

.. admonition:: Dynamic Gates

    In a second step, it would be of interest to incorporate to the Model Exchange Format
    "inhibit" gates, "priority" gates, and "triggers"
    (like in Boolean Driven Markov processes).
    All of these dynamic gates can be interpreted as "and" gates in a Boolean framework.
    In more general frameworks (like Markovian frameworks),
    they can have different interpretations,
    and provide mechanisms to accurately model backup systems, limited amount of resources, etc.
    The complexity of the assessment of this kind of model is indeed much higher
    than the one of Boolean models (which is already at least NP-hard or #P-hard).

.. raw:: latex

    \end{minipage}


XML Representation
==================

The RNC schema for the XML description of fault trees
is given in :numref:`schema_fault_tree` and :numref:`schema_boolean_formulae`.

This description deserves some comments.

- It leaves for now the tags "define-parameter" and "expression" unspecified.
  We shall see in the next chapter
  how these tags are used to define the probability distributions.
- Similarly, the tag "define-component" will be explained in the next section.
- Although the Model Exchange Format adopts the declarative modeling paradigm,
  it is often convenient to use variables in formulae before declaring them.
  The Model Exchange Format, therefore, refers to variables with the generic term "event",
  possibly without a "type" attribute.
- By default, the value of a house is event is "false",
  so it is not necessary to associate a value with a house event when declaring it.
  We shall see in :numref:`instructions` how to change the value of a house event.
- Although events are typed (they are either gates, house events or basic events),
  two different events cannot have the same name (within the same name space),
  even if they are of different types.
  This point will be explained in the next section.

.. literalinclude:: schema/fault_tree.rnc
    :name: schema_fault_tree
    :caption: The RNC schema of XML description of Fault Trees
    :language: rnc

.. literalinclude:: schema/formula.rnc
    :name: schema_boolean_formulae
    :caption: The RNC schema of the XML representation of Boolean formulae
    :language: rnc

The attribute "role" is used to declare whether an element is public or private,
i.e., whether it can be referred by its name everywhere in the model
or only within its inner most container.
This point will be further explained in the next section.
This attribute is optional, for by default, all elements are public.

The fault tree pictured in :numref:`fig_fault_tree` is described in :numref:`xml_fault_tree`.
In this representation, the house event "h1" has by default the value "true".
Basic events are not declared, for it is not necessary,
so no probability distributions are associated with basic events.

.. code-block:: xml
    :name: xml_fault_tree
    :caption: XML description of Fault Tree pictured in :numref:`fig_fault_tree`

    <?xml version="1.0" ?>
    <!DOCTYPE opsa-mef>
    <opsa-mef>
        <define-fault-tree name="FT1">
            <define-gate name="top">
                <or>
                    <gate name="g1"/>
                    <gate name="g2"/>
                </or>
            </define-gate>
            <define-gate name="g1">
                <and>
                    <house-event name="h1"/>
                    <gate name="g3"/>
                    <gate name="g4"/>
                </and>
            </define-gate>
            <define-gate name="g2">
                <and>
                    <not>
                        <house-event name="h1"/>
                    </not>
                    <basic-event name="e2"/>
                    <gate name="g4"/>
                </and>
            </define-gate>
            <define-gate name="g3">
                <or>
                    <basic-event name="e1"/>
                    <basic-event name="e3"/>
                </or>
            </define-gate>
            <define-gate name="g4">
                <or>
                    <basic-event name="e3"/>
                    <basic-event name="e4"/>
                </or>
            </define-gate>
            <define-house-event name="h1">
                <constant value="true"/>
            </define-house-event>
        </define-fault-tree>
    </opsa-mef>


Extra Logical Constructs and Recommendations
============================================

Model-Data and Components
-------------------------

The Model Exchange Format provides a number of extra-logical constructs
to document and structure models.
Labels and attributes are introduced in :numref:`definitions_labels_attributes`.
They can be associated with a declared element in order to document this element.
Fault trees are a first mean to structure models.
A fault tree groups any number of declarations of
gates, house events, basic event, and parameters.

It is sometimes convenient
to group definitions of house events, basic events, and parameters outside fault trees.
The Model Exchange Format provides the container "model-data" to do so.

The Model Exchange Format makes it possible
to group further declarations through the notion of component.
A component is just a container for declarations of events and parameters.
It has a name and may contain other components.
The use of components is illustrated by the following example.

:numref:`fault_tree_with_components` shows a fault tree FT with three components A, B, and C.
The component B is nested into the component A.
The XML representation for this Fault Tree is given in :numref:`xml_fault_tree_with_components`.
With a little anticipation, we declared basic events.
Note that components and fault trees may also contain definitions of parameters.
Note also that the basic event BE1, which is declared in the component A,
is used outside of this component (namely in the sibling component C).

.. figure:: ../images/fault_tree_with_components.*
    :name: fault_tree_with_components
    :align: center

    A Fault Tree with Three Components


.. code-block:: xml
    :name: xml_fault_tree_with_components
    :caption: XML Representation for the Fault Tree pictured in :numref:`fault_tree_with_components`

    <define-fault-tree name="FT">
        <define-gate name="TOP">
            <or>
                <gate name="G1"/>
                <gate name="G2"/>
                <gate name="G3"/>
            </or>
        </define-gate>
        <define-component name="A">
            <define-gate name="G1">
                <and>
                    <basic-event name="BE1"/>
                    <basic-event name="BE2"/>
                </and>
            </define-gate>
            <define-gate name="G2">
                <and>
                    <basic-event name="BE1"/>
                    <basic-event name="BE3"/>
                </and>
            </define-gate>
            <define-basic-event name="BE1">
                <float value="1.2e-3"/>
            </define-basic-event>
            <define-component name="B">
                <define-basic-event name="BE2">
                    <float value="2.4e-3"/>
                </define-basic-event>
                <define-basic-event name="BE3">
                    <float value="5.2e-3"/>
                </define-basic-event>
            </define-component>
        </define-component>
        <define-component name="C">
            <define-gate name="G3">
                <and>
                    <basic-event name="BE1"/>
                    <basic-event name="BE4"/>
                </and>
            </define-gate>
            <define-basic-event name="BE4">
                <float value="1.6e-3"/>
            </define-basic-event>
        </define-component>
    </define-fault-tree>


Solving Name Conflicts: Public versus Private Elements
------------------------------------------------------

By default, all elements of a model are public:
they are visible everywhere in the model
and they can be referred by their name.
For instance, the basic event "BE1" of the fault tree
pictured in :numref:`xml_fault_tree_with_components`
can be just referred as "BE1".
This principle is fairly simple.
It may, however, cause some problem for large models, developed by several persons:
it is hard to prevent the same name to be used twice,
especially for what concerns gates (some software allow actually this possibility).

The Model Exchange Format makes it possible to declare elements of fault trees
either as public or as private (to their inner most container).
Unless declared otherwise, an element is public
if its innermost container is public and private otherwise.
For instance, if the component "A" of the fault tree
pictured in :numref:`xml_fault_tree_with_components`
is declared as private,
then the component "B" (and its two basic events "BE2" and "BE3"),
the gates "G1" and "G2", and the basic event "BE1" are private by default.
There is no difference between public and private elements
except that two private elements of two different containers may have the same name,
while public elements must be uniquely defined.

There is actually three ways to refer an element:

- An element can be referred by its name.
  This works either if the element is public
  or if it is referred inside the container (fault tree or component) in which it is declared.
  For instance, if the basic event "BE1" is public,
  it can be referred as "BE1" anywhere in the model.
  If it is private, it can be referred as "BE1" only inside the component "A".
- An element can be referred by its full path (of containers),
  whether it is public or private.
  The names of containers should be separated with dots.
  For instance, the basic event "BE2" can be referred as "FT.A.B.BE2" anywhere in the model.
- Finally, an element can be referred by its local path,
  whether it is public or private.
  For instance, if the gate "G1" can be referred as "FT.A.G1" outside of the fault tree "FT",
  as "A.G1" inside the declaration of "FT",
  and finally as "G1" inside the declaration of the component "A".
  If the basic event BE1 is private (for a reason or another),
  it should be referred either as "FT.A.BE1" inside the component "C".
  In this case, the definition of the gate "G3" is as follows.

.. code-block:: xml

    <define-gate name="G3">
        <and>
            <basic-event name="FT.A.BE1"/>
            <basic-event name="BE4"/>
        </and>
    </define-gate>

The important point here is that it is possible
to name two private elements of two different containers with the same identifier.
For instance, if components "B" and "C" are private,
it is possible to rename the basic-event "BE4" as "BE2".
Outside these two components,
the two basic events "B2" must be referred using their (local or global) paths.

Inherited attributes
--------------------

Attributes associated with a container (fault tree, event tree or component)
are automatically inherited by all the elements declared in the container.
It is indeed possible to change the value of the attribute at element level.

Recommendations
---------------

Layered Models
~~~~~~~~~~~~~~

In PSA models, fault trees are in general layered,
i.e., arguments of connectives (and, or, etc.)
are always either variables or negations of variables.
Although there is no reason to force such a condition,
it is recommended to obey it for the sake of clarity.


Use Portable Identifiers
~~~~~~~~~~~~~~~~~~~~~~~~

In the XML description of fault trees,
we intentionally did not define identifiers.
In many fault tree tools, identifiers can be any string.
It is, however, strongly recommended for portability issues to use non problematic identifiers,
like those of programming languages,
and to add a description of elements as a comment.
This means
not using lexical entities, such as spaces, tabulations, "." or "/", in names of elements,
as well as realizing that some old tools cannot differentiate between capital and small letters.

The following is a general, recommended format
that is likely to produce portable identifiers.

- Consistent with XML NCName datatype
  (XML Schema Part 2: Datatypes Second Edition, Derived datatypes, `Section 3.3.7`__)

    * The first character must be alphabetic.
    * May contain alphanumeric characters and special characters like ``_``, ``-``.
    * No whitespace or other special characters like ``:``, ``,``, ``/``, etc.

- No double hyphens ``--``
- No trailing hyphen
- No periods ``.`` (reserved for references)

.. __: https://www.w3.org/TR/xmlschema-2/#NCName

References to constructs, such as gates, events, and parameters,
may include names of fault trees or components to access public or private members.
This feature requires a period ``.`` between names;
thus references may follow the pattern ``fault_tree.component.event``.

In addition to the identifier format,
the following is a set of recommendations for conforming tools
to maximize the input acceptability:

- Avoid restricting the word character set (e.g., ASCII-only, English-only)
- Support popular character encodings (e.g., UTF-8, UTF-16)
- Provide case-sensitive identifier processing (e.g., no capital-letters-only restrictions)
- Sanitize input leading and trailing whitespace characters
  (i.e., insensitive to noise)


Role of Parameters, House Events, and Basic Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Parameters, house events, and basic events should be always public,
in order to facilitate their portability from one tool to another.
