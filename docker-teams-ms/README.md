-------
Microsoft Teams - Video and audio conference solution.
-------

# to build the Docker image:
docker build -t teams_ms:latest .

#to install the wrapper script to /usr/bin directory:
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir teams_ms:latest install

#to uninstall the wrapper script to /usr/bin directory:
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir teams_ms:latest uninstall

# to run Microsoft Teams, make sure you have enough permissions to
# run docker containers and the user is a desktop's owner:
teams-insiders
