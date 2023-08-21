found_nginx=sudo yum list installed | grep nginx
if [ -z "${found_nginx}" ]; then
  echo "nginx is available"
fi

a=$1
b=$2
echo $a
echo $b
echo "working on substitution variables"
date_today=$(date)
echo $date_today
echo "working on manipulation variables"
add=$((2+2))
echo addition $add
function input-args() {
  echo "working on the function part to pass arguments from the main"
  q=$1
  w=$2
  echo $*
  echo $#
  echo "printed all the type of special variables"
  return 10
  echo "executed the return command"

}

input-args 123 "abv"
echo Function returned - $?

echo Env. variables $bnc
