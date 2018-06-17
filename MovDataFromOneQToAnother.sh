#!/usr/bin/ksh
# ABC Project: Copying messages from one queue to another Queue
# Updated: 1/25/2018
#      by: Pan Dhoni
# Details:
# Script will run using cron                                                        
# ----------------------------------------------------------------------------------------------- 

# ############################################################################################## #
# Main: Setup variables, Reading Segments from File & moving data at corresponding queues        #
# ############################################################################################## #


# Required Segments file

fileSegName=/MQHA/scripts/File.dat

current_time=$(date "+%Y-%m-%d-%H-%M-%S")
# Define Variable: We can set Broker Name dynamically from envirnment, here we have assigned value to variable

QM1=QM_TEST

#logfile=/home/wmbadm/log/DBReplay.alog
# Reading data from file
while read -r line
do
	segNames="$line"
	curdepth1="$(echo "dis ql(ABC.DEF.U."$segNames".XYZ.DBERROR) CURDEPTH" | runmqsc $QM1| grep 'CURDEPTH('| tr '(' ' '| tr ')' ' '|awk '{print $4}')"

	if [[ "$curdepth1" > "0" ]]; then
		dmpmqmsg -m $QM1 -I ABC.DEF.U."$segNames".XYZ.DBERROR -o ABC.DEF.U."$segNames".XYZ.REPLAY
              echo ABC.DEF.U."$segNames".XYZ.DBERROR "|" $curdepth1 "|" $QM1 "|" $current_time >> /ABC/ABC.alog
	fi

done < "$fileSegName"

#End Script