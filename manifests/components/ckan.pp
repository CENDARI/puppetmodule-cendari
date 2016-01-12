# Private Class cendari::components::ckan
#
class cendari::components::ckan inherits cendari {


  ensure_packages(['tomcat7'])

  # solr install

  package { 'cendari-ckan':
    ensure  => latest,
    require => [Package['tomcat7']],
  }

}

