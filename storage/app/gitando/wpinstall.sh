#!/usr/bin/env bash

while [ -n "$1" ] ; do
    case $1 in
    -u | --user )
        shift
        USERNAME=$1
        ;;
    -p | --pass )
        shift
        PASS=$1
        ;;
    -b | --path )
        shift
        BASEPATH=$1
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
cd /home/$USERNAME/web/

# Install WP
wp --allow-root core download
wp --allow-root core config --dbhost='localhost' --dbname=$USERNAME --dbuser=$USERNAME --dbpass=$PASS
wp --allow-root core install --url=$URL --title=$URL --admin_name=$WPUSER --admin_password=$WPPASS --admin_email=$WPMAIL

# Update Permissions
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/web/
sudo chmod 600 wp-config.php

# Todo: is clearing the history needed (to clear credentials?
# history -c 