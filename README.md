# Simple nginx reverse proxy with auto ssl generation

A simple nginx reverse proxy configuration to secure app on a different destination port. This docker also include an auto ssl certificate generation process and auto renewal, using letsencrypt certificates with the certbot client and certbot-dns-route53 plugin.

Certificate will be generated on initial start and a cronjob will be configured to attempt certificate renewal once a week. If the certificates are not yet within 30 days of expiry, the renewal process will not be completed.

This version will be using the certbot dns-route53 plugin, so an AWS access key and secret key with sufficient rights will be required to update route53 dns records. Please see https://certbot-dns-route53.readthedocs.io/en/stable/ for IAM permissions and a sample IAM policy.

Run with:
```
docker run -d --name='nginx' --net='bridge' \
      -e 'SERVERNAME'='fqdn' \
      -e 'HOSTIP'='host_ip' \
      -e 'DESTPORT'='dest_port' \
      -e 'EMAIL'='your_email' \
      -p '80:80/tcp' -p '443:443/tcp' \
      -v '/tmp/nginx/config':'/etc/nginx/conf.d/' \
      -v '/tmp/nginx/sslcerts':'/etc/letsencrypt/' \
      jakezp/nginx
```

Change:<br>
SERVERNAME - FQDN of host / instance / site<br>
HOSTIP - Host IP address<br>
DESTPORT - Port of the destination application / service<br>
EMAIL - Email address (required for letsencrypt certificates)<br>
/tmp/nginx/config - preferred nginx config location on the host<br>
/tmp/nginx/sslcerts - letsencrypt config and cert location
