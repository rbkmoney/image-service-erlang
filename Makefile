UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := service_erlang
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BASE_IMAGE_NAME := base
BASE_IMAGE_TAG := 3610f8eeb453a0e891aa271b48b7ec533b764fdc

-include $(UTILS_PATH)/make_lib/utils_image.mk

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

clean:
	rm Dockerfile

