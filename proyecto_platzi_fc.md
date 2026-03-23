# Plan del Proyecto Web para Platzi FC

## Introducción
Este documento detalla la arquitectura y el plan de desarrollo del sitio web para **Platzi FC**, un club profesional de fútbol, implementado bajo la metodología Jamstack.

## Arquitectura General del Proyecto
- **Tipo de Arquitectura**: Aplicación web moderna **Jamstack** con un frontend estático (o SSR) que consume un backend diseñado API-first.
- **Patrón**:
  - **Frontend**: SPA o aplicación multi-página con generación estática para SEO y rendimiento.
  - **Backend**: API RESTful o GraphQL.
- **Hosting**:
  - **Frontend**: En CDN (Netlify, Vercel, Cloudflare Pages).
  - **Backend**: En contenedores (Docker + Kubernetes o PaaS).

## Tecnologías Sugeridas
- **Frontend**: React + TypeScript (Next.js o Remix).
- **Backend**: Node.js (NestJS) o Python (Django/DRF) con PostgreSQL.
- **Backend Secundario**: CMS (Strapi, Contentful o Sanity) y API personalizada.
- **Integraciones Externas**: API deportiva y pasarela de pago (Stripe, Mercado Pago).

## Separación por Capas
### Backend (Capas Lógicas)
1. **Domain**: Entidades y reglas de negocio.
2. **Application**: Casos de uso.
3. **Persistence**: Repositorios y acceso a DB.
4. **API / Presentation**: Controladores y validación.
5. **Integration**: Servicios para APIs externas.

### Frontend (Capas Lógicas)
1. **UI / Components**: Componentes visuales.
2. **Layouts**: Estructura de páginas.
3. **Pages**: Definición de rutas.
4. **Data / Services**: Llamadas a la API.

## Estructura de Carpetas

### Estructura Raíz del Proyecto
platzi-fc/ ├── apps/ │   ├── frontend/ │   └── backend/ ├── libs/ ├── scripts/ ├── docs/ └── infra/


### Frontend: Estructura de Carpetas

frontend/ ├── public/ ├── src/ │   ├── layouts/ │   ├── pages/ │   ├── components/ │   ├── hooks/ │   ├── services/ │   ├── styles/ │   ├── i18n/ │   └── utils/ ├── next.config.js └── .env.local


### Backend: Estructura de Carpetas (NestJS)

backend/ ├── src/ │   ├── app.module.ts │   ├── main.ts │   ├── modules/ │   ├── shared/ │   └── config/ ├── migrations/ ├── tests/ └── .env


## Módulos / Secciones Principales y sus Componentes Clave
1. **Inicio**: Hero banner, resultados, noticias.
2. **Noticias**: Listado y detalle de noticias.
3. **Jugadores**: Listado, filtros y perfil de jugadores.
4. **Calendario de Partidos**: Visualización del calendario.
5. **Resultados**: Historial de partidos y estadísticas.
6. **Tienda**: Listado de productos y checkout.
7. **Historia del Club**: Línea de tiempo y biografía.
8. **Multimedia**: Galería de fotos y videos.
9. **Contacto**: Formulario y datos de contacto.

## Modelo Básico de Datos
### Entidades Principales
- **Team / Club**: `id`, `name`, `shortName`, `crestUrl`.
- **Player**: `id`, `name`, `shirtNumber`, `position`, `dateOfBirth`.

## Conclusión
Esta estructura proporciona una base sólida para el desarrollo del sitio web de Platzi FC, asegurando modularidad, reutilización y facilidad de mantenimiento.