!#/bin/bash

for d in */ ; do
	rsync --verbose --archive "$d" /mnt/e/directory_clone/Haqqee/batch_4/reorganized/ 
done
