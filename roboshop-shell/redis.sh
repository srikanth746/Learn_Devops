yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum module enable redis:remi-6.2 -y
yum install redis -y

vim /etc/redis.conf
echo "updated the redis address"
vim /etc/redis/redis.conf
systemctl enable redis
systemctl start redis