#!/bin/sh
APIPATH="/tmp/cloudflare.ini"
DOMAINPATH=$(echo "${DOMAIN}" | sed 's/\*\.//g')

# initial checks
echo "Checking for initial requirements..."
if [ -z "${CF_DNS_API_TOKEN}" ]; then
    echo "Cloudflare API token is not set in the environment variable"
    exit 1
fi
echo "Cloudflare API token is set..."
echo "dns_cloudflare_api_token = ${CF_DNS_API_TOKEN}" > ${APIPATH}
chmod 600 ${APIPATH}

if [ -z "${DOMAIN}" ]; then
    echo "Domain is not set in the environment variable"
    exit 1
fi
echo "Domain is set..."

if [ -z "${EMAIL}" ]; then
    echo "Email is not set in the environment variable"
    exit 1
fi
echo "Email is set..."
echo "initial requirements are met!"

# check if the certificate exists, if not create it if it does echo certificate exists
echo "Checking if certificate exists..."
if [ ! -f "/etc/letsencrypt/live/${DOMAINPATH}/fullchain.pem" ]; then
    certbot certonly \
        --dns-cloudflare \
        --dns-cloudflare-credentials "${APIPATH}" \
        -d "${DOMAIN}" \
        --agree-tos \
        -m "${EMAIL}" \
        --no-eff-email
fi
echo "Certificate exists!"

echo "Checking if certificate is due for renewal..."
if [ -z "$(find /etc/letsencrypt/live/${DOMAINPATH}/fullchain.pem -mtime -2)" ]; then
    echo "Certificate is due for renewal"
    certbot renew
fi
echo "Certificate is not due for renewal"

if [ -f "/etc/letsencrypt/live/${DOMAINPATH}/fullchain.pem" ]; then
    echo "Certificate exists!"
    cp -r /etc/letsencrypt/ /cert
fi
echo "cert synced!"


# check if self signed cert exist, and generate it if it doesnt
if [ ! -f "/cert/selfsigned/cert.pem" ]; then
    mkdir -p /cert/selfsigned
    openssl req -x509 -newkey rsa:4096 -sha256 -days 36500 -nodes \
        -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=SelfSigned/CN=SelfSigned" \
        -keyout key.pem \
        -out /cert/selfsigned/cert.pem  
fi

nc -lvnp 9988