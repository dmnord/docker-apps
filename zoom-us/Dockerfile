FROM fedora:32
MAINTAINER dmnord

ENV ZOOM_URL=https://zoom.us/client/latest/zoom_x86_64.rpm

RUN dnf -y update

RUN dnf -y install findutils procps-ng \
 && dnf -y install sudo curl pulseaudio-utils

RUN curl -sSL $ZOOM_URL -o /tmp/zoom.rpm \
 && dnf -y install /tmp/zoom.rpm \
 && rm -f /tmp/zoom.rpm

COPY scripts/ /var/cache/zoom/
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
