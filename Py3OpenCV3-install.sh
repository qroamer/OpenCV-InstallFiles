#!/bin/bash
#OpenCV Installation Notes
#This is made from the instructions found at:
#https://www.pyimagesearch.com/2015/07/27/installing-opencv-3-0-for-both-python-2-7-and-python-3-on-your-raspberry-pi-2/
#Some of my own edits have been added in as well.

#Prepping the PiOS
#sudo apt-get update && sudo apt-get upgrade && sudo rpi-update
sudo apt-get update
sudo apt-get upgrade
sudo rpi-update

#First Packages
sudo apt-get install -y build-essential git cmake pkg-config
sudo apt-get install -y libjpeg8-dev libjasper-dev libpng12-dev
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libatlas-base-dev gfortran

#grabbing the OpenCV repository from GitHub
cd ~/
git clone https://github.com/Itseez/opencv.git
cd opencv
git checkout 3.3.1

#grabbing the OpenCV contrib from GitHub
cd ~/
git clone https://github.com/Itseez/opencv_contrib.git
cd opencv_contrib
git checkout 3.3.1

# This is where it differs.  I am going to install support for Python3 
# Because Python2 is for losers.
sudo apt-get install -y python3-dev

#Installing PIP3
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

#VIRTUAL ENVIRONMENTS ARE THE BREAST THING EVAR
sudo pip3 install virtualenv virtualenvwrapper

#Addendums to the ~/.profile file.
sudo echo "virtualenv and virtualenvwrapper" ~/.profile
sudo echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
sudo echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
sudo echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile

#Telling the OS to use the new Profile File:
source ~/.profile

# Creating the Virtual Environment.
# From here on out, anything we create will be in the virtual environment
mkvirtualenv cv

#Telling the OS to use the CV virtualenv
workon cv

#Install NumPy:
pip install numpy

#going back to the CV VIRTUALENVWRAPPER
workon cv
cd ~/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D BUILD_EXAMPLES=ON \
-D WITH_TBB=ON=ON >> ~/build-log.txt ..

#build this thang (gonna take like....a billion years)
make -j4

#Once this finishes; install that thang:
sudo make install
sudo ldconfig