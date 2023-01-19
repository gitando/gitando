#!/bin/bash

USER=""
HOST=""
PASS=""
PATH=/var/www/html

sshpass -p $PASS ssh $USER@$HOST

cd $PATH

touch 'came-saw-conquered.txt'

sudo -u systemusername OR --allow-root (see below)

# Export DB
wp db export dbname.sql --allow-root --all-tablespaces --add-drop-table
mysqldump -u wpuser -ppassword wpdatabase > copy-db-20150429.sql

# Arhive tar/zip
tar -cvf archive.tar ./
gzip archive.tar

# Transfer
cd /var/www/vhost/new-directory
# scp
scp your_new_username@new_host.com:/var/www/vhost/domain.com/archive.tar ./
# rsync
rsync -avz user@old-server.com:/var/www/vhost/domain.com/archive.tar ./
# 3. wegt
wget http://old-web-site.com/copy-db-20150429.sql
wget http://old-web-site.com/copy-test-conetix-com-au.tar

# Extract Archive
tar -xvf archive.tar

# Improt DB
wp --quiet db import dbname.sql
mysql -u username -p databasename < filename.sql

# Check if this helps with old wp-configs
wp core config --dbname=YOUR_DATABASE_NAME --dbuser=YOUR_DATABASE_USER --dbpass=YOUR_DATABASE_PASSWORD

# If new url
wp search-replace "http://old-url.com" "https://new-url.com"

# Cleanup
rm ./archive.tar
