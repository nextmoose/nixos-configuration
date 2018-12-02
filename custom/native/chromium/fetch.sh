#!/bin/sh

cd $(mktemp -d) &&
  (cat > hello.txt <<EOF
Hello World!!!
EOF
  ) &&
  true
