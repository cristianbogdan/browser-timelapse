FROM phusion/baseimage

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN update-locale LANG=C.UTF-8

# only install dependencies, no recommended or suggested pakages
RUN printf "APT::Install-Recommends \"0\";APT::Install-Suggests \"0\";" > /etc/apt/apt.conf.d/01norecommend

RUN apt-get update && apt-get install -y wget ffmpeg imagemagick

RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub

RUN apt-key add linux_signing_key.pub

RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update

RUN apt-get install -y cron google-chrome-stable

RUN apt-get install -y ghostscript
RUN apt-get install -y tzdata
RUN echo "Europe/Bucharest" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

#COPY start.sh /
#RUN chmod +x /start.sh

COPY img/logo_api_portrait.png /

# Add a chrome user and setup home dir.
RUN groupadd --system chrome && \
    useradd --system --create-home --gid chrome --groups audio,video chrome && \
    mkdir --parents /home/chrome/reports && \
    chown --recursive chrome:chrome /home/chrome

USER chrome

COPY bin/snapshot.sh /home/chrome


COPY bin/video.sh /home/chrome

COPY bin/crontab.in /home/chrome
RUN crontab </home/chrome/crontab.in

USER root
RUN chmod +x /home/chrome/snapshot.sh
RUN chmod +x /home/chrome/video.sh

RUN usermod -a -G docker_env chrome

RUN chmod 755 /etc/container_environment
RUN chmod 644 /etc/container_environment.sh /etc/container_environment.json

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*