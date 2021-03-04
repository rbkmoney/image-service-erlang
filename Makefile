SERVICE_NAME := service-erlang

BASE_IMAGE_NAME := library/erlang
BASE_IMAGE_TAG := 23.2.5.0-alpine

SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

UTILS_PATH := build_utils
TEMPLATES_PATH := .

.PHONY: $(SERVICE_NAME) push clean
$(SERVICE_NAME): .image-tag

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
-include $(UTILS_PATH)/make_lib/utils_image.mk

SUBMODULES := $(UTILS_PATH)
SUBTARGETS := $(patsubst %,%/.git,$(SUBMODULES))

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
