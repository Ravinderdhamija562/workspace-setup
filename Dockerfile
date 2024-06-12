FROM ubuntu:22.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y update \
    && echo "------------------------------------------------------ Common" \
    && apt-get install -y sudo jq git \
    && apt-get install -y curl wget telnet netcat dnsutils \
    && apt-get install -y zip gzip tar unzip bzip2 \
    && apt-get install -y zsh fonts-powerline powerline python3-pip fzf vim \
    && apt-get install -y ca-certificates gnupg \
    && apt-get install -y apt-transport-https ca-certificates \
    && apt-get install -y ansible \
    && apt-get install -y wget gpg \
    && apt-get install -y apt-transport-https



    #&& apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    #&& apt-get install -y kubectl apt-transport-https \
    #&& google-cloud-sdk-gke-gcloud-auth-plugin \
    #&& apt-get install -y code \
    #&& apt-get install -y terraform \
    #&& apt-get install -y gh \