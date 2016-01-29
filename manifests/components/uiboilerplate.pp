# Private Class cendari::components::uiboilerplate
#
class cendari::components::uiboilerplate inherits cendari {

  # download from github
  vcsrepo { '/var/www/uiboilerplate':
    ensure   => latest,
    owner    => 'www-data',
    group    => 'www-data',
    revision => 'master',
    provider => git,
    source   => 'https://github.com/CENDARI/UI-Boilerplate.git',
  }


}
