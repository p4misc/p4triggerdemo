#!/bin/bash

docker rm -f `docker ps -a -q`
docker rmi trigger_demo
docker build -t trigger_demo .
docker run -p 1666:1666 -itd trigger_demo
