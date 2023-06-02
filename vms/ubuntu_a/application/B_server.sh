echo "create network bridge between second (192.168.22.1) and first (192.168.22.10) servers
....
...."
ip a
ip link add macvlan1 link eth0 type macvlan mode bridge
ip address add dev macvlan1 192.168.22.1/24
ip link set macvlan1 up
ip a
echo "create network bridge between second (192.168.9.1) and third (192.168.9.100) servers
....
...."
ip link add macvlan2 link eth0 type macvlan mode bridge
ip address add dev macvlan2 192.168.9.1/24
ip link set macvlan2 up
ip a
echo "check connection with the third server
....
...."
ping 192.168.9.100
echo "check connection with the first server
....
...."
ping 192.168.22.10
echo "tcp connection between second (192.168.22.1) and first (192.168.22.10) servers
....
...."
apk add tcpdump
tcpdump -i macvlan1
echo "tcp connection between second(192.168.9.1) and third (192.168.9.100) servers
....
...."
tcpdump -i macvlan2
echo "check the routes for second server
....
...."
ip route
echo "create tcp connection to listen to port 5000
....
...."
tcpdump 'port 5000'