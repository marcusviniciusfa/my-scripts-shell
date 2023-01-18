#!/bin/bash

if [ "$#" -eq 1 -a "$1" = "-h" -o "$1" = "--help" ]
then
  echo "usage:"
  echo "./key_generation.sh [-h | --help]"
  echo "./key_generation.sh [VALUE] [LENGTH_KEY]"
  echo "./key_generation.sh \"sample\" 10"
  exit 0
fi

VALUE_INPUT=$1
LENGTH_KEY_INPUT=$2

keyGenerator() {
  if [ -z "$LENGTH_KEY_INPUT" ]
  then
    echo -n "$VALUE_INPUT" | shasum -a 256 | cut -f 1 -d " "
  else
    echo -n "$VALUE_INPUT" | shasum -a 256 | cut -f 1 -d " " | cut -c -"$LENGTH_KEY_INPUT"
  fi
  return 0
}

numericalValueChecker() {
  echo "$LENGTH_KEY_INPUT" | egrep "^[0-9]+$" > /dev/null 2>&1
  return "$?"
}

while [ -z $VALUE_INPUT ]
do
  read -p "enter some value to turn into key: " VALUE_INPUT
done

if [ -z "$LENGTH_KEY_INPUT" ]
then
  read -p "does the key need to be a specific length? [y/n]: " LENGTH_IS_REQUIRED
  case "$LENGTH_IS_REQUIRED" in
    "y")
      read -p "enter key length: " LENGTH_KEY_INPUT
      ;;
    *)
      keyGenerator "$VALUE_INPUT"
      exit 0
      ;;
  esac
fi

numericalValueChecker "$LENGTH_KEY_INPUT"
while [ "$?" -ne 0 ]
do
  echo "error: key value must be numeric, positive and integer"
  read -p "enter key length: " LENGTH_KEY_INPUT
  numericalValueChecker "$LENGTH_KEY_INPUT"
done

keyGenerator "$VALUE_INPUT" "$LENGTH_KEY_INPUT"
exit
