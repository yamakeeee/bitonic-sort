FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install g++


RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install python3
RUN apt install -y python3-pip
RUN apt-get install -y libgl1-mesa-dev

RUN apt-get update && apt-get upgrade -y
RUN apt-get install libglib2.0-0

RUN pip install numpy
RUN pip3 install opencv-python
RUN pip3 install opencv-contrib-python

