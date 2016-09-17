#!/usr/bin/env ruby
require 'trollop'
require 'yaml'
require_relative 'lib/ramsay.rb'

ramsay = Ramsay.new

case ARGV[0] 
	when 'run'
		ramsay.run		

	when 'file_config'
		opts = Trollop::options do
	  	opt :name, 'File name', :type => :string, :required => true
	  	opt :content, 'File content', :type => :string
	  	opt :permissions, 'File permissions', :type => :string, :default => "755"
	  	opt :location, 'File folder', :type => :string, :required => true
	  	opt :notifyOnUpdate, 'Packages to notify for restart package1,package2,..,packageN', :type => :string, :default => ''
		end
		ramsay.file_config(opts)

	when 'package_config'
		opts = Trollop::options do
			opt :package, 'Package to add to the install list', :type => :string, :required => true
			opt :status, 'Desired status of the package status1,status2,..,statusN', :default => ''
			opt :notifyOnUpdate, 'Services to notify when this package is installed', :default => ''
		end

		ramsay.package_config(opts)
	
	else
		puts "#{ARGV[0]} - Command not valid."
end