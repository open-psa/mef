FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y --no-install-recommends inkscape lmodern \
    texlive texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra \
    texlive-xetex
RUN apt-get install -y git zip wget python python-pip python-setuptools \
    hunspell enchant
RUN pip install sphinx==1.5.5 sphinx_rtd_theme sphinxcontrib-spelling
RUN wget http://mirrors.ctan.org/install/macros/latex/contrib/titlesec.tds.zip
RUN unzip titlesec.tds.zip -d $(kpsewhich --var-value TEXMFHOME)

ADD . mef/
WORKDIR mef
RUN mkdir -p build
CMD make latexpdf > /dev/null && make html linkcheck && make spelling
