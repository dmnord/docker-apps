-------
Zoom US (zoom.us) - Video and audio conference solution.
-------

# to build the Docker image:
docker build -t zoom_us:latest .

# to install the wrapper script to /usr/bin directory:
docker run -it --rm --volume /usr/bin:/target zoom_us:latest install

# to run Zoom US, make sure you have enough permissions to run 
# docker containers and the user is a desktop's owner:
zoom