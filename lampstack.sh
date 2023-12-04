#!/bin/bash

# Get username
# If script run as  get  caller username
username=$USER
if [ "$username" = root ]; then username=$SUDO_USER; fi

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

# Assign variables
database_name="githubstats"
passwd="password"

# Create the MySQL database
mysql -e "CREATE DATABASE ${database_name};"

# Create the user in MySQL
mysql -e "CREATE USER '${username}'@'%' IDENTIFIED BY '$passwd';"

# Grant the user permissions to the database
mysql -e "GRANT ALL ON ${database_name}.* TO '${username}'@'%';"

# Assign the password
password="password"

# Create the table in the database
mysql -u $username -p$password -e "CREATE TABLE ${database_name}.scd_openstack_utils_commits (
user_id INT AUTO_INCREMENT,
username VARCHAR(255),
no_commits INT,
PRIMARY KEY(user_id)
);"

# Create the table in the database
mysql -u $username -p$password -e "CREATE TABLE ${database_name}.st2_cloud_pack_commits (
user_id INT AUTO_INCREMENT,
username VARCHAR(255),
no_commits INT,
PRIMARY KEY(user_id)
);"

# Install grafana
apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor |  tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" |  tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana


