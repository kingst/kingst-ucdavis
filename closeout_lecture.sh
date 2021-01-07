#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url video_slides_url"
    exit
fi

gcloud config set account kingst@ucdavis.edu

slides_url=$1
video_url=$2
cwd=`pwd`

cd ~/class/2021-winter-189e/LectureProgrammingWinter2021
git commit -a -m "End of lecture"
today=`date +"%Y-%m-%d"`
git tag ${today}
git push
git push --tags

github_url="https://github.com/kingst/LectureProgrammingWinter2021/releases/tag/${today}"

cd ${cwd}/scripts
source venv/bin/activate
python add_lecture_to_reading_list.py "${slides_url}" "${video_url}" "${github_url}"

python download_reading_list.py ../classes/w21-ecs189e/reading_list.csv
cd ..
git commit -a -m "Bump reading list"
./deploy.sh
