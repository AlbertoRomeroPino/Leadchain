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

<h3 align="center">Tecnologías Núcleo (Core Stack)</h3>

<div align="center">
  <img src="https://skillicons.dev/icons?i=react,laravel&theme=dark" height="65" />
</div>

<h3 align="center">Ecosistema de Desarrollo e Infraestructura</h3>

<div align="center">
  <!-- Stack de Soporte y Herramientas -->
  <img src="https://skillicons.dev/icons?i=ts,js,html,css,php,postgres,docker,github,postman,markdown&theme=dark" height="45" />
</div>

<h3 align="center"> Conectividad y Exposición </h3>

<p align="center">
  <a href="https://ngrok.com/">
    <img alt="Ngrok" src="https://img.shields.io/badge/Ngrok-1F1F1F?style=for-the-badge&logo=ngrok&logoColor=white">
  </a>
</p>

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

<h3 align="center">1.2. Configuración de Exposición Pública (Ngrok)</h3>

Este servicio permite probar la aplicación desde dispositivos móviles o fuera de tu red local.

> Acción requerida: Para evitar que el contenedor de Ngrok se reinicie constantemente por error de autenticación, debes elegir una de estas dos opciones antes de ejecutar docker-compose up:

#### **Opción A**: Configurar el Token (Recomendado)

Consigue tu token en dashboard.ngrok.com y añádelo al archivo .env:

```bash
# Deja esta variable vacía para habilitar rutas relativas
VITE_API_BASE_URL=

# Tu token de Ngrok
NGROK_AUTHTOKEN=tu_token_aqui
```

#### Opción B: Desactivar el servicio

Si no necesitas acceso externo, **comenta** las líneas del servicio en `docker-compose.yml` para que Docker ignore este contenedor:

```bash
# ngrok:
#    image: ngrok/ngrok:latest
#    container_name: leadchain_tunnel
#    restart: unless-stopped
#    command:
#      - "http"
#      - "frontend:80" # Apunta directamente al contenedor frontend en su puerto interno
#    environment:
#      NGROK_AUTHTOKEN: "${NGROK_AUTHTOKEN}"
#    ports:
#      - "4040:4040" # Expone el panel de control web de Ngrok en tu PC local
#    depends_on:
#      - frontend
#    networks:
#      - Leadchain
```

<h3 align="center">2. Orquestación y Construcción de los Servicios</h3>

Una vez configurado el entorno, se procede a la inicialización de los microservicios definidos en el manifiesto `docker-compose.yml`. Este proceso automatiza la compilación de imágenes personalizadas, la creación de redes internas y la adquisición de dependencias:

```bash
docker-compose up -d --build
```

### 3. Exposición Pública y Pruebas en Dispositivos (Ngrok)

El ecosistema de Leadchain incluye un contenedor de **Ngrok** completamente automatizado. Esto permite generar un túnel seguro con certificado SSL (`https`) que apunta directamente a tu entorno de desarrollo local.

Cualquier persona pueden probar desde sus propios teléfonos móviles o portátiles, podrá interactuar con la aplicación en tiempo real sin importar en qué red estén conectados.

#### Cómo Obtener la URL Pública de tu Entorno:

Una vez levantados los contenedores (`docker compose up -d`), puedes recuperar la URL:

Abre tu navegador en la máquina local y accede a [http://localhost:4040](https://www.google.com/search?q=http://localhost:4040&authuser=1). Encontrarás un panel web de Ngrok con la URL activa y un inspector de peticiones HTTP en tiempo real.

<h2 align="center"> Especificaciones Técnicas del Ecosistema </h2>

<h3 align="center">Matriz de Versiones de Infraestructura</h3>

| Servicio                        | Nombre del Contenedor  | Componente Tecnológico                        | Versión de Referencia              |
| ------------------------------- | ---------------------- | ---------------------------------------------- | ----------------------------------- |
| **Base de Datos**         | `leadchainDB`        | PostGIS (PostgreSQL + GIS)                     | `15-3.3`                          |
| **Servicios de Backend**  | `leadchain_Api`      | PHP + Apache                                   | `8.2-apache`                      |
| **Interfaz de Usuario**   | `leadchain_frontend` | Node.js (Compilación) / Nginx (Distribución) | `Node 20`/`Nginx stable-alpine` |
| **Túnel de Exposición** | `leadchain_tunnel`   | Ngrok Agent (Túnel HTTPS seguro)              | `latest`                          |

<h2 align="center">Puntos Clave del Diseño</h2>

Esta infraestructura ha sido diseñada bajo principios de **resiliencia, seguridad y eficiencia**. A continuación, se detallan los pilares del ecosistema:

* **Automatización Total:** Mediante el script `entrypoint.sh`, el sistema gestiona de forma autónoma la limpieza de caché, la ejecución de migraciones de base de datos y la carga de *seeders* (datos iniciales) en cada arranque.
* **Red Privada Segura:** Los microservicios operan dentro de una red aislada denominada `Leadchain`. Solo los servicios estrictamente necesarios exponen puertos al exterior, manteniendo la base de datos protegida de accesos externos no autorizados.
* **Persistencia Garantizada:** El uso de volúmenes gestionados (`postgres_data`) asegura que la información de la base de datos sea persistente, sobreviviendo incluso a la eliminación o actualización de los contenedores.
* **Optimización Frontend:** La aplicación se sirve a través de un servidor **Nginx** de alto rendimiento, configurado para entregar contenido estático de forma optimizada y rápida.
* **Seguridad de Credenciales:** El sistema aplica una política de "cero fugas", ignorando automáticamente archivos sensibles como el `.env` para prevenir la exposición de claves en repositorios públicos.
* **Exposición y Pruebas Multidispositivo No-Invasivas:** Gracias a la integración nativa de Ngrok en la orquestación, el ecosistema puede exponerse a internet bajo demanda con un único comando. Esto elimina la necesidad de desplegar el proyecto en un servidor en la nube de pago durante la fase de validación y permite realizar auditorías o pruebas de usabilidad móvil de forma inmediata.

---

<h2 align="center" id="autor">Autor</h2>

**Alberto Romero Pino**

- **Email**: albertoromeropino2004@gmail.com
- **LinkedIn**: [linkedin.com/in/alberto-romero-pino-8aa0a32ba](https://linkedin.com/in/alberto-romero-pino-8aa0a32ba)
- **GitHub:** [@AlbertoRomeroPino](https://github.com/AlbertoRomeroPino)

<hr>
<p align="center">
  <b>Trabajo de Fin de Grado</b> | <i>Grado en Desarrollo de Aplicaciones Web</i><br>
  I.E.S.Francisco de los Rios - Curso 2025/2026<br>
  <i>El código fuente expuesto forma parte de los entregables técnicos para la defensa del proyecto.</i>
</p>
