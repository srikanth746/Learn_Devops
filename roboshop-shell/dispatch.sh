Log_file_location=/tmp/dispatch.log

echo -e "\e[31mCopying the dispatch content\e[0m" | tee -a $Log_file_location
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[33mInstalling the golang application\e[0m" | tee -a $Log_file_location
yum install golang -y &>> $Log_file_location

echo -e "\e[33mAdding the roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e "\e[34mCreating a new directory\e[0m" | tee -a $Log_file_location
mkdir /app

echo -e "\e[33mDownloading the dispatch zip file\e[0m" | tee -a $Log_file_location
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

cd /app
unzip /tmp/dispatch.zip
echo -e "\e[33mExecuting the go lang commands\e[0m" | tee -a $Log_file_location
go mod init dispatch
go get
go build

echo -e "\e[33mReboot the services and enabling,restarting the dispatch\e[0m" | tee -a $Log_file_location
systemctl daemon-reload

systemctl enable dispatch &>> /dev/null
systemctl restart dispatch &>> $Log_file_location