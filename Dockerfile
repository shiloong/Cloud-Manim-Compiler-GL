FROM python:3.9-bullseye

USER root

# 配置软件源并更新系统
RUN echo "deb http://deb.debian.org/debian bullseye main contrib non-free\ndeb http://deb.debian.org/debian bullseye-updates main contrib non-free\ndeb http://security.debian.org/debian-security bullseye-security main contrib non-free" > /etc/apt/sources.list && \
    apt-get update -y && apt-get upgrade -y && \
    # 安装精简依赖包
    apt-get install -y --no-install-recommends \
    # 核心中文字体（保留最常用的）
    fonts-wqy-zenhei \
    # 核心图形和媒体依赖
    libgl1-mesa-glx libglib2.0-0 ffmpeg \
    # 必要编译工具
    build-essential python3-dev libssl-dev \
    # 核心pangocairo依赖
    libpango1.0-dev libcairo2-dev && \
    # 清理缓存
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 精简Python包安装
RUN pip install --upgrade pip -v && \
    pip install notebook manimgl -v

ARG NB_USER=manimuser
USER ${NB_USER}

COPY --chown=manimuser:manimuser . /manim
    
