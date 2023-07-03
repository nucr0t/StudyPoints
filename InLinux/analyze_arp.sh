#!/bin/bash

#The script to search for an abnormal number of ARP-queries.
#Commands builtin in shell(bash) - non user commands
#read - read one line [-a] - to array,  [-r] - escape backslash

LOG=$1
TOP=11  #TOP ip adresses with arp requests
IP_REGX='([[:digit:]]{1,3}\.+){3}([[:digit:]]){1,3}'


#Counting the number of events per minute. 
#Minute - containing the second with the most requests. Printing out the results.
events_counter () {
	sed -n $1\p $attacker | read -r -a numb
	if [ "${numb[0]}" -gt 2 ]; then
		ALL_MIN=
		minute=$(echo "${numb[1]}" | grep --only-matching --extended-regexp '[0-9]{2}T[0-9]{2}:[0-9]{2}')
		grep -E $minute $attacker > min.tmp
		while read -r -a amount; do
			(( ALL_MIN += ${amount[0]} ))
		done < min.tmp
		echo -e "\tHOST $(basename $attacker) made $ALL_MIN arp requests at $minute"
		#sed -n -i "s/${minute}/" "/g" $attacker #Delete used minutes
	fi
}


mkdir ./find
#Get source ip and timestamp
#OR MAYBE MAC ADDRESS?
cut --fields=2,3 --delimiter=, $LOG > ./temp_log.tmp
#Sort ip repeats
#OR MAYBE TIME SEQUNCE?
grep --only-matching --extended-regexp $IP_REGX ./temp_log.tmp | sort | uniq --count --repeated | sort --key=1nr > ./result_ip.tmp

#Counter sorting requests in one second
for (( i=1; i<TOP; i=i+1 )); do
	ip=$(sed --silent "${i}p" ./result_ip.tmp | grep --only-matching --extended-regexp $IP_REGX)
	grep --extended-regexp "${ip}\"" ./temp_log.tmp | cut --fields=1 --delimiter=, > ./time_$ip.tmp
	grep --only-matching --extended-regexp '[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}' ./time_$ip.tmp | sort \
| uniq --count --repeated | sort --key=1nr > ./find/$ip
done

set +m  #Enable monitor mode for lastpipe
shopt -s lastpipe  #Disable subshell for save var

#Events in one minute
for attacker in ./find/*; do
	events_counter 1
	events_counter 2
	events_counter 3
done
set -m

rm --recursive --force ./find/ ./*.tmp