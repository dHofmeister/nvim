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
  unzip \
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

RUN curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && \
  mv lazygit /usr/local/bin/

RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV DENO_INSTALL="/root/.deno"
ENV PATH="$PATH:$DENO_INSTALL/bin"

RUN mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf && fc-cache -fv
