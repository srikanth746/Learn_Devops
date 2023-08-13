Log_file_location=/tmp/shipping.log
echo -e"\e[32m Copying the service of shipping to desired location\e[0m" | tee -a $Log_file_location
cp shipping.service /etc/systemd/system/shipping.service

echo -e"\e[33m Installing the maven application\e[0m" | tee -a $Log_file_location
yum install maven -y &>> $Log_file_location

echo -e"\e[33m Added roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e"\e[34m Creating a directory\e[0m" | tee -a $Log_file_location
mkdir /app

echo -e"\e[35m downloaded shipping zip file\e[0m" | tee -a $Log_file_location
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

cd /app
echo -e"\e[34m Unzipping the shipping file\e[0m" | tee -a $Log_file_location
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e"\e[31m Installing the mysql server\e[0m" | tee -a $Log_file_location
yum install mysql -y

echo -e"\e[31m Added password details\e[0m" | tee -a $Log_file_location
mysql -h mysql.srilearndevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e"\e[31m rebooted the services and enabled,restarted shipping service\e[0m" | tee -a $Log_file_location
systemctl daemon-reload &>> /dev/null
systemctl enable shipping &>> /dev/null
systemctl restart shipping & $Log_file_location

echo -e"\e[31m Status of the shipping service\e[0m" | tee -a $Log_file_location
systemctl status shipping ; tail -f /var/log/messages &>> $Log_file_location