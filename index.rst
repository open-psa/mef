.. raw:: latex

    \begin{titlepage}
        \centering
        \pagenumbering{gobble}
        \vspace*{0cm}
        \includegraphics[width=0.15\textwidth]{opsa_logo.pdf}\par\vspace{0.5cm}
        {\scshape\Large The Open-PSA Initiative\par}
        \vspace{5cm}
        {\huge\bfseries Open-PSA Model Exchange Format\par}{\Large

.. only:: latex

    |release|

.. raw:: latex

        }\vfill
        {\small \today\par}
    \end{titlepage}

.. only:: latex

    .. include:: stamp.rst

.. raw:: latex

    \pagenumbering{roman}
    \pagestyle{plain}
    \begingroup
        \tableofcontents
        \listoftables
        \listoffigures
    \endgroup
    \clearpage
    \pagenumbering{arabic}
    \pagestyle{normal}

#########
|project|
#########

.. only:: html

    .. include:: stamp.rst

    :download:`Download PDF version <build/latex/opsa_mef.pdf>`

.. toctree::
    :caption: Contents
    :maxdepth: 3
    :numbered:

    mef/open_psa_initiative
    mef/introduction
    mef/anatomy
    mef/fault_tree_layer
    mef/stochastic_layer
    mef/meta_logical_layer
    mef/event_tree_layer
    mef/model_organization
    mef/report_layer
    mef/bibliography
