# A simple minecraft generator!

FROM debian

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget sudo
RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list
RUN wget -O - http://overviewer.org/debian/overviewer.gpg.asc | sudo apt-key add -
RUN apt-get update && apt-get install -y minecraft-overviewer

RUN groupadd -g 22922 drgroup \
    && adduser --disabled-password --gecos '' -u 22922 --gid 22922 druser

USER druser
ENV VERSION 1.10.2
RUN wget --no-check-certificate https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}/${VERSION}.jar -P ~/.minecraft/versions/${VERSION}/

USER root
# chown actually sticks now for named volumes!
RUN mkdir /www && chown druser:drgroup /www
COPY ["./usrlocalbin","/usr/local/bin"]
RUN chmod a+x /usr/local/bin/*

USER druser
COPY ["./drunner","/drunner"]
