class phpmyadmin {
  package { 'phpmyadmin':
    ensure  => installed,
    require => [Package['php5-fpm'],
                Package['mariadb-server-10.0']],
  }

  file { '/www/phpmyadmin':
    ensure  => 'link',
    target  => '/usr/share/phpmyadmin',
    require => Package['phpmyadmin'],
  }
}
