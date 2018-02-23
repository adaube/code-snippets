# fix broken user sudo
# for Sudo: /usr/bin/sudo must be owned by uid 0 and have the setuid bit set
# restart to get to login screen and ctrl-F1 for a terminal, login as root
chown root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo
# then restart!
