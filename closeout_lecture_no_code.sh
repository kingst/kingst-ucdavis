#!/bin/bash


if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
reading_list="classes/f24-ecs150/reading_list.csv"

#today=`date +"%Y-%m-%d"`
today='2024-10-18'

python3.10 add_lecture_to_reading_list.py  "${today}" "${reading_list}" "${slides_url}"

git commit -a -m "Bump reading list"
./deploy.sh
