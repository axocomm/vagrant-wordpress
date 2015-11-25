class wordpress::wp-cli {
  exec { 'download-wp-cli':
    path    => '/bin:/usr/bin',
    unless  => 'test -f /tmp/wp-cli.phar -o -f /usr/local/bin/wp',
    command => 'curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar',
    require => Package['php5-fpm'],
  }

  exec { 'install-wp-cli':
    path    => '/bin:/usr/bin',
    unless  => 'test -x /usr/local/bin/wp',
    command => 'mv /tmp/wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp',
    require => Exec['download-wp-cli'],
  }
}

class wordpress::setup {
  exec { 'download-wp-core':
    path    => '/usr/bin:/usr/local/bin',
    cwd     => "${::wwwroot}",
    user    => 'vagrant',
    unless  => 'test -f wp-load.php',
    command => 'wp core download',
    require => [Exec['install-wp-cli'],
                Package['php5-cli']],
  }

  exec { 'create-wordpress-db':
    path    => '/usr/bin',
    command => "mysql -uroot -p${::mysql_root_password} -e 'CREATE SCHEMA IF NOT EXISTS ${::mysql_wordpress_dbname}'",
    require => Exec['set-mysql-root-password'],
  }

  exec { 'create-wordpress-user':
    path    => '/usr/bin',
    unless  => "mysqladmin -u${::mysql_wordpress_user} -p${::mysql_wordpress_password} status",
    command => "mysql -uroot -p${::mysql_root_password} -e \"GRANT ALL ON ${::mysql_wordpress_dbname}.* TO '${::mysql_wordpress_user}' IDENTIFIED BY '${::mysql_wordpress_password}'; FLUSH PRIVILEGES\"",
    require => Exec['create-wordpress-db'],
  }

  exec { 'configure-wp':
    path    => '/usr/bin:/usr/local/bin',
    cwd     => $::wwwroot,
    unless  => 'test -f wp-config.php',
    command => "wp core config --dbname=${::mysql_wordpress_dbname} --dbuser=${::mysql_wordpress_user} --dbpass=${::mysql_wordpress_password} --extra-php=\"define('WP_DEBUG', true);\ndefine('JETPACK_DEV_DEBUG', true);\"",
    user    => 'vagrant',
    require => [Exec['create-wordpress-user'],
                Exec['install-wp-cli'],
                Exec['download-wp-core']],
  }

  exec { 'finish-wp-install':
    path    => '/usr/bin:/usr/local/bin',
    cwd     => $::wwwroot,
    user    => 'vagrant',
    unless  => 'wp core is-installed',
    command => "wp core install --url='${::wordpress_url}' --title='${::wordpress_title}' --admin_user='${::wordpress_admin_user}' --admin_password='${::wordpress_admin_password}' --admin_email='${::wordpress_admin_email}'",
    require => Exec['configure-wp'],
  }
}

class wordpress {
  include wordpress::wp-cli
  include wordpress::setup
}
