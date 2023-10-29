#ARG GITHUB_USERNAME
#ARG GITHUB_TOKEN

FROM ubuntu:latest
#ARG GITHUB_TOKEN
#ARG GITHUB_USERNAME

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  curl \
  wget \
  xz-utils \
  ca-certificates \
  build-essential \
  cmake \
  && rm -rf /var/lib/apt/lists/*


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

#RUN git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/nvim /tmp/nvim && \
#  mkdir -p ~/.config/nvim/ && \
#  mv /tmp/nvim/nvim/* ~/.config/nvim && \
#  rm -rf /tmp/nvim


