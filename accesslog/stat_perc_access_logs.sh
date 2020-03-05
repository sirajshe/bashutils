RESULT_FILE="$1"
#set -x
cat $RESULT_FILE > /tmp/ac.1

RESULT_FILE=/tmp/ac.1

TOTAL_REQ=`cat $RESULT_FILE | grep -v '^#' | wc -l`

echo "=== `date`: Host: $HOSTNAME ==="
echo Total Requests : $TOTAL_REQ

awk -v treq="$TOTAL_REQ" '{
			if (match($(NF-3),"[0-9][0-9][0-9]") )
			a[$(NF-3)]++;
                        #print  "1 min -  5 mins , " a[i] " ("int(a[i]*100/treq)"%)";
} END{for (i in a) print i " - " a[i]  " ("int(a[i]*100/treq)"%)"}' $RESULT_FILE

#rm /tmp/ac.1
