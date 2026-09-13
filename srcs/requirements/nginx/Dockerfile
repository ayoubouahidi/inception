FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
        -keyout /etc/nginx/ssl/ayouahid.key \
        -out    /etc/nginx/ssl/ayouahid.crt \
        -subj "/C=MA/ST=BENGUERIR/L=BENGUERIR/O=4242/OU=42/CN=ayouahid.42.fr"


COPY conf/nginx.conf /etc/nginx/sites-available/default

ENTRYPOINT	[ "nginx", "-g", "daemon off;" ]

