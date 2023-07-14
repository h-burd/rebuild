#!/bin/bash
# Written by: Henry Burd, Sean Bachman

#declare new_build function
function new_build {
    # check if there is a build directory, and remove it if it exists
    if [ -d "build" ]; then
        rm -r build
    fi
    # create a new build directory and cd into it
    mkdir build
    cd build
    # run cmake and make
    cmake ..
    make $make_args
    cp ../CMakeLists.txt rebuildcache.txt
}

# get the name of current directory
dir=${PWD##*/}   

# capture command line args
# look for -jN where n is a number
if [[ $@ =~ -j[0-9]+ ]]; then
    make_args=$@
else
    make_args=""
fi
# look for -d for debug flag
if [[ $@ =~ -d ]]; then
    debug_flag="-DCMAKE_BUILD_TYPE=Debug"
else
    debug_flag=""
fi



# check if the script is run in build the rebuild
if [ $dir == "build" ]; then
    # check if there is a rebuildcache.txt file
    if [ -f "rebuildcache.txt" ]; then
        # check if ../CMakeLists.txt matches rebuildcache.txt
        if cmp -s ../CMakeLists.txt rebuildcache.txt; then
            echo "no cmakelists changes detected, making..."
            make $make_args
        else
            echo "cmakelists changes detected, creating new build and making..."
            cd ..
            new_build
        fi
    else
        echo "creating new build and making..."
        cd ..
        new_build
    fi

else
    # check if there is a CMakeLists.txt file
    if [ -f "CMakeLists.txt" ]; then
        new_build
    else
        echo "[ERROR] No CMakeLists.txt file found in current directory"
    fi
fi
