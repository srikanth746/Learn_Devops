yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

yum module enable redis:remi-6.2 -y

yum install redis -y

#Update the listen address to 0.0.0.0
sed -i 's/127.0.0.1 to 0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf

systemctl enable redis
systemctl restart redis