#!/bin/sh
files=`ls | grep .JPG$`
for org_fname in $files
do
	new_fname=`echo $org_fname | sed s/JPG$/jpg/`
	echo $org_fname ... $new_fname
	cp -f $org_fname $new_fname
done
