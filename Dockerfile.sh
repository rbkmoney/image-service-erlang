#!/bin/bash
cat <<EOF
FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8

MAINTAINER Grigory Antsiferov <g.antsiferov@rbkmoney.com>
LABEL com.rbkmoney.${SERVICE_NAME}.parent=${BASE_IMAGE_NAME}  \
    com.rbkmoney.${SERVICE_NAME}.parent_tag="${BASE_IMAGE_TAG}"  \
    com.rbkmoney.${SERVICE_NAME}.branch=${BRANCH}  \
    com.rbkmoney.${SERVICE_NAME}.commit_id=${COMMIT}  \
    com.rbkmoney.${SERVICE_NAME}.commit_number=`git rev-list --count HEAD`

ADD erlang.cfg /tmp

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends  curl equivs \
    && cd /tmp \
    && equivs-build erlang.cfg \
    && dpkg -i erlang*.deb \
    && apt-get purge -y --auto-remove equivs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/erlang.cfg /tmp/erlang*.deb
    && echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

CMD ["bash"]
EOF

