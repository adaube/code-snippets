## Resolve the IP address of the server you are currently on
Best way to find exposed (public) IP:

```bash
wget -qO- http://ipecho.net/plain | xargs echo
```


```bash
# These should give the local DNS output, which typically (hopefully) is not the IP exposed to public
dig +short myip.opendns.com @resolver1.opendns.com
host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}'
```
