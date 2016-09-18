#!/bin/bash
mkdir /opt/ramsay
mv * /opt/ramsay/
ln -s /opt/ramsay/ramsay.rb /usr/bin/ramsay
touch /var/log/ramsay.log