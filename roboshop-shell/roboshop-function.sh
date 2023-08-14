func_frontend(){
  Log_file_location=/tmp/roboshop-frontend.log
  echo -e "\e[35mInstalling ${component} web server\e[0m" | tee -a $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[34mCopying the roboshop frontend conf to a desired location" | tee -a $Log_file_location
  cp roboshop.conf /etc/nginx/default.d/roboshop.conf

  echo -e "\e[31mRemoving the default web server html\e[0m" | tee -a $Log_file_location
  rm -rf /usr/share/nginx/html/*

  echo -e "\e[34mDownloading the required roboshop content provided by DEV\e[0m" | tee -a $Log_file_location
  curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

  echo -e "\e[34m Changing the dir to unzip the downloaded roboshop content\e[0m" | tee -a $Log_file_location
  cd /usr/share/nginx/html
  unzip /tmp/frontend.zip

  echo -e "\e[35m enabling and restarting the ${component} web server\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> /dev/null
  systemctl restart ${component} &>> $Log_file_location

  echo -e "\e[36m Checking the status of ${component}\e[0m" | tee -a $Log_file_location
  systemctl status ${component} ; tail -f /var/log/messages &>> $Log_file_location
}

func_mongodb(){
  Log_file_location=/tmp/mongo.log
  echo -e "\e[32mCopying the repo file of mongo db to install for a desired location\e[0m" | tee -a $Log_file_location
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[32mInstalling mongo db with updated repo\e[0m" | tee -a $Log_file_location
  yum install mongodb-org -y &>> $Log_file_location


  echo -e "\e[33mlisten address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf\e[0m" | tee -a $Log_file_location
  sed -i 's/127.0.0.1/0.0.0.0/' /etc/${component}.conf

  echo -e "\e[34mEnabling and restart of mongo DB\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location
}