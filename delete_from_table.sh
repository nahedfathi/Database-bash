#! /bin/bash


function deleteRow {
	
	printf "\nenter name of the table\n"
	read dbtable
	
	# check if table not exist
	if ! [[ -f "$dbtable" ]]; then
		echo  "this table doesn't exist"
		echo press any key
		read
		
	else
		
	# enter primary key 
	echo  "enter primary key $(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" '{print $1}') of type $(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" '{print $2}')of the record to delete"
		
		read
		
		
		# get Number of this record
		recordNum=$(cut -d ':' -f1 "$dbtable" | grep -n ^"$REPLY"$ | cut -d':' -f1)
		
		
# primary key validation
		if [[ "$REPLY" == '' ]]; then
			echo  "no entry"
			
		elif [[ "$REPLY" =~ [/.:\|\-]  ]]; then
			echo  "enter valid primary key"
			
		# row not exists
		elif [[ "$recordNum" = '' ]]; then
			echo  "this primary key doesn't exist"
			
		
		else
			sed -i "${recordNum}d" "$dbtable"
			echo "record deleted successfully"
			
		fi
		echo press any key
		read
	fi
}



 
if [[ -d  ~/bash/DATABASE ]] ;
then
   
    cd ~/bash/DATABASE

    # arr_dataBases=($(ls -d */)) 2>  ~/bash/error_log
     
     #check if there are dataBases exist
     
     if [[ $(ls -d */) > 0 ]] 2>  ~/bash/error_log
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
		                       for i in $(ls); 
				       do
					 echo ${i}; 
				       done
		                           #calling  deleteRow function
		                           deleteRow
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
