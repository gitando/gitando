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
    -wpu | --wpuser )
        shift
        WPUSER=$1
        ;;
    -wpp | --wppass )
        shift
        WPPASS=$1
        ;;
    -wpm | --wpmail )
        shift
        WPMAIL=$1
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

# Enter into the public directory
cd $PATH

# Install WP
wp --allow-root core download
wp --allow-root core config --dbhost='localhost' --dbname=$USER --dbuser=$USER --dbpass=$PASS
wp --allow-root core install --url=$ULR --title=$URL --admin_name=$WPUSER --admin_password=$WPPASS --admin_email=$WPMAIL

# Update Permissions
sudo chown -R $USER:$USER $PATH
sudo chmod 600 wp-config.php

# Todo: is clearing the history needed (to clear credentials?
history -c