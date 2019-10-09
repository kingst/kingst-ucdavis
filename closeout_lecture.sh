#!/bin/bash

cd ~/class/2019-fall-189e/LectureProgrammingFall2019
git commit -a -m "End of lecture"
today=`date +"%Y-%m-%d"`
git tag ${today}
git push
git push --tags

echo "https://github.com/kingst/LectureProgrammingFall2019/releases/tag/${today}"