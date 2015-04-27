class mysql::install {
  package {['mysql-server-5.5', 'mysql-client-5.5']:
    ensure  => installed
  }

  exec {'set-mysql-root-password':
    path        => '/bin:/usr/bin',
    unless      => "mysqladmin -uroot -p${::mysql_root_password} status",
    refreshonly => true,
    command     => "mysqladmin -uroot password ${::mysql_root_password}",
    subscribe   => Package['mysql-server-5.5']
  }
}

class mysql::php5-mysql {
  package {'php5-mysql':
    ensure  => installed,
    require => Package['php5-fpm', 'mysql-server-5.5'],
    notify  => Service['php5-fpm']
  }
}
