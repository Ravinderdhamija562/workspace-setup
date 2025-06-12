FROM --platform=linux/amd64 ubuntu:24.04

LABEL maintainer="ravinderk" \
      description="Ravinder's RK Debugger Docker Container"

ENV LANG=C.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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
    gpg \
    iotop && \
    rm -rf /var/lib/apt/lists/*

# --- Oh My Zsh and Zsh Plugins Installation ---
RUN BRANCH=master \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
    --unattended && \
    chmod 644 /root/.zshrc && \
    touch /usr/share/doc/fzf/examples/key-bindings.zsh && \
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/fzf-tab && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/themes/powerlevel10k && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-completions && \
    # kubectx installation
    git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    mkdir -p /root/.oh-my-zsh/completions && \
    chmod -R 755 /root/.oh-my-zsh/completions && \
    ln -s /opt/kubectx/completion/_kubectx.zsh /root/.oh-my-zsh/completions/_kubectx.zsh && \
    ln -s /opt/kubectx/completion/_kubens.zsh /root/.oh-my-zsh/completions/_kubens.zsh

COPY zshrc /root/.zshrc

# --- Kubernetes CLI (kubectl) Installation ---
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends kubectl && \
    rm -rf /var/lib/apt/lists/*

#Install helm
RUN wget --no-check-certificate https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.10.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm helm-v3.10.0-linux-amd64.tar.gz && \
    rm -r linux-amd64 # Clean up extracted directory

# --- Google Cloud CLI (gcloud) Installation ---
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg curl sudo && \
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin && \
    rm -rf /var/lib/apt/lists/*

#Install terraform
# RUN apt-get update && apt-get install -y gnupg software-properties-common
# RUN wget -O- https://apt.releases.hashicorp.com/gpg
# RUN gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \\nhttps://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
# RUN apt update
# RUN apt-get install -y terraform
# RUN terraform -version

# --- GitHub CLI (gh) Installation ---
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gh && \
    rm -rf /var/lib/apt/lists/*

#Install jfrog cli
RUN curl -fL https://install-cli.jfrog.io | sh

CMD ["/bin/zsh", "-c", "tail -f /dev/null"]