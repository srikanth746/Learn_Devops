echo "Practicing the print cmd and installing nginx"

echo -e "\e[33mChecking the nginx status\e[0m"

yum list installed | grep nginx

echo -e "\e[32mInstalling Nginx\e[0m"

yum install nginx -y

echo -e "\e[35mInstallation of nginx is completed\e[0m"

echo -e "\e[34starting the nginx web service\e[0m"

systemctl start nginx

echo -e "\e[35checking the status of nginx\e[0m"
systemctl status nginx

echo -e "\e[36removing nginx\e[0m"
yum remove nginx -y