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
# This will make an identical copy of all subdirectories of where it is run, in a destination folder
## i.e., it will recreate what you see when you type "ls" in the directroy you are running this script (folders only)
### can use to specify file types. For example, only .tar files


src="."
dst="/lustre03/project/rpp-markpb68/m3group/etcetcetc"


rsync -amhv --include='*.tar' --include='*/' --exclude='*' "$d" "$dst"


echo "Done!"
