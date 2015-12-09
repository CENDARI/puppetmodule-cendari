# == Class cendari
#
#
class cendari (
  $adminmail      = $cendari::params::adminmail,
  $manage_repo    = $cendari::params::manage_repo,
  $repo_component = $cendari::params::repo_component,
  $variant        = $cendari::params::variant,
) inherits cendari::params {

  validate_string($adminmail)
  validate_bool($manage_repo)
  validate_string($repo_component)
  validate_string($variant)




}

