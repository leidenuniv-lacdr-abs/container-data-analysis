FROM centos:centos7.4.1708

LABEL maintainer="m.s.vanvliet@lacdr.leidenuniv.nl"

ARG anaconda_installer=Anaconda3-5.2.0-Linux-x86_64.sh
ARG rstudio_server_installer=rstudio-server-rhel-1.1.456-x86_64.rpm

# download required versions
RUN curl -O https://download2.rstudio.org/$rstudio_server_installer && \
    curl -O https://repo.continuum.io/archive/$anaconda_installer

RUN echo "export PATH=\"/tmp/anaconda3/bin:$PATH\"" >> /etc/profile && \
    echo "alias R='/usr/bin/R'" >> /etc/profile && \
    echo "alias Rscript='/usr/bin/Rscript'" >> /etc/profile && \
    echo "alias pip='/tmp/anaconda3/bin/pip'" >> /etc/profile && \        
    echo "alias python='/tmp/anaconda3/bin/python'" >> /etc/profile && \            
    echo "alias conda='/tmp/anaconda3/bin/conda'" >> /etc/profile && \
    echo "alias jupyter='/tmp/anaconda3/bin/jupyter'" >> /etc/profile && \
    echo "alias jupyterhub='/tmp/anaconda3/bin/jupyterhub'" >> /etc/profile

RUN echo "Install OS dependencies" && \
    source /etc/profile && \
    yum update -y && yum groupinstall -y "Development tools" && yum install epel-release -y && \
    yum install -y cairo-devel libjpeg-turbo-devel openssl-devel libpng-devel libxml2-devel libcurl-devel libssh2-devel libgit2-devel nodejs openssl nano htop git wget && \
    npm install -g configurable-http-proxy && \
    yum clean all && \
    rm -rf /var/cache/yum    

RUN echo "Install RStudio" && \
    source /etc/profile && \
    yum install -y $rstudio_server_installer initscripts R && rm -rf $rstudio_server_installer && \
    echo 'www-port=8787' > /etc/rstudio/rserver.conf && \
    echo 'rsession-which-r=/usr/bin/R' >> /etc/rstudio/rserver.conf && \    
    rstudio-server verify-installation && \
    systemctl enable rstudio-server.service && \
    yum clean all && \
    rm -rf /var/cache/yum    

RUN echo "Install Jupyter(hub/labs) and dependencies" && \
    source /etc/profile && \
    bash $anaconda_installer -b -f -p /tmp/anaconda3 && rm -rf $anaconda_installer && \
    conda install -n base conda && \
    conda install -y -c conda-forge pyzmq jupyterhub jupyterlab && \
    conda install -y -c r r-essentials r-git2r r-devtools r-pbdzmq r-repr r-irdisplay r-evaluate r-crayon r-uuid r-digest r-irkernel && \
    jupyter labextension install -y @jupyterlab/hub-extension@0.9.2 && \
    pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir dockerspawner && \
    jupyterhub --generate-config && mkdir /etc/jupyterhub && mv jupyterhub_config.py /etc/jupyterhub/ && \
    echo >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.Spawner.cmd = ['/tmp/anaconda3/bin/jupyter-labhub']" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo >> /etc/jupyterhub/jupyterhub_config.py && \
    echo '{"argv": ["/usr/bin/R", "--slave", "-e", "IRkernel::main()", "--args", "{connection_file}"], "display_name":"R", "language":"R"}' > /tmp/anaconda3/share/jupyter/kernels/ir/kernel.json

RUN source /etc/profile && \
    echo "Install bash kernel" && \
    pip install bash_kernel && python -m bash_kernel.install && \
    conda clean --all

CMD ["/tmp/anaconda3/bin/jupyterhub --help"]