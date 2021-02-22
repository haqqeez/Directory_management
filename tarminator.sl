#!/bin/bash
#SBATCH --job-name=jan-tarring
#SBATCH --account=rpp-markpb68
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

initials='ZHA'

pwdirectory=$(pwd)
data=$(find $pwdirectory -type d -name "BehavCam_0")

for session in $data
do
	cd $session

	ID=$initials${session#*$initials}
	ID=${ID::6}
	date=202${session#*202}; date=${date::10}
	ID=$(echo ${ID}_${date})

	cd ../../
	tar_check=$(find -type f -name "*.tar" | wc -l)

	if (( $tar_check == 0 ))
	then
		echo "ttttttttttttttttttttttttttttttttttttttttttttttar-ing $ID in $session"
		tar -cvf "$ID.tar" .
	else
		echo "CHECKED: Already tar-ed $ID in $session"
	fi
done

echo "Done!"
