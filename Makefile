PACKAGE=debian-dev
DOCKER=docker
UID=$(shell id -u)
USER=$(shell id -un)
GID=$(shell id -g)
GROUP=$(shell id -gn)
DOCKER_GID=$(shell stat -c %g /var/run/docker.sock)
STATIC=Dockerfile \
	Makefile \
	deb.nodesource.com.gpg \
	download.docker.com.linux.debian.gpg \
	start.sh

.PHONY: all

all: build
	
build: ${STATIC}
	$(DOCKER) build \
		--build-arg="docker_gid=$$(stat -c %g /var/run/docker.sock)" \
		--build-arg="user=$(USER)" \
		--build-arg="uid=$(UID)" \
		--build-arg="group=$(GROUP)" \
		--build-arg="gid=$(GID)" \
		-t $(PACKAGE):$(USER).$(UID).$(GROUP).$(GID).$(DOCKER_GID) .
