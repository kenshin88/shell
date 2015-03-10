#!/bin/bash
LOOPBACK="127.0.0.1"
master_ip=$(ifconfig | grep "inet addr" | grep -v "$LOOPBACK" | awk -F ":" '{print $2}' | awk '{print $1}'| xargs | sed 's/\s/,/g')
mysql_user="root"
mysql_passwd="check_db"
checksum_meta_db="check_db"
checksum_meta_tbl="dsns"
separator="|"
DEFAULT_IFS=$IFS
SMTP_SERVER="x.y.z.t"
function send_mail(){ ### send mail neu co difference
     ADMIN="xxx@gmail.com"
     slave_host_ip=$1
     message=$2
     cat $message | /bin/mail -s  "[Warning]  There is a difference between master `hostname` and slave $slave_host_ip" -S smtp=smtp://${SMTP_SERVER} -S from="Admin_Checksum<admin@org.com>" "$ADMIN"
}
function checksum(){ ### pass param $1 la dsn string
     dsn=$1
     slave_host_ip=$(echo $dsn | cut -d "," -f 1 | cut -d "=" -f 2)
     if [ "$slave_host_ip" == "$master_ip" ]; then
        return
     fi
     checksum_output="/dev/shm/checksum_output"
     pt-table-checksum -h $master_ip -u $mysql_user -p"$mysql_passwd"  --recursion-method dsn=$dsn,D=$checksum_meta_db,t=$checksum_meta_tbl --nocheck-binlog-format --set-vars innodb_lock_wait_timeout=50 --replicate-check-only --quiet  > $checksum_output
     grep -F "Differences" $checksum_output
     status=$?
     [ $status -eq 0 ] && send_mail $slave_host_ip $checksum_output
}
function main(){
     IFS=$DEFAULT_IFS
     all_nodes=$(mysql -u $mysql_user -p"$mysql_passwd" -h $master_ip -ANe "select group_concat(dsn separator '$separator')  from $checksum_meta_db.$checksum_meta_tbl;")
     IFS="|"
     for node in $all_nodes; do
         checksum "${node}"
     done
}
main
### NOTE:
# 1. Moi variables nen duoc su dung o dang "${var_name}"
