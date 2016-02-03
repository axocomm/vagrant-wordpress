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

  file { '/etc/phpmyadmin/config-db.php':
    content => template('phpmyadmin/config-db.php.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['phpmyadmin'],
  }

  exec { 'create-pma-tables':
    command => "zcat /usr/share/doc/phpmyadmin/examples/create_tables.sql.gz | mysql -uroot -p${::mysql_root_password}",
    unless  => 'test -d /var/lib/mysql/phpmyadmin',
    require => Package['phpmyadmin'],
    path    => '/bin:/usr/bin',
  }
}
