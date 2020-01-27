#!/bin/bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

ZOOM_US_USER=zoom

install_zoom_us() {
  echo "Installing zoom..."
  install -m 0755 /var/cache/zoom-us/zoom-wrapper /target/zoom
}

uninstall_zoom_us() {
  echo "Uninstalling zoom..."
  rm -rf /target/zoom
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
  zoom)
    create_user
    grant_access_to_video_devices
    echo "$1"
    launch_zoom_us $@
    ;;
  *)
    exec $@
    ;;
esac
