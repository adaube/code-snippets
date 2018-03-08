# Keep Avahi by re-ordering dns ahead of multicast dns in Linux
## One way to fix DNS resolution for .local conflicts
Issue: cannot navigate to a `.local` domain in a Linux client because host uses Microsoft DNS.

> Can you brute force remove avahi-daemon? _Yes_
If that is a quick and easy solution for your situation, go for it!
But if you don't necessarily want to do that, please read on. :sunglasses:

## Discovery
There is an inherent conflict between Microsoft _unicast_ .local domains and Linux _multicast_ .local domains
```
# /etc/nsswitch.conf hosts line:
hosts: files mdns4_minimal [NOTFOUND=return] dns
#                                            ^^^
```
The ordering is causing .local to resolve with mDNS (Avahi)

## Solution for Linux and Microsoft .local compatibility, without gutting Avahi
- First, back up `/etc/nsswitch.conf`
```
# recommend backing up the nsswitch.conf somehow
sudo nano cp /etc/nsswitch.conf /etc/bak.nsswitch.conf
```
- Second, edit /etc/nsswitch.conf
```
# we are editing the configuration
sudo nano /etc/nsswitch.conf
```
-- Change the `hosts` line to reflect as below
```
hosts:          files dns mdns4_minimal [NOTFOUND=return]
#                     ^^^
```
- Finally, restart the PC (which takes care of a `service avahi-daemon restart` and _should_ flush browser DNS caches)

Now you should be able to navigate to Microsoft .local domains.
Bonus - you didn't gut default functionality within Linux for Bonjour/Apple! :)

## Research
Not possible without some guidance from the sources below!
- Source [link](http://www.lowlevelmanager.com/2011/09/fix-linux-dns-issues-with-local.html).
- Source [link](https://askubuntu.com/questions/414277/cant-resolve-windows-domains-in-local-network)
