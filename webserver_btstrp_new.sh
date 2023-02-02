#!/bin/bash 

##Install the needed packages and enable the services(MariaDb, Apache)
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

MOUNT_POINT=/var/www/html
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
chmod -R 755 /var/www/html

##Add ec2-user to Apache group and grant permissions to /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html
 
##Grant file ownership of /var/www & its contents to apache user
sudo chown -R apache /var/www
 
##Grant group ownership of /var/www & contents to apache group
sudo chgrp -R apache /var/www
 
##Change directory permissions of /var/www & its subdir to add group write 
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
 
##Recursively change file permission of /var/www & subdir to add group write perm
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
 
##Restart Apache
sudo systemctl restart httpd
sudo service httpd restart
 
##Enable httpd 
sudo systemctl enable httpd 
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5
