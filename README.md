# Tomcat Docker Container

This service creates a Tomcat installation on a Centos 7 base image and is managed by supervisord. It is very closely derived from [kirillF's Docker image](https://github.com/kirillF/centos-tomcat). It requires you to set a password for the tomcat user when it starts for the first time. 
 
# Installation

Docker and Docker-Compose are required to run this application, which are packaged together for Mac and Windows users into [Docker Toolbox](https://www.docker.com/products/docker-toolbox), for Linux users, follow the instructions for installing  the [Docker Engine](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/).

# Building the Tomcat service

After installing the Docker dependencies, run the following from the command line at the root of this directory :

```
make docker
```

That command will build an image (using the `Dockerfile` "recipe" in this project folder) from which containers can be created.

# Running the Container

This container can be run from the command line like this:

```bash
docker run --name=tcat -v $PWD/mywebapp:/opt/tomcat/webapps/ -p 8080:8080 -e TOMCAT_PASS=<password> arizonatribe/centossupervisortomcat
```

That command runs the dockerized tomcat application, mapping the `/opt/tomcat/webapps` volume to the directory on your host where your web application files reside. Addtionally it sets a password for the admin user and exposes the standard port 8080.

These options are more easily committed to a `docker-compose.yml` file if they become this lengthy.  The settings from the previous commands would appear in a `docker-compose.yml` file like this:

```yaml
version: '2'
services:
  tommy:
    build: ./
    image: arizonatribe/centossupervisortomcat:latest
    container_name: tcat
    volumes:
      - ./mywebapp:/opt/tomcat/webapps
    environment:
      - TOMCAT_PASS=<password>
    ports:
      - 8080:8080
```

This file (if placed in the same directory as the Dockerfile, as indicated by the `build: ./` line) would be executed from the command line from the project root directory:

```bash
docker-compose up --build
```

This builds the image(s) first, and then instantiates the two containers together. If you wish to separate building and running into different commands, you can do so too:

```bash
docker-compose build
docker-compose up
```

# Environment variables

* __TOMCAT_PASS__ - The (required) tomcat user password.
