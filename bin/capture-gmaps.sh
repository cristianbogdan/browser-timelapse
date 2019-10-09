#!/bin/bash

DIR=/data

#while  true;
#do
USER_DATE=$(env TZ=Europe/Bucharest date "+%d.%m_%H:%M")
DATE=$(env TZ=Europe/Bucharest date "+%Y_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=Europe/Bucharest date "+%Y_%V")
LAST_WEEK=$(env TZ=Europe/Bucharest date --date='1 weeks ago' '+%Y_%V')

google-chrome --no-sandbox --headless --screenshot=$DIR/$DATE.png --window-size=1280,720 https://www.google.com/maps/@44.6170083,26.4951149,12z/data=!5m1!1e1 
convert $DIR/$DATE.png /logo_api_portrait.png -gravity northeast -geometry +10+10 -composite  -gravity North -pointsize 40 -annotate  +0+100 "${USER_DATE/_/ }" $DIR/$DATE.png
if [ ! -f $DIR/_$YEAR_WEEK.mp4 ]; then
    #   convert -limit memory 2GiB -limit map 10GiB -define registry:temporary-path=/data/tmp  -delay 0 -quality 1000% $DIR/*.png  -gravity North -pointsize 40 -annotate  +0+100 %f $DIR/_status.mp4
    ffmpeg -pattern_type glob -i "$DIR/$YEAR_WEEK*.png"  $DIR/_$YEAR_WEEK.mp4 >> /dev/null 2>&1
    mv $DIR/_$YEAR_WEEK.mp4 $DIR/$YEAR_WEEK.mp4
    cp $DIR/$YEAR_WEEK.mp4 $DIR/status.mp4 &
    if [ ! -f $DIR/_$LAST_WEEK.mp4 ] && [ -f $DIR/$LAST_WEEK.mp4 ]; then
	rm $DIR/$LAST_WEEK*.png >> /dev/null 2>&1
    fi
    chmod 644 $DIR/*
fi
#    if [[ "$(env TZ=Europe/Bucharest date +"%T")" < '05:00:00' ]] ; then
#	sleep 900 
#    else
#        sleep 60
#    fi

#done
