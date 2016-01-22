# Private Class cendari::components::ontologies
#
class cendari::components::ontologies (
  $webvowl_version        = '0.4.0',
) inherits cendari {

  ensure_packages(['unzip'])

  file { '/var/www/ontologies':
    ensure  => directory,
    require => Package['apache2'],
  }->
  file { '/var/www/ontologies/webvowl':
    ensure  => directory,
  }->
  # manually download and install webvowl
  staging::file { "webvowl-${webvowl_version}.zip":
    source  => "https://github.com/VisualDataWeb/WebVOWL/releases/download/${webvowl_version}/webvowl-${webvowl_version}.zip",
    timeout => 1800,
  }->
  exec { 'extract_webvowl':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => "unzip /opt/staging/cendari/webvowl-${webvowl_version} && chmod -R o+rX /var/www/ontologies/webvowl",
    cwd     => '/var/www/ontologies/webvowl',
    creates => '/var/www/ontologies/webvowl/index.html',
    require => Package['unzip'],
  }


}

