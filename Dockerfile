# 使用 Python 官方镜像作为基础
FROM python:3.9-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    texlive \
    texlive-latex-extra \
    libgl1-mesa-glx \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 ManimGL
RUN pip install --no-cache-dir manimgl

# 设置工作目录
WORKDIR /workspace

# 创建非特权用户
RUN useradd -m -u 1000 user && chown -R user:user /workspace
USER user

# 设置默认命令
CMD ["bash"]
