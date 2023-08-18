echo -e "\e[32m Please enter your current age\e[0m"
read age
if [ "$age" -gt 18 ]
then
  echo "your are eligible for vote"
fi