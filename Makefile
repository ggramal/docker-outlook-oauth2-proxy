VERSION_FILE = VERSION

VERSION = $(shell cat $(VERSION_FILE) 2> /dev/null)

ifeq ($(VERSION),)
$(error VERSION is not set)
endif


DOCKER_REPOSITORY = gramal
CONTAINER_NAME = outlook-oauth2-proxy

.PHONY: build

build:
	docker build -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	#docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)

