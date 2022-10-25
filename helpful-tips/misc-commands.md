# Quote
- You know what architecture really is?
- It is the art of drawing lines.


## MySQL permissions reset
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';


# Graphic drivers
==================
<!-- sudo apt-get install xorg-server -->
sudo apt-get purge xserver-xorg-video-intel
sudo apt-get install xserver-xorg-lts-saucy


# System commands
===================
sudo swapoff -a
sudo swapon -a

sudo ifconfig wlan0 down
sudo ifconfig wlan0 up
iwlist wlan1 scan | egrep 'Cell |Encryption|Quality|Last beacon|ESSID'

hardware info
----------------------
sudo lshw -c network


## Get hold of the open connections
sudo netstat -tulpn


## Refresh font cache
sudo fc-cache -f -v


# Firewall
==============
Uncomplicated Firewall – UFW, which is a firewall for our ubuntu server.

sudo apt-get install ufw

Now lets setup the rules for our firewall

sudo ufw default deny
sudo ufw allow ssh
sudo ufw allow http
sudo ufw enable

Now lets check our rules to see if port 22, and 80 are open to the internet

sudo ufw status
