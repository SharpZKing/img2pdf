#! /bin/bash

# only support *.png to pdf now(2022-03-13).

OLDIFS=$IFS
IFS=$'\n'
function read_dir(){
    for file in `ls $1` 
    do
        if [ -d $1"/"$file ]  
        then
            read_dir $1"/"$file
        else
            if echo "$file" | grep -q -E '\.png$'
            then
		target=$file
                len=$(echo ${#target})
		len=$(expr $len - 4)  # .png length: 4
                target=$(echo ${target: 0: $len})
                echo trans $1"/"$file to $1"/pdf/"$target".pdf"
		
		# convert is a command name, can be installed by imagemagick in linux, windows, macos and etc.
		# reference with: 
	        convert $1"/"$file $1"/pdf/"$target".pdf"
            fi
        fi
    done
}

if [ "" = "$1" ] ;then
    echo "you must input a directory to parameter"
    exit 0
fi

# $1 is must a directory which contains images with suffix ".png"   
if [ ! -d $1 ]; then
    echo "$1 not a directory"
    exit 0
fi

if [ -d $1/pdf ]; then
    rm -rf $1/pdf
fi 

mkdir -p $1/pdf
read_dir $1
IFS=$OLDIFS
