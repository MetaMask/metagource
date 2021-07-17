# downloads all repos and creates a gource viz of all of them together

set -e
set -x
set -u

# download repos
mkdir -p ./repos
cd ./repos
concurrently \
  "git clone git@github.com:MetaMask/metamask-extension.git" \
  "git clone git@github.com:MetaMask/metamask-mobile.git" \
  "git clone git@github.com:MetaMask/metamask-docs.git" \
  "git clone git@github.com:MetaMask/KeyringController.git" \
  "git clone git@github.com:MetaMask/eth-sig-util.git" \
  "git clone git@github.com:MetaMask/eth-json-rpc-middleware.git"
cd ..
