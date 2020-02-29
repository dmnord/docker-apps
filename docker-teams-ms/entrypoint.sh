#!/bin/bash

set -e

BINARY_NAME=teams-insiders
TEAMS_USER=teams

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}


install_teams() {
  echo "Installing teams..."
  install -m 0755 /var/cache/teams/teams-wrapper /target/${BINARY_NAME}
  install -m 0644 /usr/share/applications/${BINARY_NAME}.desktop /sharedir/applications/${BINARY_NAME}.desktop
  install -m 0644 /usr/share/pixmaps/${BINARY_NAME}.png  /sharedir/pixmaps/${BINARY_NAME}.png
}

uninstall_teams() {
  echo "Uninstalling teams..."
  rm -f /target/${BINARY_NAME}
  rm -f /sharedir/applications/${BINARY_NAME}.desktop
  rm -f /sharedir/pixmaps/${BINARY_NAME}.png
}

create_user() {
  # create group with USER_GID
  if ! getent group ${TEAMS_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${TEAMS_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${TEAMS_USER} >/dev/null; then
    useradd -m -d /home/${TEAMS_USER} -u ${USER_UID} -g ${USER_GID} \
      -c 'Teams' ${TEAMS_USER} >/dev/null 2>&1
  fi

  # prepare the required permissions
  chown -R ${USER_UID}:${USER_GID} /home/${TEAMS_USER}
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=teamsvideo
        groupadd -f -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${TEAMS_USER}
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
        AUDIO_GROUP=teamsaudio
        groupadd -f -g ${AUDIO_GID} ${AUDIO_GROUP}
      fi
      usermod -a -G ${AUDIO_GROUP} ${TEAMS_USER}
      break
    fi
  done
}

launch_teams() {
  cd /home/${TEAMS_USER}
  exec sudo -HEu ${TEAMS_USER} /usr/share/${BINARY_NAME}/${BINARY_NAME} "$@" 2>&1
}

case "$1" in
  install)
    install_teams
    ;;
  uninstall)
    uninstall_teams
    ;;
  ${BINARY_NAME})
    create_user
    grant_access_to_video_devices
    grant_access_to_audio_devices
    echo "$1"
    shift
    launch_teams $@
    ;;
  *)
    exec $@
    ;;
esac
