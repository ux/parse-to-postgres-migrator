#!/usr/bin/env bash


display_usage() {
  echo -e "\nUsage:\n$0 path/to/parse-export.zip\n"
}


if [ $# -le 0 ]
then
	display_usage
	exit 1
fi

PARSE_FILE=$1

if [ ! -f "$PARSE_FILE" ]
then
  echo "$PARSE_FILE file not found!"
  exit 1
fi

DATA_DIR="`mktemp -d`"
SCRIPT_DIR="`dirname \"$0\"`"

PARSE_DIR="$DATA_DIR/parse"
unzip "$PARSE_FILE" -d "$PARSE_DIR"

PREPARED_DIR="$DATA_DIR/prepared"
`$SCRIPT_DIR/prepare/stackmob-parse-migrator "--import-path=$PARSE_DIR" "--export-path=$PREPARED_DIR"`

if [ $? -ne 0 ]
then
    echo "Failed to prepare parse dump"
fi


rm -r "$DATA_DIR"
