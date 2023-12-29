ARG PACKAGE
FROM ${PACKAGE}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  gnupg \
  sudo \
  wget \
  ca-certificates \
  tar \
  build-essential \
  git \
  xclip \
  xsel \
  cmake \
  unzip \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  llvm-17 \
  lldb-17 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  cd /usr/bin && \
  for tool in llvm-*17; do \
  # Strip the -17 suffix to create the new name \
  new_name=$(echo "$tool" | sed 's/-17$//'); \
  # Create the symlink \
  ln -s "$tool" "$new_name"; \
  done && \
  for tool in lldb-*17; do \
  # Strip the -17 suffix to create the new name \
  new_name=$(echo "$tool" | sed 's/-17$//'); \
  # Create the symlink \
  ln -s "$tool" "$new_name"; \
  done

RUN useradd -m dev

RUN echo 'dev:dev' | chpasswd

RUN echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz && \
  tar -xzf nvim-linux64.tar.gz && \
  sudo mv nvim-linux64 /opt/nvim && \
  rm nvim-linux64.tar.gz

RUN wget https://nodejs.org/dist/v20.9.0/node-v20.9.0-linux-x64.tar.xz && \
  tar -xJf node-v20.9.0-linux-x64.tar.xz && \
  sudo mv node-v20.9.0-linux-x64 /opt/node && \
  rm node-v20.9.0-linux-x64.tar.xz

RUN wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && \
  sudo mv lazygit /usr/local/bin/ && \
  rm -rf lazygit.tar.gz

ENV PATH=/opt/nvim/bin:$PATH
ENV PATH=/opt/node/bin:$PATH

