SERVICE_NAME := service-erlang
ORG_NAME ?= rbkmoney
SERVICE_IMAGE_NAME ?= $(ORG_NAME)/$(SERVICE_NAME)

BASE_IMAGE_NAME := library/erlang
BASE_IMAGE_TAG := 24.1.5.0-slim
ERLANG_VERSION := $(subst  -slim,,${BASE_IMAGE_TAG})

REGISTRY ?= dr2.rbkmoney.com
DOCKER ?= docker
DOCKER_BUILD_OPTIONS ?=

.PHONY: $(SERVICE_NAME) push clean
$(SERVICE_NAME): .state

COMMIT := $(shell git rev-parse HEAD)
rev = $(shell git rev-parse --abbrev-ref HEAD)
BRANCH := $(shell \
if [ "${rev}" != "HEAD" ]; then \
	echo "${rev}" ; \
elif [ -n "${BRANCH_NAME}" ]; then \
	echo "${BRANCH_NAME}"; \
else \
	echo `git name-rev --name-only HEAD`; \
fi)

erlang.cfg: erlang.cfg.sh
	ERLANG_VERSION=${ERLANG_VERSION} \
	./erlang.cfg.sh > erlang.cfg

Dockerfile: erlang.cfg Dockerfile.sh
	REGISTRY=$(REGISTRY) ORG_NAME=$(ORG_NAME) \
	BASE_IMAGE_NAME=$(BASE_IMAGE_NAME) BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	BASE_IMAGE="$(BASE_IMAGE_NAME):$(BASE_IMAGE_TAG)" \
	COMMIT=$(COMMIT) BRANCH=$(BRANCH) \
	./Dockerfile.sh > Dockerfile

.state: Dockerfile
	$(eval TAG := $(shell git rev-parse HEAD))
	$(DOCKER) build -t "$(REGISTRY)/$(SERVICE_IMAGE_NAME):$(TAG)" $(DOCKER_BUILD_OPTIONS) .
	echo $(TAG) > $@

push:
	$(DOCKER) push "$(REGISTRY)/$(SERVICE_IMAGE_NAME):$(shell cat .state)"

clean:
	test -f .state \
	&& $(DOCKER) rmi -f "$(REGISTRY)/$(SERVICE_IMAGE_NAME):$(shell cat .state)" \
	&& rm .state
