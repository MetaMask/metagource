# downloads all repos and creates a gource viz of all of them together

set -e
set -x
set -u

# clear previous install
rm -rf ./repos

# install deps
./install-deps.sh

# download repos
./download-repos.sh

# gource
START_DATE="2021-01-01" END_DATE="2021-07-01" ./gource.sh
