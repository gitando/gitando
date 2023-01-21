#!/usr/bin/env bash

BASE_PATH=
USER_SHELL=/bin/bash

while [ -n "$1" ] ; do
    case $1 in
    -u | --user )
        shift
        USER_NAME=$1
        ;;
    -p | --pass )
        shift
        PASSWORD=$1
        ;;
    -dbp | --dbpass )
        shift
        DBPASS=$1
        ;;
    -b |  --base )
        shift
        BASE_PATH=$1
        ;;
    -id |  --siteid )
        shift
        SITEID=$1
        ;;
    -php |  --php )
        shift
        PHP=$1
        ;;
    -dbr | --dbroot )
        shift
        DBROOT=$1
        ;;
    -r | --remote )
        shift
        REMOTE=$1
        ;;
    * )
        echo "ERROR: Unknown option: $1"
        exit -1
        ;;
    esac
    shift
done

sudo useradd -m -s $USER_SHELL -d /home/$USER_NAME -G gitando $USER_NAME
echo "$USER_NAME:$PASSWORD"|chpasswd

# Seciry measure, just in case (default behavour)
sudo chmod o-r /home/$USER_NAME

# Fixes "permission denied"
# https://stackoverflow.com/a/43686446/512277
sudo chmod +x /home/$USER_NAME

mkdir /home/$USER_NAME/web
mkdir /home/$USER_NAME/log

if [ $BASE_PATH != "" ]; then
    mkdir /home/$USER_NAME/web/$BASE_PATH
    WELCOME=/home/$USER_NAME/web/$BASE_PATH/index.php
else
    WELCOME=/home/$USER_NAME/web/index.php
fi
sudo touch $WELCOME
sudo cat > "$WELCOME" <<EOF
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Coming Soon</title><style>html{font-family: Arial, sans-serif; color: #000;}main{margin: 6rem 0 0; text-align: center;}h1{font-size: clamp(1em, 9vw, 3em); margin-bottom: 0;}h2{font-size: clamp(1em, 12vw, 6em);}p{margin-top: 8px; color: #7d7d7d; font-size: clamp(0.7em, 5vw, 1.2em);;}a{color: #7d7d7d;}</style></head><body><main><h1><script>document.write(window.location.hostname); </script></h1><p> Managed with <a href="https://gitando.com/">Gitando</a></p><h2>COMING SOON</h2></main></body></html>
EOF

NGINX=/etc/nginx/sites-available/$USER_NAME.conf
sudo wget $REMOTE/conf/host/$SITEID -O $NGINX
sudo dos2unix $NGINX
POOL=/etc/php/$PHP/fpm/pool.d/$USER_NAME.conf
sudo wget $REMOTE/conf/php/$SITEID -O $POOL
sudo dos2unix $POOL
CUSTOM=/etc/nginx/gitando/$USER_NAME.conf
sudo wget $REMOTE/conf/nginx -O $CUSTOM
sudo dos2unix $CUSTOM
sudo ln -s $NGINX /etc/nginx/sites-enabled/$USER_NAME.conf

#redundant
# sudo chown -R www-data: /home/$USER_NAME/web 

sudo service php$PHP-fpm restart
sudo systemctl restart nginx.service

DBNAME=$USER_NAME
DBUSER=$USER_NAME
/usr/bin/mysql -u gitando -p$DBROOT <<EOF
CREATE DATABASE IF NOT EXISTS $DBNAME;
use mysql;
CREATE USER $DBUSER@'%' IDENTIFIED WITH mysql_native_password BY '$DBPASS';
GRANT ALL PRIVILEGES ON $DBNAME.* TO $DBUSER@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

sudo mkdir /home/$USER_NAME/.cache
sudo mkdir /home/$USER_NAME/git
sudo cp /etc/gitando/github /home/$USER_NAME/git/deploy

sudo chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.cache
sudo chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/git
sudo chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/web