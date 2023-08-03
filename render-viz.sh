#!/bin/bash

# Generates Gource video (h.264) from multiple repositories.
# Pass the repositories in command line arguments.
# Example: ./this.sh /path/to/repo1 /path/to/repo2

# Setup
outfile="gource.mp4"
combined_log="./combined.log"

# Gource visualization parameters
gource_args=(
  --title "MetaMask Development History"
  --seconds-per-day 0.03
  --auto-skip-seconds 0.05
  # --stop-at-end
  # --highlight-users
  # --user-scale 1.5
  # --user-friction 1
  --default-user-image "./icon-fox.png"
  --hide mouse,progress,dirnames,filenames,bloom
  --highlight-dirs
  # --dir-name-depth 1
  --file-idle-time 0
  --max-files 0
  --file-filter ".*node_modules.*"
  --background-colour 000000
  --font-size 18
  --date-format "%b %d, %Y"
  --multi-sampling
  --viewport 1920x1080
  --output-ppm-stream -
  --output-framerate 30
  ${START_DATE+--start-date "$START_DATE"}
  ${END_DATE+--stop-date "$END_DATE"}
)

# Generate Gource video
echo "Generating Gource video..."
time gource "${gource_args[@]}" "$combined_log" > gource.ppm

# ffmpeg conversion parameters
ffmpeg_args=(
  -y
  -r 60
  -f image2pipe
  -vcodec ppm
  -i gource.ppm
  -vcodec libx264
  -preset ultrafast
  -crf 1
  -threads 2
  -bf 0
  "$outfile"
)

# Convert to mp4
echo "Converting to mp4..."
ffmpeg "${ffmpeg_args[@]}"

# Cleanup
echo "Cleaning up..."
rm gource.ppm
echo "Done."
