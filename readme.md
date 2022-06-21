# Build voyager 
This repo builds voyager. There are 3 build files, for build time, run time and portainer respectively. 

* `docker-compose-build.yml` - is the build time file, it builds the docker image
* `docker-compose.yml` - is the run time file, it does not build but use the pre-built image from the build script
* `docker-compose-portainer.yml` - is the special Portainer running file, it uses the pre-built image from the build script and only runs on Portainer

### Build image 
Build the image
```shell
docker-compose -f docker-compose-build.yml build
```

### Run image
```shell
docker-compose up -d
```
Note: _The `-d` option puts the conatiner in daemon mode and keeps it alive_

### Stop the container
```shell
docker-compose down
```


## Run voyager with nextcloud (upload files and editor online)
### Step 0 git clone into different folder and change env file (Run ONCE per instance)
Clone or download the repo 
```shell
git clone https://github.com/vicding-mi/voyager.git myfolder # please change myfolder every time
```
Make sure HOSTNAME is correct in the env file
```shell
cd myfolder # replace myfolder with your actual folder name
vim .env
```
Sample content of the env file
The hostname is your base url without subdomain, the full url of next cloud will be 
`nc.<your domain>` while full url of voyager will be `viewer.<your domain>`

The password would be your nextcloud admin password, username is `admin`
```shell
.
.
.
HOSTNAME=pure3d.dev.clariah.nl
PASSWORD=mypassword # please make it really safe!!!
```
### Step 1 run the setup script (Run ONCE per instance)
This script creates and starts the build
```shell
./docker-compose-single-create.sh
```
When this script finishes, it will ask you to start the stack

### How to stop the stack
This script stops the stack (all the config and data is preserved!)
```shell
./docker-compose-single-stop.sh
```

### How to start the stack 
This script start the pre-built stack (all the config and data is preserved!)
```shell
./docker-compose-single-start.sh
```

## Add cron job to backup files 
The below file is added to crontab, it will create hourly backup in user folder `backup`
```shell
docker-compose-single-backup.sh
```


## Add cron job to scan for externally added files for nextcloud
The below file is added to crontab, it will run every 2 minutes to make sure that the folder permission is well 
set and newly modified files from voyager are well picked up in next cloud
```shell
docker-compose-single-scan.sh
```

### Note: below section is deprecated, it is only kept here for backward compatibility purpose as there are old containers running

Whenever user saves their work externally, for example, save their work in voyager, 
they won't see their work automatically in Nextcloud. This is due to the fact that all the 
externally added files have to be scanned first. 

To tackle this issue, a `cron.sh` file is created and should be added to crontab of the root user. 
It is possible to use user level crontab, however, that might have unknow consequence for containers 
created by different users. To be on the safe side, for now, `cron.sh` should be added to root space. 

Adding cron job should be done only once. It will take care of all the containers within one folder. 
Below is the config of the `cron.sh`
```shell
wd=/data/pure3d_dev
scan_script=docker-compose-multiple-scan.sh
```
Line 1 sets the working directory of all the instances
Line 2 sets the job we want to invoke

and by default the cron job runs every 2 minutes, users will see 2 minutes delay. 
