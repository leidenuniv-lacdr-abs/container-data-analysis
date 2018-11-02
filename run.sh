#!/usr/bin/env bash

# run an instance of the jh-da container
if [ -x "$(command -v docker)" ]; then
    echo "Found Docker... preparing container"
    docker rm jhda # clean previous version
    docker run -it --name jhda -p 8787:8787 -p 8000:8000 -p 8001:8001 jh-da-base-image /bin/bash -c "rstudio-server start; /tmp/anaconda3/bin/jupyterhub jupyterhub -f /etc/jupyterhub/jupyterhub_config.py --no-ssl"
else
    echo "Please install Docker: https://docs.docker.com/install/"
fi
