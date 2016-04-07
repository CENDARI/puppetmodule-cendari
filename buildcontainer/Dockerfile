FROM ubuntu:14.04
MAINTAINER CENDARI

RUN apt-get update && apt-get install -y wget git

RUN wget "https://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -cs).deb"

RUN dpkg -i puppetlabs-release-$(lsb_release -cs).deb && rm puppetlabs-release-$(lsb_release -cs).deb

RUN apt-get update && apt-get -y install puppet

RUN sed -i '/^templatedir=.*/d' /etc/puppet/puppet.conf;

RUN git clone https://github.com/CENDARI/puppetmodule-cendari.git /etc/puppet/modules/cendari

RUN puppet module install puppetlabs-stdlib --version 4.3.2

RUN puppet module install nanliu-staging --version 1.0.0

RUN puppet apply -e "include cendari::components::builder"

