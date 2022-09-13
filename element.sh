#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $# -ne 1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]                     #if argument is a number, assume atomic_number
      then
        WHERE_CLAUSE="e.atomic_number = $1"
    elif [[ ${#1} -le 2 ]]                      #if argument is short, assume symbol
      then
        WHERE_CLAUSE="symbol = '$1'"
    else                                        #assume name
      WHERE_CLAUSE="e.name = '$1'"
    fi
    ELEMENTS=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, atomic_mass, t.type, melting_point_celsius, boiling_point_celsius FROM elements e INNER JOIN properties p USING(atomic_number) INNER JOIN types t USING(type_id) WHERE $WHERE_CLAUSE")
    if [[ -z $ELEMENTS ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENTS" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR ATOMIC_MASS BAR TYPE BAR MP BAR BP
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
      done
    fi
fi
