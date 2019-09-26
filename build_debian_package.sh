#!/bin/sh

MAJOR_VERSION=`sed '35!d' ../vscp/src/vscp/common/version.h  | cut -b 33-`
MINOR_VERSION=`sed '36!d' ../vscp/src/vscp/common/version.h  | cut -b 33-`
RELEASE_VERSION=`sed '37!d' ../vscp/src/vscp/common/version.h  | cut -b 33-`
BUILD_VERSION=`sed '38!d' ../vscp/src/vscp/common/version.h  | cut -b 33-`
NAME_PLUS_VER=vscp-driver-l1-logger-$MAJOR_VERSION.$MINOR_VERSION.$RELEASE_VERSION
BUILD_FOLDER=/tmp/__build__/`date +vscp_build_%y%m%d_%H%M%S`

echo ---$NAME_PLUS_VER

# Create the build folder
echo "---Creating build folder:"$BUILD_FOLDER
mkdir -p $BUILD_FOLDER

# Clean project
make clean
rm dist/*
./clean_for_dist

echo "---Copying Debian_orig to destination folder"
cp -r debian_orig $BUILD_FOLDER

echo "---making tar"
tar -zcf $BUILD_FOLDER/$NAME_PLUS_VER.tar.gz *
echo $NAME_PLUS_VER.tgz created.
cd $BUILD_FOLDER
mkdir $NAME_PLUS_VER/
cd $NAME_PLUS_VER/
mkdir debian
tar -zxvf ../$NAME_PLUS_VER.tar.gz
dh_make -f ../$NAME_PLUS_VER.tar.gz -a -s -c mit -y
cp -r ../debian_orig/* debian/
echo "---Now do 'dpkg-buildpackage -us -uc' or 'dpkg-buildpackage -b'"

cd $NAME_PLUS_VER
debuild -us -uc

#cp -r vscp-driver-l1-logger /tmp/__build__/vscp-driver-l1-logger-${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}
#cd /tmp/__build__
#tar czvf vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}.tar.gz vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}
#rm -rf vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}
#tar xzvf vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}.tar.gz
#cd vscp-driver-l1-logger-${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}
#dh_make -f ../vscp-driver-l1-logger_${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_VERSION}.tar.gz
#cp -r debian_orig/* debian
#debuild -us -uc
