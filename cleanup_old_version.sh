#!/bin/bash
VERSIONS=$(gcloud app versions list --project=$1 --sort-by '~LAST_DEPLOYED' --format 'value(version.id)')
COUNT=0
echo "Keeping the $2 latest versions of the $1 service"
for VERSION in $VERSIONS
do
    ((COUNT++))
    if [ $COUNT -gt "2" ]
    then
      echo "Going to delete version $VERSION of the $1 project."
      #gcloud app versions delete $VERSION --project=$1 -q
    else
      echo "Going to keep version $VERSION of the $1 project."
    fi
done