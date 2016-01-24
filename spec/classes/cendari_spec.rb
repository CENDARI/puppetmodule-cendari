require 'spec_helper'

describe 'cendari' do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }
  it do
    is_expected.to contain_anchor('cendari::prepare')
  end
  it do
    is_expected.to contain_anchor('cendari::begin')
  end
  it do
    is_expected.to contain_anchor('cendari::end')
  end
  context 'with repository' do
  let(:params) { { :manage_repo => true } }
    it do
      is_expected.to contain_class('cendari::repository')
    end
    it do
      is_expected.to contain_apt__source('cendari_deb_repository')
    end
    it do
      is_expected.to contain_exec('update_cendari_deb_repository')
    end
  end

  # FRONTOFFICE

  ['cendariinabox','frontoffice'].each do |variant|
    context "for variant #{variant}" do
      let(:params) {{ :variant => variant }}

      # DOCS
      it do
        is_expected.to contain_package('cendari-docs')
          .with(
            'ensure' => 'latest'
          )
      end

    end
  end

  # BACKOFFICE

  ['cendariinabox','backoffice'].each do |variant|
    context "for variant #{variant}" do
      let(:params) {{ :variant => variant }}

      # ATOM
      it do
        is_expected.to contain_package('cendari-atom')
          .with(
            'ensure' => 'latest'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/config/config.php')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/config/propel.ini')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]',
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/atom2ckan/complete_atom_to_ckan_config.php')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end
      it do
        is_expected.to contain_cron('atom2ckanjob')
          .with(
            'user'    => 'www-data'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/config/search.yml')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/config/databases.yml')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/apps/qubit/config/app.yml')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end
      it do
        is_expected.to contain_file('/var/www/atom2/apps/qubit/config/settings.yml')
          .with(
            'ensure'  => 'file',
            'require' => 'Package[cendari-atom]'
          )
      end

      # CKAN
      it do
        is_expected.to contain_package('cendari-ckan')
          .with(
            'ensure'  => 'latest',
          )
      end
      it do
        is_expected.to contain_file('/etc/solr/conf/schema.xml')
          .with(
            'ensure'  => 'link',
            'notify'  => 'Service[tomcat7]',
            'target'  => '/var/www/ckan/src/ckan/ckan/config/solr/schema.xml'
          )
      end
      it do
        is_expected.to contain_file('/etc/ckan')
          .with(
            'ensure' => 'directory',
          )
      end
      it do
        is_expected.to contain_file('/etc/ckan/apache.wsgi')
          .with(
            'ensure'  => 'file',
            'notify'  => 'Service[apache2]',
          )
      end
      it do
        is_expected.to contain_file('/etc/ckan/production.ini')
          .with(
            'ensure'  => 'file',
            'notify'  => 'Service[apache2]',
          )
      end
      it do
        is_expected.to contain_file('/etc/ckan/who.ini')
          .with(
            'ensure'  => 'file',
            'notify'  => 'Service[apache2]',
          )
      end

    end
  end


end
