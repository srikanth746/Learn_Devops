func_frontend(){
  Log_file_location=/tmp/roboshop-frontend.log
  if [ -z "${runtype}" ]; then
    echo -e "\e[31m Process is exiting due to improper arguments\e[0m"
    exit
  fi
  if [ "${runtype}" == "restart" ]
  then
      echo -e "\e[35m Restarting the ${component} web server\e[0m" | tee -a $Log_file_location
      #systemctl enable ${component} &>> /dev/null
      systemctl restart ${component} &>> $Log_file_location
      status=$?

      echo -e "\e[36m Checking the status of ${component}\e[0m" | tee -a $Log_file_location
      systemctl status ${component} ; tail -f /var/log/messages &>> $Log_file_location
      status=$?
  else
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
  fi

  if [ "$status" -eq 0 ]; then
    echo "Success"
  else
    echo "Please try again"
  fi

}

func_mongodb(){
  Log_file_location=/tmp/mongo.log
  echo -e "\e[32m Copying the repo file of mongo db to install for a desired location\e[0m" | tee -a $Log_file_location
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[32m Installing mongo db with updated repo\e[0m" | tee -a $Log_file_location
  yum install mongodb-org -y &>> $Log_file_location


  echo -e "\e[33m listen address from 127.0.0.1 to 0.0.0.0 in /etc/${component}.conf\e[0m" | tee -a $Log_file_location
  sed -i 's/127.0.0.1/0.0.0.0/' /etc/${component}.conf

  echo -e "\e[34mEnabling and restart of mongo DB\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location
}

func_systemd(){
  echo -e "\e[33m Restarting all the service in the server\e[0m" | tee -a $Log_file_location
    systemctl daemon-reload
    echo -e "\e[33m Enabling and restarting the catalogue service\e[0m" | tee -a $Log_file_location
    systemctl enable catalogue &>> $Log_file_location
    systemctl restart catalogue &>> $Log_file_location
}

func_databasesetup(){
  if [ -z "${databasetype}" ]; then
    echo "Please give the database name"
    exit
  fi
  if [ "${databasetype}" == "mongodb" ]; then
    echo -e "\e[33m Installing MongoDB for the roboshop project\e[0m" | tee -a $Log_file_location
    yum install mongodb-org-shell -y

    echo -e "\e[33m Updating the catalogues schema, java script to the mongo server\e[0m" | tee -a $Log_file_location
    mongo --host mongo.srilearndevops.online </app/schema/catalogue.js
  fi

}
func_catalogue(){
  Log_file_location=/tmp/catalogue.log

  echo -e "\e[32m Copying service and repo file to a desired location\e[0m" | tee -a $Log_file_location
  cp catalogue.service /etc/systemd/system/catalogue.service
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[32m Downloading the ${component} from web\e[0m" | tee -a $Log_file_location
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $Log_file_location

  echo -e "\e[33m Installing node JS for roboshop project\e[0m" | tee -a $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[33m Adding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[32m Calling database setup\e[0m"
  func_databasesetup

  echo -e "\e[33m Creating the directory called app\e[0m" | tee -a $Log_file_location
  mkdir /app
  cd /app
  pwd

  echo -e "\e[33m Downloading the required package from the DEV \e[0m" | tee -a $Log_file_location
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
  unzip /tmp/catalogue.zip
  npm install &>> $Log_file_location

  echo -e "\e[34m Calling system service\e[0m"
  func_systemd

}

func_redis(){
  Log_file_location=/tmp/${component}.log

  echo -e "\e[34m Installing the ${component} resource file from the official webpage\e[0m" | tee -a $Log_file_location
  yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
  yum module enable redis:remi-6.2 -y &>> $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[33m Updating the listen address for the ${component} conf to 0.0.0.0\e[0m" | tee -a $Log_file_location
  sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf

  echo -e "\e[32m Enabling and restarting the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location
}

func_user(){
  Log_file_location=/tmp/${component}.log
  echo -e "\e[32m Copying the ${component} service and Mongo repo file to the desired location\e[0m" | tee -a $Log_file_location
  cp user.service /etc/systemd/system/user.service
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[34m Downloading the node resource file\e[0m" | tee -a $Log_file_location
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[34m Installing the node JS \e[0m" | tee -a $Log_file_location
  yum install nodejs -y &>> $Log_file_location

  echo -e "\e[32m Adding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[33m Creating a directory\e[0m" | tee -a $Log_file_location
  mkdir /app

  echo -e "\e[33m Downloading the roboshop ${component} code from DEV team\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  cd /app

  pwd
  echo -e "\e[34m Unzipping the downloaded user file\e[0m" | tee -a $Log_file_location
  unzip /tmp/${component}.zip

  echo -e "\e[33m Installing npm is started\e[0m" | tee -a $Log_file_location
  npm install &>> $Log_file_location
  echo -e "\e[34m Completed installation of npm\e[0m" | tee -a $Log_file_location

  yum install mongodb-org-shell -y

  echo -e "\e[32m Updating the schema of ${component} to mongo server\e[0m" | tee -a $Log_file_location
  mongo --host mongo.srilearndevops.online </app/schema/${component}.js

  echo -e "\e[34m restarting all the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload &>> /dev/null
  echo -e "\e[34m enabling and restarting the ${component} service\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> $Log_file_location
  systemctl restart ${component} &>> $Log_file_location

}

func_cart(){

  Log_file_location=/tmp/${component}.log
  echo -e "\e[31m Copying the ${component} service to a desired location\e[0m" | tee -a $Log_file_location
  cp cart.service /etc/systemd/system/${component}.service

  echo -e "\e[33m Downloading the node js from the web page\e[0m" | tee -a $Log_file_location
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[34m Installing the node JS application\e[0m" | tee -a $Log_file_location
  yum install nodejs -y &>> $Log_file_location

  echo -e "\e[33m Adding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[35m Creating a directory\e[0m" | tee -a $Log_file_location
  mkdir /app

  echo -e "\e[36m Downloading the ${component} development file\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  cd /app
  echo -e "\e[36m Unzipping the ${component} file\e[0m" | tee -a $Log_file_location
  unzip /tmp/${component}.zip
  pwd
  echo -e "\e[36m Installing the npm\e[0m" | tee -a $Log_file_location
  npm install &>> $Log_file_location

  echo -e "\e[36m Restarting all the service present in server \e[0m" | tee -a $Log_file_location
  systemctl daemon-reload &>> /dev/null

  echo -e "\e[34m Enabling and restarting the ${component} application\e[0m" | tee -a $Log_file_location
  systemctl enable ${component} &>> /dev/null
  systemctl restart ${component} &>> $Log_file_location

  echo -e "\e[31m Status of cart application\e[0m" | tee -a $Log_file_location
  systemctl status ${component} ; tail -f /var/log/messages &>> $Log_file_location
}

func_mysql(){
  Log_file_location=/tmp/MySql.log
  #Removing the current default MySQL version
  echo -e "\e[31m Disabling the current default MYSQL version\e[0m" | tee -a $Log_file_location
  yum module disable ${component} -y &>> /dev/null

  echo -e "\e[32m copying the repo file\e[0m" | tee -a $Log_file_location
  cp MySQL.repo /etc/yum.repos.d/${component}.repo

  echo -e "\e[32m Installing the Mysql\e[0m" | tee -a $Log_file_location
  yum install ${component}-community-server -y

  #Updating the password details to start service for the DB
  echo -e "\e[32m Updating the password details\e[0m" | tee -a $Log_file_location
  mysql_secure_installation --set-root-pass RoboShop@1
  mysql -uroot -pRoboShop@1

  echo -e "\e[36m Enabling and restarting mysql\e[0m" | tee -a $Log_file_location
  systemctl enable ${component}d &>> /dev/null
  systemctl restart ${component}d &>> $Log_file_location
}

func_shipping(){
  Log_file_location=/tmp/shipping.log
  echo -e "\e[32m Copying the service of shipping to desired location\e[0m" | tee -a $Log_file_location
  cp shipping.service /etc/systemd/system/shipping.service

  echo -e "\e[33m Installing the maven application\e[0m" | tee -a $Log_file_location
  yum install maven -y &>> $Log_file_location

  echo -e "\e[33m Added roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[34m Creating a directory\e[0m" | tee -a $Log_file_location
  mkdir /app

  echo -e "\e[35m downloaded shipping zip file\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

  cd /app
  echo -e "\e[34m Unzipping the shipping file\e[0m" | tee -a $Log_file_location
  unzip /tmp/shipping.zip
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  echo -e "\e[31m Installing the mysql server\e[0m" | tee -a $Log_file_location
  yum install mysql -y

  echo -e "\e[31m Added password details\e[0m" | tee -a $Log_file_location
  mysql -h mysql.srilearndevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

  echo -e "\e[31m rebooted the services and enabled,restarted shipping service\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload &>> /dev/null
  systemctl enable shipping &>> /dev/null
  systemctl restart shipping & $Log_file_location

  echo -e "\e[31m Status of the shipping service\e[0m" | tee -a $Log_file_location
  systemctl status shipping ; tail -f /var/log/messages &>> $Log_file_location
}

func_rabbitMQ(){
  Log_file_location=/tmp/${component}.log

  echo -e "\e[33m Downloading the resource file and script for ${component} roboshop application\e[0m" | tee -a $Log_file_location
  curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
  curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

  echo -e "\e[33m Installing ${component} server application\e[0m" | tee -a $Log_file_location
  yum install ${component}-server -y &>> $Log_file_location

  echo -e "\e[34m Enabling and restarting the ${component} application\e[0m" | tee -a $Log_file_location
  systemctl enable ${component}-server &>> /dev/null
  systemctl restart ${component}-server &>> $Log_file_location

  echo -e "\e[32m added roboshop user and assigned permissions\e[0m" | tee -a $Log_file_location
  rabbitmqctl add_user roboshop roboshop123
  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
}

func_payment(){
  Log_file_location=/tmp/${component}.log
  echo -e "\e[31m Copying the ${component} content service\e[0m" | tee -a $Log_file_location
  cp payment.service /etc/systemd/system/${component}.service

  echo -e "\e[32m Installing the python3\e[0m" | tee -a $Log_file_location
  yum install python36 gcc python3-devel -y &>> $Log_file_location

  echo -e "\e[32m Adding roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[32m Creating a directory\e[0m" | tee -a $Log_file_location
  mkdir /app
  echo -e "\e[32m Downloading the ${component} developed zip file\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> /dev/null

  cd /app
  echo -e "\e[32m Unzipping the ${component} file\e[0m" | tee -a $Log_file_location
  unzip /tmp/payment.zip

  echo -e "\e[32m Installing the pip3.6 requirements\e[0m" | tee -a $Log_file_location
  pip3.6 install -r requirements.txt &>> $Log_file_location

  echo -e "\e[32m Rebooting the system services\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload &>> $Log_file_location

  echo -e "\e[32m Enabling and restarting the ${component} service\e[0m" | tee -a $Log_file_location
  systemtctl enable ${component} &>> /dev/null
  systemctl restart ${component} &>> $Log_file_location

  echo -e "\e[34m Checking the status of ${component} service\e[0m" | tee -a $Log_file_location
  systemctl status ${component} ; tail -f /var/log/messages &>> $Log_file_location

}

func_dispatch(){
  Log_file_location=/tmp/${component2}.log

  echo -e "\e[31m Copying the ${component2} content\e[0m" | tee -a $Log_file_location
  cp dispatch.service /etc/systemd/system/${component2}.service

  echo -e "\e[33m Installing the golang application\e[0m" | tee -a $Log_file_location
  yum install ${component} -y &>> $Log_file_location

  echo -e "\e[33m Adding the roboshop user\e[0m" | tee -a $Log_file_location
  useradd roboshop

  echo -e "\e[34m Creating a new directory\e[0m" | tee -a $Log_file_location
  mkdir /app

  echo -e "\e[33m Downloading the ${component2} zip file\e[0m" | tee -a $Log_file_location
  curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

  cd /app
  unzip /tmp/${component2}.zip
  echo -e "\e[33m Executing the go lang commands\e[0m" | tee -a $Log_file_location
  go mod init dispatch
  go get
  go build

  echo -e "\e[33m Reboot the services and enabling,restarting the ${component2}\e[0m" | tee -a $Log_file_location
  systemctl daemon-reload

  systemctl enable ${component2} &>> /dev/null
  systemctl restart ${component2} &>> $Log_file_location
}