# How to install/run Cron in a Docker Container

## Example crontab entry for testing

- Append a timestamp to the log file every minute `/var/log/cron`.
- Append "tick" and "tock" in alternate minutes to `/var/log/cron`.

```
* * * * * /bin/date --rfc-3339=seconds >> /var/log/cron
*/2 * * * * /bin/echo 'tick' >> /var/log/cron
1-59/2 * * * * /bin/echo 'tock' >> /var/log/cron
```

## Run a test Container

### Standard docker method

```
$ docker rm -f crond &> /dev/null; \
 docker run -d \
 --name crond \
 --restart always \
 --env SSH_AUTOSTART_SSHD=false \
 --env SSH_AUTOSTART_SSHD_BOOTSTRAP=false \
 --env DOCKER_PORT_MAP_TCP_22=NULL \
 jdeathe/centos-ssh:2.2.0
```

## Install cronie

### Install the cronie package

```
$ docker exec -i crond \
 yum -y install cronie
```

The following might be necessary if using an Ubuntu type host.

```
$ docker exec -i crond \
 sed -i -e 's~^\(session.*pam_loginuid.so\)$~#\1~' /etc/pam.d/crond
```

### Configure crond to run under supervisord

```
$ docker exec -i crond \
 tee /etc/supervisord.d/crond.conf 1> /dev/null <<-CONFIG
[program:crond]
priority = 100
command = bash -c "while true; do sleep 0.1; [[ -e /var/run/crond.pid ]] || break; done && exec /usr/sbin/crond -m off -n"
startsecs = 0
autorestart = true
redirect_stderr = true
stdout_logfile = /var/log/cron
stdout_events_enabled = true
CONFIG
```

### Add some cron jobs

#### Option 1 - Add to the root users crontab.

```
$ docker exec -i crond bash -c "cat <<-CONFIG | crontab -
* * * * * /bin/date --rfc-3339=seconds >> /var/log/cron
0-58/2 * * * * /bin/echo 'tick' >> /var/log/cron
1-59/2 * * * * /bin/echo 'tock' >> /var/log/cron
CONFIG"
```

#### Option 2 - Add jobs to `/etc/cron.d/`

System job so rules must specify the user at position 6.

```
$ docker exec -i crond tee /etc/cron.d/cron-examples 1> /dev/null <<-CONFIG
* * * * * root /bin/date --rfc-3339=seconds >> /var/log/cron
0-58/2 * * * * root /bin/echo 'tick' >> /var/log/cron
1-59/2 * * * * root /bin/echo 'tock' >> /var/log/cron
CONFIG
```

### Restart container

Restarting the container allows supervisord start the process. If you Upload a new configuration you will not need to restart for the changes to apply.

```
$ docker restart crond
```

### Check it works

Tail the logs - Note: Use Ctl + c to exit.

```
$ docker exec -i crond tail -f /var/log/cron
```

## Apline Linux (Busybox) version

If you only want to run the crond daemon the busybox or alpine linux images are smaller.

```
$ docker rm -f crond &> /dev/null; \
 docker run -d \
 --name crond \
 --restart always \
 alpine:3.5 \
 /usr/sbin/crond -f
```

### Add some cron jobs

In this example the cron commands replace the contents of the log instead of appending to them.

```
$ docker exec -i crond \
sh -c "cat <<-CONFIG | crontab -
* * * * * /bin/date -Iseconds > /var/log/cron-minutes
0-58/2 * * * * /bin/echo 'tick' > /var/log/cron-alternator
1-59/2 * * * * /bin/echo 'tock' > /var/log/cron-alternator
CONFIG"
```

### Check it works

After at least 1 minute, check that it's working.

Watch the file `/var/log/cron-minutes` every 1 second for it to be updated once a minute with the date time string.

```
$ docker exec -i crond \
 watch -n 1 cat /var/log/cron-minutes
```

Watch the file `/var/log/cron-minutes` every 1 second. It's value should alternate between "tick" and "tock" for even and odd minutes respectively.

```
$ docker exec -i crond \
 watch -n 1 cat /var/log/cron-alternator
```
