class nginx {
  package { 'nginx':
    ensure => installed,
  }

  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['nginx'],
  }

  file { '/etc/nginx/nginx.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    notify => Service['nginx'],
  }

  exec { 'add-vagrant-to-www-data':
    path    => '/bin:/usr/bin:/usr/sbin',
    unless  => "grep -q 'www-data\\S*vagrant' /etc/group",
    command => 'usermod -aG www-data vagrant',
  }

  vhost { $hostname:
    name    => $hostname,
    wwwroot => $::wwwroot,
    notify  => Service['nginx'],
  }
}
