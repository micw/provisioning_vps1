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

if ! grep /etc/ansible/hosts -e '\[local\]' > /dev/null ; then
  echo "Configuring ansible hosts"
  echo -e "[local]\nlocalhost" > /etc/ansible/hosts
else
  echo "Already configured ansible hosts"
fi

if [ ! -f /root/.ssh/id_rsa ]; then
  echo "Creating ssh keys for root"
  ssh-keygen -f /root/.ssh/id_rsa -N '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys
else
  echo "Already created ssh keys for root"
fi

if [ ! -f /root/ansible/local.yml ]; then
  echo "Cloning ansible repo"
  git clone git@github.com:micw/provisioning_vps1.git /root/ansible/
else
  echo "Already cloned ansible repo"
fi

if [ ! -d /root/ansible/roles ]; then
  echo "Cloning ansible roles repo"
  git clone ssh://git@ci.evermind.de:7999/evops/evermind-ansible-roles.git /root/ansible/roles/
else
  echo "Already cloned ansible roles repo. Just updating..."
  ( cd /root/ansible/roles && git pull )
fi



echo "Running ansible"
/usr/bin/ansible-playbook /root/ansible/local.yml
