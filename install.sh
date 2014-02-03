#!/bin/sh
#download 
wget https://www.stunnel.org/downloads/stunnel-4.56.tar.gz --no-check-certificate
wget http://3proxy.ru/current/3proxy-0.7-devel.tgz
tar zxvf stunnel-4.56.tar.gz
tar zxvf 3proxy-0.7-devel.tgz
yum install openssl openssl-devel
#yum install openssl*


#3proxy
cd 3proxy-0.7-devel
make -f Makefile.Linux
make -f Makefile.Linux install
cat > /etc/3proxy.cfg << EOF
internal 127.0.0.1
auth none
socks -p22222
EOF
3proxy /etc/3proxy.cfg &


cd ../stunnel-4.56
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
/usr/local/bin/stunnel

#ps -ef | grep stunnel
