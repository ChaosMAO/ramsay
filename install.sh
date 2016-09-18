#!/bin/bash
dir="/opt/ramsay"

if [[ ! -e $dir ]]; then
    mkdir $dir
    mv * /opt/ramsay/
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

if [ -f /usr/bin/ramsay ]; then
	echo "File /usr/bin/ramsay exists already."
else
	ln -s /opt/ramsay/ramsay.rb /usr/bin/ramsay
fi

if [ ! -f /var/log/ramsay.log ]; then
	touch /var/log/ramsay.log
else
	echo "File /var/log/rasay.log exists already."
fi
