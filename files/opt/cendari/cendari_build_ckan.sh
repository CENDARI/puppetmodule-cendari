#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

set -e

: ${VERSION:=2.2.2} ;
: ${ITERATION:=0} ;

#
# BUILD CKAN
#

mkdir -p /var/www/ckan
cd /var/www/ckan
echo "-- Preparing working directory $(pwd)"
rm -rf *
virtualenv --no-site-packages /var/www/ckan
source /var/www/ckan/bin/activate
echo "-- Building CKAN ${VERSION}"
pip install -e "git+https://github.com/ckan/ckan.git@ckan-$VERSION#egg=ckan"
pip install -r /var/www/ckan/src/ckan/requirements.txt
deactivate
source /var/www/ckan/bin/activate
cd /var/www/ckan/src/ckan
../../bin/python setup.py install

#
# BUILD EXTENSIONS
#
echo "-- Building extensions"

git clone https://github.com/CENDARI/ckanext-dariahshibboleth.git /var/www/ckan/src/ckanext-dariahshibboleth
cd /var/www/ckan/src/ckanext-dariahshibboleth
../../bin/python setup.py install
git clone https://github.com/CENDARI/ckanext-cendari.git /var/www/ckan/src/ckanext-cendari
cd /var/www/ckan/src/ckanext-cendari
../../bin/python setup.py install
git clone https://github.com/okfn/ckanext-archiver.git /var/www/ckan/src/ckanext-archiver
pip install -r /var/www/ckan/src/ckanext-archiver/pip-requirements.txt
cd /var/www/ckan/src/ckanext-archiver
../../bin/python setup.py install
git clone https://github.com/okfn/ckanext-datastorer.git /var/www/ckan/src/ckanext-datastorer
pip install -r /var/www/ckan/src/ckanext-datastorer/pip-requirements.txt
cd /var/www/ckan/src/ckanext-datastorer
../../bin/python setup.py install
git clone https://github.com/okfn/ckanext-harvest.git /var/www/ckan/src/ckanext-harvest
pip install -r /var/www/ckan/src/ckanext-harvest/pip-requirements.txt
cd /var/www/ckan/src/ckanext-harvest
../../bin/python setup.py install
cd /var/www/ckan/src
pip install -e git://github.com/kata-csc/ckanext-kata.git@1.2#egg=ckanext-kata
git clone https://github.com/kata-csc/ckanext-oaipmh.git /var/www/ckan/src/ckanext-oaipmh
cd /var/www/ckan/src/ckanext-oaipmh
../../bin/python setup.py install

#
# COMPILE PACKAGE
#
cat <<EOF > /tmp/ckan-postinst
#!/bin/bash
if [ "\$1" = configure ] ; then
  # restart apache if ready
  if invoke-rc.d apache2 status >/dev/null 2>&1 ; then
    if apache2ctl configtest >/dev/null 2>&1 ; then
      invoke-rc.d apache2 restart
    fi
  fi
fi
EOF

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-ckan \
                  --description='CKAN - the open-source DMS - compiled for CENDARI' \
                  --license='AGPL v3.0' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='Open Knowledge Foundation - packaged by CENDARI' \
                  --url='http://ckan.org' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x "**/.git**" -x "**/.hg**" -x "**/.svn**" \
                  --depends apache2 --depends libapache2-mod-wsgi --depends libpq5 \
                  --after-install /tmp/ckan-postinst \
                  /var/www/ckan

