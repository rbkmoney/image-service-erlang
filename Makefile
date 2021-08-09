SERVICE_NAME := service-erlang

BASE_IMAGE_NAME := library/erlang
BASE_IMAGE_TAG := 24.0.5-slim
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

erlang.cfg: erlang.cfg.sh
	ERLANG_VERSION=${ERLANG_VERSION} \
	./erlang.cfg.sh > erlang.cfg

Dockerfile: erlang.cfg Dockerfile.sh
	REGISTRY=$(REGISTRY) ORG_NAME=$(ORG_NAME) \
	BASE_IMAGE_NAME=$(BASE_IMAGE_NAME) BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	BASE_IMAGE="$(BASE_IMAGE_NAME):$(BASE_IMAGE_TAG)" \
	COMMIT=$(COMMIT) BRANCH=$(BRANCH) \
	./Dockerfile.sh > Dockerfile
