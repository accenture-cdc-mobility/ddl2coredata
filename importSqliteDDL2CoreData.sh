#!/bin/sh

# create importing target database
sqlite3 $1 ""

# run DDL
cat $2 | sqlite3 $1

# call sqlite2coredata
./sqlite2coredata $1 ~/output $3

# create new version in the current coredata model
TIME_VERSION=`date "+%Y-%m-%d-%H-%M-%S"`
#echo $TIME_VERSION
sed -e s/{0}/$3_$TIME_VERSION/g xccurrentversion_template > ~/output/$3.xcdatamodeld/.xccurrentversion

# copy the new version
#cp ~/output/$3.xcdatamodeld/.xccurrentversion $4/
cp -R ~/output/$3.xcdatamodeld/$3.xcdatamodel $4/$3_$TIME_VERSION.xcdatamodel
