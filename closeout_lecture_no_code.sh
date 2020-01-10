#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

gcloud config set account kingst@gmail.com

slides_url=$1
cwd=`pwd`

cd ${cwd}/scripts
python add_lecture_to_reading_list_no_code.py "${slides_url}"

python download_reading_list.py ../classes/f19-ecs189e/reading_list.csv
cd ..
git commit -a -m "Add slides to reading list"
./deploy.sh
