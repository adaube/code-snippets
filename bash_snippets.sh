#@IgnoreInspection BashAddShebang

# find inode utilization
sudo df -i /

# free apt cache, temp files
sudo apt autoremove
sudo du -sh /var/cache/apt
sudo apt autoclean
sudo apt clean

# find python symlinks
ls -l /usr/bin/python*

# fix npm permissions (updated, works great!)
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# use ubuntu package manager to install current nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt update && apt install nodejs build-essentials -y

# traverses directory depth to find and remove empty directories
find . -depth -type d -exec rmdir {} \;

# using the -p flag to create directory structure
mkdir -p /a/very/long/directory/structure/which/nobody/will/ever/find

# using the -p flag to remove any empty directories recursively
rmdir -p glo/30m/*/

# remove all symlinks
find -type l -delete

# add headers to csv in-place
sed -i '1iSTATION,DATE,METRIC,VALUE,C5,C6,C7,C8' 2015.csv

# add headers to csv as new file
{ echo 'STATION,DATE,METRIC,VALUE,C5,C6,C7,C8'; cat 2015.csv; } > 2015_new_headers.csv

# print headers of csv file
head -1 2015.csv

# auto answer yes (line 1) or no (line 2) to command
yes | apt update
yes no | command

# create file with specific size, example of 10 MB of zeros
dd if=/dev/zero of=out.txt bs=1M count=10

# replace spaces with tabs
cat file.txt | tr ':[space]:' '\t' > out.txt

# replace lower case to upper case
cat file.txt | tr a-z A-Z > out.txt

# change back to prev dir
cd -

# while true loop to repeat command until it returns and runs successfully
while true
do
ping -c 1 google.com > /dev/null 2>&1 && break
done ;

# invert (or use normal to revert) laptop screen (lenovo, intel graphics)
xrandr --output eDP1 --rotate inverted

# invert lenovo screen, nvidia graphics
xrandr --output eDP-1-1 --rotate inverted

# fast way to vpn linux
apt install ike
cp csi.vpn ~/.ike/sites/
ikec -r csi.vpn -u your_username -p your_password -a

# reorder around time axis
#!/bin/bash
input_dir="."
output_dir="./reordered"
time_dim="time"
#other_dim="lat,lon"
other_dim="land_id"
for f in *.nc; do
  echo ${f}
  ncecat -O ${input_dir}/${f} tmp/${f}
  # !!! next one needs at least 2*filesize RAM !!!
  ncwa -a record tmp/${f} tmp/${f}.tmp
  ncpdq -F -O -a ${other_dim},${time_dim} tmp/${f}.tmp ${output_dir}/${f}
  rm -f tmp/*
done

# converted ~10GB of GRIB2 to netCDF4 in 17m
time find /skynet/METOC_Store/data/product/cfsrv2/archive/1979-01/ -maxdepth 1 -name '*.grb2' | xargs -I '{}' -P 32 java -Xmx1g -classpath /home/adam/scheduled_jobs/netcdfAll-4.6.11.jar ucar.nc2.write.Nccopy -f netcdf4 -i {} -o {}.nc

# install 

curl -sSL https://get.docker.com/ | sudo sh

# add user to docker group (requires logging back in to work)
sudo usermod -aG docker $USER

# add jenkins to docker
sudo usermod -aG docker jenkins

# check groups for jenkins to make sure docker is there
groups jenkins

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

# how to block quote shell script
: <<'END'
bla bla
blurfl
END

# magic nginx proxy api fix - secure, correct URI transformations
: <<'END'
Write an nginx location directive to proxy requests to subdirectory to another server
preserving urlencoding and removing subdirectory prefix

Artificial example — request like this:

http://1.2.3.4/api/save/http%3A%2F%2Fexample.com

should pass as

http://abcd.com/save/http%3A%2F%2Fexample.com
END
    location /api/ {
        rewrite ^ $request_uri;
        rewrite ^/api/(.*) $1 break;
        return 400;
        proxy_pass http://127.0.0.1:82/$uri;
    }


# nginx list available virtualhosts
ls /etc/nginx/sites-available

# nginx activate virtualhost
ln -s /etc/nginx/sites-available/www.example.org.conf /etc/nginx/sites-enabled/
sudo service nginx reload

# syntax of dd command to test read/write speed
dd if=path/to/input_file of=/path/to/output_file bs=block_size count=number_of_blocks

# write from /dev/zero, source of inf. useless bytes, with fixed blocksize and count
dd if=/dev/zero of=./largefile bs=1M count=1024

# clear cache then determine read speed, sending to /dev/null which is nowhere
dd if=./largefile of=/dev/null bs=4k

# find out cache memory uses by Linux system
free -m

# command run by user in terminal to clear cache
sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"

# Free pagecache, dentries and inodes in cache memory
sync; echo 3 > /proc/sys/vm/drop_caches

# Free dentries, inodes in cache memory
sync; echo 2 > /proc/sys/vm/drop_caches

# Free pagecache in cache memory
sync; echo 1 > /proc/sys/vm/drop_caches

# Clean install of docker from old docker
sudo apt remove docker docker-engine docker.io -y
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# for ubuntu: sudo apt install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt install linux-image-extra-xenial linux-image-extra-virtual -y
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# Update and upgrade
sudo apt update && sudo apt upgrade -y

# Remove intermediate docker images (saves space)
docker rmi $(docker images -f "dangling=true" -q)

# Disable Cortana in Win10

# curl get file url
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# wget example
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# scp copy the file "foobar.txt" from the local host to a remote host
scp foobar.txt your_username@remotehost.edu:/some/remote/directory

# Windows VM password
 Passw0rd!

# find exposed IP of localhost and run in nmap to see open ports
ip -4 route get 8.8.8.8 |
 {'print $7'} | tr -d '\n' | xargs -I {} nmap {}

# tail directory for changes to files
watch "ls -lrt | tail -10"

# put contents of id_rsa.pub in xclip buffer to clipboard
cat id_rsa.pub | xclip -selection clipboard

# put pwd in xclip buffer to clipboard so you can paste anywhere!
pwd | xclip -selection clipboard

# put pwd in xclip buffer to paste in terminal
pwd | xclip

# shell redirection during execution
python make_dataset_test_set_a.py > all_backend_tests.txt

# call script using lines from file as args
xargs -0 -I '{}' -P 8 python add_dataset_test.py -u "{}" < <(tr \\n \\0 <all_backend_tests.txt)

# clean up cached packages
sudo apt autoclean && sudo apt clean

# purge unused configuration files
sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2)

# remove tmp, operating on files that haven't been accessed for more than 10 days
sudo find /tmp -type f -atime +10 -delete

# list all installed kernels
dpkg -l linux-image-\* | grep ^ii

# show all kernels that can be removed
kernelver=$(uname -r | sed -r 's/-[a-z]+//')
dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve $kernelver

# another way to show all kernels that can be removed
dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]'

# remove all but last kernel
dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]' | xargs sudo apt-get -y purge

curl -c rda_auth_cookies -d "email=adam@clearscienceinc.com&passwd=$(cat rda_cookie_password)&action=login" https://rda.ucar.edu/cgi-bin/login

wget --save-cookies rda_cookie --post-data="email=adam@clearscienceinc.com&passwd=$(cat rda_cookie_password)&action=login" https://rda.ucar.edu/cgi-bin/login


# docker examples

# list docker images named <none>
docker images | awk '$2 == "<none>" { print $3 }'

# get docker image names for given string value
docker image ls | grep jenkins2 | tr -s ' ' | cut -d ' ' -f 1

# remove docker images using command to filter by string value
docker rmi $(docker image ls | grep jenkins2 | tr -s ' ' | cut -d ' ' -f 1)

# jenkins docker swarm
docker swarm init
# create jenkins master
docker service create --name jenkins-master \
    -p 50009:50009 \
    -p 8080:8080 jenkins
# create docker secret
echo "-master http://192.168.10.26 -password br549terminal -username csi-admin"|docker secret create jenkins-v1 -
# create and add jenkins swarm agent
docker service create \
	--mode=global \
	--name jenkins-swarm-agent \
	-e LABELS=docker-test \
	--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
	--mount "type=bind,source=/tmp/,target=/tmp/" \
	--secret source=jenkins-v1,target=jenkins \
  vfarcic/jenkins-swarm-agent
# get docker container ID for specific named container
docker inspect --format="{{.Id}}" container-name
# bash docker breadcrumb trail of image; usage example: `dc_trace_cmd jenkins`
function dc_trace_cmd() {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

docker run -d -p 8080:8080 \
  -v /skynet/ACAF5_data/openlayers:/openlayers \
  -v /skynet/ACAF5_data/common:/common \
  -v /skynet/METOC_Store:/skynet/METOC_Store \
  -v /skynet/ACAF5_data:/skynet/ACAF5_data \
  -v $PWD:/acaf \
  -itd --name jenkins-acaf acaf-docker



# printf subdirectories
for d in /skynet/ACAF5_data/noaa_ww3/*;do printf $d;done

# find files
find "$noaa_ww3_origin" -type f -name "*.nc" | while read file; do
echo $file
done

#
for d in ${noaa_ww3_origin}; do 
if [ -d "$d" ]; then 
echo $(find $d -type f -name "*.nc");
fi;
done



# get number of files in dir
ls -l . | egrep -c '^-'

# ubuntu style linux install and configure unattended-upgrades
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades

# install java 1.8 from inside a running drift docker container
yum install java-1.8.0-openjdk-devel -y

# find LDAP DIT Root Entry and the RootDN Bind (given CSI example)
ldapsearch -H ldap://192.168.10.2 -x -LLL -s base -b "" namingContexts
# *** above command outputs below ***
# dn:
# namingContexts: DC=csi,DC=local
# namingContexts: CN=Configuration,DC=csi,DC=local
# namingContexts: CN=Schema,CN=Configuration,DC=csi,DC=local
# namingContexts: DC=DomainDnsZones,DC=csi,DC=local
# namingContexts: DC=ForestDnsZones,DC=csi,DC=local

# find supported LDAP server SASL mechanisms
ldapsearch -H ldap://192.168.10.2 -x -LLL -s base -b "" supportedSASLMechanisms
# *** above command outputs below ***
# dn:
# supportedSASLMechanisms: GSSAPI
# supportedSASLMechanisms: GSS-SPNEGO
# supportedSASLMechanisms: EXTERNAL
# supportedSASLMechanisms: DIGEST-MD5

# find all kinds of LDAP info
ldapsearch -H ldap://192.168.10.2 -x -LLL -s base -b "" "(cn=*)"

# find all files changed in last seven days
find path_to_directory -type f -mtime -7

# find png files and compress them
find. -name *.png -type f -print | xargs tar -cvzf images.tar.gz

# take url list and download them
cat urls.txt | xargs wget

# use xargs to process the middle input instead of first input passed
ls /etc/*.conf | xargs -i cp {} /home/likegeeks/Desktop/out

# find and move
find ./ -name '*article*' | xargs -I '{}' mv {} ../backup

# find in this directory items with name containing string value
find . -maxdepth 1 -name "*pr_wav_per*"

find . -maxdepth 1 -name "*failures*" | sort -r | head

# moved files
adam@skynet:/volume1/Drift-SAR_test_data/dynamic/netcdf$ mkdir hidden_files
adam@skynet:/volume1/Drift-SAR_test_data/dynamic/netcdf$ find . -maxdepth 1 -type f -mtime -12 | xargs -I '{}' mv {} hidden_files/

# find pycharm
jps -mv

# find and kill pid
kill $(ps aux | grep 'worker' | awk '{print $2}')

# list pids
pgrep -f '[k]worker'

# kill where PID is the process id number
kill -9 PID

# find all groups in system
getent group | cut -d: -f1

# tail a directory...
watch "ls -lrt /dirpath | tail -10"

# evals checksum for grb2 files and their correspondingly named *.md5 files residing within the same $PWD
for f in *.grb2.md5; do
    md5sum -c <<<$(cat $f) >> errors.log; done

# reads a list of urls and downloads them with wget
while read -r line; do
    wget $line 2>&1 | tee -a new_wget.log; done < md5_url_new.txt

# reads a list of urls and downloads them with curl
while read -r line; do
curl -O $line >> downloads.log; done < url_fails.txt

# remove file extensions
find . -name '*.bak' -type f | while read NAME ; do mv "${NAME}" "${NAME%.bak}" ; done

# copies files from $PWD to an absolute directory
while read -r line; do
cp -f $line /home/adam/METOC_Store/new_cfsr_additions > copy.log; done < passed.txt

# finds files in $PWD and copies to new dir
find $PWD -name '*matching_stuff_here' | xargs -i -t cp {} $PWD/testing

# using deflation level 1 from NCO tools to create netcdf4 files
find . -name '*hycom-12_00600*' | xargs -i -t -n1 -P8 ncks -4 --dfl_lvl=1 {} {}4

# same as above but using exec
find $PWD -name '*bounding_box*' -exec cp {} testing/ \;

# finds files with permissions and modifies their permissions
for f in $(find $PWD/$f \! \( -perm 0777 -o -perm 0775 \)); do
sudo chmod 777 $f; done

# remove files matching pattern <10k in size
find $PWD -type f -size -10k -name '*GR[?]dyn*' -exec rm -f {} \;
#
time find $PWD -name '*curr_vcmp&format=GRIB2*' | xargs -i -t -n1 -P4 sudo java -Xmx256m -classpath /home/adam/PycharmProjects/drift-sar/lib/drift_modules/downloader/netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in {} -out {}.nc

# removes files in $PWD
while read -r line; do
rm $line; done < delete_me_from_server.txt 2>&1 | tee -a deleted.log

# read through file using regex
grep "FAIL.*read" errors.log

# mount/unmount via ssh fileshare
sudo apt install sshfs
mkdir /home/adam/Documents/ci-admin-Documents/
sshfs ci-admin@192.168.10.11:/home/ci-admin/Documents /home/adam/Documents/ci-admin-Documents/

sshfs ci-admin@192.168.10.11:/volume1/METOC_Store /home/adam/Documents/ci-admin-Documents/

# unmount ssh fileshare
fusermount -u /home/adam/Documents/ci-admin-Documents/

# ssh passwordless, if $USER is a sudoer
# generate pubkey on client if not already done
ssh-keygen -t rsa
# ALT EXAMPLE FOR SSH passwordless
ssh-copy-id user@server-name-here
## new syntax ##
ssh-copy-id -p 2222 nixcraft@192.168.1.146
ssh -p 2222 nixcraft@192.168.1.146

# time a couple java procs to run parallel
time java -Xmx2g -classpath netcdfAll-4.6.6.jar ucar.nc2.write.Nccopy -i pgbh06.gdas.1979010100.grb2 -o pgbh06.gdas.1979010100.nc -f netcdf4 & java -Xmx2g -classpath netcdfAll-4.6.6.jar ucar.nc2.write.Nccopy -i pgbh06.gdas.1979010106.grb2 -o pgbh06.gdas.1979010106.nc -f netcdf4 && fg

time java -Xmx2g -classpath netcdfAll-4.6.6.jar ucar.nc2.write.Nccopy -i pgbh06.gdas.1979010112.grb2 -o pgbh06.gdas.1979010112.nc -f netcdf4 & java -Xmx2g -classpath netcdfAll-4.6.6.jar ucar.nc2.write.Nccopy -i pgbh06.gdas.1979010118.grb2 -o pgbh06.gdas.1979010118.nc -f netcdf4	 && fg

# method@2
time java -Xmx512m -classpath netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in pgbh06.gdas.1979010100.grb2 -out pgbh06.gdas.1979010100.nc -f netcdf4 & java -Xmx512m -classpath netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in pgbh06.gdas.1979010106.grb2 -out pgbh06.gdas.1979010106.nc -f netcdf4 && fg

time java -Xmx512m -classpath netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in pgbh06.gdas.1979010112.grb2 -out pgbh06.gdas.1979010112.nc -f netcdf4 & java -Xmx512m -classpath netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in pgbh06.gdas.1979010118.grb2 -out pgbh06.gdas.1979010118.nc -f netcdf4 && fg

# connect cerbo
ssh -t root@10.10.101.101 screen -R

# read markdown from command line
sudo apt install -y pandoc lynx
# command example:
pandoc README.md | lynx -stdin
