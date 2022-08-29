#!/usr/bin/env bash

#wd=/data/pure3d_dev
#scan_script=docker-compose-multiple-scan.sh
#
#for file in "$wd"/*; do
#  if [ -d $file ]; then
#    source $file/.env
#    export USERNAME
#    bash $file/$scan_script
#  fi
#done

/data/voyager/docker-compose-single-scan.sh
