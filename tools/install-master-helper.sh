#!/bin/bash

# Print commands; fail on errors.
set -v -e

# Check out the jenkins repo.
sudo su vagrant -c "git clone https://github.com/tundra/jenkins.git"
ROOT=/home/vagrant/jenkins
JENKINS_HOME=$ROOT/home

# Copy the private key into the roots dir and set the appropriate permissions.
KEY_DROP=/home/vagrant/keydrop
mkdir -p $JENKINS_HOME/keys
cp $KEY_DROP/id_rsa $JENKINS_HOME/keys
chmod 400 $JENKINS_HOME/keys/id_rsa
chown -R jenkins $JENKINS_HOME/keys
rm -rf $KEY_DROP

# Install jenkins from their repo. This is the recommended way. Looks dodgy.
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
apt-get update

# Jenkins needs this stuff to run.
mkdir -p /var/jenkins
chown vagrant /var/jenkins

# Install jenkins. This will also start it so we explicitly stop it after.
apt-get install -y jenkins
/etc/init.d/jenkins stop

# Use the jenkins repo's .
chmod o+w $JENKINS_HOME
rm -rf /var/lib/jenkins
ln -s $JENKINS_HOME /var/lib/jenkins

# Start it again.
/etc/init.d/jenkins start

# Give the server a bit of time to become available, otherwise the cli will
# fail in some creative way.
sleep 60

# Install the required plugins in jenkins.
SERVER_URL=http://localhost:8080
jenkins-cli -s $SERVER_URL install-plugin git
jenkins-cli -s $SERVER_URL install-plugin ghprb
jenkins-cli -s $SERVER_URL restart
