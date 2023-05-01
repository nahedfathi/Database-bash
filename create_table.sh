#! /bin/bash


function createMetaData {

		if [[ -f "$table_name" ]]; then
#num of columns
			validMetaData=true
			while $validMetaData; do
				echo  "how many columns do you want?"
				read num_col
				
				if [[ "$num_col" =~ [/.:\|\-] ]]; then 
					echo  "invalid entry.."
				elif [[ "$num_col" -gt 1 && "$num_col" =~ [0-9] ]]; then
					validMetaData=false
				
				else 
				     echo "invalid entry" 
				fi
			done
#primary key 
			validMetaData=true
			while $validMetaData; do
				echo "enter primary key name"
				read pk_name
#primary key name validation
				if [[ $pk_name = "" ]]; then
					echo "invalid entry, please enter a correct name"
					
				
				elif [[ $pk_name =~ [/.:\|\-] ]]; then
					echo "You can't enter these characters"
					
				
				elif [[ $pk_name =~ ^[a-zA-Z] ]]; then
				#'-n' to not echo in a newline and write in same line in the file
					echo -n "$pk_name" >> "$table_name"
					echo -n "-" >> "$table_name"
					validMetaData=false
				
				else
					echo "enter valid Primary key "
					
				fi
			done
#primary key data type validation
			validMetaData=true
			while $validMetaData; do
				echo "enter primary key datatype"
				select choice in "integer" "string"; do
					if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
						echo -n "$choice" >> "$table_name"
						echo -n ":" >> "$table_name"
						validMetaData=false
					else
						echo "invalid chioce"
					fi
					break
				done
			done
			
			
			# to iterate over num of columns after the primary key
			for (( i = 2; i <= num_col; i++ )); do
#field name validation	
				validMetaData=true
				while $validMetaData; do
					echo "enter field $[i] name"
					read field_name
	
					if [[ $field_name = "" ]]; then
						echo "invalid entry, please enter a correct name"
					
					elif [[ $field_name =~ [/.:\|\-] ]]; then
						echo  "You can't enter these characters"
						
					
					elif [[ $field_name =~ ^[a-zA-Z] ]]; then
						echo -n "$field_name" >> "$table_name"
						echo -n "-" >> "$table_name"
						validMetaData=false
				
					else
						echo  "enter valid field name "
					fi
				done
#field data type validation
				validMetaData=true
				while $validMetaData; do
					echo  "enter field $[i] datatype"
					select choice in "integer" "string"; do
						if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
							echo -n "$choice" >> "$table_name"
							validMetaData=false
						else
							echo "invalid choice"
						fi
						break
					done
				done
		
				validMetaData=true
				while $validMetaData; do
					
						if [[ i -eq $num_col ]]; then
							echo $'\n' >> "$table_name"
							printf "\n table created successfully"
							
						
						else
							echo -n ":" >> "$table_name"
						fi
						validMetaData=false
				done
				
			done
			
		else
			echo  "invalid entry" 
			echo press any key
			read
		fi
}


function createTable {


		printf "\n enter the name of the table please\n"
		read table_name
#table name validation


		if [[ $table_name = "" ]]; then
			printf "\n invalid entry \n"
			printf press any key
			read
                       
                 #elif [[ $table_name =~ [\r' '] ]]; then
		#	printf "\nspace not allowed \n"
		#	printf press any key
		#	read
			       
		elif [[ $table_name =~ [/.:\|\-] ]]; then
			echo  "You can't enter these characters"
			echo press any key
			read
			
		
		elif [[ -e "$table_name" ]]; then
			echo "this table name exists"
			echo press any key
			read
			
			
		elif  [[ $table_name =~ ^[a-zA-Z] ]]; then
		       touch $table_name
		      
		       createMetaData;
			
		else
			echo "enter valid Table name "
			echo press any key
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
     
               #check if the dataBase_name Directory exist
               if [[ $db_name =~ [/.:\|\-] ]]; then
                    echo "not valid database name"
               elif [[ -d $db_name ]]
               then
                               cd $db_name
                             
                              if [ "$(ls)" ]; then
                              
		                       printf "\nAll Tables  \n\n"
		                       for i in $(ls); 
				       do
					 echo ${i}; 
				       done
		                          
                               else
                                       printf "\nNO Tables  \n\n"
                                       
			       fi
			        #calling  createTable function
		                           createTable
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
