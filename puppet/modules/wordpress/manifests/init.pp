class wordpress::wp-cli {
  exec {'download-wp-cli':
    path    => '/bin:/usr/bin',
    unless  => 'test -f /tmp/wp-cli.phar',
    command => 'curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar'
  }

  exec {'install-wp-cli':
    path    => '/bin:/usr/bin',
    unless  => 'test -x /usr/local/bin/wp',
    command => 'mv /tmp/wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp',
    require => Exec['download-wp-cli']
  }
}

class wordpress {
  include wordpress::wp-cli
}
