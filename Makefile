SERVICE_NAME := service-erlang

BASE_IMAGE_NAME := library/erlang
BASE_IMAGE_TAG := 23.2.7-slim
ERLANG_VERSION := $(subst  -slim,,${BASE_IMAGE_TAG})

UTILS_PATH := build_utils
TEMPLATES_PATH := .

SUBMODULES = $(UTILS_PATH)
SUBTARGETS = $(patsubst %,%/.git,$(SUBMODULES))

.PHONY: submodules

COMMIT := $(shell git rev-parse HEAD)
rev = $(shell git rev-parse --abbrev-ref HEAD)
BRANCH := $(shell \
if [[ "${rev}" != "HEAD" ]]; then \
	echo "${rev}" ; \
elif [ -n "${BRANCH_NAME}" ]; then \
	echo "${BRANCH_NAME}"; \
else \
	echo `git name-rev --name-only HEAD`; \
fi)

SERVICE_IMAGE_TAG=$(COMMIT)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

-include $(UTILS_PATH)/make_lib/utils_image.mk

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

Dockerfile: Dockerfile.sh
	REGISTRY=$(REGISTRY) ORG_NAME=$(ORG_NAME) \
	BASE_IMAGE_NAME=$(BASE_IMAGE_NAME) BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	BASE_IMAGE="$(BASE_IMAGE_NAME):$(BASE_IMAGE_TAG)" \
	COMMIT=$(COMMIT) BRANCH=$(BRANCH) \
	./Dockerfile.sh > Dockerfile

erlang.cfg: erlang.cfg.sh
	ERLANG_VERSION=${ERLANG_VERSION} \
	./erlang.cfg.sh > erlang.cfg

.image-tag: Dockerfile erlang.cfg
	docker build -t "$(SERVICE_IMAGE_NAME):$(COMMIT)" .
	echo $(COMMIT) > $@

push:
	if [ -f .image-tag ]; then $(DOCKER) push "$(SERVICE_IMAGE_NAME):`cat .image-tag`"; \
	else echo "No .image-tag file. Build the image first"; exit 1; fi

clean:
	if [ -f .image-tag ]; then $(DOCKER) rmi -f "$(SERVICE_IMAGE_NAME):`cat .image-tag`"; fi
	rm -f .image-tag Dockerfile erlang.cfg
