Backus-Naur form for the Open-PSA Model Exchange Format
=======================================================

Models
------

.. code:: latex

    model ::=
      <?xml version="1.0" ?>
      <!DOCTYPE opsa-mef >
      <opsa-mef [ name="identifier" ] >
      [ label ] [ attributes ]
      (
      event-tree-definition
      | alignment-definition
      | consequence-group-definition | consequence-definition
      | rule-definition
      | initiating-event-group-definition | initiating-event-definition
      | fault-tree-definition
      | substitution-definition
      | CCF-group-definition
      | include-directive
      )*
      </opsa-mef>

    label ::= <label> any text </label>

    attributes ::= <attributes> attribute+ </attributes>

    attribute ::=
      <attribute name="identifier" value="string" [ type="string" ]  />

    include-directive ::= <include file="string" />

Consequence, Consequence Groups, Alignments
-------------------------------------------

.. code:: latex

    consequence-definition ::=
      <define-consequence name="identifier">
        [ label ] [ attributes ]
        <initiating-event name="identifier"/>
        <sequence name="identifier" />
      </define-consequence>

    consequence-group-definition ::=
      <define-consequence-group name="identifier" >
        [ label ] [ attributes ]
        consequence | consequence-group
      </define-consequence-group>

    consequence ::= <consequence name="identifier" />

    consequence-group ::= <consequence-group name="identifier" />

    alignment-definition ::=
      <define-alignment name="identifier" time-fraction="float" >
        [ label ] [ attributes ]
        instruction*
      </define-alignment>

Initiating events, Initiating event Groups
------------------------------------------

.. code:: latex

    initiating-event-definition ::=
      <define-initiating-event name="identifier" [event-tree="identifier"]>
        [ label ] [ attributes ]
        [ collected-item | consequence | consequence-group ]
      </define-initiating-event>

    initiating-event-group-definition ::=
      <define-initiating-event-group name="identifier"
        [event-tree="identifier"] >
        [ label ] [ attributes ]
        initiating-event+
      </define-initiating-event-group>

    initiating-event ::=
        <initiating-event name="identifier" />
        |<initiating-event-group name="identifier" />

    collected-item ::=
      <basic-event name="identifier" />
      | <gate name="identifier" />
      | <parameter name="identifier" />


Event Trees
-----------

.. code:: latex

    event-tree-definition ::=
      <define-event-tree name="identifier">
        [ label ] [ attributes ]
        functional-event-definition*
        sequence-definition*
        branch-definition*
        initial-state
      </define-event-tree>

    functional-event-definition ::=
      <define-functional-event name="identifier" >
        [ label ]
        [ attributes ]
      </define-functional-event>

    sequence-definition ::=
      <define-sequence name="identifier" >
        [ label ]
        [ attributes ]
        instruction+
      </define-sequence>

    branch-definition ::=
      <define-branch name="identifier" >
        [ label ]
        [ attributes ]
        branch
      </define-branch>

    branch ::= instruction* (fork | end-state)
    fork ::= <fork functional-event="identifier"> path+ </fork>
    path ::= <path state="identifier" > branch </path>
    end-state ::=
      <sequence name="identifier" />
      | <branch name="identifier" />

    initial-state ::= <initial-state> branch </initial-state>

Instructions, Rules
-------------------

.. code:: latex


    instruction ::= set | collect | if-then-else | block | rule | link

    set ::= set-gate | set-house-event | set-basic-event | set-parameter

    set-gate ::=
      <set-gate name="identifier" [ direction="direction" ] >
        formula
      </set-gate>

    set-house-event ::=
      <set-house-event name="identifier" [ direction="direction" ] >
        Boolean-constant
      </set-house-event>

    set-basic-event ::=
      <set-basic-event name="identifier" [ direction="direction" ] >
        expression
      </set-basic-event>

    set-parameter ::=
      <set-parameter name="identifier" [ direction="direction" ] >
        expression
      </set-parameter>

    direction ::= forward | backward | both

    if-then-else ::= <if> expression instruction [ instruction ] </if>

    collect ::= collect-formula | collect-expression

    collect-formula ::= <collect-formula> formula </collect-formula>

    collect-expression ::= <collect-expression> expression </collect-expression>

    block ::= <block> instruction* </block>

    rule ::= <rule name="identifier" />

    link ::= <event-tree name="name" />

    rule-definition ::=
      <define-rule name="identifier" >
        [ label ] [ attributes ]
        instruction+
      </define-rule>

CCF-groups, Substitutions
-------------------------

