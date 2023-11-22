# /bin/zsh
set -e

if [ -e ~/.ssh/id_rsa ]; then
    echo "The id_rsa key exists."
else
    echo "The id_rsa key does not exist."
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
fi

echo "1) Installing xcode"
xcode-select --install || true > /dev/null

echo "2) Installing ansible"
python3 -m pip install ansible > /dev/null

echo "3) Running ansible playbook"
python3 -m ansible playbook main.yml --ask-become-pass

echo "4) Executing private bootstrap script"
bash ~/bootstrap/bootstrap.sh