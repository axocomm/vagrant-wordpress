class mariadb::install {
  package {'mariadb-server':
    ensure => installed
  }

  exec {'Set MySQL root password':
    path        => '/bin:/usr/bin',
    unless      => "mysqladmin -uroot -p${::mysql_password} status",
    refreshonly => true,
    command     => "mysqladmin -uroot password ${::mysql_password}",
    subscribe   => Package['mariadb-server']
  }
}
