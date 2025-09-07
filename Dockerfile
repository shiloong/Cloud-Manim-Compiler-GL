# 使用 Jupyter 的 scipy-notebook 作为基础镜像，已包含常用科学计算包
FROM jupyter/scipy-notebook:latest

# 切换到 root 用户进行系统级安装
USER root

# 安装 ManimGL 所需的系统依赖和中文字体
# 注意：避免在包名后添加注释，以免造成 Docker 解析错误
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

# 创建示例目录并添加示例文件
RUN mkdir -p manim-examples && chown -R jovyan:users manim-examples

# 添加一个简单的示例文件
COPY --chown=jovyan:users examples/ /home/jovyan/manim-examples/

# 切换回 jovyan 用户（BinderHub 标准用户）
USER jovyan

# 设置环境变量
ENV MANIM_VIDEO_DIR=/home/jovyan/manim-output

# 创建输出目录
RUN mkdir -p /home/jovyan/manim-output

# 添加启动脚本
COPY --chown=jovyan:users start-manim.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-manim.sh

# 设置默认启动命令（BinderHub 会自动启动 JupyterLab）
