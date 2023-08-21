echo -e "\e[34m Working to understand basic loops concept in shell script \e[0m"
n=$1
i=0
while [ "$n" -gt "$i" ]; do
  echo "hello **"
  i=$((i+1))
  done