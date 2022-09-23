FROM node:16
WORKDIR /usr/src/app
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y update && apt-get -y install nginx
# install python3.8 and pip
# replace contents of /etc/nginx/sites-available/default with contents from nginx.conf
COPY nginx.conf /etc/nginx/sites-available/default
# COPY requirements.txt .
# RUN pip3 install -r requirements.txt
COPY package.json .
COPY package-lock.json .
COPY .npmignore .
RUN npm install
COPY . .
RUN npm run build -- --CATALOG_URL="https://planetarycomputer.microsoft.com/api/stac/v1"
WORKDIR /usr/src/app/dist
RUN cp -rf . /var/www/html
# install requirements.txt
WORKDIR /usr/src/app

EXPOSE 80/tcp
# start both nginx and gunicon hosting proxy:app
CMD nginx -g daemon off;

