#! /bin/bash

echo "Enter Your Database Name: ";
read newDB;                                                
if [[ $newDB =~ [0-9]+$ || $newDB =~ [/.:\|\-] ]]; then
   echo " invalid entry "
elif [[ $newDB =~ ^[a-zA-Z] ]]; then
#validate if DB exist or not 
    if  [ -d ~/bash/DATABASE/$newDB ]
    then
         printf "$newDB already exist.\n";
    else 
        mkdir ~/bash/DATABASE/$newDB
        printf "$newDB created succesfully.\n";
    fi
else
    printf "Can not create $newDB \n";
fi
