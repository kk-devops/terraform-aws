#!/bin/bash
yum --assumeyes update
yum --assumeyes install httpd.x86_64
systemctl enable httpd.service
systemctl start httpd.service
echo "Hello world from $(hostname --fqdn)" > /var/www/html/index.html