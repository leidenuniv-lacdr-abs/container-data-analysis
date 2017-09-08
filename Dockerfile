# Start with full anaconda (Python 3) distribution
FROM continuumio/anaconda3

MAINTAINER Michael van Vliet <m.s.vanvliet@lacdr.leidenuniv.nl>

RUN apt-get update --fix-missing && apt-get install -y font-manager

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]