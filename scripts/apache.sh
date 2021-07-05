#!/bin/bash
yum install httpd -y
echo "<h2> Webapp is Running </h2>" > /var/www/html/index.html
service httpd start
chkconfig httpd on