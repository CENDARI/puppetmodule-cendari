# Private Class cendari::components::ontologies
#
class cendari::components::ontologies (
  $webvowl_version        = '0.4.0',
) inherits cendari {

  package { 'cendari-ontologies':
    ensure => latest
  }

}

