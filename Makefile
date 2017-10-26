UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := service_erlang
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BASE_IMAGE_NAME := embedded
BASE_IMAGE_TAG := aef2cdde76a52bac839c4b712f97bd1062f7cece

-include $(UTILS_PATH)/make_lib/utils_image.mk

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

clean:
	rm Dockerfile

