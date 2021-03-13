#! /bin/csh
# according to https://github.com/leonid-shevtsov/headless/issues/47
mkdir /tmp/.X11-unix
# touch /tmp/.X11-unix/X1
# chmod 777 /tmp/.X11-unix/X1
sudo chmod 1777 /tmp/.X11-unix
sudo chown root /tmp/.X11-unix
