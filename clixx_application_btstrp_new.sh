#!/bin/bash
sudo su -

#######
# Set the variables for the EBS volumes and the logical volume
echo "Mounting EBS Volumes"

for vol in sdf sdg sdh sdi sdj
do
sudo parted /dev/$vol mklabel gpt

parted /dev/$vol mkpart primary ext4 0% 100%
done

#Create physical volume
pvcreate /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1

#Create the Volume Group: 
vgcreate stack_vg /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1

#create the Logical Volumes (LUNS) with about 5G of space allocated initially: 
for LUN in u01 u02 u03 u04 backups
do
lvcreate -L 5G -n Lv_$LUN stack_vg

#create est4 file system
mkfs.ext4 /dev/stack_vg/Lv_$LUN

mkdir /$LUN

mount /dev/stack_vg/Lv_$LUN /$LUN

lvextend -L +3G /dev/mapper/stack_vg-Lv_$LUN

resize2fs /dev/mapper/stack_vg-Lv_$LUN

echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" >> /etc/fstab

mount -a
done

db_password=${db_password}
db_username=${db_username}
db_name=${db_name}
rds_db=${rds_db}
wp_config_dir=${wp_config_dir}
my_webip=${my_webip}   

##Install the needed packages and enable the services(MariaDb, Apache)
yum update -y
yum install -y nfs-utils 
yum install git -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server
systemctl start httpd
systemctl enable httpd
systemctl is-enabled httpd

#Mount on EFS
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${efs_dnsname}:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4
chmod -R 755 ${MOUNT_POINT}

 
##Add ec2-user to Apache group and grant permissions to /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html

# After mounting, check if the wp-config.php has been mounted previously
if [[ -d ${wp_config_dir} ]]
then
    echo "The webpage configuration file ${wp_config_dir} already exists"
    sleep 5
else
    echo "The webpage configuration file ${wp_config_dir} does not exist
          Proceed to git clone of the repository containing ${wp_config_dir}" 
    #git clone https://github.com/stackitgit/CliXX_Retail_Repository.git
    #sudo git clone -b development https://github.com/stackitgit/CliXX_Retail_Repository.git
    sudo git clone https://github.com/PHRONESIS007/Clixx-Docker-Image-Repo.git
    mv CliXX_Retail_Repository/* /var/www/html
    
    mv /var/www/html/wp-config.php wp-config-old.php

    cp wp-config-sample.php wp-config.php
    sudo sed -i "s/'database_name_here'/'${db_name}'/g" wp-config.php
    sudo sed -i "s/'username_here'/'${db_username}'/g" wp-config.php
    sudo sed -i "s/'password_here'/'${db_password}'/g" wp-config.php
    sudo sed -i "s/'localhost'/'${rds_db}'/g" wp-config.php
fi

## Allow wordpress to use Permalinks
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf
 
mysql -u ${db_username} --password=${db_password} -h ${rds_db} -D ${db_name}<<EOF
UPDATE wp_options SET option_value = "http://${my_webip}" WHERE option_value LIKE 'http%';
EOF

