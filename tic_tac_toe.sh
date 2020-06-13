#!/bin/bash -x

echo -e "\nWelcome to Tic Tac Toe Game\n"

#constants
ROWS_COLUMNS=3
PLAYER_SYMBOL=''
COMPUTER_SYMBOL=''

#variables
place=1
chance=''

declare -A placeValue

#Function  to Resets the board
function boardReset() {
	for ((i=0; i<ROWS_COLUMNS; i++))
	do
		for ((j=0; j<ROWS_COLUMNS; j++))
		do
			placeValue[$i,$j]=$place
                        ((place++))
		done
	done
	firstChance
}

#function to Display the board
function boardDisplay() {
        echo -e "****** TicTacToe Game ******\n"
        local i=0
        local j=0
        for (( i=0; i<ROWS_COLUMNS; i++ ))
        do
                for (( j=0; j<ROWS_COLUMNS; j++ ))
                do
                        echo -n "   ${placeValue[$i,$j]}    "
                done
                printf "\n\n"
        done
}

#Function to check who can play first
function firstChance() {
	toss=$((RANDOM%2))
	case $toss in
		1)
			chance=$toss
			echo -e "You won the toss. It's your Chance \nSelect the valid option for symbol: \n\n1. 'X' \n\n2. 'O' "
			read selectSymbol
			symbolSelection $selectSymbol ;;
		0)
			chance=$toss
			echo -e "Computer Won the toss. It's Computer's Chance\n"
			selectSymbol=$(($((RANDOM%2))+1))
			symbolSelection $selectSymbol ;;
	esac
}

#Funtion to select the Symbol as X or O
function symbolSelection() {
        selectSymbol=$1
        case $selectSymbol in
                1)
                        PLAYER_SYMBOL=X
                        COMPUTER_SYMBOL=O ;;
                2)
                        PLAYER_SYMBOL=O
                        COMPUTER_SYMBOL=X ;;
        esac
        echo -e "\nYour Symbol is '$PLAYER_SYMBOL' and Computer's Symbol is '$COMPUTER_SYMBOL'\n"
}

#Main function to start game
function playGame() {
	boardReset
	row=0
	column=0
	for (( i=0; i<$(($ROWS_COLUMNS*$ROWS_COLUMNS)); i++ ))
	do
		boardDisplay
		checkWin=2
		case $chance in
			1)
				echo -e "---------YOUR CHANCE----------\n"
				player
				checkWin=$? ;;
			0)
				echo -e "-------COMPUTER CHANCE--------\n"
				computer
				checkWin=$? ;;
		esac
		if [ $checkWin -eq 5 ]
                then
			boardDisplay
                	return 0
                fi
	done
	echo -e "----Match Tie----\n"
	boardDisplay
}

