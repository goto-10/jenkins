#!/bin/bash

# Print commands; fail on errors.
set -v -e

# Check out the jenkins repo.
ROOT=/home/vagrant/jenkins
mkdir -p $ROOT
chown vagrant $ROOT

# Copy the private key into the roots dir and set the appropriate permissions.
KEY_DROP=/home/vagrant/keydrop
mkdir -p $ROOT/keys
cp $KEY_DROP/id_rsa $ROOT/keys
chmod 400 $ROOT/keys/id_rsa
chown -R jenkins $ROOT/keys
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
NEW_HOME=/home/vagrant/jenkins
chmod o+w $NEW_HOME
rm -rf /var/lib/jenkins
ln -s $NEW_HOME /var/lib/jenkins

# Start it again.
/etc/init.d/jenkins start

# Give the server a bit of time to become available, otherwise the cli will
# fail.
sleep 30

# Install the required plugins in jenkins.
SERVER_URL=http://localhost:8080
jenkins-cli -s $SERVER_URL install-plugin git
jenkins-cli -s $SERVER_URL restart
