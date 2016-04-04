# Private Class cendari::components::defaults
#
class cendari::components::defaults inherits cendari {

  ensure_packages(['g++','python-pip','python-virtualenv','nfs-common','nodejs','nodejs-legacy','ruby-dev','npm','fabric'])

  # install less compiler
  exec { 'npm_install_lessc':
    path    => ['/usr/bin','/bin'],
    command => 'npm install -g less@1.3.3',
    cwd     => '/root',
    user    => 'root',
    group   => 'root',
    umask   => '0022',
    unless  => '[ "$(ls -A /usr/local/bin/lessc)" ]',
    require => Package['npm'],
  }
  file { '/usr/bin/lessc':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/usr/local/bin/lessc',
  }

  # install sass compiler
  exec { 'npm_install_sass':
    path    => ['/usr/bin','/bin'],
    command => 'npm install -g node-sass@3.2.0',
    cwd     => '/root',
    user    => 'root',
    group   => 'root',
    umask   => '0022',
    unless  => '[ "$(ls -A /usr/local/bin/node-sass)" ]',
    require => Package['npm'],
  }
  file { '/usr/bin/node-sass':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/usr/local/bin/node-sass',
  }

  file { '/opt/cendari':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
