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

curl -L -o /tmp/master.zip http://github.com/uptick/bootstrap-public/zipball/master/

unzip /tmp/master.zip -d /tmp/bootstrap

cd /tmp/bootstrap/*/

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

bash bootstrap.sh