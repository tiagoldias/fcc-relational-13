PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# check if argument does not exist

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]
  then
    AN=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    AN=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' or name='$1'")
  fi
  
  # check if the element is in the database
  if [[ -z $AN ]]
  then
    echo "I could not find that element in the database."
  else
    # query the info about the element
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$AN")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$AN")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$AN")
    case $TYPE_ID in
    1 ) TYPE='metal' ;;
    2 ) TYPE='nonmetal' ;;
    3 ) TYPE='metalloid' ;;
    esac
    AMU=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$AN")
    MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$AN")
    BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$AN")
    echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AMU amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  fi
fi

