# Private Class cendari::components::atom
#
class cendari::components::atom inherits cendari {

  package { 'cendari-atom':
    ensure  => latest,
  }

  # config files
  file { '/var/www/atom2/config/config.php':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['cendari-atom'],
    content => template('cendari/var/www/atom2/config/config.php.erb'),
  }

  file { '/var/www/atom2/config/propel.ini':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['cendari-atom'],
    source  => '/var/www/atom2/config/propel.ini.tmpl'
  }

  file { '/var/www/atom2/atom2ckan/complete_atom_to_ckan_config.php':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['cendari-atom'],
    content => template('cendari/var/www/atom2/atom2ckan/complete_atom_to_ckan_config.php.erb'),
  }

  cron { 'atom2ckanjob' :
    command => 'cd /var/www/atom2/atom2ckan && php complete_atom_to_ckan.php',
    user    => 'www-data',
    hour    => '04',
    minute  => '37',
    require => File['/var/www/atom2/atom2ckan/complete_atom_to_ckan_config.php'],
  }

  file { '/var/www/atom2/config/search.yml':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0400',
    require => Package['cendari-atom'],
    content => template('cendari/var/www/atom2/config/search.yml.erb'),
  }

  file { '/var/www/atom2/config/databases.yml':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0400',
    require => Package['cendari-atom'],
    content => '',
  }

  file { '/var/www/atom2/apps/qubit/config/app.yml':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0400',
    require => Package['cendari-atom'],
    content => template('cendari/var/www/atom2/apps/qubit/config/app.yml.erb'),
  }

  file { '/var/www/atom2/apps/qubit/config/settings.yml':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0400',
    require => Package['cendari-atom'],
    content => template('cendari/var/www/atom2/apps/qubit/config/settings.yml.erb'),
  }




}

