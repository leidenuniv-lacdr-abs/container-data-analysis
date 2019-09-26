FROM centos:centos7.4.1708

LABEL maintainer="m.s.vanvliet@lacdr.leidenuniv.nl"

ARG anaconda_installer=Miniconda3-4.5.11-Linux-x86_64.sh
    
# download required version
RUN curl -O https://repo.anaconda.com/miniconda/$anaconda_installer && \
    echo "export PATH=\"/tmp/anaconda3/bin:/tmp/anaconda3/lib:$PATH\"" >> /etc/profile

RUN echo "Install OS dependencies" && \
    source /etc/profile && \ 
    yum install -y libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver && \   
    yum update -y && yum groupinstall -y "Development tools" && yum install epel-release -y && \
    yum install -y libunwind libXt cairo-devel libjpeg-turbo-devel openssl-devel libpng-devel libxml2-devel libcurl-devel libssh2-devel libgit2-devel nodejs openssl nano htop git wget && \
    npm install -g configurable-http-proxy && \
    yum clean all && rm -rf /var/cache/yum   
    
RUN echo "Install Jupyter(hub/labs) and dependencies" && \    
    source /etc/profile && \
    bash $anaconda_installer -b -f -p /tmp/anaconda3 && rm -rf $anaconda_installer && \
    conda install -n base conda && \
    conda install -y -c conda-forge pyzmq jupyterhub jupyterlab && \
    pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir dockerspawner && \
    jupyterhub --generate-config && mkdir /etc/jupyterhub && mv jupyterhub_config.py /etc/jupyterhub/ && \
    echo >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.Spawner.cmd = ['/tmp/anaconda3/bin/jupyter-labhub']" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo >> /etc/jupyterhub/jupyterhub_config.py && \
    conda clean --all && yum clean all && rm -rf /var/cache/yum   

RUN echo "Install R kernel" && \
    source /etc/profile && \
    conda install -y -c r r-irkernel && \
    echo '{"argv": ["/tmp/anaconda3/bin/R", "--slave", "-e", "IRkernel::main()", "--args", "{connection_file}"], "display_name":"R", "language":"R"}' > /tmp/anaconda3/share/jupyter/kernels/ir/kernel.json && \
    conda clean --all && yum clean all && rm -rf /var/cache/yum   
    
RUN echo "Install bash kernel" && \
    source /etc/profile && \
    pip install bash_kernel && python -m bash_kernel.install && \
    conda clean --all && yum clean all && rm -rf /var/cache/yum   

CMD ["/tmp/anaconda3/bin/jupyterhub --help"]