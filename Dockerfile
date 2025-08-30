# 基于Python 3.9镜像，这是ManimGL推荐的版本
FROM python:3.9-slim

# 设置工作目录
WORKDIR /home/jovyan

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libxrender1 \
    libsm6 \
    libxext6 \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装manimgl
RUN pip install --no-cache-dir manimgl

# 安装Jupyter，因为MyBinder需要Jupyter环境
RUN pip install --no-cache-dir jupyter

# 设置环境变量，确保中文显示正常
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# 暴露Jupyter端口
EXPOSE 8888

# 启动Jupyter Notebook的命令
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
    
