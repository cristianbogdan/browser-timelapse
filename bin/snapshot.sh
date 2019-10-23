#!/bin/bash

DIR=/data

USER_DATE=$(env TZ=Europe/Bucharest date "+%d.%m_%H:%M")
DATE=$(env TZ=Europe/Bucharest date "+%Y_%V_%m%d_%H:%M")
YEAR_WEEK=$(env TZ=Europe/Bucharest date "+%Y_%V")
LAST_WEEK=$(env TZ=Europe/Bucharest date --date='1 weeks ago' '+%Y_%V')

google-chrome --no-sandbox --headless --screenshot=$DIR/$DATE.png --window-size=1280,720 https://www.google.com/maps/@44.6170083,26.4951149,12z/data=!5m1!1e1 
convert $DIR/$DATE.png /logo_api_portrait.png -gravity northeast -geometry +10+10 -composite  -gravity North -pointsize 40 -annotate  +0+100 "${USER_DATE/_/ }" $DIR/$DATE.png

