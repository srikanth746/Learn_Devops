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

func_redis(){
  Log_file_location=/tmp/${component}.log

  echo -e "\e[34mInstalling the ${component} resource file from the official webpage\e[0m" | tee -a $Log_file_location
  yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
  yum module enable redis:remi-6.2 -y &>> $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[33mUpdating the listen address for the ${component} conf to 0.0.0.0\e[0m" | tee -a $Log_file_location
  sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf

  echo -e "\e[32mEnabling and restarting the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location
}

func_user(){
  Log_file_location=/tmp/${component}.log
  echo -e "\e[32mCopying the ${component} service and Mongo repo file to the desired location\e[0m" | tee -a $Log_file_location
  cp user.service /etc/systemd/system/user.service
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[34mDownloading the node resource file\e[0m" | tee -a $Log_file_location
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[34mInstalling the node JS \e[0m" | tee -a $Log_file_location
  yum install nodejs -y &>> $Log_file_location

  echo -e "\e[32mAdding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[33mCreating a directory\e[0m" | tee -a $Log_file_location
  mkdir /app

  echo -e "\e[33mDownloading the roboshop ${component} code from DEV team\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  cd /app

  pwd
  echo -e "\e[34mUnzipping the downloaded user file\e[0m" | tee -a $Log_file_location
  unzip /tmp/${component}.zip

  echo -e "\e[33m Installing npm is started\e[0m" | tee -a $Log_file_location
  npm install &>> $Log_file_location
  echo -e "\e[34m Completed installation of npm\e[0m" | tee -a $Log_file_location

  yum install mongodb-org-shell -y

  echo -e "\e[32mUpdating the schema of ${component} to mongo server\e[0m" | tee -a $Log_file_location
  mongo --host mongo.srilearndevops.online </app/schema/${component}.js

  echo -e "\e[34m restarting all the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload &>> /dev/null
  echo -e "\e[34m enabling and restarting the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location

}