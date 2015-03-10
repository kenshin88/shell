#!/bin/bash
### Version: 0.5
### Author: DungNM

function ask(){
     msg=$1
     ### check param	
     if [ -z "$msg" ]; then
        echo 'Usage: $0 "<msg>".'
        exit
     fi
     ####

     answer=''
     while [[ "$answer" != "yes" && "$answer" != "no" ]]; do
         read -p "$msg(yes/no) ?" answer
         echo "$answer"
         if [[ "$answer" != "yes" && "$answer" != "no" ]]; then
             echo "Try again"
         fi
     done
     echo "Your anwser is $answer." >&2  ### De return duoc string tu function thi bat buoc can dong nay
}
result=$(ask "${1}")
echo "result = ${result}"


### NOTE:
# 1. script nay chap nhan mot string voi space lam tham so $1
# 2. chu y khoang trong giua ky hieu so sanh va toan hang so sanh.
# 3. chu y su dung [[ ]] thay vi [ ] neu co toan tu so sanh
# 4. chu y de truyen mot string vao script thi string do phai nam trong cap dau ngoac kep " "
# 5. de truyen mot string co space vao function thi string do phai nam o dang tuong minh ask "${1}"
