#!/bin/bash

# Set AWS credentials
export AWS_ACCESS_KEY_ID=ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=SECRET_KEY

# Add config file & configure nginx
if [[ ! -f /etc/nginx/conf.d/reverseproxy.conf ]]; then
  echo -e "=> Setting up nginx"
  mv /nginx.conf /etc/nginx/conf.d/reverseproxy.conf
  sed -i "s/SERVERNAME/$SERVERNAME/g" /etc/nginx/conf.d/reverseproxy.conf
  sed -i "s/HOSTIP/$HOSTIP/g" /etc/nginx/conf.d/reverseproxy.conf
  sed -i "s/DESTPORT/$DESTPORT/g" /etc/nginx/conf.d/reverseproxy.conf
fi

if [[ ! -f /etc/ssl/certs/nginx/dh2048.pem ]]; then
  echo -e "=> Generating DH cert"
  openssl dhparam -out /etc/ssl/certs/nginx/dh2048.pem 2048
fi

# Generate letsencrypt certificates
if [[ ! -f /etc/letsencrypt/live/$SERVERNAME/fullchain.pem ]]; then
  echo -e "=> Generating certificates..."
  certbot certonly --dns-route53 --email $EMAIL --agree-tos --no-eff-email -d $SERVERNAME
fi

# Configure cron
if [[ ! -f /var/spool/cron/crontabs/root ]]; then
  mv /crontab /var/spool/cron/crontabs/root
fi
touch /etc/crontab /etc/cron.d/* /var/spool/cron/crontabs/* /var/log/cron.log
chmod 0600 /var/spool/cron/crontabs/root

# Use supervisord to start all processes
echo -e "Starting supervisord"
supervisord -c /etc/supervisor/conf.d/supervisord.conf
