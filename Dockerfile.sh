#!/bin/bash
cat <<EOF
FROM ${BASE_IMAGE}
MAINTAINER Grigory Antsiferov <g.antsiferov@rbkmoney.com>
LABEL com.rbkmoney.${SERVICE_NAME}.parent=${BASE_IMAGE_NAME}  \
    com.rbkmoney.${SERVICE_NAME}.parent_digest="${BASE_IMAGE_DIGEST}"  \
    com.rbkmoney.${SERVICE_NAME}.branch=${BRANCH}  \
    com.rbkmoney.${SERVICE_NAME}.commit_id=${COMMIT}  \
    com.rbkmoney.${SERVICE_NAME}.commit_number=`git rev-list --count HEAD`
EOF

