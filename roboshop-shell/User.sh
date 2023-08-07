curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

cd user.service /etc/systemd/system/user.service

cd mongo.repo /etc/yum.repos.d/mongo.repo

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

cd /app

unzip /tmp/user.zip

npm install

systemctl daemon-reload

yum install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js

systemctl enable user
systemctl restart user

