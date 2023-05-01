#!/bin/bash
DIR=~/bash/DATABASE
if [ -d "$DIR" ] && [ "$(ls $DIR )" ]; then
         cd $DIR
         printf "\nAll Databases created :\n \n"
         for i in $(ls -d */); 
	       do
	       # to remove '/' from DB names
	       echo  ${i} | cut -d '/' -f1   
	       done
else 
    echo "No Databases created yet"
fi
