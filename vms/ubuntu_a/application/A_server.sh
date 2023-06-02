#! /bin/bash
# a script to create the second virtual machine
echo "create network bridge between first (192.168.22.10) and second (192.168.22.1) servers
....
...."
ip a
ip link add macvlan1 link eth0 type macvlan mode bridge
ip address add dev macvlan1 192.168.22.10/24
ip link set macvlan1 up
ip a
echo "create tcp connection between first and second servers
....
...."
apk add tcpdump
tcpdump
echo "check connection with the second server
....
...."
ping 192.168.22.1
echo "check the routes for first server
....
...."
ip route
echo "tcp connection between first(192.168.22.10) and third (192.168.9.100) servers
....
...."
tcpdump
echo "create sub network with third server by routing
....
...."
ip route add 192.168.9.0/24 via 192.168.22.1
echo "check connect with the third server (192.168.9.100)
....
...."
ping 192.168.9.100
echo "create a web server on port 5000 with third server as a client
....
...."
pip install flask
mkdir myapp
cd myapp
echo "web-server configration with requests: GET, PUT, POST
..load app.py from the File VM_A file or open the A_bash file and look at the end of it..
...."
vim app.py
python3 app.py

"""
from crypt import methods
from flask import Flask

app = Flask(__name__)

@app.route("/", methods=['GET'])
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/", methods=['PUT'])
def hello_world_put():
    return "<p>Hello, World!</p>"

@app.route("/", methods=['POST'])
def hello_world_post():
    return "<p>Hello, World!</p>"

app.run(host='0.0.0.0', port=5000)
"""