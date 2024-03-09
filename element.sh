#! /bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id where elements.atomic_number=$1")
else
  RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id where elements.symbol='$1' or elements.name='$1'")
fi

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS='|'
read -ra VALUES <<< "$RESULT"
echo "The element with atomic number ${VALUES[0]} is ${VALUES[2]} (${VALUES[1]}). It's a ${VALUES[9]}, with a mass of ${VALUES[4]} amu. ${VALUES[2]} has a melting point of ${VALUES[5]} celsius and a boiling point of ${VALUES[6]} celsius."
