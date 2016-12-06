.. _model_organization:

***********************
Organization of a Model
***********************

This chapter discusses the organizations of models.
It includes the definition of two additional constructs:
the notions of consequence, consequence group, and alignment.

Additional Constructs
=====================

Consequences and Consequence Groups
-----------------------------------

It is often convenient to group sequences of event trees
into bins of sequences with similar physical consequences (e.g., Core Melt).
The Model Exchange Format provides the notion of consequence to do so.
A consequence is characterized by
an event tree, a particular initiating event for this event tree,
and a particular sequence (end-state) of the same tree.
Consequences are given a name.
Groups of consequences can be defined as well.
They are also given a name, and can include sub-groups.
The Backus-Naur form for the XML representation of declarations of groups of consequences
is given in :numref:`bnf_consequence_groups`.

.. code-block:: bnf
    :name: bnf_consequence_groups
    :caption: Backus-Naur form of the XML representation of consequence groups

    consequence-definition ::=
        <define-consequence name="identifier" >
            [ label ]
            [ attributes ]
            <initiating-event name="identifier" />
            <sequence name="identifier" />
        </define-consequence>

    consequence-group-definition ::=
        <define-consequence-group name="identifier" >
            [ label ]
            [ attributes ]
            consequence | consequence-group
        </define-consequence-group>

    consequence ::= <consequence name="identifier" />

    consequence-group ::= <consequence-group name="identifier" />

Note that consequences and consequences groups can be used as initiating events
(see section :ref:`event_tree_structure_xml_representation`).
This mechanism makes it possible to link event trees.

Missions, Phases
----------------

Phases are physical configurations (e.g., operation and maintenance)
in which the plant spends a fraction of the mission time.
Phases are grouped into missions.
The time fractions of the phases of a mission should sum to 1.
House events and parameters may be given different values in each phase.
The Backus-Naur form for the XML representation of phase declarations
is given in :numref:`bnf_mission_phase`.

.. code-block:: bnf
    :name: bnf_mission_phase
    :caption: Backus-Naur form of the XML representation of Missions and Phases

    mission-definition ::=
        <define-mission name="identifier" >
            [ label ]
            [ attributes ]
            define-phase+
        </define-alignment>

    phase-definition ::=
        <define-phase name="identifier" time-fraction="float" >
            [ label ]
            [ attributes ]
            instruction*
        </define-phase>


Splitting the Model into Several Files
======================================

So far, we have written as if the model fits completely into a single file.
For even medium size PSA models this assumption not compatible with Quality Control.
Moreover, such a monolithic organization of data would be very hard to manage
when several persons work together on the same model.

A first way to split the model into several files is to use the XML notion of entities:
in any XML file, it is possible to declare file entities in the preamble,
and to include them in the body of the document.
This mechanism is exemplified below.

.. code-block:: xml

    <?xml version="1.0" ?>

    <!DOCTYPE SMRF [
    <!ENTITY file1 SYSTEM "file1.xml">
    <!ENTITY file2 SYSTEM "file2.xml">
    ]>
    <smrf>
        ...
        &file1;
        ...
        &file2;
        ...
    </smrf>

This mechanism, however, has the drawback
that XML tools have to actually include the files into the document,
hence, making its manipulation heavier.

The Model Exchange Format proposes another simple mechanism to achieve the same goal:
the tag include.
This tag can be inserted at any place in a document.
Its effect is to load the content of the given file into the model.

.. code-block:: xml

    <opsa-mef>
        ...
        <include file="basic-events.xml"/>
        ...
    </opsa-mef>

Organization of a Model
=======================

The Model Exchange Format introduces five types of containers:
models at the top level, event trees, fault trees, components, and model-data.
The Model Exchange Format introduces also eighteen constructs.
:numref:`fig_containers_and_constructs` shows the containers and the constructs they can define.

.. figure:: ../images/containers_and_constructs.svg
    :name: fig_containers_and_constructs
    :align: center

    Containers and the constructs they can define

:numref:`bnf_containers` gives the XML representation of models.
This representation just collects what has been defined so far.

.. code-block:: bnf
    :name: bnf_containers
    :caption: Backus-Naur form for the XML representation of containers

    model ::=
        <?xml version="1.0" ?>
        <!DOCTYPE opsa-mef >
        <opsa-mef>
            [ label ]
            [ attributes ]
            (
                  mission-definition
                | consequence-group-definition
                | consequence-definition
                | event-tree-definition
                | rule-definition
                | initiating-event-group-definition
                | initiating-event-definition
                | fault-tree-definition
                | substitution-definition
                | CCF-group-definition
            )*
        </opsa-mef>

    event-tree-definition ::=
        <define-event-tree name="identifier">
            [ label ]
            [ attributes ]
            functional-event-definition*
            sequence-definition*
            branch-definition*
            initial-state
        </define-event-tree>

    fault-tree-definition ::=
        <define-fault-tree name="identifier">
            [ label ]
            [ attributes ]
            (
                 substitution-definition
                | CCF-group-definition
                | component-definition
                | gate-definition
                | house-event-definition
                | basic-event-definition
                | parameter-definition
            )*
        </define-fault-tree>

    component-definition ::=
        <define-component name="identifier">
            [ label ]
            [ attributes ]
            (
                  substitution-definition
                | CCF-group-definition
                | component-definition
                | gate-definition
                | house-event-definition
                | basic-event-definition
                | parameter-definition
            )*
        </define-component>

    model-data ::=
        <model-data>
            (house-event-definition | basic-event-definition | parameter-definition)*
        </model-data>
