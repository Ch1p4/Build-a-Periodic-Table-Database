#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

[[ -z $1 ]] \
  && echo "Please provide an element as an argument." \
    && exit

[[ $1 =~ ^[0-9]+$ ]] \
  && ATOM_NUM=$($PSQL "select atomic_number from elements where atomic_number = $1" | sed "s/ //g")
[[ -z $ATOM_NUM ]] \
  && ATOM_NUM=$($PSQL "select atomic_number from elements where name = '$1' or symbol = '$1'" | sed "s/ //g")

[[ -z $ATOM_NUM ]] \
  && echo "I could not find that element in the database." \
    && exit

ELEM=$($PSQL "select name from elements where atomic_number = $ATOM_NUM" | sed "s/ //g")
SYM=$($PSQL "select symbol from elements where atomic_number = $ATOM_NUM" | sed "s/ //g")
TYPE=$($PSQL "select type from types full join properties using(type_id) where atomic_number = $ATOM_NUM" | sed "s/ //g")
MASS=$($PSQL "select atomic_mass from properties where atomic_number = $ATOM_NUM" | sed "s/ //g")
M_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number = $ATOM_NUM" | sed "s/ //g")
B_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number = $ATOM_NUM" | sed "s/ //g")

echo "The element with atomic number $ATOM_NUM is $ELEM ($SYM). It's a $TYPE, with a mass of $MASS amu. $ELEM has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
