#!/bin/bash


if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
reading_list="classes/w25-ecs150/reading_list.csv"

git commit -a -m "End of lecture"
git push
#today=`date +"%Y-%m-%d"`
today="2025-01-13"
#sha=`git rev-parse HEAD`
sha="409f0506a7947d313fc5807730465a11fca4b18d"
github_url="https://github.com/kingst/kingst-ucdavis/tree/${sha}/inclass_programming/w25-ecs150"

python3.10 add_lecture_to_reading_list.py  "${today}" "${reading_list}" "${slides_url}" "${github_url}"

git commit -a -m "Bump reading list"
./deploy.sh
