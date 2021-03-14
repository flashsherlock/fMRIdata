#!/bin/tcsh 
# menu interface to simple commands 
# set input_line = ''
# echo "\n        COMMAND MENU\n"
# echo " a. Current date and time"
# echo " b. Users currently logged in"
# echo " c. Name of the working directory"
# echo " d. Contents of the working directory\n"
# echo -n "Enter a, b, c, or d: "
# set input_line = "$<"
# # 
# switch ($input_line)
#     case [aA*]:
#             date
#             breaksw
#     case [bB*]:
#             who
#             breaksw
#     case [cC*]:
#             pwd
#             breaksw
#     case [dD*]:
#             ls
#             breaksw
#     default:
#             echo "There is no selection: $input_line"
# endsw
# # successful
# echo $1
switch ($1)
    case b:
        set analysis=pabiode
        echo ${analysis}
        breaksw
    case p:
        set analysis=paphde
        echo ${analysis}
        breaksw
    default:
        echo $1
endsw
