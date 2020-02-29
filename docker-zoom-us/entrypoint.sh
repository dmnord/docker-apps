#!/bin/bash

set -e

BINARY_NAME=zoom
ZOOM_US_USER=zoom

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}


install_zoom_us() {
  echo "Installing zoom..."
  install -m 0755 /var/cache/zoom/zoom-wrapper /target/${BINARY_NAME}
  install -m 0644 /usr/share/applications/Zoom.desktop /sharedir/applications/${BINARY_NAME}.desktop
  install -m 0644 /usr/share/pixmaps/Zoom.png  /sharedir/pixmaps/Zoom.png
}

uninstall_zoom_us() {
  echo "Uninstalling zoom..."
  rm -f /target/${BINARY_NAME}
  rm -f /sharedir/applications/${BINARY_NAME}.desktop
  rm -f /sharedir/pixmaps/Zoom.png
}

create_user() {
  # create group with USER_GID
  if ! getent group ${ZOOM_US_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${ZOOM_US_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${ZOOM_US_USER} >/dev/null; then
    useradd -m -d /home/${ZOOM_US_USER} -u ${USER_UID} -g ${USER_GID} \
      -c 'ZoomUs' ${ZOOM_US_USER} >/dev/null 2>&1
  fi

  # prepare the required permissions
  chown -R ${USER_UID}:${USER_GID} /home/${ZOOM_US_USER}
  find /home/${ZOOM_US_USER} -type d | xargs chmod 755
  find /home/${ZOOM_US_USER} -type f | xargs chmod 644
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=zoomusvideo
        groupadd -f -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${ZOOM_US_USER}
      break
    fi
  done
}

launch_zoom_us() {
  cd /home/${ZOOM_US_USER}
  exec sudo -HEu ${ZOOM_US_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" $@
}

case "$1" in
  install)
    install_zoom_us
    ;;
  uninstall)
    uninstall_zoom_us
    ;;
  ${BINARY_NAME})
    create_user
    grant_access_to_video_devices
    echo "$1"
    launch_zoom_us $@
    ;;
  *)
    exec $@
    ;;
esac
