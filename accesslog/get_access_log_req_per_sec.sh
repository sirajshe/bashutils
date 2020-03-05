CLIENT_IP=10.242.86.62
URL=/apigw/fwd/serviceapi/entityModel/data/tags

echo "=== Requests every second and their response stats ==="
find -name "access.log*" -mmin -2 -exec grep "^$CLIENT_IP" {} \; | grep "$URL" | awk -v col=":" '{a[$2col$3col$8]++;} END{for(i in a){print i" "a[i]}}' | sort -n | tee /tmp/axs.log.1
#echo "=== Response status count ==="
#find -name "access.log*" -mmin -2 -exec grep "^$CLIENT_IP" {} \; | grep "$URL" | awk -v col=":" '{a[$2col$3]++;} END{for(i in a){print i" "a[i]}}' | sort -n | tee /tmp/axs.log.1

echo "=== Total ==="
cat /tmp/axs.log.1| awk '{x+=$NF;}END{print x}'


