#!/usr/bin/env zsh
# Our public boootstrap entry point
set -e

cat << "EOF"
 __        __   _                            _____          ____
 \ \      / /__| | ___ ___  _ __ ___   ___  |_   _|__      / / /
  \ \ /\ / / _ \ |/ __/ _ \|  _   _ \ / _ \   | |/ _ \    / / /
   \ V  V /  __/ | (_| (_) | | | | | |  __/   | | (_) |  / / /
    \_/\_/ \___|_|\___\___/|_| |_| |_|\___|   |_|\___/  / / /
          _   _ ____ _____ ___ ____ _      ____        / / /
         | | | |  _ \_   _|_ _/ ___| | __  \ \ \      / / /
         | | | | |_) || |  | | |   | |/ /   \ \ \    / / /
         | |_| |  __/ | |  | | |___|   <     \ \ \  / / /
          \___/|_|    |_| |___\____|_|\_\     \ \ \/ / /
                                               \ \  / /
                                                \ \/ /
                                                 \__/

EOF

sleep 1

echo "Fetching our bootstrap repository ..."

curl -L -o /tmp/master.zip http://github.com/uptick/bootstrap-public/zipball/master/ > /dev/null

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

rm -rf /tmp/bootstrap || true

unzip /tmp/master.zip -d /tmp/bootstrap > /dev/null

cd /tmp/bootstrap/*/

echo "1) Installing xcode"
xcode-select --install || true > /dev/null

echo "2) Installing ansible"

while ! python3 -m pip install ansible > /dev/null; do
    echo "Press [Enter] to continue after xcode-select is installed. Required for ansible"
    read
done

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

echo "3) Installing home brew";

install_brew();

echo "4) Generating ssh key";

if [ -e ~/.ssh/id_ed25519.pub ]; then
    echo "The ssh key exists."
else
    echo "The ssh key does not exist."
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
fi
ssh-add ~/.ssh/id_ed25519

echo "5) Reading user settings"
python3 read_user_config.py

echo "6) Running ansible playbook"
python3 -m ansible playbook main.yml --ask-become-pass

echo "7) Running the second part of the bootstrap script"
cd ~/bootstrap && zsh bootstrap.sh
