# docker-outlook-oauth2-proxy
A project for building a docker image of https://github.com/outlook/oauth2_proxy. The oauth2_proxy fork that supports Azure AD groups
## Motivation
Use the Azure AD groups feature until its implemented in the [official](https://github.com/pusher/oauth2_proxy) oauth2_proxy project
## Usage
```
docker run -it --rm -p 8080:8080 gramal/outlook-oauth2-proxy:v2.2.1-alpha \
  -client-id='YOUR_CLIENT_ID' \
  -client-secret='YOUR_CLIENT_SECRET' \
  -provider=azure \
  -cookie-expire=30m \
  -cookie-secret=qRDG0j8I \
  -cookie-secure=false \
  -upstream='https://someupstream.youcompany.com' \
  -http-address='0.0.0.0:8080' \
  -email-domain='*' \
  -redirect-url='http://localhost:8080/oauth2/callback' \
  -pass-groups=true \
  -permit-groups='group-that-has-access-to-upstream'
```
