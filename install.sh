#!/usr/bin/env bash

# add dependencies
yum -y install gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools-devel

# install nginx
wget http://nginx.org/download/nginx-1.8.0.tar.gz
tar -xzvf nginx*gz
cd nginx*
./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_spdy_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-ld-opt="-Wl,-E" --with-mail --with-mail_ssl_module --with-pcre --with-google_perftools_module --with-debug
make
make install

# removes tomcat + httpd
useradd -r nginx
yum -y remove tomcat8
rm -f /etc/monit.d/monit-tomcat8.conf
yum -y remove httpd

# configure nginx
wget -O /etc/init.d/nginx https://raw.githubusercontent.com/davemaple/nginx-1.8-elasticbeanstalk/master/nginx.service.sh
chmod +x /etc/init.d/nginx
chkconfig nginx on

# add sites enabled
mkdir /etc/nginx/sites-enabled
