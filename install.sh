#! /bin/bash
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

if [ -e ~/.ssh/id_rsa ]; then
    echo "The id_rsa key exists."
else
    echo "The id_rsa key does not exist."
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
fi


echo "1) Installing xcode"
xcode-select --install || true > /dev/null

echo "2) Installing ansible"
while ! python3 -m pip install ansible > /dev/null; do
    echo "Press [Enter] to continue after xcode-select is installed. Required for ansible"
    read
done

echo "3) Executing private bootstrap script"
python3 read_user_config.py


echo "4) Running ansible playbook"
python3 -m ansible playbook main.yml --ask-become-pass

cd ~/bootstrap && zsh bootstrap.sh