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
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main" >> /etc/apt/sources.list

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
RUN rustup default stable && rustup component add rust-analyzer
ENV PATH=/opt/nvim/bin:$PATH
ENV PATH=/opt/node/bin:$PATH
ENV CARGO_HOME=/opt/cargo
ENV RUSTUP_HOME=/opt/rustup

RUN echo "export CARGO_HOME=/opt/cargo" >> /root/.bashrc
RUN echo "export RUSTUP_HOME=/opt/rustup" >> /root/.bashrc
RUN echo "export PATH=/opt/cargo/bin:$PATH" >> /root/.bashrc
RUN echo "export PATH=/opt/node/bin:$PATH" >> /root/.bashrc
RUN echo "export ROS_DISCOVERY_SERVER=0.0.0.0:11811" >> /root/.bashrc
RUN echo "export DISPLAY=:1" >> /root/.bashrc
RUN echo "source /ran/install/setup.bash" >> /root/.bashrc

RUN useradd -m dev

RUN echo 'dev:dev' | chpasswd

RUN echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && \
  tar -xzf nvim-linux64.tar.gz && \
  sudo mv nvim-linux64 /opt/nvim && \
  rm nvim-linux64.tar.gz

RUN wget https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.xz && \
  tar -xJf node-v20.11.0-linux-x64.tar.xz && \
  sudo mv node-v20.11.0-linux-x64 /opt/node && \
  rm node-v20.11.0-linux-x64.tar.xz

RUN npm install -g svelte-language-server

RUN wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && \
  sudo mv lazygit /usr/local/bin/ && \
  rm -rf lazygit.tar.gz

RUN sudo chown -R dev:dev /ran
RUN rustup component add rust-analyzer
ENV PATH=/opt/nvim/bin:$PATH
ENV PATH=/opt/node/bin:$PATH
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/ran/config/super_client_configuration.xml

COPY package_entrypoint.sh /ran/dev_entrypoint.sh
ENTRYPOINT ["/ran/dev_entrypoint.sh"]
RUN echo "source /ran/dev_entrypoint.sh" >> /home/dev/.bashrc
RUN echo "export FASTRTPS_DEFAULT_PROFILES_FILE=/ran/config/super_client_configuration.xml" >> /home/dev/.bashrc
