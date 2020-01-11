#!/bin/bash

USER_DATE=$(env TZ=Europe/Bucharest date "+%d.%m_%H:%M")
DATE=$(env TZ=Europe/Bucharest date "+%G_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=Europe/Bucharest date "+%G_%V")
LAST_WEEK=$(env TZ=Europe/Bucharest date --date='1 weeks ago' '+%G_%V')

DIR=/data/timelapses/snapshots
EXT=jpg
LOGO=/home/cristi/gmaps_timelapse/img/logo_api_portrait.png

while read p; do
    array=($p)
    NAME=${array[0]}
    RES=${array[1]}
    URL=${array[2]}
    if [ -n "$NAME" ] && [[ ${NAME:0:1} != "#" ]]; then
	MYDIR=$DIR/${NAME}
	mkdir $MYDIR &>>/dev/null
     
	if [ ! -f $MYDIR/.worker ]; then
	    touch $MYDIR/.worker 
	    FILE=$MYDIR/${NAME}_$DATE.$EXT
	    google-chrome --no-sandbox --headless --screenshot=$FILE --window-size=$RES $URL &>>/dev/null
	    convert  $FILE $LOGO -gravity northeast -geometry +10+10 -composite  -gravity North -pointsize 40 -annotate  +0+100 "${USER_DATE/_/ }" $FILE
	    chmod 644 $FILE
	    rm $MYDIR/.worker
	else
	    echo "skipping ${NAME}_$DATE.$EXT" >>$DIR/log.txt
	fi
    fi
done </home/cristi/timelapse.conf
