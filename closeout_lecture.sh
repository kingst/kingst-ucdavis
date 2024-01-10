#!/bin/bash


if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
reading_list="class/w24-ecs189e/reading_list.csv"

git commit -a -m "End of lecture"
today=`date +"%Y-%m-%d"`
git tag ${today}
git push
git push --tags

github_url="https://github.com/kingst/kingst-ucdavis/releases/tag/${today}"

python3.10 add_lecture_to_reading_list.py  "${today}" "${reading_list}" "${slides_url}" "${github_url}"

git commit -a -m "Bump reading list"
./deploy.sh
