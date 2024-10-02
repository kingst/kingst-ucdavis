#!/bin/bash


if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
reading_list="classes/f24-ecs150/reading_list.csv"

git commit -a -m "End of lecture"
git push
#today=`date +"%Y-%m-%d"`
today='2024-09-30'
sha=`git rev-parse HEAD`

github_url="https://github.com/kingst/kingst-ucdavis/tree/${sha}/inclass_programming/f24-ecs150"

python3.10 add_lecture_to_reading_list.py  "${today}" "${reading_list}" "${slides_url}" "${github_url}"

git commit -a -m "Bump reading list"
./deploy.sh
