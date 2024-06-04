#!/bin/bash

ssh amer@192.168.8.187 'echo ctcvmware | sudo -S /tmp/jt-app-01/stop-container-if-exists.sh'
