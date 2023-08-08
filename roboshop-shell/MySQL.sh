
#Removing the current default MySQL version

yum module disable mysql -y

cp MySQL.repo /etc/yum.repos.d/mysql.repo

yum install mysql-community-server -y

#Updating the password details to start service for the DB

mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1

systemctl enable mysqld
systemctl restart mysqld