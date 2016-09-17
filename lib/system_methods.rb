# Function to assign permissions to a file
def assign_permissions(permissions, file)
	`chmod #{permissions} #{file}`
end

def get_current_permissions(file)
	current_permissions = `stat -c "%a" "#{file}"`
end

# Function to write desired content to a file
def write_file_content(file, content)
  File.open("#{file}","w") do |f|
  	puts file
    f.write("#{content}")
    f.close()
  end
end

# Function to restart a service
def restart_service(service)
	puts "I am restarting"
	`sudo service #{service} restart`
end

# Function to start a service
def start_service(service)
	`sudo service #{service} start`
end

# Functions to install and remove a package
def install_package(package)
	`apt-get install -y "#{package}"`
end

def remove_package(package)
	`apt-get remove -y "#{package}"`
end

# Function to enable a service at boot
def enable_service(package)

end

# Function to check if a package is installed
def check_package(package)
	is_package_installed = `dpkg -s "#{package}"`
end