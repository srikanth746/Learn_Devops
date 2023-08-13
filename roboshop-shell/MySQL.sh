Log_file_location=/tmp/MySql.log
#Removing the current default MySQL version
echo -e "\e[31m Disabling the current default MYSQL version\e[0m" | tee -a $Log_file_location
yum module disable mysql -y &>> /dev/null

echo -e "\e[32m copying the repo file\e[0m" | tee -a $Log_file_location
cp MySQL.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m Installing the Mysql\e[0m" | tee -a $Log_file_location
yum install mysql-community-server -y

#Updating the password details to start service for the DB
echo -e "\e[32m Updating the password details\e[0m" | tee -a $Log_file_location
mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1

echo -e "\e[36m Enabling and restarting mysql\e[0m" | tee -a $Log_file_location
systemctl enable mysqld &>> /dev/null
systemctl restart mysqld &>> $Log_file_location