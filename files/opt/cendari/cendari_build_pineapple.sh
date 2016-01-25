#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;
: ${VERSION:=0.0.1} ;

set -e

ITERATION="${BUILD_NUMBER}${JENKINSADD}"

#
# GET DEPENDENCIES USING COMPOSER
#

wget -O - https://getcomposer.org/installer | php
php composer.phar update

OLDDIR=$(pwd)
#
# COMPILE SASS
#
vendor/leafo/scssphp/bin/pscss -f compressed -i .:sass sass/styles.scss > public/stylesheets/styles.css

chmod -R o+rX .

cat <<EOF > /tmp/pineapple-postinst
#!/bin/bash
if [ "\$1" = configure ] ; then
  cd /var/www/pineapple
  # Delete the existing cache
  rm -rf cache/*

  # Fix permissions
  chmod -R o+rX .
  chmod -R o+w cache
fi
EOF


#
# COMPILE PACKAGE
#


cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-pineapple \
                  --description='PINEAPPLE faceted browsing and semantic search' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='CENDARI' \
                  --url='http://www.cendari.eu' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x "**/*.deb" \
                  --depends apache2 \
                  --after-install /tmp/pineapple-postinst \
                  --prefix /var/www/pineapple \
                  -C ${OLDDIR} .