.. code:: latex

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
        <basic-event name="identifier" >+
      </members>

    factors ::=
      <factors> factor+ </factors>
      | factor

    factor ::=
      <factor [ level="integer" ] >
        expression
      </factor>

    distribution ::=
      <distribution >
        expression
      </distribution>

    CCF-model ::= beta-factor | MGL | alpha-factor | phi-factor

    substitution-definition ::=
      <define-substitution [ name="identifier" ] [ type="identifier" ] >
        [ label ]
        [ attributes ]
        <hypothesis> Boolean-formula </hypothesis>
        [ <source> basic-event+ <source> ]
        <target> basic-event+ | Boolean-constant </target>
      </define-substitution>

Fault Trees, Components
-----------------------

.. code:: latex

    fault-tree-definition ::=
      <define-fault-tree name="identifier">
        [ label ]
        [ attributes ]
        (
            substitution-definition | CCF-group-definition
            | component-definition
            | gate-definition | house-event-definition
            | basic-event-definition | parameter-definition
            | include-directive
        )*
      </define-fault-tree>


    component-definition ::=
      <define-component name="identifier">
        [ label ]
        [ attributes ]
        (
          substitution-definition | CCF-group-definition
          | component-definition
          | gate-definition | house-event-definition
          | basic-event-definition | parameter-definition
          | include-directive
        )*
      </define-component>

    model-data ::=
      <model-data>
        ( house-event-definition | basic-event-definition | parameter-definition )*
      </model-data>

    event-definition ::=
      gate-definition
      | house-event-definition
      | basic-event-definition

    gate-definition ::=
      <define-gate name="identifier" [ role="private|public" ] >
        [ label ]
        [ attributes ]
        formula
      </define-gate>

    house-event-definition ::=
      <define-house-event name="identifier" [ role="private|public" ] >
        [ label ]
        [ attributes ]
        [ Boolean-constant ]
      </define-house-event>


Formulae
--------

.. code:: latex

    formula ::=
      event
      | Boolean-constant
      | <and> formula+ </and>
      | <or> formula+ </or>
      | <not> formula </not>
      | <xor> formula+ </xor>
      | <iff> formula+ </iff>
      | <nand> formula+ </nand>
      | <nor> formula+ </nor>
      | <atleast min="integer" > formula+ </atleast>
      | <cardinality min="integer" max="integer" > formula+ </cardinality>
      | <imply> formula formula </imply>

    event ::=
      <event name="identifier" [ type="event-type" ] />
      | <gate name="identifier" />
      | <house-event name="identifier" />
      | <basic-event name="identifier" />

    event-type ::= gate | basic-event | house-event

    Boolean-constant ::= <constant value="Boolean-value" />

    Boolean-value ::= true | false

Basic Events, Parameters
------------------------

.. code:: latex

    basic-event-definition ::=
      <define-basic-event name="identifier" [ role="private|public" ] >
        [ label ]
        [ attributes ]
        [ expression ]
      </declare>

    parameter-definition ::=
      <define-parameter name="identifier" [ role="private|public" ] [ unit="unit" ]>
        [ label ]
        [ attributes ]
        expression
      </define-parameter>

    unit ::= bool | int | float | hours | hours-1 | years | years-1 | demands | fit

Expressions
-----------

.. code:: latex

    expression ::=
      constant | parameter | operation | built-in | random-deviate | test-event

    constant ::=
      <bool value="Boolean-value" />
      | <int value="integer" />
      | <float value="float" />

    parameter ::=
      <parameter name="identifier" [ type="value-type" ] />
      | <system-mission-time [ unit="unit" ] />

    operation ::=
     numerical-operation | Boolean-operation | conditional-operation

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

    built-in ::=
       <exponential> [ expression ]:2 </exponential>
      | <GLM> [ expression ]:4 </GLM>
      | <Weibull> [ expression ]:3 </Weibull>
      | <periodic-test> [ expression ]:11 </periodic-test>
      | <periodic-test> [ expression ]:5 </periodic-test>
      | <periodic-test> [ expression ]:4 </periodic-test>
      | <extern-function name="name" > expression* </extern-function>

    random-deviate ::=
       <uniform-deviate> [ expression ]:2 </uniform-deviate>
      | <normal-deviate> [ expression ]:2 </normal-deviate>
      | <lognormal-deviate> [ expression ]:3 </lognormal-deviate>
      | <gamma-deviate> [ expression ]:2 </gamma-deviate>
      | <beta-deviate> [ expression ]:2 </beta-deviate>
      | histogram

    histogram ::= <histogram > expression bin+ </histogram>

    bin ::= <bin> expression expression </bin>

    test-event ::=
        <test-initiating-event name="name" />
      | <test-functional-event name="name" state="identifier" />
