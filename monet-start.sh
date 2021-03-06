#!/bin/bash

install_pkgs() {
  local IFS=,
  local WORD_LIST=($1)
  for word in "${WORD_LIST[@]}"; do
    apt-get install -y $word
  done
}

set -eo pipefail

if [[ -z "${MONET_DBFARM}" ]]; then
  MONET_DBFARM=/var/lib/monetdb/dbfarm
fi

if [[ -z "${MONET_DATABASE}" ]]; then
  echo "MONET_DATABASE not specified, exiting"
  exit 1
fi

echo "Installing additional packages..."
install_pkgs ${ADDITIONAL_PKGS}

# Print server stats
mserver5 --version

if [[ ! -d ${MONET_DBFARM} ]]; then
  # Setup Monet database
  echo "Initialising MonetDB farm in ${MONET_DBFARM}, and creating database: ${MONET_DATABASE}"
  monetdbd create ${MONET_DBFARM}
  monetdbd set listenaddr=0.0.0.0 ${MONET_DBFARM}
  monetdbd set exittimeout=5 ${MONET_DBFARM}
  monetdbd start ${MONET_DBFARM}

  if [[ -z "${MONETDB_PASSWORD}" ]]; then
    monetdb create ${MONET_DATABASE}
    monetdb release ${MONET_DATABASE}
  else
    monetdb create -p ${MONETDB_PASSWORD} ${MONET_DATABASE}
  fi

  monetdb set embedpy3=yes ${MONET_DATABASE}

  monetdbd stop ${MONET_DBFARM}
  chown -R monetdb:monetdb ${MONET_DBFARM}
fi


echo "Starting MonetDB server farm at ${MONET_DBFARM}..."
exec monetdbd start -n ${MONET_DBFARM}