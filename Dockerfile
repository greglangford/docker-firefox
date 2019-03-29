FROM ubuntu:bionic

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install firefox tigervnc-standalone-server dwm

COPY tigervnc.sh /tigervnc.sh
RUN chmod +x /tigervnc.sh

RUN useradd -ms /bin/bash firefox
USER firefox

CMD ["/tigervnc.sh"]
