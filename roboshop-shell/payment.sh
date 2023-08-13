Log_file_location=/tmp/payment.log
echo -e "\e[31mCopying the payment content service\e[0m" | tee -a $Log_file_location
cp payment.service /etc/systemd/system/payment.service

echo -e "\e[32mInstalling the python3\e[0m" | tee -a $Log_file_location
yum install python36 gcc python3-devel -y &>> $Log_file_location

echo -e "\e[32mAdding roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e "\e[32mCreating a directory\e[0m" | tee -a $Log_file_location
mkdir /app
echo -e "\e[32mDownloading the payment developed zip file\e[0m" | tee -a $Log_file_location
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>> /dev/null

cd /app
echo -e "\e[32m Unzipping the payment file\e[0m" | tee -a $Log_file_location
unzip /tmp/payment.zip

echo -e "\e[32mInstalling the pip3.6 requirements\e[0m" | tee -a $Log_file_location
pip3.6 install -r requirements.txt &>> $Log_file_location

echo -e "\e[32mRebooting the system services\e[0m" | tee -a $Log_file_location
systemctl daemon-reload &>> $Log_file_location

echo -e "\e[32mEnabling and restarting the payment service\e[0m" | tee -a $Log_file_location
systemtctl enable payment &>> /dev/null
systemctl restart payment &>> $Log_file_location

echo -e "\e[34m Checking the status of payment service\e[0m" | tee -a $Log_file_location
systemctl status payment ; tail -f /var/log/messages &>> $Log_file_location
