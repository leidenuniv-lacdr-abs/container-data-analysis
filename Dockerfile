# Start with full anaconda (Python 3) distribution
FROM continuumio/anaconda3

MAINTAINER Michael van Vliet <m.s.vanvliet@lacdr.leidenuniv.nl>

RUN bash -c 'echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran34/" >> /etc/apt/sources.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480

# make sure the font-manager is present
RUN apt-get update --fix-missing && apt-get install -y --force-yes \
    libzmq3-dev python-setuptools python-dev build-essential \
    libcurl4-gnutls-dev libxml2-dev libssl-dev apt-utils gdebi-core psmisc \
    r-base r-base-dev libapparmor1
    #apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# download Rstudio server
# RUN wget https://download2.rstudio.org/rstudio-server-1.0.153-amd64.deb
# RUN gdebi --non-interactive rstudio-server-1.0.153-amd64.deb

# fix locale
RUN LC_ALL=C

# install conda packages
RUN /opt/conda/bin/conda install jupyter lxml numba -y --quiet

COPY requirements.txt requirements.txt
RUN /opt/conda/bin/pip install -r requirements.txt

# add bash kernel to jupyter
RUN python -m bash_kernel.install

# add r and libs (including r-kernel to jupyter)
COPY rdeps.R rdeps.R
RUN Rscript rdeps.R

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]