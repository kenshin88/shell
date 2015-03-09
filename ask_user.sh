#!/bin/bash
### Version: 0.5
### Author: DungNM

function ask(){
     msg=$1
     if [ -z "$msg" ]; then
        echo 'Usage: $0 "<msg>".'
        exit
     fi

     answer=''
     while [[ "$answer" != "yes" && "$answer" != "no" ]]; do
         read -p "$msg(yes/no) ?" answer
         echo "$answer"
         if [[ "$answer" != "yes" && "$answer" != "no" ]]; then
             echo "Try again"
         fi
     done
     echo "Your anwser is $answer." >&2  ### De return duoc thi bat buoc can dong nay
}
result=$(ask "${1}")
echo "result = ${result}"
