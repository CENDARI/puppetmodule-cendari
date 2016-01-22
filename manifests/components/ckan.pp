# Private Class cendari::components::ckan
#
class cendari::components::ckan inherits cendari {


  ensure_packages(['tomcat7','solr-tomcat','python-pastescript'])

  package { 'cendari-ckan':
    ensure  => latest,
    require => [Package['tomcat7'],Package['solr-tomcat']],
  }

  # some more config
  file { '/etc/solr/conf/schema.xml':
    ensure  => link,
    target  => '/var/www/ckan/src/ckan/ckan/config/solr/schema.xml',
    require => [Package['cendari-ckan'],Package['solr-tomcat']],
    notify  => Service['tomcat7'],
  }

  file { '/etc/ckan':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/etc/ckan/apache.wsgi':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/ckan/apache.wsgi.erb'),
    notify  => Service['apache2'],
  }

  file { '/etc/ckan/production.ini':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/ckan/production.ini.erb'),
    notify  => Service['apache2'],
  }

  file { '/etc/ckan/who.ini':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cendari/etc/ckan/who.ini.erb'),
    notify  => Service['apache2'],
  }



}

