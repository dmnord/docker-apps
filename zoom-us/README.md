-------
# Zoom US (zoom.us) - Video and audio conference solution.
-------

### to build the Docker image:
```bash
docker build -t zoom_us:latest .
```

### to install the wrapper script to /usr/bin directory:
```bash
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir zoom_us:latest install
```

### to uninstall the wrapper script to /usr/bin directory:
```bash
docker run -it --rm --volume /usr/bin:/target --volume /usr/share:/sharedir zoom_us:latest uninstall
```

### to run Zoom US, make sure you have enough permissions to
### run docker containers and the user is a desktop's owner:
```bash
zoom
```
