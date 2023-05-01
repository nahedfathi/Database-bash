#! /bin/bash

function ShowTable {
	
	printf "\nenter name of the table\n"
	read dbtable
	
	# check if table not exist
	if ! [[ -f "$dbtable" ]]; then
		echo "this table doesn't exist"
		echo press any key
		read
		
	else
		
		echo "*************************************************************"
		head -1 "$dbtable" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}' | awk 'BEGIN{ORS="\t"} {print $0}'
		printf "\n*************************************************************"
		sed '1d' "$dbtable" | awk -F: 'BEGIN {OFS="\t"} {for(n = 1; n <= NF; n++) $n=$n}  1'
		printf "\npress any key"
		read
		
	fi
}


 
if [[ -d  ~/bash/DATABASE ]] ;
then
   
    cd ~/bash/DATABASE
    
     arr_dataBases=($(ls -d */))

     #check if there are dataBases exist
     
     if [[ ${#arr_dataBases[@]} > 0 ]]
     then
     printf "\nAll DataBase  \n\n"
       #Display all DataBases
       
       for i in $(ls -d */); 
       do
         echo  ${i} | cut -d '/' -f1 
       done

       printf "\nEnter the name of dataBase \n\n"
       read db_name 
       printf "\n"
      export db_name
               #check if the dataBase_name Directory exist
               if [[ $db_name =~ [/.:\|\-] ]]; then
                    echo "not valid database name"
               elif [[ -d $db_name ]]
               then
                               cd $db_name
                             
                              if [ "$(ls  )" ]; then
                              
		                       printf "\nAll Tables  \n\n"
		                       for i in $(ls ); 
				       do
					 echo ${i}; 
				       done
		                           #calling  ShowTable function
		                           ShowTable
                               else
                                       printf "\nNO Tables  \n\n"
                                       
			       fi
       else
            
            printf "\nThis DataBase Name isn't exist\n"

            printf  "Go Back To Main Menu\n" 
           

           source db_menu.sh


       fi

     else
        
          printf "\nThis DATABASE is empty , please create database first"
          
          source db_menu.sh
     fi


   

    
else
    
         printf "\nYour DATABASE  isn't exist " 
fi
