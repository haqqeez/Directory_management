#!/bin/bash

########################################################################################

# This script specifcally sends scripts out to tar and delete avi files in either miniscope of behavcam directories, assuming prelim analyses are done

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID
### Note that this and the email input are both OPTIONAL! If you put nothing, or put something incorrect, the script will likely still launch your jobs.
###### Except that the job names might look strange and you won't get e-mail notifications

# NOTE: This script will only run if CNMF-E or DLC has been completed in the directory which it targets

# for example, the animal "ZHA001" has initials "ZHA" and IDlength 6
initials="ZHA"
IDlength=6

### Enter your e-mail below
email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)
### The script will search from *this* directory onwards for either Miniscope, Miniscope_2, or BehavCam_0 folders.
root_directory=$(pwd)

# put either "miniscope" or "behaviour" depending on type of avi files you want to target for tar
tar_files_type="miniscope"

minimum_size=1M # minimum video file size; default is 1M (1 megabyte)
minimum_number=3 # minimum number of video files; set this to 1 if you've already concatenated your videos


########################################################################################

if [[ "$tar_files_type" == "miniscope" ]]; then
	tarname='"ms_videos.tar"'

	data=$(find $root_directory -type d -name "Miniscope" -o -name "Miniscope_2")
elif [[ "$tar_files_type" == "behaviour" ]]; then
	data=$(find $root_directory -type d -name "BehavCam_0")
	tarname='"behav_videos.tar"'
fi

taskname="tar"

for session in $data
do
	cd $session

	numVideos=$(find -maxdepth 1 -type f -name "*.avi" | wc -l)
	videoThreshold=$(find -maxdepth 1 -type f -size +$minimum_size -name "*.avi" | wc -l)
	tar_check=$(find -type f -name $tarname | wc -l)
	filepart_check=$(find -type f -name "*filepart" | wc -l)

	DLC_data=$(find -type f -name "*DLC*.csv" | wc -l)

	if (( $tar_check == 1 )); then
		echo "SKIPPED: $session already has $tarname"
	elif (( $numVideos < $minimum_number )); then
		echo "SKIPPED: too few video files to tar $session"
	elif (( $numVideos < $videoThreshold )) || (( $filepart_check != 0 )); then
		echo "ERROR: Some video files may be too small or corrupt in $session"

	elif [[ $tar_files_type == "miniscope" && -f "ms.mat" && -f "SFP.mat" && -f "0.avi" ]] || [[ $tar_files_type == "behaviour" && (( $DLC_data > 0 )) && -f "0.avi" ]]; then
		echo "Tarring $session"
		ID=$initials${session#*$initials}
		ID=${ID::$IDlength}
		date=202${session#*202}; date=${date::10}
		animalID="$ID-$date$end"
		ID="$taskname-$ID-$date"

		cp /lustre03/project/rpp-markpb68/m3group/Haqqee/GitHub/Directory_management/tar_and_delete.sl .
		sleep 2
		sed -i -e "s/TASKNAME/$ID/g" tar_and_delete.sl
		sed -i -e "s/FILETYPE/$tarname/g" tar_and_delete.sl
		sed -i -e "s/MINSIZE/$minimum_size/g" tar_and_delete.sl
		sed -i -e "s/MINUM/$minimum_number/g" tar_and_delete.sl
		sed -i -e "s/MYEMAIL/$email/g" tar_and_delete.sl
		sbatch tar_and_delete.sl
		sleep 2

	else
		echo "ERROR: Not ready for tar yet; check videos and matlab or DLC files exist in $session"
	fi
done
