#!/usr/bin/ksh
# ----------------------------------------------------------------------- 
# ABC Project: Segments Reporting Scripting 
# Updated: 3/11/2018
#      by: Pan Dhoni
# Details: Script will generate Report for ABC. It                         
# will have Total input Segments count and Error count for Subscriptions.                                                         
# ----------------------------------------------------------------------- 

# ##################################################################### #
# Main: Setup variables, grep Segments, and build Report 	         #
# ##################################################################### #

# Variables for File, Date & Time

#filename=${PUB_LOG_FILE#*.log}
FileSegName=/folder1/folder1/ABC.dat
current_time=$(date "+%Y-%m-%d-%H-%M-%S")
#current_date=$(date "+%Y-%m-%d")
prev_date=`TZ=bb24 date +%Y"-"%m"-"%d`

PUB_LOG_FILE=/folder1/folder1/ABC_XYZ.log"$prev_date"

status1="|SUCCESS|"
status2="|FAILURE|"
#Report Header
echo "Head1|Head2|Head3|Head4|Head5|Head6|Head7" >> /folder1/folder1/Report.$current_time

while read -r line
do
    segName="$line"
    count="$(grep -c "$segName" "$PUB_LOG_FILE")"
    succCount1="$(grep $status1 /folder1/folder1/*$segName*/*.log"$prev_date"|wc -l)"
    succCount2="$(grep $status1 /folder1/folder1/*$segName*/*.log"$prev_date"|grep "|O|" |wc -l)"
    succCount="$(($succCount1-$succCount2))"
    errCount1="$(grep $status2 /folder1/folder1/*$segName*/*.log"$prev_date"|wc -l)"
    errCount2="$(grep $status2 /folder1/folder1/*$segName*/*.log"$prev_date"|grep "|O|" | wc -l)"
    errCount="$(($errCount1-$errCount2))"
    
    echo $prev_date"|"$line"|"$count"|"$succCount"|"$succCount2"|"$errCount"|"$errCount2 >> /folder1/folder1/Report.$current_time

    DEST_LOG_FILE=/folder1/folder1/*$segName*/*$segName*.log"$prev_date"
    chmod 755 $DEST_LOG_FILE

if [[ "$segName" = "CBA" ]]; then
		echo "1i\nFLOW_NAME|DATE|TIME|APP_NAME|FLOW_STATUS|STATUS|DURATION|MSG_ID|HOST|EXEC_NAME|SEG_NAME/ERROR REASON|FLAG|P1|P2 \n.\nwq" | ex -s $DEST_LOG_FILE
else
		echo "1i\n|FLOW_NAME|DATE|TIME|APP_NAME|FLOW_STATUS|STATUS|DURATION|MSG_ID|HOST|EXEC_NAME|SEG_NAME/ERROR REASON|FLAG|P1|P2|P3|P4 \n.\nwq" | ex -s $DEST_LOG_FILE
fi

done < "$FileSegName"

    chmod 755 $PUB_LOG_FILE
    echo "1i\nFLOW_NAME|DATE|TIME|APP_NAME|SEG_NAME \n.\nwq" | ex -s $PUB_LOG_FILE
#End Script