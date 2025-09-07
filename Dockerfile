# 使用 Jupyter 的 scipy-notebook 作为基础镜像
FROM jupyter/scipy-notebook:latest

# 切换到 root 用户进行系统级安装
USER root

# 安装 ManimGL 所需的系统依赖和中文字体
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    texlive \
    texlive-latex-extra \
    texlive-fonts-extra \
    libgl1-mesa-glx \
    libxcb-xinerama0 \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 ManimGL 及其 Python 依赖
RUN pip install --no-cache-dir \
    manimgl \
    colour

# 创建输出目录并设置权限
RUN mkdir -p /home/jovyan/manim-output && \
    chown -R jovyan:users /home/jovyan/manim-output

# 切换回 jovyan 用户（BinderHub 标准用户）
USER jovyan

# 设置环境变量
ENV MANIM_VIDEO_DIR=/home/jovyan/manim-output
