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
### Step 1 run the setup script (Run ONCE)
This script creates and starts the build
```shell
./docker-compose-mutiple-create.sh
```
voyager will be running on `http://localhost:8000` while nc will be running on `http://localhost:8080`. 

### Step 2 stop the stack
This script stops the stack (all the config and data is preserved!)
```shell
./docker-compose-mutiple-stop.sh
```

### Step 3 start the stack 
This script start the pre-built stack (all the config and data is preserved!)
```shell
./docker-compose-mutiple-start.sh
```
