#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;

set -e

VERSION=$(python -c 'import editorsnotes
print editorsnotes.__version__')
ITERATION=$BUILD_NUMBER
export CENDARI_RELEASE="${VERSION}-${ITERATION}"
sed -i "s/$VERSION/$CENDARI_RELEASE/" editorsnotes/__init__.py

#
# BUILD Component
#

echo "-- Running fabric in $(pwd)"
fab setup
chmod -R og+rX .

#
# COMPILE PACKAGE
#
cat <<EOF > /tmp/notes-postinst
#!/bin/bash
if [ "\$1" = configure ] ; then
  cd /var/www/notes
  fab setup
  if [ -f /var/www/notes/editorsnotes/settings_local.py  ] ; then
    fab sync_database
  fi
  # restart django-rq
  if [ -f /etc/supervisor/conf.d/notes.conf ] ; then
    if [ -f /usr/bin/supervisorctl ] ; then
      supervisorctl start notes_script
    fi
  fi
  # restart apache if ready
  if invoke-rc.d apache2 status >/dev/null 2>&1 ; then
    if apache2ctl configtest >/dev/null 2>&1 ; then
      invoke-rc.d apache2 restart
    fi
  fi
fi
EOF

cat <<EOF > /tmp/notes-preinst
#!/bin/bash
# restart django-rq
if [ -f /etc/supervisor/conf.d/notes.conf ] ; then
  if [ -f /var/run/supervisord.pid ] ; then
    supervisorctl stop notes_script
  fi
fi
# remove old packages
if [ -d /var/www/notes ] ; then
  rm -rf /var/www/notes/bin
  rm -rf /var/www/notes/lib
  rm -rf /var/www/notes/src
fi

EOF

OLDDIR=$(pwd)

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-notes \
                  --description='CENDARI Notes VRE - compiled for CENDARI' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='CENDARI' \
                  --url='http://www.cendari.eu' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x "**/*.deb" \
                  -x "bin" -x "lib" -x "local" -x "node_modules" -x "share" -x "src" \
                  -x "editorsnotes/settings_local.py" -x "cendari/wsgi.py" -x "apache.conf" -x "supervisor.conf" \
                  --depends apache2 --depends libapache2-mod-wsgi --depends python-virtualenv --depends fabric \
                  --before-install /tmp/notes-preinst \
                  --after-install /tmp/notes-postinst \
                  --prefix /var/www/notes \
                  -C ${OLDDIR} .

