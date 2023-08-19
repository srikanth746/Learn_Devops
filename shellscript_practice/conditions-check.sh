found_nginx=sudo yum list installed | grep nginx
if [ -z "${found_nginx}" ]; then
  echo "nginx is available"
fi