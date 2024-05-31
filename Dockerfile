FROM nginx:stable

COPY index.html /usr/share/nginx/html

USER nginx

HEALTHCHECK CMD curl --fail http://localhost || exit 1
