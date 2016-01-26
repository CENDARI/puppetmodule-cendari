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
  $ckan_shibplugin             = $cendari::params::ckan_shibplugin,
  $ckan_storagepath            = $cendari::params::ckan_storagepath,
  $ckan_pgsqldb                = $cendari::params::ckan_pgsqldb,
  $ckan_pgsqluser              = $cendari::params::ckan_pgsqluser,
  $ckan_pgsqlpassword          = $cendari::params::ckan_pgsqlpassword,
  $ckan_pgsqldsdb              = $cendari::params::ckan_pgsqldsdb,
  $ckan_pgsqldsuser            = $cendari::params::ckan_pgsqldsuser,
  $ckan_pgsqldspassword        = $cendari::params::ckan_pgsqldspassword,
  $ckan_secret                 = $cendari::params::ckan_secret,
  $ckan_app_uuid               = $cendari::params::ckan_app_uuid,
  $ckan_site_url               = $cendari::params::ckan_site_url,
  $ckan_api_url                = $cendari::params::ckan_api_url,
  $ckan_storage_url_prefix     = $cendari::params::ckan_storage_url_prefix,
  $virtuoso_dba_password       = $cendari::params::virtuoso_dba_password,
  $litef_user_group            = $cendari::params::litef_user_group,
  $litef_apikey                = $cendari::params::litef_apikey,
  $litef_conductor_plugins     = $cendari::params::litef_conductor_plugins,
  $pineapple_rewrite_base      = $cendari::params::pineapple_rewrite_base,

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

  class { 'cendari::components::defaults': }
  Anchor['cendari::prepare'] -> Class['cendari::components::defaults'] -> Anchor['cendari::begin']

  case $variant {
    'cendariinabox': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::atom': } ->
      class { 'cendari::components::ckan': } ->
      class { 'cendari::components::docs': } ->
      class { 'cendari::components::litef': } ->
      class { 'cendari::components::notes': } ->
      class { 'cendari::components::ontologies': } ->
      class { 'cendari::components::pineapple': } ->
      Anchor['cendari::end']
    }
    'frontoffice': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::docs': } ->
      class { 'cendari::components::notes': } ->
      class { 'cendari::components::ontologies': } ->
      Anchor['cendari::end']
    }
    'backoffice': {
      Anchor['cendari::begin'] ->
      class { 'cendari::components::atom': } ->
      class { 'cendari::components::ckan': } ->
      class { 'cendari::components::litef': } ->
      class { 'cendari::components::pineapple': } ->
      Anchor['cendari::end']
    }
    default : {
      # nothing to do
    }
  }
  

}

