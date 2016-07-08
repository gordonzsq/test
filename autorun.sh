#!/bin/bash
########################################################
# filename : auto run list testing apps with uiautomator
# author: gordon
# date:    2016.07.07
# function: auto run testing app in LIST_FILE_PATH
# Implementing Measure: ./autorun.sh
########################################################

LIST_FILE_PATH=( 
	baiduyun 
	demo1
	emaildemo 
	qqtest 
	test-appwindow
	test-taobao
	todaynew
)

LOCAL_PATH=$(pwd)
TMP_PATH_STR=

function getPathStr()
{
	for file in `find *`
	do 
		if [ -d $file ]
			then cd $file
			TMP_PATH_STR=$TMP_PATH_STR"."$file
			getPathStr $1
		elif [ -f $file ]
		then
			TMP_PATH_STR=$TMP_PATH_STR"."$file
			return 
		fi
	done
}

function dotest()
{
	TEST_PATH=$1
	PROJECT_NAME=$1
	
	cd $LOCAL_PATH/$1/bin/com
	TMP_PATH_STR=com

	getPathStr $1
	echo $TMP_PATH_STR

	CLASS_NAME=${TMP_PATH_STR%.*}
#	PACKAGE_NAME=${CLASS_NAME%.*}
	PROJECT_NAME=$1".jar"
	
	echo "class name & project name is :"$CLASS_NAME  $PROJECT_NAME

	cd $LOCAL_PATH
	adb push $TEST_PATH/bin/$PROJECT_NAME /data/local/tmp
	adb shell uiautomator runtest $PROJECT_NAME -c $CLASS_NAME
}

for i in ${LIST_FILE_PATH[@]}
do
	echo "####################################################################"
	echo "testing in path $i:......."
	dotest $i
	echo "$i finish testing!"
done
