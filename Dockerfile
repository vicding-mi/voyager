FROM registry.huc.knaw.nl/dockerhubproxy/library/node:17-alpine

# Install provisioning and startup scripts
WORKDIR /var/scripts
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

RUN apk update && \
    apk add vim wget curl bzip2 python3 py3-pip openssl-dev && \
    apk add --virtual build-dependencies build-base gcc wget git

RUN git clone --recurse-submodules https://github.com/smithsonian/dpo-voyager /app
WORKDIR /app
RUN npm ci
ENTRYPOINT ["/var/scripts/entrypoint.sh"]
