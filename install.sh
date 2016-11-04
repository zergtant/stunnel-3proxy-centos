#!/bin/sh

#ulimit -HSn 65536
#ulimit -n
#checkversion
#openssl version
#stunnel -version
#download 
wget https://www.stunnel.org/downloads/stunnel-5.36.tar.gz --no-check-certificate
wget https://github.com/z3APA3A/3proxy/archive/3proxy-0.8.7.tar.gz
tar zxvf stunnel-5.36.tar.gz
tar zxvf 3proxy-0.8.7.tar.gz
yum install openssl openssl-devel
#yum install openssl*


#3proxy
cd 3proxy-3proxy-0.8.7
make -f Makefile.Linux
make -f Makefile.Linux install
cat > /etc/3proxy.cfg << EOF
internal 127.0.0.1
auth none
socks -p22222
EOF
#3proxy /etc/3proxy.cfg &


cd ../stunnel-5.36
#stunnel
./configure
make
make install
cat > /usr/local/etc/stunnel/stunnel.conf << EOF
output = /usr/local/etc/stunnel/stunnel.log
cert = /usr/local/etc/stunnel/stunnel.pem
pid = /usr/local/etc/stunnel/stunnel.pid

[proxy]
accept  = 443
connect = 22222
EOF
# linux must setting pid
#/usr/local/bin/stunnel

#ps -ef | grep stunnel
# add auto start after reboot
cat > /etc/rc.local << EOF

/usr/local/bin/stunnel
/usr/local/bin/3proxy /etc/3proxy.cfg &

EOF

#add iptables rule 
#iptables -I INPUT -p tcp --dport 443 -j ACCEPT
#iptables -L -n
#service iptables save
#check port
#netstat -ntlp

#make cert
#openssl gendh 2048 >> stunnel.pem
#http://www.stunnel.org/howto.html
