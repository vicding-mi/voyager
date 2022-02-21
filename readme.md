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
