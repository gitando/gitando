#!/usr/bin/env bash

PHP=
USER_NAME=

while [ -n "$1" ] ; do
    case $1 in
    -u | --user* )
        shift
        USER_NAME=$1
        ;;
    -p | --php* )
        shift
        PHP=$1
        ;;
    -dbr | --dbroot )
        shift
        DBROOT=$1
        ;;
    * )
        echo "ERROR: Unknown option: $1"
        exit -1
        ;;
    esac
    shift
done

sudo rm /etc/php/$PHP/fpm/pool.d/$USER_NAME.conf
sudo service php$PHP-fpm restart

sudo userdel -r $USER_NAME
sudo rm -rf /home/$USER_NAME

# Drop user first, then database, otherwise user won't get deleted
/usr/bin/mysql -u gitando -p$DBROOT <<EOF
DROP USER '$USER_NAME'@'localhost';
DROP DATABASE $USER_NAME;
EOF

sudo unlink /etc/nginx/sites-enabled/$USER_NAME.conf
sudo unlink /etc/nginx/sites-available/$USER_NAME.conf
sudo systemctl restart nginx.service