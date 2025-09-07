# 使用 Jupyter 的 minimal-notebook 作为基础镜像，减少潜在的依赖冲突
FROM jupyter/minimal-notebook:latest

# 切换到 root 用户进行系统级安装
USER root

# 安装 ManimGL 所需的系统依赖和中文字体
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    texlive \
    texlive-latex-extra \
    libgl1-mesa-glx \
    libxcb-xinerama0 \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 先安装一些基础依赖，再安装 ManimGL
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir numpy scipy pillow pycairo

# 安装 ManimGL - 使用特定的版本以确保兼容性
RUN pip install --no-cache-dir manimgl

# 切换回 jovyan 用户
USER jovyan

# 创建输出目录
RUN mkdir -p /home/jovyan/manim-output

# 设置环境变量
ENV MANIM_VIDEO_DIR=/home/jovyan/manim-output
