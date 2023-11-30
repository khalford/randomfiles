#!/bin/bash

# Get username
# If script run as sudo get sudo caller username
username=$USER
if [ "$username" = root ]; then username=$SUDO_USER; fi
export $username

# Install Apache2
apt update
apt install apache2 -y
echo "Webserer running on $( curl ifconfig.me ) default port is 80."

# Install MySQL
apt install mysql-server -y

# Install PHP and modules
apt install php libapache2-mod-php php-mysql -y

# Assigning the domain name
domain_name=$username

# Creating the Virtual Host
mkdir /var/www/$domain_name
chown -R $username:$username /var/www/$domain_name
echo "
<VirtualHost *:80>
    ServerName $domain_name
    ServerAlias $domain_name
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/$domain_name
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/${domain_name}.conf

# Configuring Apache2 to use the new domain
a2ensite $domain_name
a2dissite 000-default
systemctl reload apache2

# Editing the index.html page and moving it
sed -i -e "s/domain_name/${domain_name}/g" ./index.html
cp ./index.html /var/www/${domain_name}/index.html

# Editing the stats.php page and moving it
sed -i -e "s/<database_name>/$database_name/g" ./stats.php
sed -i -e "s/<username>/$username/g" ./stats.php
sed -i -e "s/<password>/"password"/g" ./stats.php
cp ./stats.php /var/www/${domain_name}/stats.php

# Call mysql.sh to do mysql things
bash ./mysql.sh

echo "Done. Check $( curl ifconfig.me )/stats.php"
