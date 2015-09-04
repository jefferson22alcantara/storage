#!/bin/bash
##Script to generate json file with list with  bucket owner information 
##format from output json file "bucket_name": {"user_owner": "user"}
radosgw-admin metadata list bucket --pool .rgw.buckets >lista_buckets.txt
clearfile=`:>buckets_owner.json`
buckets=`cat lista_buckets.txt |  sed "s,\[,,g;s,\,,,g;s,\",,g;s,\],,g" | awk '{ print $1 }' `
buckets_owner_file="buckets_owner.json"
echo "{" >>${buckets_owner_file}
echo "\"id\": \"buckets_owner\",">>${buckets_owner_file}
count=`cat lista_buckets.txt | wc -l`
for i in `echo $buckets`
{

      # userid=`radosgw-admin bucket stats --bucket ${i} | grep owner | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
#echo "\"${i}\": {\"user_owner\": \"${userid}\"}">>${buckets_owner_file}
         userid=`radosgw-admin bucket stats --bucket ${i} | grep owner | sed "s/{//g;s/,//g;s/\"//g" | awk '{ print $2 }'`
         echo "\"${i}\": {\"user_owner\": \"${userid}\"}">>${buckets_owner_file}
if [ $count -gt 1  ]; then
       echo "," >>${buckets_owner_file}
fi
count=$((count - 1 ))
}

echo "}">>${buckets_owner_file}
