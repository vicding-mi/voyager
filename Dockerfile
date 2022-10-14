FROM registry.huc.knaw.nl/dockerhubproxy/library/node:17-alpine

# Install provisioning and startup scripts
WORKDIR /var/scripts
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

RUN apk update && \
    apk add vim wget curl bzip2 python3 py3-pip openssl-dev && \
    apk add --virtual build-dependencies build-base gcc wget git

RUN git clone --recurse-submodules https://github.com/Smithsonian/dpo-voyager.git /app && \
    cd /app && \
    git checkout master
#    git checkout tags/v0.22.0 -b 0.22.0
WORKDIR /app
RUN npm ci
ENTRYPOINT ["/var/scripts/entrypoint.sh"]
