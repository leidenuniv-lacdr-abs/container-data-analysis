# Start with full anaconda (Python 3) distribution
FROM continuumio/anaconda3

MAINTAINER Michael van Vliet <m.s.vanvliet@lacdr.leidenuniv.nl>

# make sure the font-manager is present
RUN apt-get update --fix-missing && apt-get install -y font-manager python-setuptools python-dev build-essential

# fix locale
CMD LC_ALL=C

# intall pip
CMD sudo easy_install pip

# install pyteomics
CMD sudo pip install lxml numpy matplotlib pyteomics

# install Jupyter using conda
CMD /opt/conda/bin/conda install jupyter -y --quiet

# clear cache
CMD rm -rf ~/.cache/matplotlib

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]