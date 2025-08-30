FROM ubuntu:22.04

USER root

# 设置非交互模式以避免安装过程中的交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 ManimGL 和 Notebook
RUN pip3 install --no-cache-dir manimgl notebook

# 创建非root用户
ARG NB_USER=manimuser
ARG NB_UID=1000
RUN useradd -m -s /bin/bash -u ${NB_UID} ${NB_USER}

USER ${NB_USER}

# 复制项目文件
COPY --chown=${NB_USER}:${NB_USER} . /manim

# 设置工作目录
WORKDIR /manim
