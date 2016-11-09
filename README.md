# vagrant-wordpress
A refresh of [vagrant-wordpress-lemp](https://bitbucket.org/axocomm/vagrant-wordpress-lemp), which aims to provide quick temporary WordPress development environments.

## Overview
### What is Included
+ Ubuntu 14.04
+ Nginx
+ PHP 5.6
+ MariaDB 10.0
+ phpMyAdmin
+ [WP-CLI](http://wp-cli.org/)

### Configuration
Configuration is mostly done inside the `Vagrantfile`. Key items are as follows:

+ `config.vm.hostname` - the hostname of the VM. With the Vagrant Hostsupdater plugin, it will be accessible at `http://<hostname>.dev/` when setup is complete.
+ `config.vm.network` - a static IP address for the VM
+ `config.vm.provider` block - contains modifications for the VM (right now just the RAM but this can be updated to suit your needs)
+ `config.vm.provision` block and `puppet.facter` hash - contains details for Puppet, which will provision the VM. The `facter` hash is used for various details for WordPress and MySQL.

### How to Use
To begin, copy `Vagrantfile.sample` to your machine in a folder where you want the website to be saved. Rename this file to `Vagrantfile` and edit line 16 as needed. Optionally, install [Vagrant Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) to automatically add the VM to your `hosts` file.

You will also need to create a `www` folder and also copy the `puppet` folder and its contents in to the same folder you've copied, and edited, the `Vagrantfile` into,

When all has been copied and edited; simply run `vagrant up` and, if all goes well, the environment should be ready to use in just a few minutes.

phpMyAdmin will also be accessible at `/phpmyadmin`.

The document root of the webserver is the `www` directory at the root of this project and is mapped to `/www` on the VM.

#### Default Credentials
Account     | Username  | Password
------------|-----------|---------
MySQL       | root      | vagrant
MySQL WP DB (wordpress) | wordpress | wordpress
WordPress Admin | vagrant | vagrant
