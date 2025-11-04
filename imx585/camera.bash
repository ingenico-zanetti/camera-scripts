#!/bin/bash

if [ -f parameters.new ]
then
	cp -f parameters.new parameters.bash
fi

source ./parameters.bash


