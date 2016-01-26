# Private Class cendari::repository
#
class cendari::repository inherits cendari {

  # add ubuntu repository if on trusty (repo doesn't have other distros)
  if $::osfamily == 'Debian' {
    if $::lsbdistcodename == 'trusty' {
      apt::source { 'cendari_deb_repository':
        comment           => 'CENDARI repository',
        location          => $::cendari::repo_url,
        release           => $::lsbdistcodename,
        repos             => $::cendari::repo_component,
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => $::cendari::repo_key_id,
        key_source        => $::cendari::repo_key_url,
        include_src       => false,
        include_deb       => true,
        architecture      => 'amd64',
      }
      exec {'update_cendari_deb_repository':
        path    => ['/usr/bin','/bin'],
        command =>  'apt-get update -o Dir::Etc::sourcelist="sources.list.d/cendari_deb_repository.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"',
        cwd     => '/tmp',
        user    => 'root',
        group   => 'root',
        require => Apt::Source['cendari_deb_repository'],
      }
    }
  }


}
