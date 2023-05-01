#! /bin/bash


printf "\nWelcome To Database Menu\n\n"
   select choise in "Create DataBase" "List Databases" "Connect To Databases" "Drop Database" "Exit the program" 
          do

          case $choise in 
              
              "Create DataBase")
                              
                              source create_db.sh;;

              "List Databases")
                              
                              source show_db.sh;;
                         
          
              "Connect To Databases")

                              source connect_db.sh;;

               "Drop Database")

                              source drop_db.sh;;

               "Exit the program" )
                             
                              exit ;;
                         
                              * )
                              printf "\n Please Select Option From Menu \n";;

          esac
          
          done
