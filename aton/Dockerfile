FROM node:14

RUN apt update && apt install vim -y

# Create main ATON folder
WORKDIR /aton

#COPY ./aton ./

RUN npm install && npm install pm2 -g

#EXPOSE 8080
#CMD [ "node", "services/ATON.service.main.js" ]
ENTRYPOINT [ "/aton/entrypoint.sh" ]
