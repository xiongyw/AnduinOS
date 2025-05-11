#!/bin/bash

# this script is to clean the git workspace in case the build process failed.

sudo umount ./src/new_building_os/run
sudo umount ./src/new_building_os/proc
sudo umount ./src/new_building_os/sys
sudo umount ./src/new_building_os/dev/pts
sudo umount ./src/new_building_os/dev

sudo umount ./src/image/isolinux/efi

sudo chmod u+w ./src/new_building_os
sudo rm -rf ./src/new_building_os
git clean -nfxd
git clean -fxd


