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

func_catalogue(){
  Log_file_location=/tmp/catalogue.log

  echo -e "\e[32mCopying service and repo file to a desired location\e[0m" | tee -a $Log_file_location
  cp catalogue.service /etc/systemd/system/catalogue.service
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[32mDownloading the nodejs from web\e[0m" | tee -a $Log_file_location
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $Log_file_location

  echo -e "\e[33mInstalling node JS for roboshop project\e[0m" | tee -a $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[33mAdding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[33mInstalling MongoDB for the roboshop project\e[0m" | tee -a $Log_file_location
  yum install mongodb-org-shell -y

  #Creating a directory to add the catalogue content

  echo -e "\e[33mCreating the directory called app\e[0m" | tee -a $Log_file_location
  mkdir /app
  cd /app
  pwd

  echo -e "\e[33mDownloading the required package from the DEV \e[0m" | tee -a $Log_file_location
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
  unzip /tmp/catalogue.zip
  npm install &>> $Log_file_location

  echo -e "\e[33mUpdating the catalogues chema, java script to the mongo server\e[0m" | tee -a $Log_file_location
  mongo --host mongo.srilearndevops.online </app/schema/catalogue.js

  echo -e "\e[33mRestarting all the service in the server\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload
  echo -e "\e[33mEnabling and restarting the catalogue service\e[0m" | tee -a $Log_file_location
  systemctl enable catalogue &>> $Log_file_location
  systemctl restart catalogue &>> $Log_file_location
}