# Params class
#
class cendari::params {

  $adminmail      = 'root@localhost'
  $manage_repo    = false
  $repo_component = 'cendari_prod'
  $repo_url       = 'https://sandbox.cendari.dariah.eu/packages'
  $repo_key_url   = 'https://sandbox.cendari.dariah.eu/cendari_repository.asc'
  $repo_key_id    = 'F00A281A8DD528C1EBDB0D849985BE2057446003'
  $variant        = undef

  $atom_url                    = undef
  $atom_mysql_db               = 'atom2'
  $atom_mysql_user             = 'atom2'
  $atom_mysql_password         = undef
  $atom_ckanuser_name          = undef
  $atom_ckanuser_apikey        = undef
  $atom_dataspace_name         = undef
  $atom_dataspace_id           = undef
  $atom_ckansync_user_email    = undef
  $atom_ckansync_user_password = undef
  $atom_ckansync_ckan_url      = undef
  $atom_mail_report_to         = 'root@localhost'

  $ckan_shibplugin             = 'cendari'
  $ckan_storagepath            = undef
  $ckan_pgsqldb                = 'ckan'
  $ckan_pgsqluser              = 'ckan'
  $ckan_pgsqlpassword          = undef
  $ckan_pgsqldsdb              = 'ckands'
  $ckan_pgsqldsuser            = 'ckands'
  $ckan_pgsqldspassword        = undef
  $ckan_secret                 = undef
  $ckan_app_uuid               = undef
  $ckan_site_url               = "https://${::fqdn}"
  $ckan_api_url                = '/ckan'
  $ckan_storage_url_prefix     = "https://${::fqdn}/ckan/storage/f/"

  $virtuoso_dba_password       = undef
  $virtuoso_dav_password       = undef
  $virtuoso_host               = 'localhost'
  $litef_user_group            = undef
  $litef_apikey                = undef
  $litef_conductor_plugins     = 'conductor.plugins.DocumentIndexerPlugin,conductor.plugins.NerdPlugin,conductor.plugins.VirtuosoFeederPlugin,conductor.plugins.ElasticFeederPlugin'

  $notes_pgsqldb               = 'notes'
  $notes_pgsqluser             = 'notes'
  $notes_pgsqlpassword         = undef
  $notes_secret                = undef
  $notes_adminuser_eppn        = undef
  $notes_adminuser_mail        = undef
  $notes_adminuser_key         = undef
  $notes_debugmode             = false
  $notes_hostname              = $::fqdn
  $notes_siteurl               = "https://${::fqdn}/"
  $notes_sub_site              = '/'

  $pineapple_rewrite_base      = '/'
}

