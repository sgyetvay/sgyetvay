#!/bin/bash

# Get the directory of the script
DIR="$(cd "$(dirname "$0")" && pwd)"
OUTFILE="$DIR/index.html"

# Write header
cat > "$OUTFILE" <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>ECO8000 Files</title>
</head>
<body>
  <h1>ECO8000 Course Files</h1>
  <ul>
EOF

# Loop over files (alphabetical, ignore index.html and hidden files)
for f in $(ls -1 "$DIR" | sort); do
  if [[ "$f" != "index.html" && "$f" != .* && "$f" != "make_index.sh" && "$f" != "make_index.app" ]]; then
    echo "    <li><a href=\"$f\">$f</a></li>" >> "$OUTFILE"
  fi
done

# Write footer
cat >> "$OUTFILE" <<EOF
  </ul>
</body>
</html>
EOF

echo "index.html regenerated."
