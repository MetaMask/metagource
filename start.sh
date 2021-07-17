# downloads all repos and creates a gource viz of all of them together

set -e
set -x
set -u

# install deps
npm install -g concurrently

# # download repos
# mkdir -p ./repos
# cd ./repos
# concurrently \
#   "git clone git@github.com:MetaMask/metamask-extension.git" \
#   "git clone git@github.com:MetaMask/metamask-mobile.git" \
#   "git clone git@github.com:MetaMask/metamask-docs.git" \
#   "git clone git@github.com:MetaMask/KeyringController.git" \
#   "git clone git@github.com:MetaMask/eth-sig-util.git" \
#   "git clone git@github.com:MetaMask/eth-json-rpc-middleware.git"
# cd ..

# gource
START_DATE="2021-01-01" END_DATE="2021-07-01" \
./gource.sh \
  ./repos/metamask-extension \
  ./repos/metamask-mobile \
  ./repos/metamask-docs \
  ./repos/KeyringController \
  ./repos/eth-sig-util \
  ./repos/eth-json-rpc-middleware