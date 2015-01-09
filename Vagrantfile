
# Server Configuration
hostname      = "dog.dev"
server_name   = "debian76-dogCMS"
server_ip       = "172.135.52.20"


# Config Github Settings
github_username = "fideloper"
github_repo     = "Vaprobash"
github_branch   = "1.1.0"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

# Config Dogstudio Github Settings
#dogstudio_project  = "emulsion"
#dogstudio_repo     = "vagrant"
#dogstudio_branch   = "master"
#dogstudio_url      = "http://gitlab.dogstudio.be:800/#{dogstudio_project}/#{dogstudio_repo}/raw/#{dogstudio_branch}"

dogstudio_project  = "julienroland"
dogstudio_repo     = "Vagrant"
dogstudio_branch   = "master"
dogstudio_url      = "https://raw.githubusercontent.com/#{dogstudio_project}/#{dogstudio_repo}/#{dogstudio_branch}"

server_memory         = "512" # MB
server_swap           = "768" # Options: false | int (MB) - Guideline: Between one or two times the server_memory


# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# US/Central for American Central
# US/Eastern for American Eastern
server_timezone  = "UTC"

# Database Configuration
mysql_root_password   = "root"   # We'll assume user "root"
mysql_version         = "5.5"    # Options: 5.5 | 5.6
mysql_enable_remote   = "true"  # remote access enabled when true
pgsql_root_password   = "root"   # We'll assume user "root"
mongo_enable_remote   = "false"  # remote access enabled when true

# Languages and Packages
php_timezone          = "UTC"    # http://php.net/manual/en/timezones.php
ruby_version          = "latest" # Choose what ruby version should be installed (will also be the default version)
ruby_gems             = [        # List any Ruby Gems that you want to install
  #"jekyll",
  #"sass",
  #"compass",
]

# To install HHVM instead of PHP, set this to "true"
hhvm                  = "false"


# Default web server document root
# Symfony's public directory is assumed "web"
# Laravel's public directory is assumed "public"
public_folder         = "/vagrant"

nodejs_version        = "latest"   # By default "latest" will equal the latest stable version
nodejs_packages       = [          # List any global NodeJS packages that you want to install
  #"grunt-cli",
  #"gulp",
  #"bower",
  #"yo",
]

Vagrant.configure("2") do |config|

  # Set server to Debian 7.6
  config.vm.box = "rafacas/debian76-plain"

  config.vm.define "Vaprobash" do |vapro|
  end


  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  # TO DO: Make this work with virtualhost along-side xip.io URL
  config.vm.hostname = hostname

  # Create a static IP
  config.vm.network :private_network, ip: server_ip

  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']

  # If using VirtualBox
  config.vm.provider :virtualbox do |vb|

    vb.name = server_name

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end

  # If using VMWare Fusion
  config.vm.provider "vmware_fusion" do |vb, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"

    # Set server memory
    vb.vmx["memsize"] = server_memory

  end

  # If using Vagrant-Cachier
  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # Usage docs: http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    config.cache.synced_folder_opts = {
        type: :nfs,
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  ####
  # Base Items
  ##########

  # Provision Base Packages
  config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap, server_timezone]

  # Provision PHP
  config.vm.provision "shell", path: "#{dogstudio_url}/vagrant/scripts/php.sh", args: [php_timezone, hhvm]

  ####
  # Web Servers
  ##########

  # Provision Apache Base
  # config.vm.provision "shell", path: "#{dogstudio_url}/vagrant/nginx/apache.sh", args: [server_ip, public_folder, hostname, github_url, dogstudio_url]

  # Provision Nginx Base
   config.vm.provision "shell", path: "#{dogstudio_url}/vagrant/nginx/nginx.sh", args: [server_ip, public_folder, hostname, github_url, dogstudio_url]


  ####
  # Databases
  ##########

  # Provision MySQL
  config.vm.provision "shell", path: "#{dogstudio_url}/vagrant/scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]


  ####
  # Frameworks and Tooling
  ##########

  # Provision Composer
  config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", privileged: false, args: composer_packages.join(" ")

end
