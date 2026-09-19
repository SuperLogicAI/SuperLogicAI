#!/bin/sh
# Rebuild AI.gif = AI-base.gif (1920x680, no text) + tagline.svg burned onto the bottom.
# Edit tagline.svg, run this, bump the ?v= in README.md, push.
# ponytail: the tagline is baked into the GIF because two stacked images on GitHub
# always leave a few px of line-box gap and the sanitizer strips the CSS that fixes it.
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

"$CHROME" --headless --disable-gpu --allow-file-access-from-files --hide-scrollbars \
  --default-background-color=000000ff --window-size=1920,180 \
  --screenshot=/tmp/tagline.png "file://$PWD/tagline.svg"

ffmpeg -y -i AI-base.gif -i /tmp/tagline.png -filter_complex \
  "[0:v]pad=1920:860:0:0:black[bg];[bg][1:v]overlay=0:680[v];[v]split[a][b];\
   [a]palettegen=stats_mode=full[p];[b][p]paletteuse=dither=sierra2_4a" \
  -loop 0 AI.gif

echo "AI.gif rebuilt: $(ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0 AI.gif)"
