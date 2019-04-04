#!/usr/bin/env bash

# Resolve directories
here=`dirname "$0"`
cd "$here"

printf '\e[0m'

# Load modules and env. variables
. ../info.conf
. load.sh
. checks.sh 

