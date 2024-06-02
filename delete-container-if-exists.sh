#!/bin/bash

wc=`sudo docker ps --all | grep -w my-nginx-container | wc -l`

if [[ $wc -eq 0 ]]; then
	echo "my-nginx-container --> not found."
else
	sudo -S docker stop my-nginx-container
fi
