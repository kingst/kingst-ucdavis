#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url video_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
video_url=$2
cwd=`pwd`

cd ${cwd}/scripts
source venv/bin/activate
python add_lecture_to_reading_list_no_code.py "${slides_url}" "${video_url}"

#python download_reading_list.py ../classes/w20-ecs251/reading_list.csv
#cd ..
#git commit -a -m "Add slides to reading list"
#./deploy.sh
