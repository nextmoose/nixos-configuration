#!/bin/sh

(cat <<EOF
#!/bin/sh

${@} &&
  true
EOF
) &&
    true
