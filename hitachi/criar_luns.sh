raidcom -login maintenance raid-mainte

Host Group Creation / WWN Nickname

raidcom add host_grp -port CL2-E-1 -host_grp_name test-it
raidcom add host_grp -port CL1-E-1 -host_grp_name test-it
raidcom modify host_grp -port CL1-E-1 -host_mode 3 -host_mode_opt 12 40 (HPUX and proper modes)
raidcom modify host_grp -port CL2-E-1 -host_mode 3 -host_mode_opt 12 40
raidcom add hba_wwn -port CL1-E-1 -hba_wwn 10000000c9537bb2
raidcom add hba_wwn -port CL2-E-1 -hba_wwn 10000000c9537d06
raidcom set hba_wwn -port CL1-E-1 -hba_wwn 10000000c9537bb2 -wwn_nickname testhpux1
raidcom set hba_wwn -port CL2-E-1 -hba_wwn 10000000c9537d06 -wwn_nickname testhpux1
Create Ldevs and assign to proper CU and Pool

Create an ldev in HDT Pool 0, ldev=00:40:00 , capacity=30GB in blocks

raidcom add ldev -pool_id 0 -ldev_id 0x4000 -capacity 62914560
Create an ldev in HDT Pool 0, ldev=00:46:47 , capacity=300GB in blocks

raidcom add ldev -pool_id 0 -ldev_id 0x4647 -capacity 629145600
Add an ldev to a hostgroup

raidcom add lun -port CL1-E-1 -lun_id 0003 -ldev_id 0x4647
raidcom add lun -port CL2-E-1 -lun_id 0003 -ldev_id 0x4647
raidcom -logout
