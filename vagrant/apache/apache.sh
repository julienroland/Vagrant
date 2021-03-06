#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# If HHVM is installed, assume PHP is *not*
[[ $HHVM_IS_INSTALLED -eq 0 ]] && { PHP_IS_INSTALLED=-1; }

echo ">>> Installing Apache Server"

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [[ -z $2 ]]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

if [[ -z $4 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$4"
fi

if [[ -z $5 ]]; then
    dogstudio_url="https://raw.githubusercontent.com/julienroland/Vagrant/master"
else
    dogstudio_url="$5"
fi

echo "Repo use >>>" $dogstudio_url

# Install Apache
# -qq implies -y --force-yes
sudo apt-get install -y apache2
sudo apt-get install -y libapache2-mod-php5

echo ">>> Configuring Apache"

# Add vagrant user to www-data group
sudo usermod -a -G www-data vagrant

# Apache Config
# On separate lines since some may cause an error
# if not installed
sudo a2enmod rewrite actions ssl

sudo cat /vagrant/vagrant/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start, with SSL certificate
sudo vhost -s $1.xip.io -d $public_folder -p /etc/ssl/xip.io -c xip.io -a $3
sudo a2dissite 000-default

sudo service apache2 restart
