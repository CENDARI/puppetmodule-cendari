# Private Class cendari::components::litef
#
class cendari::components::litef inherits cendari {

  ensure_packages(['openjdk-7-jre-headless'])

  package { 'cendari-litef':
    ensure  => latest,
    require => [Package['openjdk-7-jre-headless'],User['litef'],File['/etc/litef/application.conf']],
  }

  file { '/opt/litef':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/etc/litef':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  user { 'litef':
    ensure => present,
    gid    => $::cendari::litef_user_group,
    system => true,
  }

  file {'/etc/litef/application.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('cendari/etc/litef/application.conf.erb'),
    require => File['/etc/litef'],
    notify  => Service['litef-conductor'],
  }

  file {'/var/log/litef':
    ensure => directory,
    owner  => 'litef',
    group  => 'root',
    mode   => '0755',
  }

  file {'/var/lib/litef':
    ensure => directory,
    owner  => 'litef',
    group  => 'root',
    mode   => '0755',
  }->
  file {'/var/lib/litef/default':
    ensure => directory,
    owner  => 'litef',
    group  => 'root',
    mode   => '0755',
  }->
  file {'/var/lib/litef/default/resources':
    ensure => directory,
    owner  => 'litef',
    group  => 'root',
    mode   => '0755',
  }

  service { 'litef-conductor':
    ensure     => true,
    enable     => true,
    require    => File['/var/log/litef'],
    hasrestart => true,
    hasstatus  => true,
  }

  logrotate::rule { 'litef-conductor':
    path         => '/var/log/litef/conductor.log',
    rotate       => 5,
    rotate_every => 'week',
    size         => '100M',
    compress     => true,
    copytruncate => true,
  }

}

