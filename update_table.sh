#! /bin/bash

function validate_dataType {

	datatype=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $2}')

	if [[ "$1" =~ [0-9]+$ && $datatype == integer ]]; then
			echo 1
			
        elif [[ "$1" =~ [a-zA-Z]+$ && $datatype == string ]]; then
			echo 1
			
	else
		echo 0
	fi
}


function updateTable {
	
	echo "enter name of the table"
	read dbtable
	##########
	# not exist
	if ! [[ -f "$dbtable" ]]; then
		echo " this table doesn't exist"
		echo "press any key"
		read
	else
		##########
		# table exists
		##########
		# enter pk
		echo "enter primary key $(head -1 "$dbtable" | cut -d ':' -f1 |
		awk -F "-" '{print $1}') of type $(head -1 "$dbtable" | cut -d ':' -f1 |
		awk -F "-" '{print $2}')"
		read
		
		recordNum=$(cut -d ':' -f1 "$dbtable" | grep -n "^$REPLY$" | cut -d':' -f1)
		##########
		# null entry
		if [[ "$REPLY" == '' ]]; then
			echo "no entry"
		##########
		# record not exists
		elif [[ "$recordNum" = '' ]]; then
			echo "this primary key doesn't exist "
		##########
		# record exists
		else
			
			# to get number of columns in table
			num_col=$(head -1 "$dbtable" | awk -F: '{print NF}') 
			
			##########
			##########
			# to show the other fields' names of this record
			echo  "record fields:"
			option=$(head -1 $dbtable | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}')
			echo "$option"
			getFieldName=true
			while $getFieldName; do
				
				echo "enter field name to update"
				read
				
				if [[ "$REPLY" = '' ]]; then
					echo  "invalid entry"
				
				elif [[ $(echo "$option" | grep "^$REPLY$") = "" ]]; then
					echo "no such field with the entered name, please enter a valid field name"
				
				else
					# get field number
					#each raw is also each field
					fieldnum=$(head -1 "$dbtable" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}'| grep -n "^$REPLY$" | cut -d: -f1)
					
					updatingField=true
					while $updatingField; do
						##########
						# updating field's primary key
						if [[ "$fieldnum" = 1 ]]; then
							echo enter primary key $(head -1 "$dbtable" | cut -d ':' -f1 |
							awk -F "-" '{print $1}') of type $(head -1 "$dbtable" | cut -d ':' -f1 |
							awk -F "-" '{print $2}')
							read

							
							check_type=$(validate_dataType "$REPLY" "$dbtable" 1)
							pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep "^$REPLY$")
							##########
							# null entry
							if [[ "$REPLY" == '' ]]; then
								echo "no entry, id can't be null"
							##########
							#match datatype
							elif [[ "$check_type" == 0 ]]; then
								echo "entry invalid"
							
							##########
							#elif [[ "$REPLY" =~ [\r' '] ]]; then
							#	echo "space not ya 5laf"
							# pk is used
							elif ! [[ "$pk_used" == '' ]]; then
								echo "this primary key already used"
							##########
							# pk is valid
							else 
								awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY" 'BEGIN { FS = OFS = ":" }
								 { if(NR == rn) {$fn = nv} } 1' "$dbtable" >> "$dbtable".new &&         
								 rm "$dbtable" && mv "$dbtable".new "$dbtable"
								updatingField=false
								getFieldName=false
							fi
						##########
						# updating other field 
						else
							updatingField=true
							while $updatingField ; do
								echo enter \"$(head -1 $dbtable | cut -d ':' -f$fieldnum |
								awk -F "-" '{print $1}') of type $(head -1 "$dbtable" | cut -d ':' -f$fieldnum  |
								awk -F "-" '{print $2}')
								read
								check_type=$(validate_dataType "$REPLY" "$dbtable" "$fieldnum")
								##########
								# match datatype
								if [[ "$check_type" == 0 ]]; then
									echo "entry invalid"
								##########
								# entry is valid
								else
									awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY" 'BEGIN { FS = OFS = ":" } 
									{ if(NR == rn)	$fn = nv } 1' "$dbtable" >> "$dbtable".new && 
									rm "$dbtable" && mv "$dbtable".new "$dbtable"
									updatingField=false
									getFieldName=false
								fi
							done
						fi
					done
					echo "field updated successfully"
				fi
			done
		fi
		echo "press any key"
		read
	fi
}

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
		                       for i in $(ls ); 
				       do
					 echo ${i}; 
				       done
		                           #calling  updateTable function
		                           updateTable
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
