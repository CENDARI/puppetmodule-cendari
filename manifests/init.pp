# == Class cendari
#
#
class cendari (
  $adminmail                   = $cendari::params::adminmail,
  $manage_repo                 = $cendari::params::manage_repo,
  $repo_component              = $cendari::params::repo_component,
  $repo_url                    = $cendari::params::repo_url,
  $repo_key_url                = $cendari::params::repo_key_url,
  $repo_key_id                 = $cendari::params::repo_key_id,
  $variant                     = $cendari::params::variant,
  $atom_url                    = $cendari::params::atom_url,
  $atom_mysql_db               = $cendari::params::atom_mysql_db,
  $atom_mysql_user             = $cendari::params::atom_mysql_user,
  $atom_mysql_password         = $cendari::params::atom_mysql_password,
  $atom_ckanuser_name          = $cendari::params::atom_ckanuser_name,
  $atom_ckanuser_apikey        = $cendari::params::atom_ckanuser_apikey,
  $atom_dataspace_name         = $cendari::params::atom_dataspace_name,
  $atom_dataspace_id           = $cendari::params::atom_dataspace_id,
  $atom_ckansync_user_email    = $cendari::params::atom_ckansync_user_email,
  $atom_ckansync_user_password = $cendari::params::atom_ckansync_user_password,
  $atom_ckansync_ckan_url      = $cendari::params::atom_ckansync_ckan_url,
  $atom_mail_report_to         = $cendari::params::atom_mail_report_to,

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
      class { 'cendari::components::ckan': } ->
      class { 'cendari::components::docs': } ->
      class { 'cendari::components::litef': } ->
      class { 'cendari::components::notes': } ->
      class { 'cendari::components::pineapple': } ->
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

