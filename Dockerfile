FROM robotics-deployment:provisioner

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  curl \
  wget \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz && \
  tar -xzf nvim-linux64.tar.gz && \
  mv nvim-linux64 /opt/nvim && \
  rm nvim-linux64.tar.gz

ENV PATH=/opt/nvim/bin:$PATH

RUN git clone https://github.com/LazyVim/starter ~/.config/nvim

