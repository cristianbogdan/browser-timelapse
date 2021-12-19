# browser-timelapse
Docker image that
- takes snapshots of certain webpages every minute and produces a timelapse mp4 video for each week
- resolution for each snapshot/video can be adjusted
- includes a logo and the date on each snapshot

## Example configuration
```
# timelapse.conf, use TL_CONF to point to this file

# SD snapshots
2plus1          1280,720        https://www.google.com/maps/@44.6170083,26.4951149,12z/data=!5m1!1e1
margina		1280,720        https://www.google.com/maps/@45.8623996,22.282324503,14z/data=!5m1!1e1
# HD snapshots
VP-traffic	4096,2160       https://www.google.com/maps/@45.4371645,25.7908289,12z/data=!5m1!1e1
```

## Build
```docker build . -t timelapse``` 

## Example docker run command
```
# run a VPN first, if needed!
docker run -d -t   --net=container:protonvpn \
   --shm-size 512M --restart unless-stopped \
   --env TL_LOGO="/conf/logo.png" \
   --env TL_CONF="/conf/timelapse.conf" \
   --env TL_SNAPSHOT_DIR="/result/snapshots" \
   --env TL_VIDEO_DIR="/result/videos" \
   --env TL_FONT="DejaVu-Sans" \
   --env TL_TZ="Europe/Bucharest" \
   -v /home/azureuser/timelapse:/conf \
   -v /srv/data/timelapses:/result   \
   --security-opt apparmor:unconfined --name timelapse timelapse
```

## In Europe, use with US VPN to avoid cookie dialogues in the snapshots
```
docker run --rm --detach --name=protonvpn \
     --device=/dev/net/tun --cap-add=NET_ADMIN \
     --env PROTONVPN_USERNAME="YOUR_USERNAME" \
     --env PROTONVPN_PASSWORD="YOUR_PASSWORD" \
     --env PROTONVPN_TIER=0 \
     --env PROTONVPN_SERVER=US-FREE\#9 ghcr.io/tprasadtp/protonvpn:latest
```

