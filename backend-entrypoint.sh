#!/bin/sh
set -e

cd /var/www/html

if [ ! -f .env ]; then
  cp .env.example .env
fi

for key in DB_HOST DB_DATABASE DB_USERNAME DB_PASSWORD; do
  eval "value=\"\$$key\""
  if [ -n "$value" ]; then
    if grep -q "^${key}=" .env; then
      sed -i "s#^${key}=.*#${key}=${value}#" .env
    else
      printf '%s=%s\n' "$key" "$value" >> .env
    fi
  fi
done

if grep -q '^APP_KEY=' .env; then
  if [ -z "$(grep '^APP_KEY=' .env | cut -d'=' -f2-)" ]; then
    php artisan key:generate --force
  fi
else
  php artisan key:generate --force
fi

if ! grep -q '^JWT_SECRET=' .env; then
  php artisan jwt:secret --force
fi

echo "Sincronizando backend desde GitHub..."
if [ -d .git ]; then
  git -c safe.directory=/var/www/html fetch --all --prune
  git -c safe.directory=/var/www/html reset --hard "origin/${BACKEND_BRANCH:-main}"
fi

composer install --no-interaction --prefer-dist --optimize-autoloader --no-progress
composer dump-autoload -o
php artisan config:clear >/dev/null 2>&1 || true
php artisan cache:clear >/dev/null 2>&1 || true

export PGPASSWORD="${DB_PASSWORD}"
tries=0
until psql -h "${DB_HOST}" -U "${DB_USERNAME}" -d "${DB_DATABASE}" -c '\q' 2>/dev/null; do
  tries=$((tries+1))
  if [ "$tries" -gt 20 ]; then
    echo "No se pudo conectar a la base de datos después de 20 intentos."
    exit 1
  fi
  echo "Esperando la base de datos... intento ${tries}/20"
  sleep 2
done

echo "Base de datos disponible. Ejecutando migraciones..."
php artisan migrate --force

user_count=$(psql -h "${DB_HOST}" -U "${DB_USERNAME}" -d "${DB_DATABASE}" -tAc "SELECT count(*) FROM users;")
user_count="$(echo "$user_count" | tr -d '[:space:]')"
if [ "${user_count}" = "0" ]; then
  echo "Tabla users vacía. Ejecutando ProduccionSeeder..."
  php artisan db:seed --force --class=ProduccionSeeder
else
  echo "Ya existen usuarios en la base de datos (${user_count}). No se siembra de nuevo."
fi

exec "$@"