#Function for the player to play game.
function player() {
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
		if [ ${placeValue[$row,$column]} == $PLAYER_SYMBOL ] || [ ${placeValue[$row,$column]} == $COMPUTER_SYMBOL ]
		then
			echo -e "\nThe cell is already filled. Please select another cell. \n"
			((i--))
		else
			placeValue[$row,$column]=$PLAYER_SYMBOL
			winner $PLAYER_SYMBOL
			winnerReturn=$?
			if [ $winnerReturn -eq 1 ]
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

#Function for the computer to play game.
function computer() {
	computerMind
	winner $COMPUTER_SYMBOL
        winnerReturn=$?
        if [ $winnerReturn -eq 1 ]
        then
                echo -e "Computer Won !!!\n"
                return 5
        fi
	chance=1
}

#Function for the computer to think like human inorder to play game
function computerMind() {
	local returnValue=''
        rowColumnDigonalCondition $COMPUTER_SYMBOL $PLAYER_SYMBOL
	returnValue=$?
	if [ $returnValue -ne 9 ]
	then
		rowColumnDigonalCondition $PLAYER_SYMBOL $COMPUTER_SYMBOL
                returnValue=$?
                if [ $returnValue -ne 9 ]
                then
                        cornersCentreSide
        	        return
                fi
	fi
	return
}

#Function for the computer to determine condition for checking winning places and blocking the player
function rowColumnDigonalCondition() {
        local cellValue=0
        symbol1=$1
        symbol2=$2
        for ((cellValue=0; cellValue<ROWS_COLUMNS; cellValue++))
        do
               	if [ ${placeValue[$cellValue,0]} == $symbol1 ] && [ ${placeValue[$(($cellValue)),1]} == $symbol1 ]
               	then
                       	if [ ${placeValue[$cellValue,2]} != $symbol2 ]
                       	then
                               	placeValue[$cellValue,2]=$COMPUTER_SYMBOL
                               	return 9
                       	fi
               	elif [ ${placeValue[$cellValue,1]} == $symbol1 ] && [ ${placeValue[$cellValue,2]} == $symbol1 ]
               	then
               	        if [ ${placeValue[$cellValue,0]} != $symbol2 ]
               	        then
               	                placeValue[$cellValue,0]=$COMPUTER_SYMBOL
               	                return 9
               	        fi
               	elif [ ${placeValue[$cellValue,0]} == $symbol1 ] && [ ${placeValue[$cellValue,2]} == $symbol1 ]
               	then
               	        if [ ${placeValue[$cellValue,1]} != $symbol2 ]
               	        then
               	                placeValue[$cellValue,1]=$COMPUTER_SYMBOL
               	                return 9
               	        fi
               	elif [ ${placeValue[0,$cellValue]} == $symbol1 ] && [ ${placeValue[1,$cellValue]} == $symbol1 ]
               	then
               	        if [ ${placeValue[2,$cellValue]} != $symbol2 ]
               	        then
               	                placeValue[2,$cellValue]=$COMPUTER_SYMBOL
				return 9
               	        fi
               	elif [ ${placeValue[1,$cellValue]} == $symbol1 ] && [ ${placeValue[2,$cellValue]} == $symbol1 ]
               	then
               	        if [ ${placeValue[0,$cellValue]} != $symbol2 ]
               	        then
               	                placeValue[0,$cellValue]=$COMPUTER_SYMBOL
               	                return 9
               	        fi
               	elif [ ${placeValue[0,$cellValue]} == $symbol1 ] && [ ${placeValue[2,$cellValue]} == $symbol1 ]
               	then
               	        if [ ${placeValue[1,$cellValue]} != $symbol2 ]
               	        then
               	                placeValue[1,$cellValue]=$COMPUTER_SYMBOL
               	                return 9
               	        fi
		fi
        done
        if [ ${placeValue[0,0]} == $symbol1 ] &&  [ ${placeValue[1,1]} == $symbol1 ]
        then
                if [ ${placeValue[2,2]} != $symbol2 ]
                then
                        placeValue[2,2]=$COMPUTER_SYMBOL
                        return 9
                fi
        elif [ ${placeValue[1,1]} == $symbol1 ] && [ ${placeValue[2,2]} == $symbol1 ]
        then
                if [ ${placeValue[0,0]} != $symbol2 ]
                then
                        placeValue[0,0]=$COMPUTER_SYMBOL
                        return 9
                fi
        elif [ ${placeValue[0,0]} == $symbol1 ] && [ ${placeValue[2,2]} == $symbol1 ]
        then
                if [ ${placeValue[1,1]} != $symbol2 ]
                then
                        placeValue[1,1]=$COMPUTER_SYMBOL
                        return 9
                fi
        elif [ ${placeValue[2,0]} == $symbol1 ] &&  [ ${placeValue[1,1]} == $symbol1 ]
        then
                if [ ${placeValue[0,2]} != $symbol2 ]
                then
                        placeValue[0,2]=$COMPUTER_SYMBOL
                        return 9
                fi
        elif [ ${placeValue[1,1]} == $symbol1 ] && [ ${placeValue[0,2]} == $symbol1 ]
        then
                if [ ${placeValue[2,0]} != $symbol2 ]
                then
                        placeValue[2,0]=$COMPUTER_SYMBOL
                        return 9
                fi
        elif [ ${placeValue[2,0]} == $symbol1 ] && [ ${placeValue[0,2]} == $symbol1 ]
        then
                if [ ${placeValue[1,1]} != $symbol2 ]
                then
                        placeValue[1,1]=$COMPUTER_SYMBOL
                        return 9
                fi
	else
		return 3
	fi
}

#Function for the computer to determine condition for grtting to the corners, centre and any of the sides
function cornersCentreSide() {
	if [ ${placeValue[0,0]} != $PLAYER_SYMBOL ] && [ ${placeValue[0,0]} != $COMPUTER_SYMBOL ]
	then
		placeValue[0,0]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[0,2]} != $PLAYER_SYMBOL ] && [ ${placeValue[0,2]} != $COMPUTER_SYMBOL ]
	then
		placeValue[0,2]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[2,0]} != $PLAYER_SYMBOL ] && [ ${placeValue[2,0]} != $COMPUTER_SYMBOL ]
	then
        	placeValue[2,0]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[2,2]} != $PLAYER_SYMBOL ] && [ ${placeValue[2,2]} != $COMPUTER_SYMBOL ]
	then
        	placeValue[2,2]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[1,1]} != $PLAYER_SYMBOL ] && [ ${placeValue[1,1]} != $COMPUTER_SYMBOL ]
	then
		placeValue[1,1]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[0,1]} != $PLAYER_SYMBOL ] && [ ${placeValue[0,1]} != $COMPUTER_SYMBOL ]
	then
		placeValue[0,1]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[1,2]} != $PLAYER_SYMBOL ] && [ ${placeValue[1,2]} != $COMPUTER_SYMBOL ]
	then
		placeValue[1,2]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[2,1]} != $PLAYER_SYMBOL ] && [ ${placeValue[2,1]} != $COMPUTER_SYMBOL ]
	then
		placeValue[2,1]=$COMPUTER_SYMBOL
		return
	elif [ ${placeValue[1,0]} != $PLAYER_SYMBOL ] && [ ${placeValue[1,0]} != $COMPUTER_SYMBOL ]
	then
		placeValue[1,0]=$COMPUTER_SYMBOL
		return
	fi
}

#Function to check the winning conditions
function winner() {
	local mark=$1
	for ((value=0; value<ROWS_COLUMNS; value++))
	do
		if [ ${placeValue[$value,0]} == $mark ] && [ ${placeValue[$value,1]} == $mark ] && [ ${placeValue[$value,2]} == $mark ]
		then
			return 1
		elif [ ${placeValue[0,$value]} == $mark ] && [ ${placeValue[1,$value]} == $mark ] && [ ${placeValue[2,$value]} == $mark ]
                then
                        return 1
                fi
	done
	if [ ${placeValue[0,0]} == $mark ] && [ ${placeValue[1,1]} == $mark ] && [ ${placeValue[2,2]} == $mark ]
	then
		return 1
	elif [ ${placeValue[2,0]} == $mark ] && [ ${placeValue[1,1]} == $mark ] && [ ${placeValue[0,2]} == $mark ]
	then
		return 1
	else
		return 7
	fi
}

#Main function call
playGame
