# == Class cendari
#
#
class cendari (
  $adminmail      = $cendari::params::adminmail,
  $manage_repo    = $cendari::params::manage_repo,
  $repo_component = $cendari::params::repo_component,
  $repo_url       = $cendari::params::repo_url,
  $repo_key_url   = $cendari::params::repo_key_url,
  $repo_key_id    = $cendari::params::repo_key_id,
  $variant        = $cendari::params::variant,
) inherits cendari::params {

  validate_string($adminmail)
  validate_bool($manage_repo)
  validate_string($repo_component)
  validate_string($variant)


  anchor { 'cendari::prepare': }
  anchor { 'cendari::begin': }
  anchor { 'cendari::end': }

  if $manage_repo {
    class { 'cendari::repository': }
    Anchor['cendari::prepare'] -> Class['cendari::repository'] -> Anchor['cendari::begin']
  }

  case $variant {
    default,'cendariinabox': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::atom': } ->
      class { 'cendari::components::docs': } ->
      Anchor['cendari::end']
    }
    'frontoffice': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::docs': } ->
      Anchor['cendari::end']
    }
    'backofice': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::atom': } ->
      Anchor['cendari::end']
    }
  }
  

}

