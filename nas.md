# NAS Stuff
## Synology
```
# Add docker permissions (likely need to sudo this)
synogroup --add docker $USER
# owner permission change
chown root:docker /var/run/docker.sock
```
