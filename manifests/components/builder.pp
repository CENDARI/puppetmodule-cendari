# Private Class cendari::components::builder
#
class cendari::components::builder inherits cendari {

  ensure_packages(['openjdk-7-jre-headless','openjdk-7-jdk','maven'])
  ensure_packages(['libsasl2-dev','php5-cli'])

  Package['openjdk-7-jdk'] -> Package['maven']

  package {
    'texlive-generic-recommended': ensure => installed;
    'texlive-latex-recommended':   ensure => installed;
    'texlive-latex-extra':         ensure => installed;
    'texlive-fonts-recommended':   ensure => installed;
    'texlive-fonts-extra':         ensure => installed;
    'lmodern':                     ensure => installed;
    'fonts-linuxlibertine':        ensure => installed;
    'texlive-xetex':               ensure => installed;
  }

  # install fpm as gem
  exec { 'gem_install_fpm':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'gem install fpm',
    cwd     => '/tmp',
    creates => '/usr/local/bin/fpm',
    umask   => '0022',
  }
  
  # install bower via npm
  exec { 'npm_install_bower':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'npm install -g bower',
    cwd     => '/tmp',
    creates => '/usr/local/bin/bower',
    umask   => '0022',
  }

  # install grunt via npm
  exec { 'npm_install_grunt_cli':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'npm install -g grunt-cli',
    cwd     => '/tmp',
    creates => '/usr/local/bin/grunt',
    umask   => '0022',
  }

  # manually install doxphp
  exec { 'install_doxphp':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'git clone https://github.com/avalanche123/doxphp.git /opt/doxphp',
    cwd     => '/tmp',
    creates => '/opt/doxphp',
  }
  file { '/usr/local/bin/doxphp2sphinx':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    target  => '/opt/doxphp/bin/doxphp2sphinx',
    require => Exec['install_doxphp'],
  }
  file { '/usr/local/bin/doxphp':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    target  => '/opt/doxphp/bin/doxphp',
    require => Exec['install_doxphp'],
  }

  # sbt to compile litef  
  staging::deploy { 'sbt-0.13.6.tgz':
    source  => 'https://dl.bintray.com/sbt/native-packages/sbt/0.13.6/sbt-0.13.6.tgz',
    target  => '/opt/',
    creates => '/opt/sbt',
  }

  # build scripts
  file {'/opt/cendari/cendari_build_docs.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_docs.sh',
  }->
  file { '/usr/local/bin/cendari_build_docs':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_docs.sh',
  }
  file {'/opt/cendari/cendari_build_notes.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_notes.sh',
  }->
  file { '/usr/local/bin/cendari_build_notes':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_notes.sh',
  }
  file {'/opt/cendari/cendari_build_ckan.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_ckan.sh',
  }->
  file { '/usr/local/bin/cendari_build_ckan':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_ckan.sh',
  }

  file {'/opt/cendari/cendari_build_atom.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_atom.sh',
  }->
  file { '/usr/local/bin/cendari_build_atom':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_atom.sh',
  }

  file {'/opt/cendari/cendari_build_pineapple.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_pineapple.sh',
  }->
  file { '/usr/local/bin/cendari_build_pineapple':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_pineapple.sh',
  }

  file {'/opt/cendari/cendari_build_litef.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_litef.sh',
  }->
  file { '/usr/local/bin/cendari_build_litef':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_litef.sh',
  }

  file {'/opt/cendari/cendari_build_ontologies.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cendari/opt/cendari/cendari_build_ontologies.sh',
  }->
  file { '/usr/local/bin/cendari_build_ontologies':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/cendari/cendari_build_ontologies.sh',
  }

  file { '/var/cache/cendari_builder':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0777',
  }


}
