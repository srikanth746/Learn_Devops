yum install maven -y
useradd roboshop

cp shipping.service /etc/systemd/system/shipping.service

mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar

yum install mysql -y

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql

systemctl daemon-reload
systemctl enable shipping
systemctl start shipping