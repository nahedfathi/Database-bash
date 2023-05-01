#! /bin/bash
# 		$1	$REPLY	
#               $2	$file 
#               $3      $column
					
function validate_dataType {

	datatype=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" '{print $2}')

	if [[ "$1" =~ [0-9]+$ && $datatype == integer ]]; then
			echo 1
			
        elif [[ "$1" =~ [a-zA-Z]+$ && $datatype == string ]]; then
			echo 1
			
	else
		echo 0
	fi
}


function insertData {

	printf "\nenter the name of the table\n"
	read dbtable
	#validate if table isn't exist
	if ! [[ -f "$dbtable" ]]; then
		echo  "this table doesn't exist"
		echo press any key
		read
		
	else
#validate inserting data 	
		insertingData=true
		while $insertingData ; do
			
	        echo  "enter primary key "$(head -1 "$dbtable" | cut -d ':' -f1  | awk -F "-" '{print $1}')" of type $(head -1 "$dbtable" | cut -d ':' -f 1  | awk -F "-" '{print $2}') "

			read
	
# validate primary key data type
			check_type=$(validate_dataType "$REPLY" "$dbtable" 1) 
                        
                        #check if PK is already exist
			pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep  ^"$REPLY"$)
			if [[ "$REPLY" == '' ]]; then
				echo  "no entry"
			
			elif [[ $REPLY =~ [/.:\|\-] ]]; then
				echo "You can't enter these characters => . / : - | "
			
			elif [[ "$check_type" == 0 ]]; then 
				echo "entry invalid"
			
			
			elif ! [[ "$pk_used" == '' ]]; then
				echo  "this primary key is already used"
			
			else 
				#write inserting data in table file			
				echo -n "$REPLY" >> "$dbtable"
				echo -n ':' >> "$dbtable"
				
				# to get number of columns in table
				num_col=$(head -1 "$dbtable" | awk -F: '{print NF}')
				## to iterate over the columns after the primary key
				for (( i = 2; i <= num_col; i++ )); do
					inserting_fields_data=true
					while $inserting_fields_data ; do
				        echo  "enter $(head -1 "$dbtable" | cut -d ':' -f$i | awk -F "-" '{print $1}') of type $(head -1 "$dbtable" | cut -d ':' -f$i | awk -F "-" '{print $2}')"

						read
# validate fields data type						
						check_type=$(validate_dataType "$REPLY" "$dbtable" "$i")
						
						if [[ "$check_type" == 0 ]]; then
							echo  "entry invalid"
						
						elif [[ $REPLY =~ [/.:\|\-] ]]; then
							echo  "You can't enter these characters => . / : - | "
						
						else
							#all fields are inserted
							if [[ i -eq $num_col ]]; then
								echo "$REPLY" >> "$dbtable"
								inserting_fields_data=false
								insertingData=false
								echo  "entry inserted successfully"
								
							else
								
								# next column 
								echo -n "$REPLY": >> "$dbtable"
								inserting_fields_data=false
							fi
						fi
					done
				done
			fi
		done
		echo press any key
		read
	fi
}
######################################################################################################################################################
  
if [[ -d  ~/bash/DATABASE ]] ;
then
   
    cd ~/bash/DATABASE
    


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
		                           #calling  create_table function
		                           insertData
                               else
                                       printf "\nNO Tables  \n\n"
                                       cd 
			       fi
       else
            
            printf "\nThis DataBase Name isn't exist\n"

            printf  "Go Back To Main Menu\n" 
            cd

           source db_menu.sh


       fi

     else
        
          printf "\nThis DATABASE is empty , please create database first"
          cd
          source db_menu.sh
     fi


   

    
else
    
         printf "\nYour DATABASE  isn't exist " 
fi
