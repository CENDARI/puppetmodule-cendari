# Private Class cendari::components::docs
#
class cendari::components::docs inherits cendari {

  package { 'cendari-docs':
    ensure => latest,
  }


}

