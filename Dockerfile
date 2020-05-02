# Syncthing server based on ubuntu-server:focal
#
# 2020-05-02 by Yank555.lu

FROM ubuntu-server:focal
MAINTAINER Jean-Pierre Rasquin <yank555-lu@gmail.com>

# Build Arguments
ARG GUI_ADDRESS="127.0.0.1"
ARG GUI_PORT="8384"
ARG USERNAME="root"

# Define Setup Environment
USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install additional dependencies
RUN curl -s https://syncthing.net/release-key.txt | apt-key add - ; \
    echo "deb https://apt.syncthing.net/ syncthing release" > /etc/apt/sources.list.d/syncthing.list ; \
    apt-get update ; \
    apt-get install syncthing

# Setup syncthing server
ENV SYNCTHING_GUI=$GUI_ADDRESS:$GUI_PORT
ENV SYNCTHING_USERNAME=$USERNAME
COPY assets/syncthing.runit /etc/service/syncthing/run
RUN chmod 700 /etc/service/syncthing/run ; \
    mkdir /home/syncthing ; \
    chown $USERNAME:$USERNAME /home/syncthing ; \
    chmod 750 /home/syncthing
