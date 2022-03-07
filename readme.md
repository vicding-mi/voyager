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
Clone the repo to a different folder every time
```shell
git clone https://github.com/vicding-mi/voyager.git myfolder # please change myfolder every time
```
Then change the USERNAME and PASSWORD in the env file
```shell
cd myfolder # replace myfolder with your actual folder name
vim .env
```
Sample content of the env file
```shell
.
.
.
USERNAME=myuser # this will be part of your domain name
PASSWORD=mypassword # please make it really safe!!!
```
### Step 1 run the setup script (Run ONCE per instance)
This script creates and starts the build
```shell
./docker-compose-multiple-create.sh
```
When this script finishes, it will ask you to start the stack

### How to stop the stack
This script stops the stack (all the config and data is preserved!)
```shell
./docker-compose-multiple-stop.sh
```

### How to start the stack 
This script start the pre-built stack (all the config and data is preserved!)
```shell
./docker-compose-multiple-start.sh
```
