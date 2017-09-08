# Start with full anaconda (Python 3) distribution
FROM continuumio/anaconda3

MAINTAINER Michael van Vliet <m.s.vanvliet@lacdr.leidenuniv.nl>

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]