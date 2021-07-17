#!/usr/bin/env bash
# modified from https://gist.github.com/EricReiche/3621855

set -e
set -x
set -u
set -o pipefail

# Generates gource video (h.264) out of multiple repositories.
# Pass the repositories in command line arguments.
# Example:
# <this.sh> /path/to/repo1 /path/to/repo2
outfile="gource.mp4"

i=0
for repo in ./repos/*; do
	# 1. Generate a Gource custom log files for each repo. This can be facilitated by the --output-custom-log FILE option of Gource as of 0.29:
	logfile="$(mktemp /tmp/gource.XXXXXX)"
	gource --output-custom-log "${logfile}" ${repo}
	# 2. If you want each repo to appear on a separate branch instead of merged onto each other (which might also look interesting), you can use a 'sed' regular expression to add an extra parent directory to the path of the files in each project:
  # using gnu sed on mac, on linux "sed" should work
	# gsed -i -E "s#(.+)\|#\1|/${repo}#" ${logfile}
	sed -i -E "s#(.+)\|#\1|/${repo}#" ${logfile}
	logs[$i]=$logfile
	let i=$i+1
done

combined_log="$(mktemp /tmp/gource.XXXXXX)"
cat ${logs[@]} | sort -n > $combined_log
rm ${logs[@]}


# echo "Committers:"
# cat $combined_log | awk -F\| {'print  $2'} | sort | uniq
# echo "======================"

time gource $combined_log \
	--stop-at-end \
  --seconds-per-day .25 \
  --user-scale 1.5 \
  --viewport 1280x720 \
  --auto-skip-seconds .05 \
  --multi-sampling \
  --highlight-users \
  --hide mouse,progress,filenames,bloom \
  --dir-name-depth 2 \
  --file-idle-time 0 \
  --max-files 0  \
  --background-colour 000000 \
  --font-size 18 \
  --date-format "%b %d, %Y" \
  --user-friction 0.1 \
  --title "MetaMask Development History" \
  ${START_DATE+ --start-date "$START_DATE"} \
  ${END_DATE+ --stop-date "$END_DATE"} \
  -o gource.ppm

  # --default-user-image "./images/icon-512.png" \
  # --output-ppm-stream - \
  # --output-framerate 30 \
	

# convert to mp4
ffmpeg -y -r 60 -f image2pipe -vcodec libx264 -i gource.ppm -vcodec libx264 -preset ultrafast -crf 1 -threads 2 -bf 0 gource.mp4 
# ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i gource.ppm -vcodec libx264 -preset ultrafast -crf 1 -threads 2 -bf 0 gource.mp4 
# ffmpeg -i gource.mp4 -s 960x540 -ps 100000000 -vcodec libx264 output.mp4

# cleanup
rm $combined_log
rm /tmp/gource.*