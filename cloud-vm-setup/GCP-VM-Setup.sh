# Setup NS GCP VM

export VMNAME="rk-gcp11-bastion"
# Change column to 4 for private address
export IP_ADDRESS=`gcloud compute instances list | grep -i $VMNAME | awk '{print $5}'`
echo "IP_ADDRESS: $IP_ADDRESS"
scp ~/.ssh/id_rsa ravinderk@$IP_ADDRESS:~/.ssh/
scp ~/.ssh/id_rsa.pub ravinderk@$IP_ADDRESS:~/.ssh/
#Copy till the line break and paste in the terminal
#Manual Setup
# Login/SSH to VM
sudo su -
export USER="ravinderk"
usermod -a -G sudo $USER
passwd $USER

echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
cat /etc/sudoers | grep -i $USER
exit
exit

#Exit and relogin with $USER
sudo apt update -y  && sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit

#Relogin with  $USER

#Automated Setup
#sudo chmod o+rwx /tmp
sudo apt update -y  && sudo apt install -y cloud-utils zsh fonts-powerline powerline python3-pip fzf  jq zip vim
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
mkdir -p ~/.oh-my-zsh/completions
chmod -R 755 ~/.oh-my-zsh/completions
ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
echo "fpath=($ZSH/custom/completions $fpath)" >> ~/.zshrc
#Install Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
export USER="ravinderk"
sudo usermod -a -G docker $USER
#Install Ansible
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update && sudo apt install -y ansible
#Set Python
sudo ln -s /usr/bin/python3 /usr/bin/python
#Install kubectl
sudo apt-get update
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
#Install gcloud ubuntu20
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-cli
which gcloud
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
#Install terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg 
gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \\n--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \\n--fingerprint\n
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \\nhttps://apt.releases.hashicorp.com $(lsb_release -cs) main" | \\nsudo tee /etc/apt/sources.list.d/hashicorp.list\n
sudo apt update
sudo apt-get install terraform
terraform -version
#Install vscode
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code -y
#Install gh cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
#Install jfrog cli
wget -qO - https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key | sudo apt-key add -
echo "deb https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" | sudo tee -a /etc/apt/sources.list &&    sudo apt update &&
sudo apt install -y jfrog-cli-v2-jf &&
jf intro
sed -i '/^plugins/ s/.*/plugins=(kubectl gcloud git fzf z zsh-syntax-highlighting zsh-autosuggestions kube-ps1 terraform)/' ~/.zshrc
#Set PROMPT
sed -i "/^PROMPT+/ s/.*/PROMPT+=' GCP-U22 \$(git_prompt_info)'/" ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
echo "PROMPT='\$(kube_ps1)'\$PROMPT" >> ~/.zshrc
#Install bazelisk ubuntu 20
wget https://github.com/bazelbuild/bazelisk/releases/download/v1.18.0/bazelisk-linux-amd64
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel
sudo chmod 755 /usr/local/bin/bazel

autoload -U compinit && compinit

## Bazel

### Install Bazel ubuntu

sudo apt install apt-transport-https curl gnupg -y\ncurl -fsSL <https://bazel.build/bazel-release.pub.gpg> | gpg --dearmor >bazel-archive-keyring.gpg\nsudo mv bazel-archive-keyring.gpg /usr/share/keyrings\necho "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] <https://storage.googleapis.com/bazel-apt> stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel
which bazel
bazel --version
bazel version

## pyenv

### install pyenv ubuntu 22

apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
curl <https://pyenv.run> | bash
pyenv install 3.8.3
pyenv versions
pyenv global 3.8.3
pyenv versions
