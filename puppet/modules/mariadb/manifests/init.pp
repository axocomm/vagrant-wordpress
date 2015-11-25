class mariadb::install {
  include apt

  apt::key { 'mariadb':
    ensure => present,
    id     => 'cbcb082a1bb943db',
    server => 'hkp://keyserver.ubuntu.com:80',
  }

  apt::source { 'mariadb':
    location    => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu',
    release     => 'trusty',
    repos       => 'main',
    include     => {
      'src' => false,
    },
    require     => Apt::Key['mariadb'],
  }

  exec { 'update-apt':
    path    => '/usr/bin',
    unless  => 'dpkg -s mariadb-server-10.0',
    command => 'apt-get update',
    require => Apt::Source['mariadb'],
  }

  package { ['mariadb-server-10.0', 'mariadb-client-10.0']:
    ensure  => installed,
    require => Exec['update-apt'],
  }

  exec { 'set-mysql-root-password':
    path        => '/bin:/usr/bin',
    unless      => "mysqladmin -uroot -p${::mysql_root_password} status",
    refreshonly => true,
    command     => "mysqladmin -uroot password ${::mysql_root_password}",
    subscribe   => Package['mariadb-server-10.0'],
  }
}

class mariadb::php5-mysql {
  package { 'php5-mysql':
    ensure  => installed,
    require => Package['php5-fpm', 'mariadb-server-10.0'],
    notify  => Service['php5-fpm'],
  }
}
