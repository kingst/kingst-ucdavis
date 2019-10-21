#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 lecture_slides_url"
    exit
fi

slides_url=$1
cwd=`pwd`

cd ~/class/2019-fall-189e/LectureProgrammingFall2019
git commit -a -m "End of lecture"
#today=`date +"%Y-%m-%d"`
today = '2019-10-17'
git tag ${today}
git push
git push --tags

github_url="https://github.com/kingst/LectureProgrammingFall2019/releases/tag/${today}"

cd ${cwd}/scripts
python add_lecture_to_reading_list.py "${slides_url}" "${github_url}"

python download_reading_list.py ../classes/f19-ecs189e/reading_list.csv
cd ..
git commit -a -m "Bump reading list"
./deploy.sh
