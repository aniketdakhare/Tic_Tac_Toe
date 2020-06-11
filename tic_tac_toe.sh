#!/bin/bash -x

echo -e "\nWelcome to Tic Tac Toe Game\n"

#constants
ROWS_COLUMNS=3
PLAYER_SYMBOL=''
COMPUTER_SYMBOL=''

#variables
place=1
chance=''

declare -A place_Value

function board_Reset()
{
	for ((i=0; i<ROWS_COLUMNS; i++))
	do
		for ((j=0; j<ROWS_COLUMNS; j++))
		do
			place_Value[$i,$j]=$place
                        ((place++))
		done
	done
	who_is_First
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
        echo -e "\nYour Symbol is '$PLAYER_SYMBOL' and Computer's Symbol is '$COMPUTER_SYMBOL'\n"
}

function play_Game()
{
	board_Reset
	row=0
	column=0
	for (( i=0; i<$(($ROWS_COLUMNS*$ROWS_COLUMNS)); i++ ))
	do
		board_Display
		check_win=2
		case $chance in
			1)
				echo -e "---------YOUR CHANCE----------\n"
				player
				check_win=$? ;;
			0)
				computer
				check_win=$? ;;
		esac
		if [ $check_win -eq 5 ]
                then
			board_Display
                	return 0
                fi
	done
	echo -e "----Match Tie----\n"
	board_Display
}

function player()
{
	read -p "Select the number for the Cell you want to mark:  " cell
	printf "\n"
	if [ $cell -le $(($ROWS_COLUMNS*$ROWS_COLUMNS)) ]
	then
		row=$(( $cell/$ROWS_COLUMNS ))
		column=$(( $cell%$ROWS_COLUMNS ))
		case $column in
			0)
				row=$(( $row-1 ))
				column=$(( $column+2 )) ;;
			*)
				column=$(( $column-1 )) ;;
		esac
		if [ ${place_Value[$row,$column]} == $PLAYER_SYMBOL ] || [ ${place_Value[$row,$column]} == $COMPUTER_SYMBOL ]
		then
			echo -e "\nThe cell is already filled. Please select another cell. \n"
			((i--))
		else
			place_Value[$row,$column]=$PLAYER_SYMBOL
			if [ $(winner $PLAYER_SYMBOL) -eq 1 ]
			then
				echo -e "Congrats You Won !!!\n"
				return 5
			fi
			chance=0
		fi
	else
		echo -e "Invalid Input\n"
		((i--))
	fi
}

function computer()
{
	computer_mind
	if [ $(winner $COMPUTER_SYMBOL) -eq 1 ]
	then
		echo -e "Computer Won !!!\n"
		return 5
	fi
	chance=1
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
	for (( i=0; i<ROWS_COLUMNS; i++ ))
	do
		for (( j=0; j<ROWS_COLUMNS; j++ ))
		do
			echo -n "   ${place_Value[$i,$j]}    "
		done
		printf "\n\n"
	done
}

play_Game
