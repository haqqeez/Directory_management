#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

# check if videos have already been concatenated
concat_check=$(find -type f -name "*_concat.avi" | wc -l)

if (( $concat_check == 0 )); then

  ID=MYID
  printf "file '%s'\n" *.avi | sort -V > myvidlist.txt
  for f in *.avi; do echo "$f" >> mytarlist.txt; done

  # count the total number of frames in all video files
  original_total=0
  for f in *.avi; do
    numframes=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $f)
    original_total=$((original_total+$numframes))
  done
  echo "Total frames is $original_total"

  #concatenate all avi files in myvidlist.txt; name it by "animalID_concat.avi"
  ffmpeg -f concat -safe 0 -i myvidlist.txt -c copy $ID.avi

  # count number of frames in new concatenated video
  new_total=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 "$ID.avi")

  #check if concatenated file has as many frames as original avi files
  if (( $new_total > 0 )) && (( $original_total > 0 )) && (( $new_total == $original_total )); then
    echo "Good! $new_total matches $original_total ; tarring files now..."
    tar -cvf behav_videos.tar -T mytarlist.txt
  else
    echo "ERROR: Concatenated file has $new_total frames; does not match original $original_total frames"
  fi

  # if tar file was succesfully created, delete all old avi files
  if [ -f "behav_videos.tar" ]; then
    echo "Everything concatenated and tarred! Deleting files now..."
    xargs rm <mytarlist.txt
    echo "Files deleted!"
    gosignal=1
  fi

elif (( $concat_check == 1 )); then
  echo "concatenaed video file already exists!"
fi