Log_file_location=/tmp/cart.log
echo -e"\e[31m Copying the cart service to a desired location\e[0m" | tee -a $Log_file_location
cp cart.service /etc/systemd/system/cart.service

echo -e"\e[33m Downloading the node js from the web page\e[0m" | tee -a $Log_file_location
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
pwd
npm install

systemctl daemon-reload
systemctl enable cart
systemctl restart cart