#!/bin/bash

# set source and destination

src="."
dst="/mnt/e/directory_clone/backup_test_unsorted/"



rsync -amhv --include='*.tar.bz2' --include='*/' --exclude='*' "$src" "$dst"


echo "Done!"
