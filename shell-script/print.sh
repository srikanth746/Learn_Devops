location=/tmp/roboshop.log

echo -e "\e[33mChecking the nginx server available\e[0m" | tee -a $location

yum list installed | grep nginx

echo -e "\e[32mInstalling Nginx\e[0m" | tee -a $location

yum install nginx -y &>> $location

echo -e "\e[35mInstallation of nginx is completed\e[0m" | tee -a $location

echo -e "\e[34mStarting the nginx web service\e[0m" | tee -a $location

systemctl start nginx

echo -e "\e[35mChecking the status of nginx\e[0m" | tee -a $location
systemctl status nginx &>> $location

echo -e "\e[31mInstallation of python starts\e[0m" | tee -a $location
yum install python3 -y &>> $location

echo -e "\e[32mCreating and editing python file for execution\e[0m" | tee -a $location
touch sample1.py
echo -e "\e[34mPrinting the start pattern in python\e[0m" | tee -a $location
python3 sample1.py

echo -e "\e[34mSuccessfully executed python script\e[0m" | tee -a $location

echo -e "\e[31m Uninstalling the python and Nginx\e[0m" | tee -a $location
yum remove nginx -y
yum remove python3 -y