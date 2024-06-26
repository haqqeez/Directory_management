#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:10:00
#SBATCH --mem=2000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

# replace below with name of filetype, e.g., ms_videos.tar
filetype=FILETYPE
# replace below with minimum file size for videos, e.g., 1M
minsize=MINSIZE
# replace below with minimum number of files to have before tarring, e.g., 3
minum=MINUM

ID=MYID

############################################################################################

# check if videos have already been concatenated
concat_check=$(find -type f -name "*_concat.avi" | wc -l)

if (( $concat_check == 0 )); then

  # check if .tar files already exist in directory
  tar_check=$(find -maxdepth 1 -type f -name $filetype | wc -l)

  # estimate size of all avi files based on size of 0.avi x number of files > threshold size
  videosize=$(wc -c <"0.avi")
  videoThreshold=$(find -maxdepth 1 -type f -size +$minsize -name "*.avi" | wc -l)
  video_size_estimate=$(( (videoThreshold-1)*videosize ))

  # check to make sure fileparts (incomeplete files) don't exist
  filepart_check=$(find -type f -name "*filepart" | wc -l)

  # count number of avi files
  numVideos=$(find -maxdepth 1 -type f -name "*.avi" | wc -l)

  if [ -f "myvidlist.txt" ]; then
    echo "renaming existing myvidlist.txt to previousvidlist.txt" 
    mv myvidlist.txt previousvidlist.txt
  fi

  if [ -f "mytarlist.txt" ]; then
    echo "renaming existing mytarlist.txt to previoustarlist.txt"
    mv mytarlist.txt previoustarlist.txt
  fi

  if (( $tar_check == 0 )) && (( $filepart_check == 0 )) && (( $numVideos > $minum )) && (( $numVideos == $videoThreshold )); then
  
    printf "file '%s'\n" *.avi | sort -V > myvidlist.txt
    for f in *.avi; do echo "$f" >> mytarlist.txt; done

    # count the total number of frames in all video files
    original_total=0
    for f in *.avi; do
      numframes=$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 $f)
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
      tar -cvf $filetype -T mytarlist.txt
    else
      echo "ERROR: Concatenated file has $new_total frames; does not match original $original_total frames"
    fi

    # if tar file was succesfully created, delete all old avi files
    if [ -f $filetype ]; then
      echo "Everything concatenated and tarred! Deleting files now..."
      xargs rm <mytarlist.txt
      echo "Files deleted!"
      gosignal=1
    fi
  fi
elif (( $concat_check == 1 )); then
  echo "concatenaed video file already exists!"
fi
