#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_DATA=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_DATA ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME')" > /dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  IFS="|" read USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS_COUNT=0

echo "Guess the secret number between 1 and 1000:"

while read GUESS
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    (( GUESS_COUNT++ ))
    if [[ $GUESS -eq $SECRET_NUMBER ]]
    then
      break
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  fi
done

echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

$PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESS_COUNT, $SECRET_NUMBER)" > /dev/null

USER_STATS=$($PSQL "SELECT games_played, best_game FROM users WHERE user_id=$USER_ID")
IFS="|" read OLD_GAMES_PLAYED OLD_BEST_GAME <<< "$USER_STATS"
NEW_GAMES_PLAYED=$(( OLD_GAMES_PLAYED + 1 ))

if [[ -z $OLD_BEST_GAME || $GUESS_COUNT -lt $OLD_BEST_GAME ]]
then
  NEW_BEST_GAME=$GUESS_COUNT
else
  NEW_BEST_GAME=$OLD_BEST_GAME
fi

$PSQL "UPDATE users SET games_played=$NEW_GAMES_PLAYED, best_game=$NEW_BEST_GAME WHERE user_id=$USER_ID" > /dev/null
# Script generates a random number between 1 and 1000
