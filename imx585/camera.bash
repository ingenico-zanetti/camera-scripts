#!/bin/bash
# Top level camera script.
# Responsible for:
# - sourcing the global parameters
# - launching the proper camera script

if [ -f parameters.new ]
then
	cp -f parameters.new parameters.bash
fi

source ./parameters.bash


