FROM python:3.9-bullseye

USER root

# 配置软件源并更新
RUN echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update -y && apt-get upgrade -y

# 安装中文字体和manimGL依赖
RUN apt-get install -y --no-install-recommends \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ffmpeg \
    libxext6 \
    libsm6 \
    libxrender1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装notebook和manimGL
RUN pip install --upgrade pip && \
    pip install notebook manimgl

ARG NB_USER=manimuser
USER ${NB_USER}

COPY --chown=manimuser:manimuser . /manim
    
