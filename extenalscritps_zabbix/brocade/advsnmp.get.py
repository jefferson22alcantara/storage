#!/usr/bin/python
import os
import sys

def main(argv1, argv2, argv3):
	oid = os.popen("/usr/bin/snmpwalk -u admin -v 3 -n VF:%s %s:161 %s 2>/dev/null" % (argv1, argv2, argv3) ).read()
	#SNMP_INDEX = oid.split("=")[0].split(".")[-1]
	SNMP_VALUE = oid.split("=")[1].split(".")[0].split(":")[1].replace(" ", "")
	SNMP_TYPE = oid.split("=")[1].split(".")[0].split(":")[0].replace(" ", "")
	#if SNMP_TYPE == "INTEGER":
	#	print(str(SNMP_VALUE).split('\n')[0])

        #if SNMP_TYPE == "Hex-STRING":
        print(str(SNMP_VALUE).replace(" ", "").split('\n')[0])
	#else:
	#	print(str(SNMP_VALUE).split('\n')[0])
if __name__ == "__main__":
   main(sys.argv[2], sys.argv[1], sys.argv[3])
