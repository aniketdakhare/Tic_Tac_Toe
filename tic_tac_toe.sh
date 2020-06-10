#!/bin/bash -x

echo -e "\nWelcome to Tic Tac Toe Game\n"

#constants
ROWS=3
COLUMNS=3
EMPTY=0

#variables
place=1

declare -A place_Value

function board_Reset()
{
   for ((i=0; i<ROWS; i++))
   do
      for ((j=0; j<COLUMNS; j++))
      do
         place_Value[$i,$j]=$EMPTY
      done
   done
}

function winner()
{
   local symbol=$1

   if [ ${place_Value[0,0]} == $symbol ] && [ ${place_Value[0,1]} == $symbol ] && [ ${place_Value[0,2]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[1,0]} == $symbol ] && [ ${place_Value[1,1]} == $symbol ] && [ ${place_Value[1,2]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[2,0]} == $symbol ] && [ ${place_Value[2,1]} == $symbol ] && [ ${place_Value[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[0,0]} == $symbol ] && [ ${place_Value[1,0]} == $symbol ] && [ ${place_Value[2,0]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[0,1]} == $symbol ] && [ ${place_Value[1,1]} == $symbol ] && [ ${place_Value[2,1]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[0,2]} == $symbol ] && [ ${place_Value[1,2]} == $symbol ] && [ ${place_Value[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[0,0]} == $symbol ] && [ ${place_Value[1,1]} == $symbol ] && [ ${place_Value[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${place_Value[2,0]} == $symbol ] && [ ${place_Value[1,1]} == $symbol ] && [ ${place_Value[0,2]} == $symbol ]
   then
      echo 1
   else
      echo 0
   fi
}


function board_Display()
{
   echo -e "****** TicTacToe Game ******\n"
   local i=0
   local j=0
   for (( i=0; i<ROWS; i++ ))
   do
      for (( j=0; j<COLUMNS; j++ ))
      do
          place_Value[$i,$j]=$place
         ((place++))
         echo -n "   ${place_Value[$i,$j]}    "
      done
    printf "\n\n"
   done
}

function play()
{
   board_Reset
   board_Display
}
play
