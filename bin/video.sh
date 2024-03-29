#!/bin/bash
DATE=$(env TZ=$TL_TZ date "+%G_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=$TL_TZ date "+%G_%V")
LAST_WEEK=$(env TZ=$TL_TZ date --date='1 weeks ago' '+%G_%V')

IMG_EXT=jpg
EXT=mp4

# wait for the last image to be made
sleep 55

while read zeline; do
    array=($zeline)
    NAME=${array[0]}
 
    if [ -n "$NAME" ] && [[ ${NAME:0:1} != "#" ]]; then
	MYDIR=$TL_VIDEO_DIR/$NAME
	WORKDIR=$MYDIR/.work
	FILE=$YEAR_WEEK.$EXT
	
	mkdir $MYDIR &>>/dev/null
	mkdir $WORKDIR &>>/dev/null
	ln -sfn $TL_SNAPSHOT_DIR/$NAME $MYDIR/snapshots 
	
	
        #move images to the work dir
	mv $TL_SNAPSHOT_DIR/$NAME/*$YEAR_WEEK*.$IMG_EXT      $WORKDIR
	
	# make video from the latest images
	nice -40 ffmpeg -y -pattern_type glob -i "$WORKDIR/*.$IMG_EXT"  -pix_fmt yuv420p $WORKDIR/_$FILE </dev/null
	# remove images
	rm  $WORKDIR/*$YEAR_WEEK*.$IMG_EXT

	# if we have no video
	if [ ! -f $MYDIR/$FILE ]; then
	    # just copy to the output
	    mv $WORKDIR/_$FILE $MYDIR/$FILE
	else
	    #else concatenate them to _name
	    ffmpeg -y -safe 0 -f concat -i <(echo "file $MYDIR/$FILE"; echo "file $WORKDIR/_$FILE")  -c copy $MYDIR/_$FILE </dev/null
	    # remove the one we just made from images
	    rm $WORKDIR/_$FILE
	    # rename _name to name (overwrite the old)
	    mv $MYDIR/_$FILE    $MYDIR/$FILE
	fi
	chmod 644 $MYDIR/$FILE
    fi
done<$TL_CONF

