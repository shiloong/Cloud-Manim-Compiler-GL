FROM python:3.9-slim

USER root

# 配置完整的Debian软件源
RUN echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list

# 安装中文字体和manimGL依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ffmpeg \
    # 添加可能缺失的依赖
    libxext6 \
    libsm6 \
    libxrender1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 仅安装notebook和manimGL
RUN pip install --upgrade pip && \
    pip install notebook manimgl

ARG NB_USER=manimuser
USER ${NB_USER}

COPY --chown=manimuser:manimuser . /manim
    
