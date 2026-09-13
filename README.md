*This project has been created as part of the 42 curriculum by ayouahid.*

# Inception

## Description

This project is an introduction to system administration using Docker. The goal is to build a complete web infrastructure inside a virtual machine using separate, custom-built Docker containers. Docker allows each service to run inside its own isolated container, making the infrastructure easier to build, deploy, and maintain.

I used **Debian bookworm** as the base image for all my containers because it is a stable and lightweight Linux distribution that is well suited for server environments.

The stack includes:

* **NGINX:** The web server configured to only accept secure connections using TLSv1.2 and TLSv1.3 on port **443**.
* **WordPress + PHP-FPM:** The website core, installed automatically using `wp-cli`.
* **MariaDB:** The database server that stores all the WordPress data.

## Main Design Choices

* Each service runs inside its own dedicated Docker container.
* Every service is built from its own custom Dockerfile based on Debian bookworm.
* NGINX is the only container exposed to the host through port **443**.
* WordPress communicates with PHP-FPM using the FastCGI protocol.
* MariaDB is only accessible from inside the Docker network.
* Persistent data is stored in host directories bind-mounted into the containers, allowing the website and database data to remain even after the containers are removed.

## Architecture

```text
                    HTTPS :443
                         │
                         ▼
                    ┌─────────┐
                    │  NGINX  │
                    └────┬────┘
                         │
                     FastCGI
                         │
                         ▼
                  ┌──────────────┐
                  │ WordPress +  │
                  │   PHP-FPM    │
                  └──────┬───────┘
                         │
                  MySQL/MariaDB
                     protocol
                         │
                         ▼
                    ┌─────────┐
                    │ MariaDB │
                    └─────────┘
```

Only NGINX is exposed to the outside through port **443**. PHP-FPM and MariaDB communicate internally through the Docker network.

## Technical Comparisons

### Virtual Machines vs Docker

Virtual Machines emulate an entire computer and require a complete guest operating system, making them heavier and slower to start. Docker works at the operating-system level, where containers share the host's kernel. This makes containers much lighter, faster to launch, and more efficient in their use of system resources.

### Secrets vs Environment Variables

Environment variables, like the ones stored in my `.env` file, are simple to use for configuration. However, sensitive values stored as environment variables may be visible through commands such as `docker inspect`. Secrets are designed to provide a safer way to handle sensitive information instead of storing passwords directly in environment variables.

### Docker Network vs Host Network

* A Docker network, `inception_network`, creates an isolated network for the containers. WordPress and MariaDB communicate using their container names without exposing ports such as **9000** or **3306** to the outside. With the host network, the container shares the host's network instead of having its own isolated network.

### Docker Volumes vs Bind Mounts
* Bind mounts directly use folders from the host machine, so they depend on the host's directory structure. This project uses bind-mounted directories at `/home/ayouahid/data/wordpress` and `/home/ayouahid/data/mariadb` for persistent website and database data. The data remains available when the containers are removed.

## Protocols

### HTTPS

The browser communicates securely with NGINX through HTTPS on port **443**. TLS encrypts all communication between the browser and the web server.

### FastCGI

NGINX does not execute PHP code itself. Instead, it forwards PHP requests to PHP-FPM using the FastCGI protocol.

### MySQL/MariaDB Protocol

WordPress communicates with MariaDB using the MySQL/MariaDB client protocol to execute queries and manage the website data.

## TLS and Certificate

NGINX is configured to support **TLSv1.2** and **TLSv1.3**.

The project uses a **self-signed certificate**. During the TLS handshake, the certificate allows the client to identify the server and establish an encrypted connection. Since the certificate is self-signed instead of being issued by a trusted Certificate Authority (CA), browsers will display a security warning, which is expected for this project.

The private key remains on the server and is never shared. It is used together with the certificate to establish the secure TLS connection.

## Instructions

1. **Host Configuration**

   Add the following line to your `/etc/hosts` file so your domain points to your local machine:

   ```text
    127.0.0.1 ayouahid.42.fr
   ```

2. **Environment Variables**

   Make sure the `.env` file exists inside the `srcs/` directory. It contains the required configuration variables such as `DOMAIN_NAME`, `MYSQL_DATABASE`, and the WordPress user information.

3. **Build and Run**

   From the project root, run:

   ```bash
   make
   ```

   This command creates the required data directories, builds all Docker images, and starts the containers.

   You can also run:

   ```bash
   make up
   ```

4. **Access the Website**

   Open your browser and visit:

   ```text
   https://ayouahid.42.fr
   ```

5. **Stop the Project**

   ```bash
   make down
   ```

## Resources

* Docker Documentation: https://docs.docker.com/
* NGINX Documentation: https://nginx.org/en/docs/
* WordPress CLI (WP-CLI): https://make.wordpress.org/cli/handbook/
* MariaDB Documentation: https://mariadb.org/documentation/

### AI Usage

AI was used to help explain Docker concepts, clarify technical topics, improve the English writing, and organize this `README.md`. It was used as a learning tool to better understand the project requirements.