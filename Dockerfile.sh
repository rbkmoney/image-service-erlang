#!/bin/bash
cat <<EOF
FROM ${REGISTRY}/${ORG_NAME}/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}
MAINTAINER Anton Belyaev <a.belyaev@rbkmoney.com>
LABEL com.rbkmoney.${SERVICE_NAME}.parent=${BASE_IMAGE_NAME}  \
    com.rbkmoney.${SERVICE_NAME}.parent_tag=${BASE_IMAGE_TAG}  \
    com.rbkmoney.${SERVICE_NAME}.branch=${BRANCH}  \
    com.rbkmoney.${SERVICE_NAME}.commit_id=${COMMIT}  \
    com.rbkmoney.${SERVICE_NAME}.commit_number=`git rev-list --count HEAD`
EOF

