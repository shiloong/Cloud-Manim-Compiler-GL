# 使用 Jupyter 的 scipy-notebook 作为基础镜像，已包含常用科学计算包
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
    colour \
    ipywidgets

# 设置工作目录
WORKDIR /home/jovyan

# 创建示例目录和输出目录
RUN mkdir -p manim-examples manim-output && \
    chown -R jovyan:users manim-examples manim-output

# 创建一个简单的示例文件（直接在 Dockerfile 中创建，避免 COPY 问题）
RUN echo "from manimlib import *

class CircleExample(Scene):
    def construct(self):
        circle = Circle(color=BLUE, fill_opacity=0.5)
        self.play(ShowCreation(circle))
        self.wait(1)
        self.play(circle.animate.set_color(GREEN), run_time=2)
        self.wait(1)
" > /home/jovyan/manim-examples/circle_example.py && \
    chown jovyan:users /home/jovyan/manim-examples/circle_example.py

# 创建一个简单的启动说明文件
RUN echo '#!/bin/bash
echo "ManimGL 环境已准备就绪!"
echo "您可以通过以下方式使用 ManimGL:"
echo "1. 在终端中运行: manimgl your_scene.py YourSceneClass"
echo "2. 在 Jupyter Notebook 中创建 Python 脚本并运行"
echo ""
echo "示例文件位于: /home/jovyan/manim-examples/"
echo "输出目录位于: /home/jovyan/manim-output/"
' > /usr/local/bin/start-manim.sh && \
    chmod +x /usr/local/bin/start-manim.sh && \
    chown jovyan:users /usr/local/bin/start-manim.sh

# 切换回 jovyan 用户（BinderHub 标准用户）
USER jovyan

# 设置环境变量
ENV MANIM_VIDEO_DIR=/home/jovyan/manim-output

# 设置默认启动命令（BinderHub 会自动启动 JupyterLab）
