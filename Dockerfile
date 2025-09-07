# 使用 Jupyter 的 scipy-notebook 作为基础镜像，已包含常用科学计算包
FROM jupyter/scipy-notebook:latest

# 切换到 root 用户进行系统级安装
USER root

# 安装 ManimGL 所需的系统依赖和中文字体
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \           # 视频处理工具
    texlive \          # LaTeX 基础包
    texlive-latex-extra \ # 额外的 LaTeX 包
    libgl1-mesa-glx \  # OpenGL 支持
    # 中文字体包
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 ManimGL 及其 Python 依赖
RUN pip install --no-cache-dir \
    manimgl \          # 安装 ManimGL 框架
    colour \           # 颜色处理库

# 设置工作目录
WORKDIR /home/jovyan

# 复制示例文件（可选）
COPY --chown=jovyan:users . /home/jovyan/manim-examples

# 切换回 jovyan 用户（BinderHub 标准用户）
USER jovyan

# 设置默认启动命令（BinderHub 会自动启动 JupyterLab）
# 不需要显式设置 CMD，BinderHub 会处理
