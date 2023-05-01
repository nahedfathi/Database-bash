#!/bin/bash

echo "Enter Your Database Name"
read db_name 
if [[ $db_name == '' || $db_name =~ [/.:\|\-] ]]; then
 echo " not valid entry "
elif [ -d  ~/bash/DATABASE/$db_name ]; then 
    rm -r ~/bash/DATABASE/$db_name
    echo "$db_name database  deleted Successfully"
else 
    echo "$db_name Not Exist"
fi
