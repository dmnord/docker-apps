FROM fedora:31
MAINTAINER dmnord

ENV SKYPE_URL=https://repo.skype.com/latest/skypeforlinux-64.rpm

RUN dnf -y update

RUN curl -sSL $SKYPE_URL -o /tmp/skypeforlinux.rpm \
 && dnf -y install /tmp/skypeforlinux.rpm \
 && rm -f /tmp/skypeforlinux.rpm

RUN dnf -y install sudo alsa-utils gtk3 PackageKit-gtk3-module libcanberra-gtk3 curl findutils procps-ng xcompmgr

COPY scripts/ /var/cache/skypeforlinux/
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh \
 && chmod 4755 /usr/share/skypeforlinux/chrome-sandbox

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
