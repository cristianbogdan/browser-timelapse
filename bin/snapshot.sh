#!/bin/bash

USER_DATE=$(env TZ=Europe/Bucharest date "+%d.%m_%H:%M")
DATE=$(env TZ=Europe/Bucharest date "+%G_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=Europe/Bucharest date "+%G_%V")
LAST_WEEK=$(env TZ=Europe/Bucharest date --date='1 weeks ago' '+%G_%V')

DIR=/data/timelapses/snapshots
EXT=jpg
LOGO=/home/cristi/gmaps_timelapse/img/logo_api_portrait.png
MAXPROC=4

cnt=($(ps -ef |grep "test-gmaps.sh >>"  | wc -l))
if ((cnt > MAXPROC)) ; then
    echo "skipping $USER_DATE ${cnt} procsses already running" >>$DIR/log.txt
    exit 1
fi 


while read p; do
    array=($p)
    NAME=${array[0]}
    RES=${array[1]}
    URL=${array[2]}
    if [ -n "$NAME" ] && [[ ${NAME:0:1} != "#" ]]; then
	MYDIR=$DIR/${NAME}
	mkdir $MYDIR &>>/dev/null
     
	FILE=$MYDIR/${NAME}_$DATE.$EXT
	google-chrome --no-sandbox --headless --screenshot=$FILE --window-size=$RES $URL &>>/dev/null
	convert  $FILE $LOGO -gravity northeast -geometry +10+10 -composite  -gravity North -pointsize 40 -annotate  +0+100 "${USER_DATE/_/ }" $FILE
	chmod 644 $FILE
    fi
done </home/cristi/timelapse.conf
