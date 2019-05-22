#!/bin/sh

cat <<EOF
${@} && true
EOF
) &&
true
