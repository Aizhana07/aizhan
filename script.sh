#!/bin/bash
   yum install -y httpd
   systemctl start -y httpd
   systemctl enable --now httpd
   echo "Web-server!!!" > /var/www/html/index.html
   