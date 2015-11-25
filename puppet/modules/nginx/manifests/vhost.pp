define nginx::vhost(
  $name,
  $aliases = [],
  $port    = '80',
  $wwwroot,
  $index   = 'index.html index.htm index.php',
  $enabled = true,
) {
  include nginx

  $listen_port = $default ?{
    true    => "${port} default",
    default => $port,
  }

  file { "/etc/nginx/sites-available/${name}":
    content => template('nginx/vhost.erb'),
  }

  if $enabled {
    file { "/etc/nginx/sites-enabled/${name}":
      ensure => 'link',
      target => "/etc/nginx/sites-available/${name}",
    }
  }
}
