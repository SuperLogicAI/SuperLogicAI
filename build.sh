#!/bin/sh
# Rebuild AI.gif = AI-base.gif (1920x680, no text) + tagline.png burned onto the bottom.
# tagline.png is the top 200px of the brand animation frame, so the type matches the GIF.
#
# Swap tagline.png, run this, push, WAIT for raw.githubusercontent to serve the new
# bytes (~30s-2min), THEN bump the ?v= in README.md and push again. Bumping in the
# same push races the CDN: GitHub caches the stale file under the new URL and you
# have to bump a second time. Check with:
#   curl -s "https://raw.githubusercontent.com/SuperLogicAI/SuperLogicAI/main/AI.gif?cb=$RANDOM" | head -c 16 | xxd
# ponytail: the tagline is baked into the GIF because two stacked images on GitHub
# always leave a few px of line-box gap and the sanitizer strips the CSS that fixes it.
set -e
cd "$(dirname "$0")"

ffmpeg -y -i AI-base.gif -i tagline.png -filter_complex \
  "[0:v]pad=1920:880:0:0:black[bg];[bg][1:v]overlay=0:680[v];[v]split[a][b];\
   [a]palettegen=stats_mode=full[p];[b][p]paletteuse=dither=sierra2_4a" \
  -loop 0 AI.gif

echo "AI.gif rebuilt: $(ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0 AI.gif)"
