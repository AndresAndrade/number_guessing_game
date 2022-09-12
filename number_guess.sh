#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_AVAILABLE=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME'";)
BEST_GAME=$($PSQL "SELECT MIN(number_of_tries) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME';")

if [[ -z $USERNAME_AVAILABLE ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."  
fi

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
TRIES=1
echo "Guess the secret number between 1 and 1000:"

while read NUMBER
do
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $NUMBER -eq $RANDOM_NUMBER ]]
    then
      break;
    else
      if [[ $NUMBER -gt $RANDOM_NUMBER ]]
      then
        echo -n "It's lower than that, guess again:"
        elif [[ $NUMBER -lt $RANDOM_NUMBER ]]
        then
          echo -n "It's higher than that, guess again:"
      fi  
    fi
  fi
  TRIES=$(( $TRIES + 1 ))
done

if [[ $TRIES == 1 ]]
then
  echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
else
  echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"  
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")
INSERT_GAME=$($PSQL "INSERT INTO games(number_of_tries, user_id) VALUES($TRIES, $USER_ID);")