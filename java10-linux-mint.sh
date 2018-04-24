#!/bin/bash
# Script will install Java 10 for Linux Mint (18.3 as of this writing)

# First add ppa for Java 10
sudo add-apt-repository ppa:linuxuprising/java
# standard update
sudo apt update
# Install java10
apt install oracle-java10-installer
# Need to set java10 as default in Linux Mint
apt install oracle-java10-set-default
# Test for java10 install
java -version
