Log_file_location=/tmp/rabbitmq.log

echo -e "\e[33m Downloading the resource file and script for rabbitMQ roboshop application\e[0m" | tee -a $Log_file_location
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[33m Installing rabbit mq server application\e[0m" | tee -a $Log_file_location
yum install rabbitmq-server -y &>> $Log_file_location

echo -e "\e[34m Enabling and restarting the rabbitmq application\e[0m" | tee -a $Log_file_location
systemctl enable rabbitmq-server &>> /dev/null
systemctl restart rabbitmq-server &>> $Log_file_location

echo -e "\e[32m added roboshop user and assigned permissions\e[0m" | tee -a $Log_file_location
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"