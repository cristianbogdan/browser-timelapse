#!/bin/bash

DIR=/data
USER_DATE=$(env TZ=Europe/Bucharest date "+%d.%m_%H:%M")
DATE=$(env TZ=Europe/Bucharest date "+%Y_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=Europe/Bucharest date "+%Y_%V")
LAST_WEEK=$(env TZ=Europe/Bucharest date --date='1 weeks ago' '+%Y_%V')

# wait for the last image to be made
sleep 55

mv $DIR/$YEAR_WEEK*.png $DIR/work/

ffmpeg -y -pattern_type glob -i "$DIR/work/$YEAR_WEEK*.png"  $DIR/work/_$YEAR_WEEK.mp4

if [ ! -f $DIR/out/$YEAR_WEEK.mp4 ]; then
   mv $DIR/work/_$YEAR_WEEK.mp4 $DIR/out/$YEAR_WEEK.mp4
   rm $DIR/work/$YEAR_WEEK.txt 	
   echo "file $DIR/out/$YEAR_WEEK.mp4" > $DIR/work/$YEAR_WEEK.txt
   echo "file $DIR/work/_$YEAR_WEEK.mp4" >> $DIR/work/$YEAR_WEEK.txt
else
   ffmpeg -safe 0 -f concat -y -i $DIR/work/$YEAR_WEEK.txt -c copy $DIR/out/_$YEAR_WEEK.mp4
   mv $DIR/out/_$YEAR_WEEK.mp4 $DIR/out/$YEAR_WEEK.mp4
fi
rm  $DIR/work/$YEAR_WEEK*.png
chmod 644 $DIR/out/*.mp4

