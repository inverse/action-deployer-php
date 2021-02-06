#!/bin/bash

set -e

if [[ -n "$REF" && -n "$SUBSTRING" ]]; then
  REF=${REF/$SUBSTRING/}
  echo "REF: $REF"
fi

if [ -z "$1" ]; then
    CMD_ARGS=""
else 
    CMD_ARGS="$@"
fi

if [[ $DEPLOYER_VERSION != $DEFAULT_DEPLOYER_VERSION ]]; then
  echo "Overwriting the default version of ${DEFAULT_DEPLOYER_VERSION} to ${DEPLOYER_VERSION}"
  curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/deployer /
  && chmod +x /usr/local/bin/deployer
fi

mkdir -p /github/home/.ssh

eval $(ssh-agent -s)

echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "$SSH_PRIVATE_KEY" | tr -d '\r' > /tmp/id_rsa
chmod 600 /tmp/id_rsa
ssh-add /tmp/id_rsa

deployer --version
deployer $CMD_ARGS
