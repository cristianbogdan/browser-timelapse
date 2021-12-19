#!/bin/bash

USER_DATE=$(env TZ=$TL_TZ date "+%d.%m_%H:%M")
DATE=$(env TZ=$TL_TZ date "+%G_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=$TL_TZ date "+%G_%V")
LAST_WEEK=$(env TZ=$TL_TZ date --date='1 weeks ago' '+%G_%V')

EXT=jpg
MAXPROC=4

cnt=($(ps -ef |grep "snapshot.sh >>"  | wc -l))
if ((cnt > MAXPROC)) ; then
    echo "skipping $USER_DATE ${cnt} processes already running" >>$TL_SNAPSHOT_DIR/log.txt
    exit 1
fi 


while read p; do
    array=($p)
    NAME=${array[0]}
    RES=${array[1]}
    URL=${array[2]}
    if [ -n "$NAME" ] && [[ ${NAME:0:1} != "#" ]]; then
	MYDIR=$TL_SNAPSHOT_DIR/${NAME}
	mkdir $MYDIR &>>/dev/null
     
	FILE=$MYDIR/${NAME}_$DATE.$EXT
	google-chrome --no-sandbox --headless --screenshot=$FILE --window-size=$RES $URL &>>/dev/null
	if test -f "$FILE"; then
	    convert  $FILE $TL_LOGO -gravity northeast -geometry +10+10 -composite  -gravity North -pointsize 40 -font $TL_FONT -annotate  +0+100 "${USER_DATE/_/ }" $FILE
	    chmod 644 $FILE
	fi
    fi
done <$TL_CONF
