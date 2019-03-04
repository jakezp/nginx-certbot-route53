#!/bin/bash

# Set AWS credentials
export AWS_ACCESS_KEY_ID=ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=SECRET_KEY

# Update certificates
certbot certonly --dns-route53
