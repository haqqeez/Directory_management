#!/bin/bash

#### This script deletes everything in one go, no warning! ###


## Change pwd if you'd like to change the parent directory of where this script runs

pwd=$(pwd)

## Change string to match what characters the files(s) you're trying to delete contian

string="INSERT_STRING_HERE"

## Change directory="false" if you want to delete directories, rather than files

directory="false"

###############################################


if [[ "$directory" == "false" ]]
then
	file_list=$(find $pwd -type f -name $string)

	for file in $file_list; do
		echo "$file"
		rm "$file"
	done
else
	folder_list=$(find $pwd -type d -name $string)

	for folder in $folder_list; do
		echo "$folder"
		rm "$folder"
	done
fi
