#!/bin/bash
# ============================================
# get_bucket_info -get bucket information .
# ============================================
#
### BEGIN INIT INFO
# Provides: jefferson22alcantara@gmail.com         
### END INIT INFO
##Scritp Get information from ceph radosgw and create one json file with userid,acess and secret key 
#radosgw-admin metadata list bucket --pool .rgw.buckets >lista_buckets.txt
clearfile=`:>buckets.json`
buckets=`cat lista_buckets.txt |  sed "s,\[,,g;s,\,,,g;s,\",,g;s,\],,g" | awk '{ print $1 }' `
bucket_file="buckets.json"
echo "{" >>${bucket_file}
echo "\"id\": \"bucket_info\",">>${bucket_file}
for i in `echo $buckets`
{

       userid=`radosgw-admin bucket stats --bucket ${i} | grep owner | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
       access_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep access_key |sed 's,\",,g;s,\,,,g' | awk '{ print $2 }'`
        secret_key=`radosgw-admin user info --uid="$userid" | grep -A 2 "\{ \"user\"\: \"${userid}\"\,"  | grep secret_key| sed 's,\",,g;s,\,,,g;s,\],,g;s,\},,g' | awk '{ print $2 }'`
echo "\"${i}\": {\"access_key\": \"${access_key}\",\"secret_key\": \"${secret_key}\"}">>${bucket_file}
echo ",">>${bucket_file}

}

echo "}">>${bucket_file}
