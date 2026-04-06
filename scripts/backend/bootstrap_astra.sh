#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

DB_HOST="127.0.0.1"
DB_PORT="3408"
DB_NAME="astra"
DB_USER="astra"
DB_PASSWORD="@Sharingan06200"
DB_PREFIX="astra_"

wait_for_db() {
  local retries=60
  until docker exec astra-db mariadb-admin ping -h 127.0.0.1 -u"${DB_USER}" -p"${DB_PASSWORD}" --silent >/dev/null 2>&1; do
    retries=$((retries - 1))
    if [ "$retries" -le 0 ]; then
      echo "Base Astra indisponible."
      return 1
    fi
    sleep 2
  done
}

install_schema() {
  docker exec -i astra-db mariadb -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" <<SQL
$(sed \
  -e "s/%PREFIX%/${DB_PREFIX}/g" \
  -e "s/%VERSION%/1.8.9/g" \
  -e "s/%REVISION%/9/g" \
  -e "s/%DB_VERSION%/9/g" \
  install/install.sql)
SQL
}

system_table_exists() {
  docker exec astra-db mariadb -N -B -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" -e "SHOW TABLES LIKE '${DB_PREFIX}system';" | grep -q "${DB_PREFIX}system"
}

main() {
  wait_for_db

  if ! system_table_exists; then
    install_schema
  fi

  docker exec astra-web php /var/www/html/scripts/backend/provision_admin.php
}

main "$@"
