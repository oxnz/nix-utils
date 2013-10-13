#!/bin/bash

android list targets
android create project --target <target-id> --name MyFirstApp \
	--path <path-to-workspace>/MyFirstApp --activity MainActivity \
	--package com.example.myfirstapp
ant debug
adb install bin/MyFirstApp-debug.apk
