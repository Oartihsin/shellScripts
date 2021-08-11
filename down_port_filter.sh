#!/bin/bash
for i in `cat /home/nishit.r/ports_id_0908.txt`  #file where all the port ids are present
do
        output1="$(neutron port-show "${i}" | grep device_id )" #greping device id line
        temp1=$(echo $output1 | cut -f3 -d\|)                   #cutting down only the device id from the output
        deviceid=`echo $temp1 | sed 's/ *$//g'`                 #deleting leading spaces

        output2="$(neutron port-show "${i}" | grep status )"    #greping port status line
        temp2=$(echo $output2 | cut -f3 -d\|)                   #cutting down only the port status from the output
        portstatus=`echo $temp2 | sed 's/ *$//g'`               #deleting leading spaces

        if [ -z "${deviceid}" ] && [ "${portstatus}" = "DOWN" ]; then  #condition for stale port
                filteredOutput="$(neutron port-show -c binding:host_id -c device_id -c id -c status -c fixed_ips "${i}" )"
                echo "${filteredOutput}" >> ports_status_0908.txt
        fi

done
