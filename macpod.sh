#!/bin/bash
# Start jupyterlab container from macpod image
# - Maps local port 8001 -> container port 8888 (JupyterLab)
# - Maps ~/llmpath -> /workspace (JupyterLab root dir)

docker run -d \
    --name jupyterlab \
    -p 8001:8888 \
    -v "$HOME/llmpath:/workspace" \
    goosmanlei/macpod-for-fastai-course
