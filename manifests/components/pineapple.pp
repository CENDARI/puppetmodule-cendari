# Private Class cendari::components::pineapple
#
class cendari::components::pineapple inherits cendari {

  package { 'cendari-pineapple':
    ensure  => latest,
  }

  file { '/var/www/pineapple':
    ensure => directory,
    mode   => '0755',
  }->
  file { '/var/www/pineapple/cache':
    ensure => directory,
    owner  => 'www-data',
    mode   => '0755',
  }->
  file_line { 'pineapple_htaccess':
    path    => '/var/www/pineapple/public/.htaccess',
    match   => '^RewriteBase',
    line    => "RewriteBase ${::cendari::pineapple_rewrite_base}",
    require => Package['cendari-pineapple'],
  }

}
