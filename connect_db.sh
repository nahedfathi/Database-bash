#! /bin/bash

select choise in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back To Main Menu"
          do

          case $choise in 
              
              "Create Table")
                              
                              source create_table.sh;;

              "List Tables")
                              
                              source show_table.sh;;
                         

               "Drop Table")

                              source delete_table.sh;;
                              
               "Insert into Table")

                              source insert_to_table.sh;;
                              
               "Select From Table")

                              source select_from_table.sh;;
                              
               "Delete From Table")

                              source delete_from_table.sh;;
                              
                
              "Update Table")

                              source update_table.sh;;


               "Back To Main Menu" )
                             
                               source db_menu.sh;;
                         
                              * )
                              printf "\n Please Select Option From Menu \n";;

          esac
          
          done
          
          
