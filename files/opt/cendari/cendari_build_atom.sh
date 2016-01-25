#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;

set -e

VERSION=`cat apps/qubit/config/qubitConfiguration.class.php | grep VERSION | grep -Po '\d\.\d\.\d'`
ITERATION="${BUILD_NUMBER}${JENKINSADD}"

#
# COMPILE CSS
#

OLDDIR=$(pwd)
for dir in arDominionPlugin sfCendariThemePlugin; do
    cd plugins/$dir
    make
    cd $OLDDIR
done

chmod -R og+rX .

#
cat <<EOF > /tmp/notes-postinst
#!/bin/bash
if [ "\$1" = configure ] ; then
  cd /var/www/atom2
  chown -R www-data data
  chown -R www-data log
  chown -R www-data cache
  chown -R www-data atom2ckan
  if [ -f /var/www/atom2/config/propel.ini ] ; then
    if [ -f /var/www/atom2/config/config.php ] ; then
      echo y | sudo -u www-data php symfony tools:upgrade-sql
      sudo -u www-data php symfony cc
    fi
  fi
fi
EOF

#
# COMPILE PACKAGE
#

OLDDIR=$(pwd)

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-atom \
                  --description='Access to Memory (AtoM): Open Source Archival Description Software - compiled for CENDARI' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='CENDARI' \
                  --url='http://www.cendari.eu' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x "**/*.deb" \
                  --depends apache2 \
                  --after-install /tmp/notes-postinst \
                  --prefix /var/www/atom2 \
                  -C ${OLDDIR} .

