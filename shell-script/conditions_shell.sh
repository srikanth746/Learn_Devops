read a
if [ $a -ge 18 ]
then
  echo "eligible to vote"
  echo $?
else
  echo "Not eligible to vote"
  echo $?
fi