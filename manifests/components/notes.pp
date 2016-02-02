# Private Class cendari::components::notes
#
class cendari::components::notes inherits cendari {

  include 'cendari::components::notes_dev'

  package { 'cendari-notes':
    ensure  => latest,
    require => File['/etc/supervisor/conf.d/notes.conf'],
  }

  package { 'iipimage-server':
    ensure  => installed,
    require => Package['apache2'],
  }

  package { 'imagemagick':
    ensure  => installed,
  }

  package { 'supervisor':
    ensure  => installed,
  }->
  file{'/etc/supervisor/conf.d/notes.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/supervisor/conf.d/notes.conf.erb'),
  }

  # wsgi script to load by apache
  file {'/var/www/notes/cendari/wsgi.py':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('cendari/var/www/notes/cendari/wsgi.py.erb'),
    require => Package['cendari-notes'],
    notify  => Service['apache2'],
  }

  # configuration file with local settings
  file {'/var/www/notes/editorsnotes/settings_local.py':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/var/www/notes/editorsnotes/settings_local.py.erb'),
    require => Package['cendari-notes'],
    notify  => Service['apache2'],
  }

  # set directory permissions
  file {'/var/www/notes/static/CACHE':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
    require => Package['cendari-notes'],
  }

  file { '/var/cache/notes':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
    require => [Package['cendari-notes'],Package['iipimage-server']]
  }

  file { '/var/log/notes':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    before => Package['cendari-notes'],
  }->
  file { '/var/log/notes/debug.log':
    ensure => file,
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { '/var/cache/notes/uploads':
    ensure  => directory,
    owner   => 'www-data',
    recurse => true,
    require => [Package['cendari-notes'],Package['iipimage-server'],File['/var/cache/notes']]
  }

  file { '/etc/odbc.ini':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/odbc.ini.erb'),
    notify  => Service['apache2'],
  }

  # configuration for image server
  file { '/etc/apache2/mods-available/iipsrv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/apache2/mods-available/iipsrv.conf.erb'),
    require => [File['/var/cache/notes'],Package['iipimage-server']],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/mods-enabled/iipsrv.conf':
    ensure  => link,
    target  => '/etc/apache2/mods-available/iipsrv.conf',
    require => File['/etc/apache2/mods-available/iipsrv.conf'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/mods-enabled/iipsrv.load':
    ensure  => link,
    target  => '/etc/apache2/mods-available/iipsrv.load',
    require => File['/etc/apache2/mods-available/iipsrv.conf'],
    notify  => Service['apache2'],
  }


}
