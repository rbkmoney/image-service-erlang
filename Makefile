UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := service_erlang
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BASE_IMAGE_NAME := base
BASE_IMAGE_TAG := a4fe78426b08c508da7f2e7a086fb801daff0def

-include $(UTILS_PATH)/make_lib/utils_image.mk

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

clean:
	rm Dockerfile

