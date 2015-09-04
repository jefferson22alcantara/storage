#!/bin/bash
#Script created to get informations from old cluster 
#ceph radosgw and create a new script to set up user on
#New cluster 
#-- recommendaded from ceph radosgw user acount  migrate 
#
#
##Run script get_info.sh on old ceph radosgw cluster  
##Run script create_users.sh  on new ceph radosgw cluster to create all users 

radosgw-admin metadata list user | egrep -v  "\]|\[" | sed 's/\,//g;s/\"//g' >lista_users.txt
create_users="create_users.sh"
for  i in `cat lista_users.txt`
{

 user=`radosgw-admin user info --uid="${i}"`
 userid=`echo ${user} | grep user_id | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
 displayname=`echo ${user} | grep display_name | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
 email="${userid}@business.com"
 #echo "userid=$userid"
 #echo "display=$displayname"
 #echo "email=${email}"
 access_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep access_key |sed 's,\",,g;s,\,,,g' | awk '{ print $2 }'`
 secret_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep secret_key| sed 's,\",,g;s,\,,,g;s,\],,g;s,\},,g' | awk '{ print $2 }'`
# echo "access_key=$access_key secret_key=$secret_key"
 echo "radosgw-admin user create --uid=${userid} --email=${email} --display-name=${displayname} --access-key=${access_key} --secret=${secret_key}" >>${create_users}
 subusers=`radosgw-admin user info --uid="${userid}" | grep -i "\{ \"id" | sed 's/{//g;s/,//g;s/\"//g' | awk '{ print $2 }' `
 	for sub in `echo $subusers`
	 {
		permission=`radosgw-admin user info --uid="${userid}" | egrep -A 1 "\{ \"id\"\: \"jmoura:teste\"" | grep permissions| sed 's,\",,g;s,\,,,g;s,},,g' | awk '{ print $2 }' | awk -F "-" '{ print $1 }'`
		#echo "--------------------------\n"
		#echo "subuser=$sub" >>${USER_INFO}
		#echo "permssion=$permission">>${USER_INFO}
		access_key=`radosgw-admin user info --uid="${userid}" | grep -A 2 "\{ \"user\"\: \"${sub}\"\,"  | grep access_key |sed 's,\",,g;s,\,,,g' | awk '{ print $2 }'`
		secret_key=`radosgw-admin user info --uid="${userid}" | grep -A 2 "\{ \"user\"\: \"${sub}\"\,"  | grep secret_key| sed 's,\",,g;s,\,,,g;s,\],,g;s,\},,g' | awk '{ print $2 }'`
		#echo "access_key=$access_key secret_key=$secret_key">>${USER_INFO}

		if [ `echo ${sub} | grep -i swift` ]; then
			   if [ -z "${secret_key}" ];then
				echo "radosgw-admin subuser create  --uid ${userid}  --subuser ${sub} --access ${permission}  " >>${create_users}
			   else
		  echo "radosgw-admin subuser create  --uid ${userid}  --subuser ${sub} --access ${permission} --secret ${secret_key} --key-type swift " >>${create_users}
			   fi
		else
			if [ -z "${secret_key}"  ];then
		  echo "radosgw-admin subuser create  --uid ${userid}  --subuser ${sub} --access ${permission}  " >>${create_users}
			else
		echo "radosgw-admin subuser create  --uid ${userid}  --subuser ${sub} --access ${permission} --secret ${secret_key} --key-type s3 " >>${create_users}
			fi
		fi
	}
#echo "radosgw-admin subuser create  --uid ${userid}  --subuser usr_replication --access ${permission} --gen-access-key --access-key=${access_key} --key-type s3 " >>
}
