<h1 align="center">
  <a href="#">Leadchain Docker</a>
</h1>

<h3 align="center">Automatización de instalación de dependencias y librerias con docker.</h3>

<h3 align="center"> Repositorios </h3>

<p align="center">
  <a href="https://github.com/AlbertoRomeroPino/Leadchain.git">
    <img alt="Docker" src="https://img.shields.io/badge/Repositorio-Docker-blue?style=for-the-badge&logo=github&logoColor=white">
  </a>
</p>

<p align="center">
  <a href="https://github.com/AlbertoRomeroPino/Leadchain-frontend">
    <img alt="Frontend Repo" src="https://img.shields.io/badge/Frontend-Repo-red?style=for-the-badge&logo=github&logoColor=white">
  </a>
  <a href="https://github.com/AlbertoRomeroPino/Leadchain-backend">
    <img alt="Backend API Repo" src="https://img.shields.io/badge/Backend-API%20Repo-black?style=for-the-badge&logo=github&logoColor=white">
  </a>
</p>

<h1 align="center"> Protocolo de Despliegue y Configuración: Ecosistema Leadchain </h1>

Este documento técnico describe de manera exhaustiva el procedimiento necesario para la puesta en marcha del entorno de Leadchain mediante la orquestación de contenedores. Se requiere el cumplimiento riguroso de las fases descritas para garantizar la integridad de los protocolos de seguridad.

<h2 align="center">Metodología de Implementación y Configuración de Seguridad </h2>

<h3 align="center">1. Inicialización del Archivo de Configuración Entorno (.env)</h3>

La etapa preliminar consiste en la preparación de las variables de entorno locales. Es imperativo derivar el archivo de configuración activo a partir de la plantilla preexistente para asegurar la compatibilidad de los parámetros iniciales:

```
cp .env.example .env
```

<h3 align="center">2. Orquestación y Construcción de los Servicios</h3>

Se procede a la inicialización de los microservicios definidos en el manifiesto `docker-compose.yml`. Este proceso automatiza la compilación de imágenes y la adquisición de dependencias desde los repositorios de origen:

```
docker-compose up -d --build
```

<h3 align="center">3. Generación de la Clave Criptográfica de la Aplicación (APP_KEY)</h3>

Se debe ejecutar el siguiente comando con el fin de instanciar una clave única para el marco de trabajo Laravel. Dicha clave constituye la base del sistema de cifrado de la aplicación:

```
docker-compose exec backend php artisan key:generate --show
```

**Procedimiento Obligatorio:** Se requiere la extracción manual de la cadena alfanumérica (prefijada por `base64:`) para su posterior inserción en el parámetro `APP_KEY` dentro del archivo `.env`.

<h3 align="center">4. Configuración del Secreto de Autenticación (`JWT_SECRET`)</h3>

Para el establecimiento de sesiones seguras mediante JSON Web Tokens, es necesaria la generación de un secreto criptográfico adicional:

```
docker-compose exec backend php artisan jwt:secret
```

**Procedimiento Obligatorio:** Tras la ejecución, se obtendrá un mensaje de confirmación. Se debe registrar exclusivamente el código contenido dentro de los corchetes `[]` y asignar dicho valor a la variable `JWT_SECRET` en el archivo de configuración `.env`.

<h3 align="center"> 5. Persistencia de Modificaciones </h3>

Es fundamental asegurar la correcta grabación de los cambios en el archivo `.env`. Se recomienda verificar la ausencia de caracteres residuales o espacios en blanco al final de cada línea para prevenir errores de interpretación por parte del sistema.

<h3 align="center"> 6. Reinicialización del Servicio de Aplicación </h3>

Para garantizar que el servidor Apache procese las nuevas variables de entorno de forma efectiva, se debe realizar un reinicio controlado del contenedor encargado del backend:

```
docker-compose restart backend
```

<h3 align="center"> 7. Depuración y Optimización del Caché de Sistema </h3>

Como fase final, se debe ejecutar una limpieza integral de los registros de optimización. Este paso asegura que el entorno de ejecución ignore configuraciones obsoletas y adopte los nuevos parámetros de seguridad:

```
docker-compose exec backend php artisan optimize:clear
```

<h2 align="center"> Especificaciones Técnicas del Ecosistema </h2>

<h3 align="center">Matriz de Versiones de Infraestructura</h3>

| Servicio                       | Nombre del Contenedor  | Componente Tecnológico                        | Versión de Referencia              |
| ------------------------------ | ---------------------- | ---------------------------------------------- | ----------------------------------- |
| **Base de Datos**        | `leadchainDB`        | PostGIS (PostgreSQL + GIS)                     | `15-3.3`                          |
| **Servicios de Backend** | `leadchain_Api`      | PHP + Apache                                   | `8.2-apache`                      |
| **Interfaz de Usuario**  | `leadchain_frontend` | Node.js (Compilación) / Nginx (Distribución) | `Node 20`/`Nginx stable-alpine` |

<h2 align="center">Puntos Clave del Diseño</h2>

* **Automatización Total:** El script `entrypoint.sh` configura automáticamente el caché, las migraciones de base de datos y la carga de datos iniciales al arrancar.
* **Red Privada Segura:** Los servicios se comunican internamente mediante la red `Leadchain`. Solo se exponen los puertos imprescindibles, protegiendo la base de datos del exterior.
* **Datos Siempre a Salvo:** Gracias al volumen `postgres_data`, toda tu información permanece intacta aunque detengas o elimines los contenedores.
* **Rendimiento Frontend:** La aplicación web se compila y sirve mediante un servidor **Nginx** optimizado, garantizando una respuesta inmediata.
* **Protección de Claves:** El sistema ignora automáticamente el archivo `.env` en el control de versiones para evitar cualquier filtración de contraseñas.
