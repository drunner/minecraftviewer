# A simple minecraft generator!

FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes minecraft-overviewer wget

ENV VERSION 1.10.2

COPY ["./drunner","/drunner"]

RUN groupadd -g 22922 drgroup \
    && adduser --disabled-password --gecos '' -u 22922 --gid 22922 druser

USER druser

RUN wget --no-check-certificate https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}/${VERSION}.jar -P ~/.minecraft/versions/${VERSION}/

#ENTRYPOINT ["overviewer.py"]
#CMD ["/minecraft/world", "/www"]
