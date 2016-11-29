class php56-fpm {
  include apt

  apt::key { 'ppa:ondrej/php':
    ensure => present,
    server => 'hkp://keyserver.ubuntu.com:80',
    id     => '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C',
  }

  apt::ppa { 'ppa:ondrej/php':
    require => Apt::Key['ppa:ondrej/php'],
  }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    require => Apt::Ppa['ppa:ondrej/php'],
  }

  package { ['php5.6-fpm', 'php5.6-cli']:
    ensure  => installed,
    require => Exec['apt-get update'],
  }

  service { 'php5.6-fpm':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['php5.6-fpm'],
  }

  file { '/etc/php/5.6/fpm/pool.d/www.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/php56-fpm/www.conf',
    notify  => Service['php5.6-fpm'],
    require => Package['php5.6-fpm'],
  }

  file { '/etc/php/5.6/fpm/php.ini':
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/php56-fpm/php.ini',
    notify  => Service['php5.6-fpm'],
    require => Package['php5.6-fpm'],
  }

  include mariadb::php56-mysql
}
