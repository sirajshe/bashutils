PROPS_FILE=props.$$.tmp
echo "$1" > $PROPS_FILE
echo "$2" >> $PROPS_FILE
echo "$3" >> $PROPS_FILE
echo $4 >> $PROPS_FILE
echo $5 >> $PROPS_FILE
echo $6 >> $PROPS_FILE

. ./$PROPS_FILE

min=$LAST_N_MINS

#LAST_N_MINS=10
#URL_LIST
#SERVER_ID

cd /var/opt/ORCLemaas/user_projects/domains/base_domain/servers/$SERVER_ID/logs

if [ ! -d "/scratch/em.heapdumps" ]; then
	mkdir /scratch/em.heapdumps
fi

while read url
do
  URL_ID=`echo $url | awk -F'=' '{print $1}'`
  URL_TO_LOOKUP=`echo $url | sed -e 's/\${[a-zA-Z]*}/\.*/g' -e 's/{API_PREFIX}//g' | awk -F"$URL_ID=" '{print $2}'`

echo URL_ID=$URL_ID
echo URL_TO_LOOKUP=$URL_TO_LOOKUP

x=$(($min*60))   #here we take 2 mins as example
#x=10

find . -name "access.log*" -mmin -${min} -exec grep -l "$URL_TO_LOOKUP" {} \; | sort > /tmp/files.$$
#last_file=`tail -1 /tmp/files.$$`
cat /tmp/files.$$

#echo last_file=$last_file

# this line get the timestamp in seconds of last line of your logfile
#last=$(tail -n1 $last_file | awk -F',' '{ gsub(/-/,"-",$1); sub(/:/,":",$1); "date +%s -d \""$1"\""|getline d; print d;}' )

#echo $last
#exit 0
#last=`date -u "+%s"`

#this awk will give you lines you needs:
#rm /tmp/access_log_test_duration.$$ 2>/dev/null

while read file
do
    #awk -F',' -v last=$last -v x=$x '{ gsub(/-/,"-",$1); sub(/:/,":",$1); "date +%s -d \""$1"\""|getline d; if (last-d<=x)print $0 }' $file | grep "$URL_TO_LOOKUP" >> /scratch/em.heapdumps/${SERVER_ID}.${URL_ID}.access.log
    grep "$URL_TO_LOOKUP" $file >> /scratch/em.heapdumps/${SERVER_ID}.${URL_ID}.access.log
done < /tmp/files.$$

    grep "$URL_TO_LOOKUP" /scratch/em.heapdumps/${SERVER_ID}.${URL_ID}.access.log | awk '{print $5}' > /scratch/em.heapdumps/${SERVER_ID}.${URL_ID}.ecids
done < $URL_LIST

# GET the url list and fetch the ECIDs for each of the URLs in the list. - Main requirment since we need this for finding SQLIDs.

# Summary can be left as is and URL based summary can be generated if there is a need for it.
# This whole summary is not an imp requireent right now.
#sh access_log_summary.sh /tmp/access_log_test_duration.$$ > /tmp/access_log_summary.out

rm /tmp/files.$$
