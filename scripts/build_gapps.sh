#!/bin/sh
#This file is part of The Simple GApps script of @Alexander Lartsev.
#
#    The Simple GApps scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
command -v realpath >/dev/null 2>&1 || { echo "realpath is required but it's not installed, aborting." >&2; exit 1; }
TOP=$(realpath .)
ARCH=$1
PLATFORM=5.1.1
DATE=$(date +"%Y%m%d%H%M")
ZIPNAME=simplegapps-$ARCH-$PLATFORM-$DATE.zip
MD5NAME=$ZIPNAME.md5
BUILD=$TOP/build
SCRIPTS=$TOP/scripts
INSTALL=$SCRIPTS/install
METAINF=$INSTALL/META-INF
INSTALLSCRIPTS=$INSTALL/Scripts
SIGN=$SCRIPTS/sign
SOURCES=$TOP/sources
COMMON=$SOURCES/common
ARCHSOURCES=$SOURCES/$ARCH
BUILDLOG=/tmp/gapps-buildlog.txt

function printerr(){
  echo "$(tput setaf 1)$1$(tput sgr 0)"
}

function printdone(){
  echo "$(tput setaf 2)$1$(tput sgr 0)"
}

function clean(){
    echo "Cleaning up..."
    rm -r $BUILD/$ARCH
    rm -r $BUILDLOG
    rm /tmp/$ZIPNAME
    return $?
}

function Gfailed(){
    printerr "Build failed, check $BUILDLOG"
    exit 1
}

function create(){
    test -f $BUILDLOG && rm -f $BUILDLOG
    echo "Starting GApps compilation" > $BUILDLOG
    echo "ARCH= $ARCH" >> $BUILDLOG
    echo "OS= $(uname -s -r)" >> $BUILDLOG
    echo "NAME= $(whoami) at $(uname -n)" >> $BUILDLOG
    test -d $BUILD || mkdir $BUILD;
    test -d $BUILD/$ARCH || mkdir -p $BUILD/$ARCH
    echo "Build directories are now ready" >> $BUILDLOG
    echo "Getting prebuilts..."
    echo "Copying stuffs" >> $BUILDLOG
    cp -r $ARCHSOURCES $BUILD/$ARCH >> $BUILDLOG
    mv $BUILD/$ARCH/$ARCH $BUILD/$ARCH/arch >> $BUILDLOG
    cp -r $COMMON $BUILD/$ARCH >> $BUILDLOG
}

function createzip(){
    echo "Copying installation scripts..."
    cp -r $METAINF $BUILD/$ARCH/META-INF && echo "META-INF copied" >> $BUILDLOG
    cp -r $INSTALLSCRIPTS $BUILD/$ARCH/Scripts && echo "Install scripts copied" >> $BUILDLOG
    echo "Creating zip package..."
    cd $BUILD/$ARCH
    zip -r /tmp/$ZIPNAME . >> $BUILDLOG
    rm -rf $BUILD/tmp >> $BUILDLOG
    cd $TOP
    if [ -f /tmp/$ZIPNAME ]; then
        echo "Signing zip package..."
        java -Xmx2048m -jar $SIGN/signapk.jar -w $SIGN/testkey.x509.pem $SIGN/testkey.pk8 /tmp/$ZIPNAME $BUILD/$ZIPNAME >> $BUILDLOG
    else
        printerr "Couldn't zip files!"
        echo "Couldn't find unsigned zip file, aborting" >> $BUILDLOG
        return 1
    fi
}

function getmd5(){
    if [ -x $(which md5sum) ]; then
        echo "md5sum is installed, getting md5..." >> $BUILDLOG
        echo "Getting md5sum..."
        GMD5=$(md5sum $BUILD/$ZIPNAME)
        echo -e "$GMD5" > $BUILD/$MD5NAME
        echo "md5 exported at $BUILD/$MD5NAME"
        return 0
    else
        echo "md5sum is not installed, aborting" >> $BUILDLOG
        return 1
    fi
}

create
LASTRETURN=$?
if [ -x $(which realpath) ]; then
    echo "Realpath found!" >> $BUILDLOG
else
    TOP=$(cd . && pwd) # some os X love
    echo "No realpath found!" >> $BUILDLOG
fi
if [ "$LASTRETURN" == 0 ]; then
    createzip
    LASTRETURN=$?
    if [ "$LASTRETURN" == 0 ]; then
        getmd5
        LASTRETURN=$?
        if [ "$LASTRETURN" == 0 ]; then
            clean
            LASTRETURN=$?
            if [ "$LASTRETURN" == 0 ]; then
                echo "Done!" >> $BUILDLOG
                printdone "Build completed: $GMD5"
                exit 0
            else
                Gfailed
            fi
        else
            Gfailed
        fi
    else
        Gfailed
    fi
else
    Gfailed
fi