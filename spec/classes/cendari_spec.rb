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

  # DEFAULTS
  it do
    is_expected.to contain_package('g++')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('python-pip')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('python-virtualenv')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('nfs-common')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('nodejs')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('nodejs-legacy')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('npm')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_package('fabric')
      .with(
        'ensure' => 'present'
      )
  end
  it do
    is_expected.to contain_exec('npm_install_lessc')
      .with(
        'require' => 'Package[npm]',
      )
  end
  it do
    is_expected.to contain_file('/usr/bin/lessc')
      .with(
        'ensure' => 'link',
        'target' => '/usr/local/bin/lessc'
      )
  end
  it do
    is_expected.to contain_exec('npm_install_sass')
      .with(
        'require' => 'Package[npm]',
      )
  end
  it do
    is_expected.to contain_file('/usr/bin/node-sass')
      .with(
        'ensure' => 'link',
        'target' => '/usr/local/bin/node-sass'
      )
  end
  it do
    is_expected.to contain_file('/opt/cendari')
      .with(
        'ensure' => 'directory',
      )
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

      # NOTES 
      it do
        is_expected.to contain_package('libvips-tools')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('python-vipscc')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libcurl4-gnutls-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libjpeg-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libtiff5-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libopenjpeg-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('zlib1g-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('unixodbc-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libtiff4-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libpq-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('python-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libxml2-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('libxslt1-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_package('ruby-dev')
          .with(
            'ensure' => 'installed'
          )
      end
      it do
        is_expected.to contain_python__pip('flup')
          .with(
            'owner'   => 'root',
            'pkgname' => 'flup',
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

      # LITEF
      it do
        is_expected.to contain_package('cendari-litef')
          .with(
            'ensure'  => 'latest',
          )
      end
      it do
        is_expected.to contain_file('/opt/litef')
          .with(
            'ensure' => 'directory'
          )
      end
      it do
        is_expected.to contain_file('/etc/litef')
          .with(
            'ensure' => 'directory'
          )
      end
      it do
        is_expected.to contain_user('litef')
          .with(
            'ensure' => 'present',
            'system' => 'true'
          )
      end
      it do
        is_expected.to contain_file('/etc/litef/application.conf')
          .with(
            'ensure'  => 'file',
            'notify'  => 'Service[litef-conductor]',
            'require' => 'File[/etc/litef]'
          )
      end
      it do
        is_expected.to contain_file('/var/log/litef')
          .with(
            'ensure' => 'directory',
          )
      end
      it do
        is_expected.to contain_service('litef-conductor')
          .with(
            'require'    => 'File[/var/log/litef]'
          )
      end

    end
  end


end
