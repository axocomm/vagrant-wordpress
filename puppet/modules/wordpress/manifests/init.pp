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

class wordpress::setup {
  exec {'download-wp-core':
    path    => '/usr/bin:/usr/local/bin',
    cwd     => '/vagrant',
    unless  => 'test -f wp-load.php',
    command => 'wp core download'
  }

  exec {'create-wordpress-db':
    path    => '/usr/bin',
    unless  => "test $(echo \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '${::mysql_wordpress_dbname}'\") -gt 0",
    command => "mysql -uroot -p${::mysql_root_password} -e 'CREATE SCHEMA ${::mysql_wordpress_dbname}'",
    require => Exec['set-mysql-root-password']
  }

  exec {'create-wordpress-user':
    path    => '/usr/bin',
    unless  => "mysqladmin -u${::mysql_wordpress_user} -p${::mysql_wordpress_password} status",
    command => "mysql -uroot -p${::mysql_root_password} -e \"GRANT ALL ON ${::mysql_wordpress_dbname}.* TO '${::mysql_wordpress_user}' IDENTIFIED BY '${::mysql_wordpress_password}'; FLUSH PRIVILEGES\"",
    require => Exec['create-wordpress-db']
  }
}

class wordpress {
  include wordpress::wp-cli
  include wordpress::setup
}
