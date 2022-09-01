FROM node:16
WORKDIR /usr/src/app
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y update && apt-get -y install nginx
RUN cat /etc/nginx/sites-available/default
COPY . .
RUN npm install
RUN npm run build -- --CATALOG_URL="https://stac-api-server.azurewebsites.net/"
WORKDIR /usr/src/app/dist
RUN cp -rf . /var/www/html
EXPOSE 80/tcp
CMD ["nginx", "-g", "daemon off;"]
