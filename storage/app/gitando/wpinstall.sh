#!/usr/bin/env bash

BASE_PATH=
USER_SHELL=/bin/bash

while [ -n "$1" ] ; do
    case $1 in
    -u | --user )
        shift
        USER=$1
        ;;
    -p | --pass )
        shift
        PASS=$1
        ;;
    -b | --path )
        shift
        PATH=$1
        ;;
    -l | --url )
        shift
        URL=$1
        ;;
    * )
        echo "ERROR: Unknown option: $1"
        exit -1
        ;;
    esac
    shift
done

wpuser=$(openssl rand -base64 8)
wppass=$(openssl rand -base64 12)

# Enter into the public directory
cd $PATH

# Install WP
wp core download
wp core config --dbhost='localhost' --dbname=$USER --dbuser=$USER --dbpass=$PASS
wp core install --url=$ULR --title=$URL --admin_name=$wpuser --admin_password=$wppass --admin_email=do@gitando.com

# Update Permissions
sudo chown -R $USER:$USER $PATH
chmod 600 wp-config.php

# Todo: is clearing the history needed (to clear credentials?
history -c