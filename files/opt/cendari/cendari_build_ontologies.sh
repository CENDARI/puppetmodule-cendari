#!/bin/bash
#
# MANAGED BY PUPPET
#
umask 0022

: ${BUILD_NUMBER:=0} ;

set -e

VERSION=1
ITERATION="${BUILD_NUMBER}${JENKINSADD}"


# prepare directories
OLDDIR=$(pwd)
rm -rf target
mkdir target

# set up langing page
echo "-- Create landing page"
cd $OLDDIR
cd target
curl -L https://github.com/CENDARI/UI-Boilerplate/raw/master/downloads/homepage-landing-template.zip -o homepage-landing-template.zip
unzip homepage-landing-template.zip
rm homepage-landing-template.zip
cat << EOF > index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CENDARI Ontologie</title>
    <link href="css/styles.css" rel="stylesheet">
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,400italic,700,700italic' rel='stylesheet' type='text/css'>
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <header>
      <div class="container">
        <div class="row">
          <div class="col-md-9">
            <div class="logo">
              <a href="#">
              </a>
            </div>
          </div>
          <div class="col-md-3">
            <div class="dropdown pull-right">
              <button class="btn btn-default dropdown-toggle" type="button" id="loginButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Log in</button>
              <div class="dropdown-menu drop-form" aria-labelledby="loginButton">
                <form>
                  <input type="text" class="form-control" placeholder="Username">
                  <input type="password" class="form-control" placeholder="Password">
                  <button class="btn btn-primary btn-block">Log in</button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
    
    <!-- Navbar -->
    <nav class="navbar navbar-inverse">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="http://www.cendari.eu">CENDARI</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="active">
              <a href="#">Home</a>
            </li>
            <li>
              <a href="view">Viewer</a>
            </li>
            <li>
              <a href="upload">Uploader</a>
            </li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    <section class="content">
      <div class="container">
        <div class="row equal">
         <div class="col-xs-12 col-sm-6 col-md-6 panel secondary">
            <div class="content-body">
              <h3>Ontology Viewer</h3>
              <a href="#" class="btn btn-default btn-block">Start using it</a>
            </div>
          </div>
          <div class="col-xs-12 col-sm-6 col-md-6 panel secondary">
            <div class="content-body">
              <h3>Ontology Uploader</h3>
              <a href="#" class="btn btn-default">Start using it</a>
            </div>
          </div>
       </div><!-- .row .equal -->
      </div>
    </section>
    <footer>
      <div class="container">
        <div class="row">
          <div class="col-md-9">
            <p>The CENDARI project is funded by the European Commission under the 7th Framework Programme</p>
          </div>
          <div class="col-md-3">
            <img src="images/funding.jpg" alt="European Commission" class="pull-right">
          </div>
        </div>
      </div>
    </footer>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="javascripts/bootstrap.min.js"></script>
  </body>
</html>
EOF

# download webvowl
echo "-- get and configure WebVowl"
cd $OLDDIR
mkdir target/view
cd target/view
curl -L https://github.com/VisualDataWeb/WebVOWL/releases/download/0.4.0/webvowl-0.4.0.zip -o webvowl-0.4.0.zip
unzip webvowl-0.4.0.zip
rm webvowl-0.4.0.zip
rm js/data/*
cd $OLDDIR

# add data to webvowl
cd $OLDDIR
cp ./*.json target/view/js/data/

cat << EOF | python
#!/usr/bin/env python
import json
from os import listdir, path
maindir = path.join(path.dirname(path.abspath(__file__)),'target/view')
datadir = path.join(maindir,'js/data')
datafiles = [f for f in listdir(datadir) if path.isfile(path.join(datadir, f))]

htmlpagehandle = open(path.join(maindir,'index.html'), 'r')
htmlcontent = htmlpagehandle.read()
htmlpagehandle.close()
newhtmlpage = htmlcontent.split('<li id="select">')[0] + '<li id="select"><a href="#">Ontology</a><ul class="toolTipMenu select">'

datadict = {}
for f in datafiles:
    if f.endswith('.json'):
        filename = f[:-5]
        filetitle = filename
        filehandle = open(path.join(datadir,f), 'r')
        current = filehandle.read().decode('cp1252')
        try:
            filetitle = json.loads(current)['header']['title']['en']
        except KeyError, err:
            pass
        datadict.update({filetitle:filename})
        filehandle.close()
        newhtmlpage = newhtmlpage + '<li><a href="#'+filename+'" id="'+filename+'">'+filetitle+'</a></li>'
newhtmlpage = newhtmlpage + '''</ul>
                </li>
            </ul>
        </nav>
    </main>
    <script src="js/d3.min.js"></script>
    <script src="js/webvowl.js"></script>
    <script src="js/webvowl-app.js"></script>
    <script>
        webvowlApp.version = "0.4.0"
    </script>
    <script>
        window.onload = webvowlApp.app().initialize;
    </script>
</body>

</html>
'''
htmlpagehandle = open(path.join(maindir,'index.html'), 'w')
htmlpagehandle.write(newhtmlpage)
htmlpagehandle.close()
EOF

DEFAULTJSON=$(ls -1 target/view/js/data/*.json | head -n 1 | xargs -n1 basename | sed -e 's/\..*$//')
sed -i "s/defaultJsonName = \"foaf\"/defaultJsonName = \"${DEFAULTJSON}\"/g" target/view/js/webvowl-app.js

#
# COMPILE PACKAGE
#

cd target
OLDDIR=$(pwd)

cd /var/cache/cendari_builder
echo "-- Creating package in $(pwd)"
fpm -t deb -s dir --name cendari-ontologies \
                  --description='CENDARI ontologies - compiled for CENDARI' \
                  --maintainer='CENDARI <cendari-admins@gwdg.de>' \
                  --vendor='CENDARI' \
                  --url='http://www.cendari.eu' \
                  --iteration ${ITERATION} \
                  --version ${VERSION} \
                  -x ".git**" -x "**/.git**" -x "**/.hg**" -x "**/.svn**" -x "**/*.deb" -x "**/__MACOSX"\
                  --depends apache2 \
                  --prefix /var/www/ontologies \
                  -C ${OLDDIR} .


