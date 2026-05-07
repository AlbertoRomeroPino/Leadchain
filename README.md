<h1 align="center">
  <a href="https://github.com/AlbertoRomeroPino/Leadchain">Leadchain Docker</a>
</h1>

<h3 align="center">Orquestación de Microservicios: Automatización de Infraestructura y Librerías</h3>

<p align="center">
  <a href="https://github.com/AlbertoRomeroPino/Leadchain">
    <img alt="Docker" src="https://img.shields.io/badge/Repositorio-Docker_Orquestador-blue?style=for-the-badge&logo=github&logoColor=white">
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

<br />

<div align="center">
  <img src="https://skillicons.dev/icons?i=react,laravel&theme=dark" height="65" />
</div>

<br />

<div align="center">
  <!-- Stack de Soporte y Herramientas -->
  <img src="https://skillicons.dev/icons?i=ts,js,html,css,php,postgres,docker,github,postman,markdown&theme=dark" height="45" />
</div>

---

<h1 align="center">Protocolo de Despliegue y Configuración: Ecosistema Leadchain</h1>

<p align="center">
  <em>Guía técnica para la orquestación y puesta en marcha del entorno Leadchain.</em>
</p>

---

Este documento detalla el procedimiento técnico para desplegar el ecosistema de **Leadchain** mediante la orquestación de contenedores.

> ⚠️ **Importante:**
> Es indispensable seguir las fases descritas en este manual paso a paso. De esto depende la correcta configuración del entorno y la integridad de los protocolos de seguridad del sistema.

---

<h2 align="center">Metodología de Implementación</h2>

<h3 align="center">1. Inicialización del Entorno (`.env`)</h3>

La etapa preliminar consiste en la preparación de las variables de entorno locales. Es imperativo derivar el archivo de configuración activo a partir de la plantilla preexistente para asegurar la compatibilidad de los parámetros iniciales y la correcta interconexión de los servicios.

> ⚠️ **Importante:**
> El archivo `.env` es el núcleo de la configuración de seguridad. Antes de avanzar, asegúrate de que los valores de conexión coincidan con tu entorno local.

**Ejecuta el siguiente comando en la raíz del proyecto:**

```bash
cp .env.example .env
```

<h3 align="center">1.1 Configuración de Saltos de Línea en Git (Windows)</h3>

Esta configuración es crítica para evitar errores de ejecución en scripts de Bash dentro de Docker.

<h4 align="center">Verificación Previa</h4>

Ejecuta el siguiente comando en una terminal **Git Bash** para comprobar el formato actual del archivo:

```bash
file entrypoint.sh
```

**Si ves esto, estás bien ✅ (puedes saltarte esta sección):**

```
entrypoint.sh: Bourne-Again shell script, Unicode text, UTF-8 text executable
```

**Si ves esto, necesitas continuar ❌:**

```
entrypoint.sh: Bourne-Again shell script, Unicode text, UTF-8 text executable, with CRLF line terminators
```

### Configuración Específica para Windows

> **Acción Requerida:** Si utilizas Windows, ejecuta el siguiente comando **antes de clonar** el repositorio. Esto evita que Git convierta automáticamente los saltos de línea de **LF (Linux)** a **CRLF (Windows)**.

```bash
git config --global core.autocrlf false
```

<h4 align="center">Solución Post-Clonación (Si ya clonaste el repo)</h4>

Si ya descargaste el proyecto sin la configuración previa, el archivo `entrypoint.sh` probablemente tenga el formato incorrecto. Puedes repararlo manualmente desde **Git Bash** con los siguientes comandos:

```bash
# 1. Verificar el formato actual
file entrypoint.sh

# 2. Convertir de CRLF a LF (Elimina los retornos de carro)
sed -i 's/\r$//' entrypoint.sh

# 3. Confirmar la corrección
file entrypoint.sh
```

<h3 align="center">2. Orquestación y Construcción de los Servicios</h3>

Una vez configurado el entorno, se procede a la inicialización de los microservicios definidos en el manifiesto `docker-compose.yml`. Este proceso automatiza la compilación de imágenes personalizadas, la creación de redes internas y la adquisición de dependencias:

```bash
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
docker compose down -v && docker compose up -d
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

Esta infraestructura ha sido diseñada bajo principios de **resiliencia, seguridad y eficiencia**. A continuación, se detallan los pilares del ecosistema:

* **Automatización Total:** Mediante el script `entrypoint.sh`, el sistema gestiona de forma autónoma la limpieza de caché, la ejecución de migraciones de base de datos y la carga de *seeders* (datos iniciales) en cada arranque.
* **Red Privada Segura:** Los microservicios operan dentro de una red aislada denominada `Leadchain`. Solo los servicios estrictamente necesarios exponen puertos al exterior, manteniendo la base de datos protegida de accesos externos no autorizados.
* **Persistencia Garantizada:** El uso de volúmenes gestionados (`postgres_data`) asegura que la información de la base de datos sea persistente, sobreviviendo incluso a la eliminación o actualización de los contenedores.
* **Optimización Frontend:** La aplicación se sirve a través de un servidor **Nginx** de alto rendimiento, configurado para entregar contenido estático de forma optimizada y rápida.
* **Seguridad de Credenciales:** El sistema aplica una política de "cero fugas", ignorando automáticamente archivos sensibles como el `.env` para prevenir la exposición de claves en repositorios públicos.

---

<h2 align="center" id="autor">Autor</h2>

- **Alberto Romero Pino**
- **Email**: albertoromeropino2004@gmail.com
- **LinkedIn**: [linkedin.com/in/alberto-romero-pino-8aa0a32ba](https://linkedin.com/in/alberto-romero-pino-8aa0a32ba)

<hr>
<p align="center">
  <b>Trabajo de Fin de Grado</b> | <i>Grado en Desarrollo de Aplicaciones Web</i><br>
  I.E.S.Francisco de los Rios - Curso 2025/2026<br>
  <i>El código fuente expuesto forma parte de los entregables técnicos para la defensa del proyecto.</i>
</p>
