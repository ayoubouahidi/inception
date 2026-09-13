# User Documentation — Inception

This document provides a simple guide for users and administrators on how to use, manage, and verify the Inception web infrastructure.

---

## 1. Provided Services

When the project is running, it provides a complete and secure web stack composed of three services:

* **NGINX:** The web server that serves the website and accepts only secure HTTPS connections.
* **WordPress:** A fully installed content management system where you can create pages, publish posts, and manage users.
* **MariaDB:** The database server that stores the website content, user accounts, and configuration.

---

## 2. Starting and Stopping the Project

Run the following commands from the root directory of the project.

### Start the Infrastructure

```bash
make
```

This command creates the required data directories, builds the Docker images, and starts the complete infrastructure in the background. After the first setup, `make up` can be used to rebuild and start the project.

### Stop the Infrastructure

```bash
make down
```

This stops all running containers without deleting your website or database data.

---

## 3. Data Persistence

The project stores the WordPress files and MariaDB database outside the containers using bind-mounted host directories.

Because of this:

* Running `make down` does **not** delete your website.
* Your posts, users, and database remain available after restarting the project.
* Rebuilding the containers does not remove your saved data.

---

## 4. Accessing the Website

Before opening the website, make sure your `/etc/hosts` file contains:

```text
127.0.0.1 ayouahid.42.fr
```

### Open the Website

Visit:

```text
https://ayouahid.42.fr
```

Because the project uses a **self-signed certificate**, your browser may display a security warning. This is expected during local development, and you can safely continue to the website.

### WordPress Administration

To access the WordPress administration panel, open:

```text
https://ayouahid.42.fr/wp-admin
```

Log in using the WordPress administrator credentials configured for the project.

---

## 5. Managing Credentials

Project configuration is stored in `srcs/.env` and Docker secrets:

```text
srcs/.env
secrets/db_password.txt
secrets/db_root_password.txt
secrets/credentials.txt
```

The `.env` file contains non-secret settings such as:

* Database name and user (`MYSQL_DATABASE`, `MYSQL_USER`)
* WordPress database endpoint (`WORDPRESS_DB_HOST`)
* Domain configuration (`DOMAIN_NAME`)

Database passwords are read from `db_password.txt` and `db_root_password.txt`. WordPress administrator and secondary-user passwords are read from `credentials.txt`. Change these files before the first launch if you need different credentials.

---

## 6. Checking the Infrastructure

To verify that all services are running correctly, execute:

```bash
make ps
```

You should see the following containers running:

* `nginx`
* `wordpress`
* `mariadb`

Their status should be **Up**, indicating that the infrastructure is running correctly.

You can also verify the project by opening:

```text
https://ayouahid.42.fr
```

If the website loads successfully, the NGINX, WordPress, and MariaDB services are communicating correctly.