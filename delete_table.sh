function deleteTable {
	echo enter the name of the table to delete
	read dbtable
	
	#check if table not exist
	if ! [[ -f $dbtable ]]; then
		echo  "this table doesn't exist"
		
	
	else
		rm  $dbtable
		
		echo  "table deleted successfully"
		
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
		                           #calling  deleteTable function
		                           deleteTable
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
