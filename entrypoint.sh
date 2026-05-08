#!/bin/bash
set -e

echo "====================================================================="
echo "🚀 INICIANDO CONFIGURACIÓN DE INFRAESTRUCTURA (LEADCHAIN BACKEND)"
echo "====================================================================="

# ---------------------------------------------------------------------
# 1. Preparar el archivo de configuración (.env)
# ---------------------------------------------------------------------
if [ ! -s .env ]; then
    echo "⚠️ .env no encontrado o vacío. Copiando plantilla .env.example..."
    cp .env.example .env
fi

# Convertir saltos de línea de Windows (CRLF) a Linux (LF) en el archivo físico
sed -i 's/\r$//' .env


# ---------------------------------------------------------------------
# 2. Generar Llaves de Seguridad de forma infalible usando PHP nativo
# ---------------------------------------------------------------------
echo "🔒 Verificando llaves criptográficas..."
php -r '
    $envFile = ".env";
    $env = file_get_contents($envFile);
    
    // Normalizar saltos de línea en memoria para evitar fallos de regex
    $env = str_replace("\r\n", "\n", $env);

    // 2.1. Generar APP_KEY si no está establecida o es inválida
    if (!preg_match("/^APP_KEY=base64:[a-zA-Z0-9+\/]+={0,2}/m", $env)) {
        $key = "base64:" . base64_encode(random_bytes(32));
        if (preg_match("/^APP_KEY=/m", $env)) {
            $env = preg_replace("/^APP_KEY=.*/m", "APP_KEY=" . $key, $env);
        } else {
            $env .= "\nAPP_KEY=" . $key . "\n";
        }
        echo "   ✅ APP_KEY generada y guardada con éxito.\n";
    } else {
        echo "   ℹ️ APP_KEY ya existente y válida.\n";
    }

    // 2.2. Generar JWT_SECRET si está vacío o no existe
    if (preg_match("/^JWT_SECRET=\s*$/m", $env) || !preg_match("/^JWT_SECRET=/m", $env)) {
        $secret = base64_encode(random_bytes(32));
        if (preg_match("/^JWT_SECRET=/m", $env)) {
            $env = preg_replace("/^JWT_SECRET=.*/m", "JWT_SECRET=" . $secret, $env);
        } else {
            $env .= "\nJWT_SECRET=" . $secret . "\n";
        }
        echo "   ✅ JWT_SECRET generada y guardada con éxito.\n";
    } else {
        echo "   ℹ️ JWT_SECRET ya existente y válida.\n";
    }

    file_put_contents($envFile, trim($env) . "\n");
'


# ---------------------------------------------------------------------
# 3. Limpieza y Optimización de Caché de Laravel
# ---------------------------------------------------------------------
echo "🧹 Limpiando configuraciones y cachés obsoletas..."
# Reducimos las líneas individuales borrando de golpe todos los archivos .php de caché
rm -f bootstrap/cache/*.php

echo "⚙️ Optimizando configuración para producción..."
php artisan config:cache
php artisan route:cache
php artisan view:cache


# ---------------------------------------------------------------------
# 4. Base de Datos: Migraciones y Carga de Datos (Seeders)
# ---------------------------------------------------------------------
echo "🗄️ Ejecutando migraciones de Base de Datos..."
php artisan migrate --force

if [ -n "$SEEDER_CLASS" ]; then
    echo "🌱 Ejecutando seeder configurado: $SEEDER_CLASS..."
    php artisan db:seed --class="$SEEDER_CLASS" --force
fi


# ---------------------------------------------------------------------
# 5. Lanzamiento del Servidor Web
# ---------------------------------------------------------------------
echo "====================================================================="
echo "🟢 ECOCONEXIÓN COMPLETADA. INICIANDO APACHE..."
echo "====================================================================="

exec "$@"