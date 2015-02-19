# vagrant-wordpress
A refresh of [vagrant-wordpress-lemp](https://bitbucket.org/axocomm/vagrant-wordpress-lemp). This Vagrant setup is based on the Ubuntu 14.04 Vagrant box and includes Nginx, MariaDB 10.0, PHP 5.6, and [WP-CLI](http://wp-cli.org/).

## Overview
### Configuration
Configuration is mostly done inside the `Vagrantfile`. Key items are as follows:
+ `config.vm.hostname` - the hostname of the VM. With the Vagrant Hostsupdater plugin, it will be accessible at `http://<hostname>.dev/` when setup is complete.
+ `config.vm.network` - a static IP address for the VM
+ `config.vm.provider` block - contains modifications for the VM (right now just the RAM but this can be updated to suit your needs)
+ `config.vm.provision` block and `puppet.facter` hash - contains details for Puppet, which will provision the VM. The `facter` hash is used for various details for WordPress and MySQL.

### How to Use
To begin, copy `Vagrantfile.sample` to `Vagrantfile` and edit as needed. Optionally, install [Vagrant Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) to automatically add the VM to your `hosts` file.

When complete, simply run `vagrant up` and if all goes well the environment should be ready to use in just a few minutes.

#### Default Credentials
Account     | Username  | Password
------------|-----------|---------
MySQL       | root      | vagrant
MySQL WP DB (wordpress) | wordpress | wordpress
WordPress Admin | vagrant | vagrant
