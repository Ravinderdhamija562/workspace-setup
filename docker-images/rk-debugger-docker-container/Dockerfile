FROM ubuntu:24.04

LABEL maintainer="ravinderk"
LABEL description="Ravinder's RK Debugger Docker Container"
LABEL version="1.0"

ENV LANG=C.UTF-8

RUN apt-get update
RUN apt-get install -y \
    ca-certificates \
    git \
    curl \
    zsh \
    cloud-utils \
    fonts-powerline \
    powerline \
    python3-pip \
    fzf \
    jq \
    zip \
    vim \
    iputils-ping \
    dnsutils \
    net-tools \
    iproute2 \
    iputils-tracepath \
    nmap \
    traceroute \
    tcpdump \
    lsof \
    strace \
    htop \
    iotop

RUN BRANCH=master \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
    --unattended

COPY zshrc /root/.zshrc

RUN touch /usr/share/doc/fzf/examples/key-bindings.zsh
RUN git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx
RUN ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
RUN ln -s /opt/kubectx/kubens /usr/local/bin/kubens
RUN mkdir -p ~/.oh-my-zsh/completions
RUN chmod -R 755 ~/.oh-my-zsh/completions
RUN ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
RUN ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh

#Install kubectl
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl
#Install helm
RUN wget --no-check-certificate https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.10.0-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm
RUN which helm
RUN helm version

#Install gcloud ubuntu20
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates gnupg curl sudo
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-cli
RUN which gcloud
RUN apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin

#Install terraform
# RUN apt-get update && apt-get install -y gnupg software-properties-common
# RUN wget -O- https://apt.releases.hashicorp.com/gpg
# RUN gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \\nhttps://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
# RUN apt update
# RUN apt-get install -y terraform
# RUN terraform -version

#Install gh cli
RUN type -p curl >/dev/null || (apt update && apt install curl -y)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y

#Install jfrog cli
RUN curl -fL https://install-cli.jfrog.io | sh

CMD ["/bin/zsh"]