#!/bin/bash
dir="/opt/ramsay"

if [[ ! -e $dir ]]; then
    mkdir $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

if [ "$(ls -A $DIR)" ]; then
     echo "Looks like you already have installed Ramsay"
else
	mv * /opt/ramsay/
fi

if [ -f /usr/bin/ramsay ]; then
	ln -s /opt/ramsay/ramsay.rb /usr/bin/ramsay
else
	echo "File /usr/bin/ramsay exists already."
fi

if [ ! -f /var/log/ramsay.log ]; then
	touch /var/log/ramsay.log
else
	echo "File /var/log/rasay.log exists already."
fi
