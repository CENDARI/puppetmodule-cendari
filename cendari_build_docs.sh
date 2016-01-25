#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;

set -e

VERSION=$(grep ^version source/conf.py | sed 's/version = '\''\([0-9.]*\)'\''/\1/g')
ITERATION="${BUILD_NUMBER}${JENKINSADD}"

export CENDARI_RELEASE="${VERSION}-${ITERATION}"
export CENDARI_INCLUDE_SUBMODULE_DOCS="YES"

echo "-- Setting up Virtualenv"
virtualenv venv
source venv/bin/activate

echo "-- Installing requirements"
pip install -r requirements.txt

echo "-- Installing dependency requirements"
pip install -r dependency-requirements.txt

#
# BUILD THEME
#

OLDDIR=$(pwd)

cd source/sphinx_rtd_theme
npm install 

grunt exec:bower_update
grunt sass:dev
grunt clean:build
grunt exec:build_sphinx

cd $OLDDIR
#
# BUILD DOCUMENTATION
#


echo "-- Preparing docs from submodules"
/bin/bash submodules-import.sh
rm -rf build
echo "-- Building HTML version within $(pwd)"
make html
echo "-- Building PDF version using LaTeX within $(pwd)"
make xetexpdf
cp build/latex/CENDARI.pdf build/html/

#
# COMPILE PACKAGE
#
OLDDIR=$(pwd)

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -a noarch -s dir --name cendari-docs \
                            --description='CENDARI Documentation' \
                            --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                            --vendor='CENDARI' \
                            --url='http://www.cendari.eu' \
                            --iteration ${ITERATION} \
                            --version ${VERSION} \
                            -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x ".buildinfo" -x "**/*.deb" \
                            --prefix /var/www/docs \
                            -C ${OLDDIR}/build/html .


