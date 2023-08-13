Log_file_location=/tmp/redis.log

echo -e "\e[34mInstalling the redis resource file from the official webpage\e[0m" | tee -a $Log_file_location
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum module enable redis:remi-6.2 -y &>> $Log_file_location
yum install redis -y &>> $Log_file_location

echo -e "\e[33mUpdating the listen address for the redis conf to 0.0.0.0\e[0m" | tee -a $Log_file_location
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[32mEnabling and restarting the redis service\e[0m" | tee -a $Log_file_location
systemctl enable redis &>> $Log_file_location
systemctl restart redis &>> $Log_file_location