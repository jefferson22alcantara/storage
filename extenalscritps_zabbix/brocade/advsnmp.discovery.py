#!/usr/bin/python
import os
import sys

def main(argv1, argv2, argv3):
	try:
		oid = os.popen("/usr/bin/snmpwalk -u admin -v 3 -n VF:%s %s:161 %s 2>/dev/null" % (argv1, argv2, argv3) ).read()
		oid_list = [line for line in oid.split('\n') if line.strip() != '']
		print(" { \"data\":[")
		last_line = oid_list[-1]
		for i in oid_list:
			SNMP_INDEX = i.split("=")[0].split(".")[-1].replace(" ", "")
			SNMP_VALUE = i.split("=")[1].split(".")[0].split(":")[1]
			if i != last_line:
				print("{ \"{#ADVSNMPINDEX2}\":\"%s\",\"{#ADVSNMPVALUE}\":%s },"%(SNMP_INDEX,SNMP_VALUE))
			else:
				print("{ \"{#ADVSNMPINDEX2}\":\"%s\",\"{#ADVSNMPVALUE}\":%s }"%(SNMP_INDEX,SNMP_VALUE))
		print("  ]}")
	except:
		pass
if __name__ == "__main__":
   main(sys.argv[2], sys.argv[1], sys.argv[3])
