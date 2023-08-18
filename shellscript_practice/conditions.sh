echo -e "\e[32m Please enter your current age\e[0m"
age=$1
echo -e "\e[33m Please enter your gender\e[0m"
gender=$2
if [ -z "${age}" ]
then
  echo "Missing age of the candidate"
  exit
fi
if [ "$age" -gt 18 ]
then
  echo "your are eligible for vote"
  status=$?
else
  echo "you are not eligible to vote"
  status=$?
fi

if [ status -qe 0 ]
then
  echo "vote is successful"
else
  echo "Your vote is not valid"
fi

echo total number of input $#
echo list of inputs $*