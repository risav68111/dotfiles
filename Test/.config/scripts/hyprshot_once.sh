#!/bin/bash

flock -n /tmp/hyprshot.lock hyprshot "$@" 

