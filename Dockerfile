FROM 3b1b/manim:latest

USER root

# 安装中文字体
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装notebook支持
RUN pip install notebook

ARG NB_USER=manimuser
USER ${NB_USER}

# 复制当前目录文件到容器内的/manim目录
COPY --chown=manimuser:manimuser . /manim
    
