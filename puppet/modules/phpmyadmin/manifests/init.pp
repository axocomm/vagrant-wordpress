class phpmyadmin {
  package {'phpmyadmin':
    ensure  => installed,
    require => Package['php5-fpm']
  }

  file {'/vagrant/phpmyadmin':
    ensure  => 'link',
    target  => '/usr/share/phpmyadmin',
    require => Package['phpmyadmin']
  }
}
