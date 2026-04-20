# Dockerización de Leadchain

Esta carpeta contiene la configuración Docker para los dos proyectos:
- `Leadchain-backend` (Laravel + PHP 8.2)
- `Leadchain-frontend` (React + TypeScript + Vite)
- PostgreSQL 15.3 + PostGIS 3.3

> Los Dockerfiles clonan directamente los repositorios de GitHub `main`, por lo que no es necesario descargar los proyectos localmente.

## Qué se ha creado

- `docker-compose.yml`
- `Dockerfile.backend`
- `Dockerfile.frontend`
- `nginx.conf`
- `.env` con credenciales locales

## Puertos

- Backend: `http://localhost:8000`
- Frontend: `http://localhost:5173`
- PostgreSQL: `localhost:5432`

## Cómo arrancar

Desde la carpeta `docker`:

```bash
docker compose up --build
```

## Base de datos

Se usa Postgres 15.3.

Los valores actuales son:

- Base de datos: `LeadchainDB`
- Usuario: `root`
- Contraseña: `root`

> Modifica estos valores en `docker/.env` cuando quieras cambiar credenciales o nombre.

## Migraciones y seeders

Al iniciar el backend Docker:

- se ejecuta `php artisan migrate --force`
- se ejecuta `php artisan db:seed --force --class=DatabaseSeeder` sólo si no hay usuarios en la base de datos

Esto significa que se cargan los seeders registrados en `DatabaseSeeder.php`, incluyendo `EstadoVisitaSeeder` y `UserSeeder`.

## JWT y claves

El backend Docker también genera automáticamente:

- `APP_KEY` con `php artisan key:generate`
- `JWT_SECRET` con `php artisan jwt:secret`

Así no tienes que hacerlo manualmente.

> Si prefieres agrupar los seeders en un solo comando, puedes crear un seeder maestro (por ejemplo `DatabaseSeeder` o `InitialDataSeeder`) que invoque `EstadoVisitaSeeder` y `UserSeeder`.

## Notas

- El frontend se construye en modo producción usando `vite build` directamente dentro del contenedor y se sirve con `nginx`.
- El backend usa `php artisan serve --host=0.0.0.0 --port=8000` para que esté accesible desde el host.
- En el frontend se usa `VITE_API_BASE_URL=http://192.168.1.40:8000` para apuntar al backend desde el navegador en la red local.

> Si accedes desde otro dispositivo, usa la IP de tu PC (`192.168.1.40` en tu caso) en lugar de `localhost`.

## Para cambiar el backend a producción real

Si más adelante quieres un stack más robusto, puedes cambiar `Dockerfile.backend` a `php-fpm` + `nginx` en lugar de `php artisan serve`.
"# Leadchain" 
