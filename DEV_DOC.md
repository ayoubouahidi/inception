# Developer Documentation — Inception

This document provides developers with the information needed to set up, build, manage, and inspect the **Inception** infrastructure. It is intended for anyone who wants to understand the project structure, rebuild the environment, or debug the running services.

---

## 1. Project Directory Structure

```text
inception/
├── Makefile
└── srcs/
    ├── .env                # (Must be created by the developer)
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/server.cnf
        │   └── tools/entrypoint.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── .dockerignore
        └── wordpress/
            ├── Dockerfile
            ├── conf/www.conf
            ├── tool/entrypoint.sh
            └── .dockerignore
```

---

## 2. Setting Up the Environment from Scratch

### Prerequisites

Before building the project, make sure your Debian/Ubuntu virtual machine has:

* Docker Engine with Docker Compose v2
* GNU Make
* `sudo` (or root privileges) to edit `/etc/hosts` and create the required data directories

### Step 1: Configure the Local Domain

The project uses a custom local domain that must resolve to your machine.

Add the configured domain to `/etc/hosts`:

```bash
echo "127.0.0.1 ayouahid.42.fr" | sudo tee -a /etc/hosts
```

Verify that the domain resolves correctly:

```bash
ping -c 1 ayouahid.42.fr
```

### Step 2: Create the `.env` File

The infrastructure reads its configuration from `srcs/.env`.

Create the file and provide your own values:

```text
# Domain Configuration
DOMAIN_NAME=ayouahid.42.fr

# MariaDB Configuration
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
WORDPRESS_DB_HOST=mariadb:3306

# WordPress Configuration
WP_ADMIN_EMAIL=admin@student.1337.ma

# WordPress Secondary User
WP_USER_EMAIL=user@student.1337.ma
```

Database passwords are supplied through Docker secrets in `secrets/db_password.txt`
and `secrets/db_root_password.txt`. WordPress admin and secondary-user passwords
are sourced from `secrets/credentials.txt` using `ADMIN_PASSWORD` and
`USER_PASSWORD`.

---

## 3. Building and Launching the Project

The project is managed through the root **Makefile**, which executes Docker Compose commands using `srcs/docker-compose.yml`.

### Build and Start

```bash
make
# or
make up
```

This command:

1. Creates the required host directories inside `/home/$USER/data/`.
2. Builds every image from its custom Dockerfile based on **Debian 12**.
3. Starts the Docker containers defined in `docker-compose.yml`.
4. Creates the internal Docker network so the containers can communicate with each other.

---

## 4. Managing the Infrastructure

### Makefile Commands

| Command            | Action        | Description                                                             |
| ------------------ | ------------- | ----------------------------------------------------------------------- |
| `make` / `make up` | Build & Start | Creates data directories, builds images, and starts the infrastructure. |
| `make down`        | Stop & Remove | Stops containers and removes containers and networks.                   |
| `make start`       | Start         | Starts previously stopped containers.                                   |
| `make stop`        | Stop          | Stops running containers without removing them.                         |
| `make ps`          | Status        | Displays the Compose service status.                                    |
| `make logs`        | Logs          | Follows logs from all Compose services.                                  |
| `make clean`       | Clean         | Stops the project and runs `docker system prune -af`.                    |
| `make fclean`      | Full clean    | Removes project data directories and prunes Docker resources.             |
| `make re`          | Rebuild       | Runs `fclean` followed by a complete setup and build.                    |

---

## 5. Useful Debugging Commands

### View Container Logs

Use logs to verify that a service started correctly or to diagnose runtime errors.

```bash
docker logs -f nginx

docker logs -f wordpress

docker logs -f mariadb
```

### Open a Shell Inside a Container

This is useful for inspecting configuration files or testing commands inside a running container.

```bash
docker exec -it wordpress bash

docker exec -it mariadb bash
```

### Inspect the Docker Network

Display the containers connected to `inception_network` and their internal IP addresses.

```bash
docker network inspect inception_network
```

---

## 6. Data Persistence

Persistent data is stored on the host machine under:

```text
/home/ayouahid/data/
├── mariadb/
└── wordpress/
```

The Compose volumes are bind mounts configured to use these directories, allowing the WordPress files and MariaDB database to remain available even after containers are removed or rebuilt.

Because the data is stored outside the containers:

* `make down` does **not** remove your website or database.
* Rebuilding the images does **not** delete existing data.
* The project can be restarted without reinstalling WordPress.

To completely reset the project, manually remove the stored data:

```bash
sudo rm -rf /home/ayouahid/data/mariadb/*
sudo rm -rf /home/ayouahid/data/wordpress/*
```

---

## 7. Verifying the Infrastructure

After running `make`, you can verify that everything is working correctly:

* `docker ps` shows the **nginx**, **wordpress**, and **mariadb** containers running.
* Opening `https://ayouahid.42.fr` displays the WordPress website.
* `docker network inspect inception_network` shows all three containers connected to the same internal network.
* WordPress successfully connects to MariaDB on the internal `mariadb:3306` endpoint.
* Website and database data remain available after running `make down` followed by `make`.