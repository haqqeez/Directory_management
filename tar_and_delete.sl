#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:20:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

# replace below with name of filetype, e.g., ms_videos.tar
filetype=FILETYPE
# replace below with minimum file size for videos, e.g., 1M
minsize=MINSIZE
# replace below with minimum number of files to have before tarring, e.g., 3
minum=MINUM

############################################################################################

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

  #tar only the miniscope avi videos from myvidlist.txt
  tar -cvf $filetype -T mytarlist.txt

  # if tar file was succesfully created, delete all old avi files
  if [ -f $filetype ]; then
    tarsize=$(wc -c <$filetype)
    if (( $tarsize > $video_size_estimate )) && (( $video_size_estimate > 0 )); then
      echo "Everything tarred! Deleting files now..."
      xargs rm <mytarlist.txt
      echo "Files deleted!"
    else
      echo "ERROR: tar may be too small, or videos corrupt!"
    fi
  fi

elif (( $tar_check == 1 )); then
  echo "videos have already been tarred!"
else
  echo "ERROR: Something wrong. Did not tar or delete."
fi
