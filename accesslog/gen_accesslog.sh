i=0
sec=59
while [ $i -lt 100 ];
do
i=`expr $i + 1`
sec=`expr $sec - 1`
min=`expr $min + 1`
hr=`expr $hr + 1`
if [ $sec -lt 09 ]; then
	sec=59
fi
if [ $min -gt 59 ]; then
	min=00
fi
if [ $hr -gt 59 ]; then
	hr=01
fi

echo "111.222.111.1  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempnow     200  0.2  Mozilla/5.0" >> /tmp/access.log
echo "111.222.111.2  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempnow     200  0.35  Mozilla/5.0" >> /tmp/access.log
echo "111.222.111.3  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempdaily     200  0.38 Mozilla/5.0" >> /tmp/access.log
echo "111.222.111.4  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempdaily     200  0.49  Chrome/xx" >> /tmp/access.log
echo "111.222.111.5  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempweekly     200  0.64  Chrome/xx" >> /tmp/access.log
echo "111.222.111.6  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempweekly     200  0.79  Chrome/xx" >> /tmp/access.log
echo "111.222.111.7  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettemplocal     200  0.98  Mozilla/5.0" >> /tmp/access.log
echo "111.222.111.8  2020-03-01T$hr:$min:$sec.941Z  GET   /weather/gettempmonthly     200  1.20  Mozilla/5.0" >> /tmp/access.log
done
