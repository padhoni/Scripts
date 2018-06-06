#!/usr/bin/sh
#  -----------------------------------------------------------------------------------
#  Modification Log:
#  Author            Date          Description
#  ---------------   -----------   ---------------------------------------------------
#  Pan Dhoni        06/05/2018     Initial Draft
#  -----------------------------------------------------------------------------------
#
# Sourcing profile to pick up the paths etc...

LOG_FILE=/folder/folder/mqsireload_IIBXXX.alog
EMAIL='abc@gmail.com'
ACTIVEQMGRS="/folder/folder/.activeqm"
hostname=`uname -n`

ReloadActiveBrokers(){
`mqsilist|grep "active"|awk '{print substr($4,2,8)}' > $ACTIVEQMGRS`

while read line
do
{
print -- "--------------------------------------------------------"
print "`date`: Initiating mqsireload for IIB $line..." 
mqsireload $line
} 2>&1 | alog -q -f $LOG_FILE -s 51200
print "See $LOG_FILE and /folder/user.log on server $hostname for details" | mail -s "$hostname: $line - mqsireload completed" $EMAIL
done < "$ACTIVEQMGRS"
}

case $hostname in
        host1  ) ReloadActiveBrokers
                                 ;;
esac

exit
