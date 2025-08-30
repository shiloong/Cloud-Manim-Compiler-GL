FROM python:3.9-bullseye

USER root

# 配置软件源并更新
RUN echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update -y && apt-get upgrade -y

# 安装完整依赖
RUN apt-get install -y --no-install-recommends \
    # 中文字体
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    # 图形和媒体依赖
    libgl1-mesa-glx \
    libglib2.0-0 \
    ffmpeg \
    libxext6 \
    libsm6 \
    libxrender1 \
    # 编译工具
    build-essential \
    python3-dev \
    libssl-dev \
    libffi-dev \
    # 可能的额外依赖
    libgirepository1.0-dev \
    gobject-introspection \
    libcairo2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 分步安装Python包，增加详细日志
RUN pip install --upgrade pip -v && \
    pip install setuptools wheel -v && \
    pip install notebook -v && \
    # 单独安装manimgl并输出详细日志
    pip install manimgl -v

ARG NB_USER=manimuser
USER ${NB_USER}

COPY --chown=manimuser:manimuser . /manim
    
