#!/bin/bash
# Written by: Henry Burd

# get the name of current directory
dir=${PWD##*/}   

# check if the script is run in build the rebuild
if [ $dir == "build" ]; then
    echo "remaking from build directory"
    cd ..
    rm -r build
    mkdir build
    cd build
    cmake ..
    make
else
    # check if there is a CMakeLists.txt file
    if [ -f "CMakeLists.txt" ]; then
        # remove old build folder and make a new one
        if [ -d "build" ]; then
            echo "remaking build directory"
            rm -r build
            mkdir build
            cd build
            cmake ..
            make
        else
            # make new build folder
            echo "making build directory"
            mkdir build
            cd build
            cmake ..
            make
        fi
    fi
fi
