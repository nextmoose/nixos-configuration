#!/bin/sh

cd $(mktemp -d) &&
  (cat > hello.txt <<
Hello World!!!
EOF
  ) &&
  true
