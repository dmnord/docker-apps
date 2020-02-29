FROM fedora:31
MAINTAINER dmnord

ENV ZOOM_URL=https://zoom.us/client/latest/zoom_x86_64.rpm

RUN dnf -y update

RUN curl -sSL $ZOOM_URL -o /tmp/zoom.rpm \
 && dnf -y install /tmp/zoom.rpm \
 && rm -f /tmp/zoom.rpm

RUN dnf -y install sudo pulseaudio-utils curl findutils procps-ng xcompmgr

COPY scripts/ /var/cache/zoom/
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
