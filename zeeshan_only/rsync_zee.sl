#!/bin/bash
#SBATCH --job-name=jan_rsync
#SBATCH --account=rpp-markpb68
#SBATCH --time=11:00:00
#SBATCH --nodes=1
#SBATCH --dependency=afterok:16365810
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL


# set source and destination

src="."
dst="/lustre03/project/rpp-markpb68/m3group/Haqqee/data/PAL_CA1/"


for d in */ ; do
	rsync -amhv --include='*.tar' --include='*/' --exclude='*' "$d" "$dst"
done


echo "Done!"
