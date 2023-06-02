echo "create network bridge between third (192.168.9.100) and second (192.168.9.1) servers
....
...."
ip a
ip link add macvlan1 link eth0 macvlan mode bridge
ip address add dev macvlan1 192.168.9.100/24
ip link set macvlan1 up
ip a
echo "create tcp connection the third and second servers
....
...."
apk add tcpdump
tcpdump
echo "check connection with the second server
....
...."
ping 192.168.9.1
echo "check the routes for second server
....
...."
ip route
echo "create sub netwoek with first server by routing
....
...."
ip route add 192.168.22.0/24 via 192.168.9.1
echo "check connection with the first server
....
...."
ping 192.168.22.10
echo "create tcp connection the third and first servers
....
...."
tcpdump
echo "send requests to the web-server on port 5000
....
...."
curl 'http://192.168.22.10:5000'
curl -X POST 'http://192.168.22.10:5000'
curl -X PUT 'http://192.168.22.10:5000'