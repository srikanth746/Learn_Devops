Log_file_location=/tmp/roboshop-frontend.log
echo -e "\e[35mInstalling Nginx web server\e[0m" | tee -a $Log_file_location
yum install nginx -y &>> $Log_file_location

echo -e "\e[34mCopying the roboshop frontend conf to a desired location" | tee -a $Log_file_location
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31mRemoving the default web server html\e[0m" | tee -a $Log_file_location
rm -rf /usr/share/nginx/html/*

echo -e "\e[34mDownloading the required roboshop content provided by DEV\e[0m" | tee -a $Log_file_location
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34m Changing the dir to unzip the downloaded roboshop content\e[0m" | tee -a $Log_file_location
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35m enabling and restarting the nginx web server\e[0m" | tee -a $Log_file_location
systemctl enable nginx &>> /dev/null
systemctl restart nginx &>> $Log_file_location

echo -e "\e[36m Checking the status of nginx\e[0m" | tee -a $Log_file_location
systemctl status nginx ; tail -f /var/log/messages &>> $Log_file_location