# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo contains Dockerfiles for running the [fast.ai course part 2](https://github.com/goosmanlei/fastai-course-part2):

- `Dockerfile.runpod` — GPU container for RunPod (clones course repo into image)
- `Dockerfile.macpod` — Local container for macOS Apple Silicon (mounts local directory)

## Build

```bash
# RunPod image (linux/amd64)
docker build --platform linux/amd64 -f Dockerfile.runpod -t goosmanlei/runpod-for-fastai-course .

# macOS Apple Silicon image (linux/arm64)
docker build --platform linux/arm64 -f Dockerfile.macpod -t goosmanlei/macpod-for-fastai-course .
```

## Run (macpod)

```bash
./macpod.sh
# JupyterLab at http://localhost:8001, working dir mapped from ~/llmpath
```

## Architecture

Both images are based on `pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel` and set up:

- A Python venv at `/opt/fastai-venv` with fastai, PyTorch, transformers, diffusers, and related ML/data-science libraries
- JupyterLab on port 8888 (no auth token)
- Chinese font support (Noto Sans CJK SC) for matplotlib
- Claude Code CLI via Node.js 22
