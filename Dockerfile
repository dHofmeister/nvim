FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  curl \
  wget \
  xz-utils \
  ca-certificates \
  build-essential \
  cmake \
  xclip \
  python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip && python3 -m pip install --no-cache-dir neovim pynvim debugpy pyright pyls

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz && \
  tar -xzf nvim-linux64.tar.gz && \
  mv nvim-linux64 /opt/nvim && \
  rm nvim-linux64.tar.gz

RUN wget https://nodejs.org/dist/v20.9.0/node-v20.9.0-linux-x64.tar.xz && \
  tar -xJf node-v20.9.0-linux-x64.tar.xz && \
  mv node-v20.9.0-linux-x64 /opt/node && \
  rm node-v20.9.0-linux-x64.tar.xz

ENV PATH=/opt/nvim/bin:$PATH
ENV PATH=/opt/node/bin:$PATH

RUN bash -c "LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)"

ENV PATH=/root/.local/bin:$PATH
