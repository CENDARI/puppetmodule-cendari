# Private Class cendari::components::notes_dev
#
class cendari::components::notes_dev inherits cendari {

  ensure_packages(['libvips-tools','python-vipscc','libcurl4-gnutls-dev', 'libjpeg-dev', 'libtiff5-dev', 'libopenjpeg-dev', 'zlib1g-dev', 'unixodbc-dev', 'libtiff4-dev'])

  ensure_packages(['libpq-dev','python-dev','libxml2-dev', 'libxslt1-dev', 'ruby-dev', 'git'])

  python::pip { 'flup':
    pkgname => 'flup',
    owner   => 'root',
    timeout => 1800,
  }

}
