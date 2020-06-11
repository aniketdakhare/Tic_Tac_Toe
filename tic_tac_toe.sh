#!/bin/bash -x

echo -e "\nWelcome to Tic Tac Toe Game\n"

#constants
ROWS=3
COLUMNS=3
PLAYER_SYMBOL=''
COMPUTER_SYMBOL=''
EMPTY='.'

#variables
place=1
chance=''

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

function symbol_Selection()
{

   select_Symbol=$1
	case $select_Symbol in
   	1)
			PLAYER_SYMBOL=X
			COMPUTER_SYMBOL=O ;;
      2)
			PLAYER_SYMBOL=O
         COMPUTER_SYMBOL=X ;;
   esac
	echo -e "\nYour Symbol is '$PLAYER_SYMBOL' and Computer's Symbol is '$COMPUTER_SYMBOL'"
}


function who_is_First()
{
	toss=$((RANDOM%2))
	case $toss in
		1)
			chance=$toss
      	echo -e "You won the toss. It's your Chance \nSelect the valid option for symbol: \n\n1. 'X' \n\n2. 'O' "
			read select_Symbol
			symbol_Selection $select_Symbol ;;
		0)
			chance=$toss
         echo -e "Computer Won the toss. It's Computer's Chance\n"
			select_Symbol=$(($((RANDOM%2))+1))
			symbol_Selection $select_Symbol ;;
	esac
}

function winner()
{
   local mark=$1

   if [ ${place_Value[0,0]} == $mark ] && [ ${place_Value[0,1]} == $mark ] && [ ${place_Value[0,2]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[1,0]} == $mark ] && [ ${place_Value[1,1]} == $mark ] && [ ${place_Value[1,2]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[2,0]} == $mark ] && [ ${place_Value[2,1]} == $mark ] && [ ${place_Value[2,2]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[0,0]} == $mark ] && [ ${place_Value[1,0]} == $mark ] && [ ${place_Value[2,0]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[0,1]} == $mark ] && [ ${place_Value[1,1]} == $mark ] && [ ${place_Value[2,1]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[0,2]} == $mark ] && [ ${place_Value[1,2]} == $mark ] && [ ${place_Value[2,2]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[0,0]} == $mark ] && [ ${place_Value[1,1]} == $mark ] && [ ${place_Value[2,2]} == $mark ]
   then
      echo 1
   elif [ ${place_Value[2,0]} == $mark ] && [ ${place_Value[1,1]} == $mark ] && [ ${place_Value[0,2]} == $mark ]
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
	who_is_First
}

function play()
{
   board_Reset
   board_Display
}
play
