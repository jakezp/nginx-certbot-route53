# Dockerfile for base image for nginx and certbot
FROM ubuntu:18.04

LABEL maintainer="Jakezp <jakezp@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Install and update packages
RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install supervisor nginx openssl ca-certificates certbot python3-pip cron -yq \
    && rm -rf /var/lib/apt/lists/*

# Add config files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx.conf /nginx.conf
ADD crontab /crontab
ADD run.sh /run.sh
RUN rm /etc/init.d/nginx

# Create directories
RUN mkdir /etc/ssl/certs/nginx

# Set permissions
RUN chmod +x /run.sh

# Expose volumes & ports
VOLUME ["/etc/nginx/conf.d/", "/etc/letsencrypt/"]

WORKDIR /
CMD ["/run.sh"]
