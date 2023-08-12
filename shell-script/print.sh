echo "Practicing the print cmd and installing nginx"

echo -e "\e[33m Checking the nginx status\e[0m"

yum list installed | grep nginx

echo -e "\e[32m Installing Nginx\e[0m"

yum install nginx -y

echo -e "\e[35m Installation of nginx is completed\e[0m"

echo -e "\e[34 mstarting the nginx web service\e[0m"

systemctl start nginx

echo -e "\e[35 mchecking the status of nginx\e[0m"
systemctl status nginx

echo -e "\e[36m removing nginx\e[0m"
yum remove nginx -y