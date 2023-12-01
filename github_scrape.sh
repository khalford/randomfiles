#!/bin/bash

# Get user
username=$USER
if [ "$username" = root ]; then username=$SUDO_USER; fi

# Get data from github
curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/stfc/SCD-Openstack-Utils/contributors?per_page-100" | grep 'contributions\|login' | paste -d "" - - > ./contributor_commits

# Format data
sed -i 's/"//g' ./contributor_commits
sed -i 's/login: //g' ./contributor_commits
sed -i 's/contributions: //g' ./contributor_commits
sed -i 's/ //g' ./contributor_commits
sed -i 's/,/, /g' ./contributor_commits

# Add to MySql table each line
while read line; do
	commiter=$( cut -d ", " -f 1 )
	no_commits=$( cut -d ", " -f 2 )
	mysql -u$username -ppassword -e "INSERT INTO GitHubStats.commit_stats (username, no_commits) VALUES (${comitter}, ${no_commits});"done < ./contributor_commits
