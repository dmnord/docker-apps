-------
# Skype - Communication tool for calls and chats.
-------

### to build the Docker image:
```bash
docker build -t skype:latest .
```

### to install the wrapper script to /usr/bin directory:
```bash
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir skype:latest install
```

### to uninstall the wrapper script to /usr/bin directory:
```bash
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir skype:latest uninstall
```

### to run Skype, make sure you have enough permissions to
### run docker containers and the user is a desktop's owner:
```bash
skypeforlinux
```
