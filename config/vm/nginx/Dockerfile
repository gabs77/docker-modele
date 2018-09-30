FROM nginx

ADD nginx.conf /etc/nginx/nginx.conf
ADD includes/sites.conf /etc/nginx/includes/sites.conf
ADD fastcgi.conf /etc/nginx/fastcgi.conf
ADD localhost.key /etc/ssl/private/localhost.key
ADD localhost.crt /etc/ssl/certs/localhost.crt

# Install base
RUN apt-get update \
  && apt-get install -y htop vim nano
