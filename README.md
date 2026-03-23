# Platzi FC - Official Website

[![Next.js](https://img.shields.io/badge/Next.js-16.2.1-black?logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-blue?logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4-06B6D4?logo=tailwindcss)](https://tailwindcss.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?logo=supabase)](https://supabase.com/)

Sitio web oficial de **Platzi FC**, un club profesional de fútbol, construido con arquitectura Jamstack moderna.

## 🚀 Stack Tecnológico

### **Frontend**
- **Framework**: Next.js 15 con App Router
- **Lenguaje**: TypeScript
- **Estilos**: Tailwind CSS + shadcn/ui
- **Estado**: React Query/TanStack
- **Build**: Vite/Turbopack

### **Backend**
- **Base de Datos**: PostgreSQL (Supabase)
- **API**: RESTful con Supabase
- **Autenticación**: Supabase Auth
- **Real-time**: Supabase Realtime

### **Infraestructura**
- **Hosting**: Vercel (Frontend)
- **Database**: Supabase Cloud
- **Monorepo**: PNPM Workspaces
- **CI/CD**: GitHub Actions

## 📁 Estructura del Proyecto

```
platzi-fc/
├── apps/
│   ├── frontend/          # Next.js application
│   └── backend/           # NestJS API (próximamente)
├── libs/                  # Componentes compartidos
├── docs/                  # Documentación
├── infra/                 # Docker y configs
├── database-schema.sql    # Schema PostgreSQL
├── plan-windsurf.md       # Plan de desarrollo
└── README.md              # Este archivo
```

## 🛠️ Instalación y Configuración

### **Prerrequisitos**
- Node.js >= 18.0.0
- PNPM >= 8.0.0
- Cuenta de Supabase

### **1. Clonar el Repositorio**
```bash
git clone <repository-url>
cd platzi-fc
```

### **2. Instalar Dependencias**
```bash
pnpm install
```

### **3. Configurar Variables de Entorno**
```bash
cp .env.example apps/frontend/.env.local
```

Edita `apps/frontend/.env.local` con tus credenciales de Supabase:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-publishable-key
NEXT_PUBLIC_API_URL=http://localhost:3001
```

### **4. Ejecutar en Modo Desarrollo**
```bash
# Frontend
pnpm run dev:frontend

# Backend (cuando esté disponible)
pnpm run dev:backend

# Ambos simultáneamente
pnpm run dev
```

### **5. Acceder a la Aplicación**
- Frontend: http://localhost:3000
- API Docs: http://localhost:3001/docs (cuando esté disponible)

## 🗄️ Base de Datos

### **Configuración de Supabase**
1. Crea un nuevo proyecto en [Supabase](https://supabase.com)
2. Ejecuta el schema desde `database-schema.sql`
3. Habilita RLS (Row Level Security)
4. Configura las políticas de acceso

### **Tablas Principales**
- **teams**: Información de equipos
- **players**: Datos de jugadores
- **matches**: Partidos y resultados
- **news**: Noticias y artículos
- **products**: Tienda y productos
- **competitions**: Ligas y torneos

### **Datos de Ejemplo**
El proyecto incluye datos de prueba para demostración:
- 4 equipos
- 4 jugadores por equipo
- Partidos programados y finalizados
- Noticias y productos de ejemplo

## 🌐 Secciones del Sitio Web

### **1. Inicio** (`/`)
- Hero section con llamadas a la acción
- Últimos resultados de partidos
- Noticias recientes
- Productos destacados

### **2. Equipos** (`/teams`)
- Listado de todos los equipos
- Detalles de cada equipo
- Estadísticas y roster

### **3. Jugadores** (`/players`)
- Plantilla completa
- Perfiles individuales
- Estadísticas por jugador

### **4. Partidos** (`/matches`)
- Calendario de partidos
- Próximos encuentros
- Resultados históricos

### **5. Noticias** (`/news`)
- Artículos y noticias
- Categorías y tags
- Búsqueda de contenido

### **6. Tienda** (`/shop`)
- Catálogo de productos
- Detalles de artículos
- Carrito de compras

### **7. Historia** (`/history`)
- Línea temporal del club
- Hitos importantes
- Galería histórica

### **8. Multimedia** (`/multimedia`)
- Galería de fotos
- Videos y highlights
- Contenido visual

### **9. Contacto** (`/contact`)
- Formulario de contacto
- Información del club
- Redes sociales

## 🎨 Componentes y Diseño

### **Sistema de Diseño**
- **Colores**: Azul y blanco (colores del club)
- **Tipografía**: Geist Sans (Next.js)
- **Layout**: Responsive y mobile-first
- **Componentes**: shadcn/ui + personalizados

### **Componentes Reutilizables**
- `Navigation`: Navegación principal
- `MatchCard`: Tarjeta de partidos
- `NewsCard`: Tarjeta de noticias
- `ProductCard`: Tarjeta de productos
- `HeroSection`: Secciones hero

## 🧪 Testing

### **Unit Tests**
```bash
pnpm run test
```

### **E2E Tests**
```bash
pnpm run test:e2e
```

### **Linting**
```bash
pnpm run lint
```

## 📦 Build y Deploy

### **Build para Producción**
```bash
pnpm run build
```

### **Deploy en Vercel**
```bash
# Instalar Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

### **Variables de Entorno en Producción**
Configura las mismas variables en Vercel:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## 🔧 Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `pnpm run dev` | Iniciar frontend y backend |
| `pnpm run dev:frontend` | Iniciar solo frontend |
| `pnpm run dev:backend` | Iniciar solo backend |
| `pnpm run build` | Build de todas las apps |
| `pnpm run test` | Ejecutar tests |
| `pnpm run lint` | Linting del código |
| `pnpm run format` | Formatear con Prettier |

## 🚀 Roadmap de Desarrollo

### **Fase 1: Foundation ✅**
- [x] Monorepo setup
- [x] Next.js frontend
- [x] Supabase integration
- [x] Basic UI components

### **Fase 2: API Development 🔄**
- [x] Database schema
- [x] Supabase services
- [ ] NestJS backend
- [ ] API documentation

### **Fase 3: Content Management ⏳**
- [ ] Sanity CMS integration
- [ ] Content schemas
- [ ] Admin interface

### **Fase 4: Advanced Features ⏳**
- [ ] E-commerce completo
- [ ] User authentication
- [ ] Real-time updates
- [ ] Mobile app

## 🤝 Contribución

1. Fork el proyecto
2. Crea una feature branch (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la branch (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Proyecto**: Platzi FC
- **Email**: contact@platzi-fc.com
- **Website**: https://platzi-fc.com

## 🙏 Agradecimientos

- [Next.js](https://nextjs.org/) - Framework React
- [Supabase](https://supabase.com/) - Backend as a Service
- [Tailwind CSS](https://tailwindcss.com/) - CSS Framework
- [Vercel](https://vercel.com/) - Hosting Platform
- [Platzi](https://platzi.com/) - Educación y comunidad

---

**Built with ❤️ for Platzi FC**
