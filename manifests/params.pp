# Params class
#
class cendari::params {

  $adminmail      = 'root@localhost'
  $manage_repo    = false
  $repo_component = 'cendari_prod'
  $repo_url       = 'https://sandbox.cendari.dariah.eu/packages'
  $repo_key_url   = 'https://sandbox.cendari.dariah.eu/cendari_repository.asc'
  $repo_key_id    = '041262CC36856E7787436790D914C5D73034679B'
  $variant        = 'cendariinabox'

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


}

