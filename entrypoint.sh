#!/bin/bash
set -e

echo "Optimizando configuración para producción..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Ejecutando migraciones..."
# El flag --force es obligatorio en entornos de producción
php artisan migrate --force

# Validar si existe la variable SEEDER_CLASS en el entorno
if [ -n "$SEEDER_CLASS" ]; then
    echo "Ejecutando seeder: $SEEDER_CLASS..."
    php artisan db:seed --class="$SEEDER_CLASS" --force
fi

echo "Iniciando servidor web..."
# Ejecutar el comando principal (Apache)
exec "$@"