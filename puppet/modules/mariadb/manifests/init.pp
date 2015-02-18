class mariadb::install {
  include apt

  apt::key {'mariadb':
    ensure     => present,
    key        => '0xcbcb082a1bb943db',
    key_server => 'hkp://keyserver.ubuntu.com:80'
  }

  apt::source {'mariadb':
    location    => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu',
    release     => 'trusty',
    repos       => 'main',
    include_src => false,
    require     => Apt::Key['mariadb']
  }

  package {['mariadb-server-10.0', 'mariadb-client-10.0']:
    ensure  => installed,
    require => Apt::Source['mariadb']
  }

  exec {'Set MySQL root password':
    path        => '/bin:/usr/bin',
    unless      => "mysqladmin -uroot -p${::mysql_password} status",
    refreshonly => true,
    command     => "mysqladmin -uroot password ${::mysql_password}",
    subscribe   => Package['mariadb-server-10.0']
  }
}

class mariadb::php5-mysql {
  package {'php5-mysql':
    ensure  => installed,
    require => Package['php5-fpm', 'mariadb-server-10.0'],
    notify  => Service['php5-fpm']
  }
}