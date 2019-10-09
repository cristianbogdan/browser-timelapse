FROM ubuntu:16.04
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

COPY bin/capture-gmaps.sh /
RUN chmod +x /capture-gmaps.sh

COPY start.sh /
RUN chmod +x /start.sh

COPY img/logo_api_portrait.png /

RUN mkdir data
RUN ./capture-gmaps.sh

ENTRYPOINT ["/start.sh"]