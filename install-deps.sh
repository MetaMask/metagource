# downloads all repos and creates a gource viz of all of them together

set -e
set -x
set -u

# install deps
npm install -g concurrently
