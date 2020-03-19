FROM ubuntu:bionic as ubuntu18
LABEL maintainer "p4misc <p4miscjp@gmail.com>"

RUN apt-get update -y \
    && apt-get install -y vim wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV P4OSPASSWD He1ixAd@min

RUN useradd -U -m -d /opt/perforce perforce \
    && echo perforce:${P4OSPASSWD} | chpasswd \
    && install -m 770 -o perforce -g perforce -d \
          /opt/perforce \
          /opt/perforce/bin \
          /opt/perforce/sbin

USER perforce

RUN cd /opt/perforce/bin \
    && wget -q http://ftp.perforce.com/perforce/r19.2/bin.linux26x86_64/p4 \
    && chmod 770 p4
RUN cd /opt/perforce/sbin \
    && wget -q http://ftp.perforce.com/perforce/r19.2/bin.linux26x86_64/p4d \
    && chmod 770 p4d

RUN cd /opt/perforce \
    && wget -q http://ftp.perforce.com/pub/perforce/tools/sampledepot.tar.gz \
    && tar xzvf sampledepot.tar.gz \
    && mv PerforceSample p4root \
    && chown -R perforce:perforce p4root

COPY --chown=perforce:perforce setup.sh run.sh /opt/perforce/
COPY --chown=perforce:perforce triggers/ /opt/perforce/triggers/
RUN cd /opt/perforce \
    && find . -name \*.sh -exec chmod u+x {} \; \
    && ./setup.sh

EXPOSE 1666

HEALTHCHECK \
    --interval=2m \
    --timeout=30s \
    CMD p4 -p 1666 info -s > /dev/null || exit 1

CMD ["/opt/perforce/run.sh"]
