#!/usr/bin/env bash


display_usage() {
  echo
  echo "Usage:"
  echo "$0 path/to/parse-export.zip db-name [optional-arguments]"
  echo
  echo "Optional arguments:"
  echo "--dbuser [user] (default to current account)"
  echo "--dbpassword [password] (default to current account)"
  echo "--host [host] (default to localhost)"
  echo
}


if [ $# -le 0 ]
then
	display_usage
	exit 1
fi

PARSE_FILE=$1
DB_NAME=$2

if [ ! -f "$PARSE_FILE" ]
then
  echo "$PARSE_FILE file not found!"
  exit 1
fi

if [ -z "$DB_NAME" ]
then
  echo "Database is not specified!"
  exit 1
fi

DATA_DIR="`mktemp -d`"
SCRIPT_DIR="`dirname \"$0\"`"

PARSE_DIR="$DATA_DIR/parse"
unzip "$PARSE_FILE" -d "$PARSE_DIR"

PREPARED_DIR="$DATA_DIR/prepared"
`$SCRIPT_DIR/bin/prepare-parse-dump "--import-path=$PARSE_DIR" "--export-path=$PREPARED_DIR"`

if [ $? -ne 0 ]
then
  rm -r "$DATA_DIR"
  echo "Failed to prepare parse dump"
  exit 1
fi


`$SCRIPT_DIR/bin/parse-db-import "--path=$PREPARED_DIR" --adapter=postgresql "--dbname=$DB_NAME" ${@:3}`

if [ $? -ne 0 ]
then
  rm -r "$DATA_DIR"
  echo "Failed to import prepared data"
  exit 1
fi


rm -r "$DATA_DIR"
