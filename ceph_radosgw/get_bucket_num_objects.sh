#!/bin/bash
##Script to get num of object per bucket and print on num_objetos.tx file 
##run this script inside radosgw server 
clear=`:>num_objetos.txt`
buckets=`cat lista_buckets.txt |  sed "s,\[,,g;s,\,,,g;s,\",,g;s,\],,g" | awk '{ print $1 }' `

for i in `echo $buckets`
{
num_obj=`radosgw-admin bucket stats --bucket ${i} | grep num_objects | sed "s/{//g;s/,//g;s/\"//g;s/}//g" | tail -1 | awk '{ print $2 }'`
echo "bucket=${i}" >>num_objetos.txt
echo "objetos=${num_obj}" >>num_objetos.txt
#if [ -z "${num_obj}" ]  ; then

#echo "bucket=${i} , nao tem 0 objetos " >>num_objetos.txt
#  else
#	if [ "${num_obj}" -ge 1000 ]; then
#
#	echo "o bucket ${i} tem mais de 1000 objetos num_objetos=${num_obj}" >>num_objetos.txt
#
#	fi
#fi
 }
