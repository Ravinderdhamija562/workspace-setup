# Local user setup(Run with root user)
useradd -m -d /home/ravinder -s /bin/bash -c "Ravinder local user" ravinder
usermod -aG sudo ravinder
passwd ravinder

# Run from local user

sudo apt update -y  && sudo apt install -y cloud-utils zsh fonts-powerline powerline python3-pip fzf  jq zip vim jq zip zsh
chsh -s $(which zsh)
# logout and login again with same user
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
mkdir -p ~/.oh-my-zsh/completions
ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
echo "fpath=($ZSH/custom/completions $fpath)" >> ~/.zshrc
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
#Install helm
wget --no-check-certificate https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -zxvf helm-v3.10.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
which helm
helm version
#Install jfrog cli
wget -qO - https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key | sudo apt-key add -
echo "deb https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" | sudo tee -a /etc/apt/sources.list &&    sudo apt update &&
sudo apt install -y jfrog-cli-v2-jf &&
jf intro

# Prompt setup
sed -i '/^plugins/ s/.*/plugins=(kubectl git fzf z zsh-syntax-highlighting zsh-autosuggestions kube-ps1 )/' ~/.zshrc
#Set PROMPT
echo "PROMPT='\$(kube_ps1)'\$PROMPT" >> ~/.zshrc
#Setup aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# install packer
cd /opt
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
which packer

#Install gcloud ubuntu20
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y google-cloud-cli
which gcloud
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin

# Setup ssh key
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
## Copy ~/.ssh/id_rsa.pub to ravinderdhamija562 github account
# Setup git
mkdir -p ~/git/ravinderdhamija562
cd git/ravinderdhamija562
git clone git@github.com:Ravinderdhamija562/rk-private-docs.git

#set up zshrc
mv ~/.zshrc ~/.zshrc-orig
ln -s ~/git/ravinderdhamija562/rk-private-docs/workspace-setup/zshrc ~/.zshrc
source ~/.zshrc

# Install gh

sudo apt update && sudo apt install -y curl
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh

# Set up nsk
gh release download v0.1.230 --repo netSkopePlatformEng/nsk --pattern nsk_0.1.230_linux_amd64.tar.gz
gzip -d nsk_0.1.230_linux_amd64.tar.gz
tar -xvf nsk_0.1.230_linux_amd64.tar
sudo cp nsk /usr/local/bin/

