FROM nginx:stable

COPY default.conf /etc/nginx/conf.d
COPY nginx.conf /etc/nginx
COPY index.html /usr/share/nginx/html

USER nginx

HEALTHCHECK CMD curl --fail http://localhost || exit 1
