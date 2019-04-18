# Ramsay
## This a simple exercise tool
Ramsay is a simple configuration management tool that provides a command line utility to create config files. 

## Requirements
Ramsay is written in Ruby and it has been tested with Ruby 1.9.3 and 2.2.5. The only requirements are two gems:
- trollop 
- logger

To install gems on your system please use:

```sh
$ gem install trollop logger
```
A script to install the requirements can be found here: [bootstrap.sh](https://s3-eu-west-1.amazonaws.com/andrea-share1/bootstrap.sh).

## Installation
Make sure to have Ruby with the requirements above installed on your system.

```sh
$ git clone https://github.com/ChaosMAO/ramsay.git
$ cd ramsay
$ chmod +x install.sh
$ sudo ./install.sh
```

## How to use
#### File config creation
```sh
$ sudo ramsay file_config --name testfile --location /tmp --content "This is a test file" --permissions --notifyOnUpdate apache2
```
The command creates a testfile.yml file in /opt/ramsay/files, with the specified settings. If you run the command and the file exists the config will be overwritten. Options meaning:
- name: file name to be created at execution time
- location: directory of the file to be created at execution time
- content: content of the file to be created at execution time
- permissions: permissions of the file to to be created at execution time
- notifyOnUpdate: list of services to restart if the file changes (service1,service2,serviceN)

The config file will look like:
```yaml
file:
  filename: index.php
  content: '<?php header("Content-Type: text/plain");echo "Hello, world!\n" ?>'
  permissions: '755'
  location: /var/www/html
```
**You can create your config files and place them in the /opt/ramsay/files/ folder as long as they are in YAML format and contain the appropriate fields.**

#### Package config creation
```sh
$ sudo ramsay package_config --package apache2 --status started,enabled --notifyOnUpdate service1,service2
```
The command creates an apache2.yml file in /opt/ramsay/packages, with the specified settings. If you run the command and the file exists the config will be overwritten. Options meaning:
- package: name of the package to install
- status: desired status of the package, can be: started, enabled, removed. 
- notifyOnUpdate: list of services to restart if package is installed/removed (service1,service2,serviceN)

The config file will look like:
```yaml
package: apache2
status:
- started
notifyOnUpdate: []
```
**You can create your config files and place them in the /opt/logs/packages/ folder as long as they are in YAML format and contain the appropriate fields.**

#### Ramsay run
```sh
$ sudo ramsay run
```
The run command, will read all the configuration files and create files, install packages, restart services, based on the desired state. If no changes are made to the config files, no actions are taken on the system. **Logs of executions can be found in /var/www/ramsay.log.**  
