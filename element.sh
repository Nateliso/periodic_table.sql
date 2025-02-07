#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument was provided
if [[ -z $1 ]]; 
then  
  echo "Please provide an element as an argument."  # feat: added argument validation to script
else
  # Query the database for element information
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1'")  # feat: implemented database query for element details
  # Check if the query returned a result
  if [[ -z $ELEMENT_INFO ]]; then  
    echo "I could not find that element in the database."  # refactor: handled case where element does not exist
  else
    # Display the formatted output
    echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius." # refactor: formatted and displayed element information
    done
  fi
fi
