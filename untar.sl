#!/bin/bash
#SBATCH --job-name=untarring001
#SBATCH --account=rpp-markpb68
#SBATCH --time=7:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

pwdirectory=$(pwd)

echo "Now un-taring"
data=$(find $pwdirectory -type f -name "*.tar")

for file in $data
do
	echo "-------------untarring $file"
	cd "$(find $file -printf '%h' -quit)"
	tar -xvf "$file"
done

echo "Done untarring!"
