echo -e "\e[32m Please enter your current age\e[0m"
age=$1
echo -e "\e[33m Please enter your gender\e[0m"
gender=$2
if [ "${age}" -gt 18 ]
then
  echo "your are eligible for vote"
else
  echo "you are not eligible to vote"
fi

echo total number of input $#
echo list of inputs $*