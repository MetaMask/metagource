#!/usr/bin/env bash
# modified from https://gist.github.com/EricReiche/3621855

set -e
set -u
set -o pipefail

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

combined_log="./combined.log"
cat ${logs[@]} | sort -n > $combined_log
rm ${logs[@]}

echo "$combined_log"