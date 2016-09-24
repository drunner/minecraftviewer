# A simple minecraft generator!
# This is based on the leaflet branch of overviewer.

FROM debian

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y wget sudo git python build-essential python-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cd / \
 && git clone https://github.com/overviewer/Minecraft-Overviewer.git \
 && cd Minecraft-Overviewer \
 && git checkout leaflet
WORKDIR "/Minecraft-Overviewer"

RUN wget https://raw.githubusercontent.com/python-pillow/Pillow/master/libImaging/Imaging.h \
 && wget https://raw.githubusercontent.com/python-pillow/Pillow/master/libImaging/ImPlatform.h \
 && wget https://bootstrap.pypa.io/get-pip.py \
 && python get-pip.py \
 && pip install -q pillow \
 && pip install -q numpy \
 && python setup.py build

RUN groupadd -g 22922 drgroup \
 && adduser --disabled-password --gecos '' -u 22922 --gid 22922 druser

USER druser

ENV MC_VERSION 1.10.2
RUN wget --no-check-certificate -N https://s3.amazonaws.com/Minecraft.Download/versions/${MC_VERSION}/${MC_VERSION}.jar -P ~/.minecraft/versions/${MC_VERSION}/

USER root
# chown actually sticks now for named volumes!
RUN mkdir /www && chown druser:drgroup /www
COPY ["./usrlocalbin","/usr/local/bin"]
RUN chmod a+x /usr/local/bin/*

USER druser
COPY ["./drunner","/drunner"]
