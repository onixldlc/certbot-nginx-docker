# certbot-nginx-docker
simple docker deployment for quick ssl certificate

## usage
1. configure the .env file
```env
  DOMAIN=*.example.com
  CF_DNS_API_TOKEN="123456890abcdefghijklmnopqrstuvewxyz"
  EMAIL="example@example.com"
```
2. replace all the templated domain at `./nginx/nginx.conf` with your domain, i.e.
```
  # ex:
  [YOURDOMAIN.COM] -> example.com
  [[SUBDOMAIN].[YOURDOMAIN.COM]] -> test.example.com

  # if you dont want any subdomain you can just remove the sub domain part, i.e.
  [[SUBDOMAIN].[YOURDOMAIN.COM]] -> example.com
```
3. to start the certbot + nginx, you can use the `start-router.sh` script 
```
./start-router.sh
```
4. and to stop the certbot + nginx, you can use the `stop-router.sh` script
```
./stop-router.sh
```
> [!IMPORTANT]
> although it is possible for you to use `docker compose up/down` to start and stop the project at will
> _**it is recomended for you to use the script instead!**_
> as  `docker compose` won't add/remove the auto renew function from the cronjob, thus limiting your certificate expiration to only 90 days
