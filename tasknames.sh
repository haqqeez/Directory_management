#!/bin/bash


######################################################################################################################

# this script is used to add missing subfolders (such as task and subtask and date) to miniscope recordings (new software)

### SPECIFY PARAMETERS BELOW ###



animal="ZHA012/"
task="PAL"
subtask="MustInitiate"

# NOTE: When specifying start and end directory, make sure the start directory actually exists in the folder you're working in.
# end_directory is the NEXT day of recording, after last day of recordings (i.e., first day of recording new subtask); it is NOT inclusive.
# thus, if wanting to include the last day of the month (e.g., 2020_12_31) you should put some nonsense date like 2020_12_35

start_directory="2020_09_25/"
end_directory="2020_09_55/"

######################################################################################################################

main_direct=$(pwd)
dontprint="true"
for d in */ ; do
	if [ "$d" != "$start_directory" ] && [ "$dontprint" == "true" ] ; then
		continue
	else
		dontprint="false"
		if [[ "$d" != "$end_directory" ]] ; then
			echo "$d"
			cd "$d"
			if [ -d "$animal" ] ; then
				cd "$animal"
				if [ ! -d "PAL" ] ; then
					movethis=$(ls)
					ls
					mkdir PAL
					cd PAL/
					mkdir "$subtask"
					cd "$subtask"
					mkdir "$d"
					pwd
					for folder in $movethis; do
						mv ../../"$folder"/ "$d"/
						echo "moving $folder"
					done
					cd "$main_direct"
				else
					echo "$d is good"
					cd "$main_direct"
				fi
			else
				echo "$animal not found in $d"
				cd "$main_direct"
			fi
		else
			break
		fi
	fi
done
