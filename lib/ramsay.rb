require 'logger'
require_relative 'system_methods.rb'

class Ramsay
	@@files_folder = "/opt/ramsay/files/"
	@@packages_folder = "/opt/ramsay/packages/"
	@@log_file = "/var/log/ramsay.log"
  
  def run
    logger = Logger.new(@@log_file)
    logger.info("ramsay run started.")
    Dir.glob("#{@@files_folder}*.yml", File::FNM_DOTMATCH) do |file|
      file_config = YAML.load_file(file)
      file_name = file_config['file']['filename']
      file_content = file_config['file']['content']
      file_location = file_config['file']['location']
      file_permissions = file_config['file']['permissions']
      to_notify = file_config['file']['notifyOnUpdate']
      file_full_name = "#{file_location}/#{file_name}"
      notify = false

      if (!File.file?(file_full_name))
        logger.info("File #{file_full_name} doesn't exits. Creating.")
        write_file_content(file_full_name, file_content)
        assign_permissions(file_permissions, file_full_name)
        notify = true
      else
        logger.info("File #{file_full_name} exists. Checking its content.")
        current_file_content = File.read(file_full_name)
        if (current_file_content == file_content)
          notify = false
          logger.info("File #{file_full_name} exists and its content is unchanged.")
        else
          write_file_content(file_full_name, file_content)
          notify = true
          logger.info("File #{file_full_name} exists but content is updated.")
        end

        current_file_permissions = get_current_permissions(file_full_name)
        if (current_file_permissions.to_i != file_permissions.to_i)
          assign_permissions(file_permissions, file_full_name)
          notify = true
          logger.info("File #{file_full_name} permissions changed.")
        else  
          logger.info("File #{file_full_name} permissions unchanged.")
        end
      end
      
      if (to_notify != nil && notify == true)
        to_notify.each do |service|
          restart_service(service)
          logger.info("#{service} restarted")
        end
      end
    end

    Dir.glob("#{@@packages_folder}*.yml") do |file|
      package_config = YAML.load_file(file)
      package_name = package_config['package']
      package_status = package_config['status']
      to_notify = package_config['notifyOnUpdatey']
      notify = false

      if(!package_status.include? 'removed')
        if(check_package(package_name) == '')
          install_package(package_name)
          notify = true
          logger.info("Package #{package_name} installed.")
        else
          logger.warn("Package #{package_name} installed.")
        end
      else
        if(check_package(package_name) != '')
          remove_package(package_name)
          logger.info("Package #{package_name} removed.")
          notify = true
        else
          logger.warn("Package #{package_name} not installed, cannot be removed.")
        end
      end

      if(package_status.include? 'enabled')
        enable_service(package_name)
        logger.info("Package #{package_name} enabled at startup.")
        notify = true
      end

      if(package_status.include? 'started')
        start_service(package_name)
        logger.info("Package #{package_name} started.")
        notify = true
      end

      if (to_notify != nil && notify == true)
        to_notify.each do |service|
          restart_service(service)
          logger.info("Service #{service} restarted.")
        end
      else
          logger.info("No services restarted.")
      end
    end
  end

  # Method to create a new file
	def file_config(opts)
    logger = Logger.new(@@log_file)
    file_content = Hash.new
    to_notify = opts[:notifyOnUpdate].split(',')

    file_content['file'] = {
  	 "filename" => opts[:name],
  	 "content" => opts[:content],
  	 "permissions" => opts[:permissions],
  	 "location" => opts[:location],
  	 "notifyOnUpdate" => to_notify
    }

    if (!File.file?("#{@@files_folder}#{opts[:name]}.yml"))
      puts "New file #{opts[:name]} will be created."
    else 
      puts "The file #{opts[:name]}, you tried to create already exists and it will be updated with your config."
    end

    File.open("#{@@files_folder}#{opts[:name]}.yml","w") do |f|
      f.write(file_content.to_yaml)
      logger.info("Config file #{opts[:name]} updated.")       
      f.close()
    end

  end

  def package_config(opts)
    logger = Logger.new(@@log_file)
    file_content = Hash.new
    desired_status = opts[:status].split(',')
    to_notify = opts[:notifyOnUpdate].split(',')
    file_content = {
     "package" => opts[:package],
     "status" => desired_status,
     "to_notify" => to_notify
    }

    if (!File.file?("#{@@packages_folder}#{opts[:package]}.yml"))
      puts "New package config #{opts[:package]}.yml will be created."         
    else
      puts "Package config #{opts[:package]}.yml exists and it will be replaced."
    end
    
    File.open("#{@@packages_folder}#{opts[:package]}.yml","w") do |f|
      f.write(file_content.to_yaml)
      logger.info("Config package #{opts[:package]} updated.")       
      f.close()
    end       
  end
end

