
RESULT_FILE=$1
mins=$2

#set -x

bname=`basename $RESULT_FILE`
dname=`dirname $RESULT_FILE`

find $dname -name "access.log*" -mmin -$2 -exec cat {} \; > /tmp/ac.1
#exit 0
RESULT_FILE=/tmp/ac.1

TOTAL_REQ=`cat $RESULT_FILE | grep -v elapsed | wc -l`

echo "=== `date`: Host: $HOSTNAME ==="
echo Total Requests : $TOTAL_REQ
echo === Request status trend - Last $2 mins ===
awk -v treq="$TOTAL_REQ" '{
                        if (match($7,"[0-9][0-9][0-9]") )
                        a[$7]++;
                        #print  "1 min -  5 mins , " a[i] " ("int(a[i]*100/treq)"%)";
} END{for (i in a) print i " - " a[i]  " ("int(a[i]*100/treq)"%)"}' $RESULT_FILE

echo === Response time trend - Last $2 mins ===
awk -v treq="$TOTAL_REQ" '{
	#print $NF
        if ($(NF-1) < 0.5)
                a[1]++;
        else if($(NF-1) >= 0.5 && $(NF-1) < 1)
                a[2]++;
        else if($(NF-1) >= 1 && $(NF-1) < 2)
                a[3]++;
        else if($(NF-1) >= 2 && $(NF-1) < 5)
                a[4]++;
        else if($(NF-1) >= 5 && $(NF-1) < 10)
                a[5]++;
        else if($(NF-1) >= 10 && $(NF-1) < 60)
                a[6]++;
        else if($(NF-1) >= 60 && $(NF-1) < 300)
                a[7]++;
        else if($(NF-1) >= 300)
                a[8]++;
        } END {
	for (i=1;i<=8;i++) {
		if (a[i] == "")
			a[i]=0;
                if (i==1)
                        print  "0 - 500 ms , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==2)
                        print  "500 ms - 1 sec , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==3)
                        print  "1 sec - 2 secs , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==4)
                        print  "2 secs - 5 secs , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==5)
                        print  "5 secs - 10 secs , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==6)
                        print  "10 secs - 60 secs , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==7)
                        print  "1 min -  5 mins , " a[i] " ("int(a[i]*100/treq)"%)";
                if (i==8)
                        print  "> 5 mins , " a[i] " ("int(a[i]*100/treq)"%)";
                }} ' $RESULT_FILE

#exit 0
#set -x
csv=$RESULT_FILE
cat $csv | grep -v '^#' | awk '{print $NF}' | grep "[0-9]" | sort -n > /tmp/csv.$$
n=`cat /tmp/csv.$$ | wc -l`
p90=`echo "$n * 0.9" | bc | awk -F'.' '{print $1}'`

if [ -z "$p90" -o "$p90" == "0" ]; then
	p90=1
fi

PERCENTILE_90=`awk 'NR=='$p90 /tmp/csv.$$`

echo PERCENTILE_90=$PERCENTILE_90

rm /tmp/csv.$$ 
#/tmp/ac.1

