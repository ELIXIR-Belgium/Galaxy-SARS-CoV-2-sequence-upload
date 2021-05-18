#!/bin/bash
set -e

# set API key and galaxy instance

API_KEY=${GALAXY_DEFAULT_ADMIN_KEY:fakekey}
galaxy_instance="http://localhost:8080"

# setting up conda 
GALAXY_CONDA_PREFIX=/tool_deps/_conda export PATH=$GALAXY_CONDA_PREFIX/bin/:$PATH


if [ "$(head -n 1 /dataDir/data-library.yaml)" != "" ];
then
    echo "Starting Galaxy in the background"
    #this is needed to use ephermeris
    startup &
    galaxy-wait -g $galaxy_instance
    echo "Downloading data from data-library.yaml"
    setup-data-libraries -i '/dataDir/data-library.yaml' -g $galaxy_instance -a $API_KEY -v
    #because galaxy runs in the background, it stops running after the data is downloaded. A second startupcommand is needed:
    startup
else
    echo "No data libraries to install"
    echo "Starting Galaxy"
    startup
fi
