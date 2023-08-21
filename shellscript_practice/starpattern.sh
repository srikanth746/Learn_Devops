#!/bin/bash
function square-pattern(){
  echo "Printing the square star pattern"
  n=$1
  for((i=1;i<=n;i++))
    do
      for((j=1;j<=n;j++))
        do
          echo "*"
        done
      done

}
square-pattern 5