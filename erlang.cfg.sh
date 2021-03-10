#!/bin/bash
cat <<EOF
Section: interpreters
Priority: optional
Standards-Version: 3.9.2

Package: erlang
Version: ${ERLANG_VERSION}
Maintainer: rbk.money <dev@rbk.money>
Description: Meta package for Erlang
 This is virtual package used for monitoring vulnerabilities.
EOF