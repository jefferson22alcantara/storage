#!/usr/bin/python
import os
import sys

def main(argv1, argv2):
	oid = os.popen("/usr/bin/snmpwalk -u admin -v 3 -n VF:%s %s IF-MIB::ifDescr"% (argv1, argv2)).read()
	oid_list = [line for line in oid.split('\n') if line.strip() != '']
	print(" { \"data\":[")
	last_line = oid_list[-1]
	for i in oid_list:
		SNMP_INDEX = i.split("=")[0].split(".")[1].replace(" ", "")
		SNMP_VALUE = i.split("=")[1].split(".")[0].split(":")[1]
		if i != last_line:
			print("{ \"{#SNMPINDEX}\":\"%s\",\"{#SNMPVALUE}\":\"%s\"   },"%(SNMP_INDEX,SNMP_VALUE))
		else:
			print("{ \"{#SNMPINDEX}\":\"%s\",\"{#SNMPVALUE}\":\"%s\"   }"%(SNMP_INDEX,SNMP_VALUE))
	print("  ]}")
if __name__ == "__main__":
   main(sys.argv[2], sys.argv[1])