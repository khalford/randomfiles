#!/bin/bash

# Assign variables
database_name="GitHubStats"
passwd="password"

# Create the MySQL database
mysql -e "CREATE DATABASE ${database_name};"

# Create the user in MySQL
mysql -e "CREATE USER '${username}'@'%' IDENTIFIED BY '$passwd';"

# Grant the user permissions to the database
mysql -e "GRANT ALL ON ${database_name}.* TO '${username}'@'%';"

# Assign table name
table_name="commit_stats"

# Assign the password
password="password"

# Create the table in the database
mysql -u $username -p$password -e "CREATE TABLE ${database_name}.${table_name} (
user_id INT AUTO_INCREMENT,
username VARCHAR(255),
no_commits INT,
PRIMARY KEY(user_id)
);"
