#!/bin/sh
certbot renew
cp -r /etc/letsencrypt/ /cert
echo "cert synced!"