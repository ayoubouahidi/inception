FROM debian:bookworm


RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY conf/server.cnf /etc/mysql/mariadb.conf.d/server.cnf

COPY tools/entrypoint.sh .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["mariadbd-safe"]