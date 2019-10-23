FROM phusion/baseimage

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN update-locale LANG=C.UTF-8

# only install dependencies, no recommended or suggested pakages
RUN printf "APT::Install-Recommends \"0\";APT::Install-Suggests \"0\";" > /etc/apt/apt.conf.d/01norecommend

RUN apt-get install -y wget ffmpeg imagemagick

RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub

RUN apt-key add linux_signing_key.pub

RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update

RUN apt-get install -y cron google-chrome-stable

RUN apt-get install -y ghostscript
RUN apt-get install -y tzdata
RUN echo "Europe/Bucharest" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

COPY bin/capture-gmaps.sh /
RUN chmod +x /capture-gmaps.sh

COPY bin/snapshot.sh /
RUN chmod +x /snapshot.sh

COPY bin/crontab.in /
RUN crontab </crontab.in

#COPY start.sh /
#RUN chmod +x /start.sh

COPY img/logo_api_portrait.png /

RUN mkdir data
RUN mkdir data/work
RUN mkdir data/out
VOLUME ["/data"]

#ENTRYPOINT ["/start.sh"]


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*