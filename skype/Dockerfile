FROM fedora:32
MAINTAINER dmnord

ENV SKYPE_URL=https://repo.skype.com/latest/skypeforlinux-64.rpm

RUN dnf -y update

RUN dnf -y install findutils procps-ng libsecret \
 && dnf -y install gnome-keyring dbus-x11 \
 && dnf -y install curl sudo wget alsa-utils gtk3 PackageKit-gtk3-module libcanberra-gtk3

RUN curl -sSL $SKYPE_URL -o /tmp/skypeforlinux.rpm \
 && dnf -y install /tmp/skypeforlinux.rpm \
 && rm -f /tmp/skypeforlinux.rpm

RUN dbus-uuidgen > /etc/machine-id

COPY scripts/ /var/cache/skypeforlinux/
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh \
 && chmod 4755 /usr/share/skypeforlinux/chrome-sandbox

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
