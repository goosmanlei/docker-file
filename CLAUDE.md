# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo contains a single Dockerfile (`Dockerfile.runpod`) that builds a GPU-enabled container image for running the [fast.ai course part 2](https://github.com/goosmanlei/fastai-course-part2) on RunPod.

## Build

```bash
docker build --platform linux/amd64 -f Dockerfile.runpod -t goosmanlei/runpod-for-fastai-course .
```

## Architecture

The image is based on `pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel` and sets up:

- A Python venv at `/opt/fastai-venv` with fastai, PyTorch, transformers, diffusers, and related ML/data-science libraries
- JupyterLab on port 8888 (no auth token, configured for RunPod proxy compatibility)
- The course repo cloned to `/root/fastai-course-part2` (also the Jupyter root dir)
- Chinese font support (Noto Sans CJK SC) for matplotlib
- Claude Code CLI via Node.js 22
