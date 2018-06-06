#!/bin/ksh

########################################################################
# stopFlowScript.sh
#
# Pan Dhoni- This script will stop the message flow on particular Execution Group.
# 
# Thank you
# 
########################################################################

#Receive .txt file which has Application and Exec names

file=$1
BROKER=BRK
while read line
do
 
appName=`echo $line | awk '{print $1}'`;
egrp=`echo $line | awk '{print $2}'`;

mqsistopmsgflow $BROKER -e $egrp -k $appName

done <"$file"