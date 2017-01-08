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
The RNC schema for the XML representation of declarations of groups of consequences
is given in :numref:`schema_consequence_groups`.

.. literalinclude:: schema/consequence_groups.rnc
    :name: schema_consequence_groups
    :caption: The RNC schema of the XML representation of consequence groups
    :language: rnc

Note that consequences and consequences groups can be used as initiating events
(see :numref:`event_tree_structure_xml_representation`).
This mechanism makes it possible to link event trees.

Missions, Phases
----------------

Phases are physical configurations (e.g., operation and maintenance)
in which the plant spends a fraction of the mission time.
Phases are grouped into missions.
The time fractions of the phases of a mission should sum to 1.
House events and parameters may be given different values in each phase.
The RNC schema for the XML representation of phase declarations
is given in :numref:`schema_mission_phase`.

.. literalinclude:: schema/mission_phase.rnc
    :name: schema_mission_phase
    :caption: The RNC schema of the XML representation of Missions and Phases
    :language: rnc


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

.. figure:: ../images/containers_and_constructs.*
    :name: fig_containers_and_constructs
    :align: center

    Containers and the constructs they can define

:numref:`schema_model` gives the RNC schema of the XML representation of a model.

.. literalinclude:: schema/model.rnc
    :name: schema_model
    :caption: The RNC schema for the XML representation of a model
    :language: rnc
