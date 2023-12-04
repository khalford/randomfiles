#!/bin/bash

# Get user
username=$USER
if [ "$username" = root ]; then username=$SUDO_USER; fi

# Get data from github
curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/stfc/SCD-Openstack-Utils/contributors?per_page-100" | grep 'contributions\|login' | paste -d "" - - > ./SCD_Openstack_Utils_commits

# Format data
sed -i 's/"//g' ./SCD_Openstack_Utils_commits
sed -i 's/login: //g' ./SCD_Openstack_Utils_commits
sed -i 's/contributions: //g' ./SCD_Openstack_Utils_commits
sed -i 's/ //g' ./SCD_Openstack_Utils_commits
sed -i 's/,/, /g' ./SCD_Openstack_Utils_commits

# Add to MySql table each line
while read line; do
        commiter=$( awk -F', ' '{ print $1 }' <<< $line)
        no_commits=$( awk -F', ' '{ print $2 }' <<< $line)
        mysql -u"$username" -ppassword -e "INSERT INTO githubstats.scd_openstack_utils_commits (username, no_commits) VALUES ('${commiter}', '${no_commits}');"
done < ./SCD_Openstack_Utils_commits


# Get data from github
curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/stfc/st2-cloud-pack/contributors?per_page-100" | grep 'contributions\|login' | paste -d "" - - > ./st2_cloud_pack_commits

# Format data
sed -i 's/"//g' ./st2_cloud_pack_commit
sed -i 's/login: //g' ./st2_cloud_pack_commits
sed -i 's/contributions: //g' ./st2_cloud_pack_commits
sed -i 's/ //g' ./st2_cloud_pack_commits
sed -i 's/,/, /g' ./st2_cloud_pack_commits

# Add to MySql table each line
while read line; do
        commiter=$( awk -F', ' '{ print $1 }' <<< $line)
        no_commits=$( awk -F', ' '{ print $2 }' <<< $line)
        mysql -u"$username" -ppassword -e "INSERT INTO githubstats.st2_cloud_pack_commits (username, no_commits) VALUES ('${commiter}', '${no_commits}');"
done < ./st2_cloud_pack_commits
