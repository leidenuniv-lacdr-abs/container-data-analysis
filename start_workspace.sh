#!/usr/bin/env bash
docker pull michaelvanvliet/container-data-analysis  # update to latest version
docker run -i -t -v ${PWD}/workspace:/workspace -p 8888:8888 michaelvanvliet/container-data-analysis:latest /bin/bash -c "/opt/conda/bin/jupyter notebook --notebook-dir=/workspace --ip='*' --port=8888 --no-browser --allow-root"

# windows

# Linux


# test local new version of container
# docker build -t local-container-data-analysis containers/container-data-analysis/
# docker run -i -t -v ${PWD}/workspace:/workspace -p 8880:8880 local-container-data-analysis /bin/bash -c "/opt/conda/bin/jupyter notebook --notebook-dir=/workspace --ip='*' --port=8880 --no-browser --allow-root"