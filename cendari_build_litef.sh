#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;

set -e

VERSION=$(grep ^version build.sbt | sed 's/version := "\([0-9.]*\)"/\1/g')
ITERATION="${BUILD_NUMBER}${JENKINSADD}"

sed -i "s/^version.*/version := \"${VERSION}-${ITERATION}\"/g" build.sbt

echo -e "\noutputPath in assembly := new java.io.File(s\"target/assembled/\${name.value}.jar\")" >> assembly.sbt

rm -rf target
rm -rf project/target

/opt/sbt/bin/sbt compile assembly

#
cat <<EOF > /tmp/litef-preinst
#!/bin/bash
if [ -f /etc/init.d/litef-conductor ] ; then
  /etc/init.d/litef-conductor stop || true
fi
EOF

cat <<EOF > /tmp/litef-postinst
#!/bin/bash
if [ -f /etc/init.d/litef-conductor ] ; then
  /etc/init.d/litef-conductor start
fi
EOF

#
# COMPILE PACKAGE
#

OLDDIR=$(pwd)

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-litef \
                  --description='CENDARI Litef Conductor - compiled for CENDARI' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='CENDARI' \
                  --url='http://www.cendari.eu' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x "**/*.deb" \
                  --depends apache2 \
                  --before-install /tmp/litef-preinst \
                  --after-install /tmp/litef-postinst \
                  --deb-init ${OLDDIR}/scripts/debian_init_d/litef-conductor \
                  --prefix /opt/litef \
                  -C ${OLDDIR}/target/assembled .

