#!/bin/bash

set -e

BINARY_NAME=skypeforlinux
SKYPE_USER=skype

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}


install_skype() {
  echo "Installing skype..."
  install -m 0755 /var/cache/${BINARY_NAME}/skype-wrapper /target/${BINARY_NAME}
  install -m 0644 /usr/share/applications/${BINARY_NAME}.desktop /sharedir/applications/${BINARY_NAME}.desktop
  install -m 0644 /usr/share/pixmaps/${BINARY_NAME}.png  /sharedir/pixmaps/${BINARY_NAME}.png
}

uninstall_skype() {
  echo "Uninstalling skype..."
  rm -f /target/${BINARY_NAME}
  rm -f /sharedir/applications/${BINARY_NAME}.desktop
  rm -f /sharedir/pixmaps/${BINARY_NAME}.png
}

create_user() {
  # create group with USER_GID
  if ! getent group ${SKYPE_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${SKYPE_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${SKYPE_USER} >/dev/null; then
    useradd -m -d /home/${SKYPE_USER} -u ${USER_UID} -g ${USER_GID} \
      -c 'Skype' ${SKYPE_USER} >/dev/null 2>&1
  fi

  # prepare the required permissions
  chown -R ${USER_UID}:${USER_GID} /home/${SKYPE_USER}
  find /home/${SKYPE_USER} -type d -print0 | while read -d $'\0' file; do chmod 755 "$file"; done
  find /home/${SKYPE_USER} -type f -print0 | while read -d $'\0' file; do chmod 644 "$file"; done
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=skypevideo
        groupadd -f -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${SKYPE_USER}
      break
    fi
  done
}

grant_access_to_audio_devices() {
  for device in /dev/snd/*
  do
    if [[ -c $device ]]; then
      AUDIO_GID=$(stat -c %g $device)
      AUDIO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        AUDIO_GROUP=audioaudio
        groupadd -f -g ${AUDIO_GID} ${AUDIO_GROUP}
      fi
      usermod -a -G ${AUDIO_GROUP} ${TEAMS_USER}
      break
    fi
  done
}

launch_skype() {
  cd /home/${SKYPE_USER}
  exec sudo -HEu ${SKYPE_USER} PULSE_SERVER=/run/pulse/native /usr/share/${BINARY_NAME}/${BINARY_NAME} --password-store=basic --executed-from="$(pwd)" --pid=$$ "$@" 2>&1
}

case "$1" in
  install)
    install_skype
    ;;
  uninstall)
    uninstall_skype
    ;;
  ${BINARY_NAME})
    create_user
    grant_access_to_video_devices
    grant_access_to_audio_devices
    echo "$1"
    shift
    launch_skype $@
    ;;
  *)
    exec $@
    ;;
esac
