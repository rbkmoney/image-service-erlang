SERVICE_NAME := service-erlang
BASE_IMAGE_NAME := library/erlang
BASE_IMAGE_DIGEST := sha256:634696cd804eff98f552bd9f9cca526eec20f08244804da370e0fada04df8c23

UTILS_PATH := build_utils

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
-include $(UTILS_PATH)/make_lib/utils_repo.mk


SUBMODULES := $(UTILS_PATH)
SUBTARGETS := $(patsubst %,%/.git,$(SUBMODULES))

$(SUBTARGETS):
	$(eval SSH_PRIVKEY := $(shell echo $(GITHUB_PRIVKEY) | sed -e 's|%|%%|g'))
	GIT_SSH_COMMAND="$(shell which ssh) -o StrictHostKeyChecking=no -o User=git `[ -n '$(SSH_PRIVKEY)' ] && echo -o IdentityFile='$(SSH_PRIVKEY)'`" \
	git submodule update --init $(basename $@)
	touch $@

submodules: $(SUBTARGETS)

Dockerfile: Dockerfile.sh
	REGISTRY=$(REGISTRY) ORG_NAME=$(ORG_NAME) \
	BASE_IMAGE_NAME=$(BASE_IMAGE_NAME) BASE_IMAGE_DIGEST=$(BASE_IMAGE_DIGEST) \
	BASE_IMAGE="$(BASE_IMAGE_NAME)@$(BASE_IMAGE_DIGEST)" \
	COMMIT=$(COMMIT) BRANCH=$(BRANCH) \
	./Dockerfile.sh > Dockerfile

.image-tag: Dockerfile
	docker build -t "$(SERVICE_IMAGE_NAME):$(COMMIT)" .
	echo $(COMMIT) > $@

push:
	if [ -f .image-tag ]; then $(DOCKER) push "$(SERVICE_IMAGE_NAME):`cat .image-tag`"; \
	else echo "No .image-tag file. Build the image first"; exit 1; fi

clean:
	if [ -f .image-tag ]; then $(DOCKER) rmi -f "$(SERVICE_IMAGE_NAME):`cat .image-tag`"; fi
	rm -f .image-tag Dockerfile
