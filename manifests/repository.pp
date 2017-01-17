# Private Class cendari::repository
#
class cendari::repository inherits cendari {

  # add ubuntu repository if on trusty (repo doesn't have other distros)
  if ($::osfamily == 'Debian') and ($::lsbdistcodename == 'trusty') {
    apt::source { 'dariah_apt_repository':
      comment      => 'DARIAH repository',
      location     => $::cendari::repo_url,
      release      => $::lsbdistcodename,
      repos        => $::cendari::repo_component,
      architecture => 'amd64',
      key          => {
        'source' => $::cendari::repo_key_url,
        'id'     => $::cendari::repo_key_id,
      },
      include      => {
        'src' => false,
        'deb' => true,
      },
    }
    # this exec runs only, if the precondition is not satisfied and than fails
    # the precondition is a successful update of the dariah repos resources
    # thus the resource will fail if the precondition fails but not report "changed" on success
    exec {'update_dariah_apt_repository':
      path    => ['/usr/bin','/bin'],
      command => 'apt-get update -o Dir::Etc::sourcelist="sources.list.d/dariah_apt_repository.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"',
      unless  => 'apt-get update -o Dir::Etc::sourcelist="sources.list.d/dariah_apt_repository.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"',
      cwd     => '/tmp',
      user    => 'root',
      group   => 'root',
      require => Apt::Source['dariah_apt_repository'],
    }
  }


}
