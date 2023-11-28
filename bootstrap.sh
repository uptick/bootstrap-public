# /bin/zsh
set -e

if [ -e ~/.ssh/id_rsa ]; then
    echo "The id_rsa key exists."
else
    echo "The id_rsa key does not exist."
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
fi

# We need to support passworded ssh-keys
ssh-add

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

function install_brew() {
    if [ -e /opt/homebrew/bin/brew ]; then
        echo "Homebrew is already installed."
    else
        echo "Installing Homebrew."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew update
        brew upgrade
    fi
}



echo "1) Installing xcode"
xcode-select --install || true > /dev/null

echo "2) Installing ansible"
python3 -m pip install ansible > /dev/null

echo "3) Installing brew"
install_brew()

echo "4) Running ansible playbook"
echo "Please enter your user password (so ansible can run sudo for you)"
python3 -m ansible playbook main.yml --ask-become-pass

echo "5) Executing private bootstrap script"
cd ~/bootstrap/ && zsh ~/bootstrap/bootstrap.sh
