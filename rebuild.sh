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

function new_build_debug {
    # check if there is a build directory, and remove it if it exists
    if [ -d "build" ]; then
        rm -r build
    fi
    # insert "set(CMAKE_BUILD_TYPE Debug)" into the 4th line of CMakeLists.txt
    sed -i '4iset(CMAKE_BUILD_TYPE Debug)' CMakeLists.txt
    # create a new build directory and cd into it
    mkdir build
    cd build
    # run cmake and make
    cmake -DCMAKE_BUILD_TYPE=Debug ..
    make $make_args
    cp ../CMakeLists.txt rebuildcache.txt
    # remove the line we added
    sed -i '4d' ../CMakeLists.txt
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

# check if the script is run in build the rebuild
if [ $dir == "build" ]; then
    # check debug flag
    if [[ $@ =~ -d ]]; then
        cd ..
        new_build_debug
        # exit the script
        exit 0
    fi
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
        # check if the debug flag is set
        if [[ $@ =~ -d ]]; then
            new_build_debug
        else
            new_build
        fi
    else
        echo "[ERROR] No CMakeLists.txt file found in current directory"
    fi
fi
