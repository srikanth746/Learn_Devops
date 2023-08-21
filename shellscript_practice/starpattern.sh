#!/bin/bash
function square-pattern(){
  echo "Printing the square star pattern"
  n=$1
  for((i=1;i<=n;i++))
  {
    for((j=i;j<=n;j++))
    {
      echo "*"
    }
  }
}
square-pattern 5