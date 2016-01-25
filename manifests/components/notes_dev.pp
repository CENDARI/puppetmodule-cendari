# Private Class cendari::components::notes_dev
#
class cendari::components::notes_dev inherits cendari {

  package {
    'libvips-tools':       ensure  => installed;
    'python-vipscc':       ensure  => installed;
    'libcurl4-gnutls-dev': ensure  => installed;
    'libjpeg-dev':         ensure  => installed;
    'libtiff5-dev':        ensure  => installed;
    'libopenjpeg-dev':     ensure  => installed;
    'zlib1g-dev':          ensure  => installed;
    'unixodbc-dev':        ensure  => installed;
    'libtiff4-dev':        ensure  => installed;
  }

  package {'libpq-dev':
    ensure => installed,
  }

  package {'python-dev':
    ensure => installed,
  }

  package {'libxml2-dev':
    ensure => installed,
  }

  package {'libxslt1-dev':
    ensure => installed,
  }

  package {'ruby-dev':
    ensure => installed,
  }


  python::pip { 'flup':
    pkgname => 'flup',
    owner   => 'root',
    timeout => 1800,
  }

}
