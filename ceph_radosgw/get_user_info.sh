#!/bin/bash
##Script to generate  json file with radosgw user information 
##Output format from user_info.json is a list "user": {"access_key": "XXXXXX","secret_key": "XXXX"}
radosgw-admin metadata list user | egrep -v  "\]|\[" | sed 's/\,//g;s/\"//g' >lista_users.txt
clear=`:>user_info.json`
user_info_file="user_info.json"
echo "{" >>${user_info_file}
echo "\"id\": \"user_info\",">>${user_info_file}
count=`cat lista_users.txt | wc -l`
for  i in `cat lista_users.txt`
{

 user=`radosgw-admin user info --uid="${i}"`
 userid=`echo ${user} | grep user_id | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
 displayname=`echo ${user} | grep display_name | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
 email="${userid}@busines.com"
 access_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep access_key |sed 's,\",,g;s,\,,,g' | awk '{ print $2 }'`
 secret_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep secret_key| sed 's,\",,g;s,\,,,g;s,\],,g;s,\},,g' | awk '{ print $2 }'`

echo "\"${i}\": {\"access_key\": \"${access_key}\",\"secret_key\": \"${secret_key}\"}">>${user_info_file}
if [ $count -gt 1  ]; then
       echo "," >>${user_info_file}
fi
count=$((count - 1 ))
}



echo "}">>${user_info_file}
