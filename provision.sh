#!/bin/bash
#
# USAGE:
# [ -f /usr/bin/curl ] || apt-get -y install curl
# curl -sSL https://raw.githubusercontent.com/micw/provisioning_vps1/master/provision.sh | /bin/bash

set -e

if [ ! -f /etc/apt/sources.list.d/wheezy-backports.list ]; then
  echo "Adding wheezy backport repository"
  echo "deb http://http.debian.net/debian wheezy-backports main contrib" > /etc/apt/sources.list.d/wheezy-backports.list
  apt-get update
else
  echo "Already added wheezy backport repository"
fi

if [ ! -f /usr/bin/nano ]; then
  echo "Installing nano"
  apt-get -y install nano
else
  echo "Already installed nano"
fi

if [ ! -f /usr/bin/git ]; then
  echo "Installing git"
  apt-get -y install git
else
  echo "Already installed git"
fi

if [ ! -f /usr/bin/ansible-playbook ]; then
  echo "Installing ansible"
  apt-get -y install ansible
else
  echo "Already installed ansible"
fi

if [ ! -d /root/ansible/local.yml ]; then
  echo "Cloning ansible repo"
  git clone git@github.com:micw/provisioning_vps1.git /root/ansible/
else
  echo "Already cloned ansible repo"
fi

