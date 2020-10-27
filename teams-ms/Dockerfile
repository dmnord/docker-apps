FROM fedora:32
MAINTAINER dmnord

COPY teams.repo /etc/yum.repos.d/teams.repo

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
 && dnf -y update

RUN dnf -y install teams-insiders

RUN dnf -y install findutils procps-ng \
 && dnf -y install sudo alsa-utils gtk3 PackageKit-gtk3-module libcanberra-gtk3

COPY scripts/ /var/cache/teams-insiders/
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
