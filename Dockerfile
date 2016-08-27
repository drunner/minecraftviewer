# A simple minecraft generator!

FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes minecraft-overviewer wget sudo cron

RUN groupadd -g 22922 drgroup \
    && adduser --disabled-password --gecos '' -u 22922 --gid 22922 druser

#RUN echo "druser ALL= (ALL) NOPASSWD: /usr/local/bin/,/sbin/my_init" > /etc/sudoers.d/samba
RUN echo "druser ALL= (ALL) NOPASSWD: /usr/local/bin/" > /etc/sudoers.d/druser
RUN chmod 0440 /etc/sudoers.d/druser

USER druser
ENV VERSION 1.10.2
RUN wget --no-check-certificate https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}/${VERSION}.jar -P ~/.minecraft/versions/${VERSION}/

USER root
# this actually sticks now for named volumes!
RUN mkdir /www && chown druser:drgroup /www
RUN touch /var/log/cron.log
RUN mkdir /etc/cron.d
COPY ["./usrlocalbin","/usr/local/bin"]
RUN chmod a+x /usr/local/bin/*

USER druser
COPY ["./drunner","/drunner"]
