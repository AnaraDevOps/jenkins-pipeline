FROM node:22.5.1
WORKDIR /opt
ADD . /opt
RUN npm install
ENTRYPOINT npm run start