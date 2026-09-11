# 🖨️ Backend API REST - Impresos Bethel

Backend profesional desarrollado en **Node.js**, **Express** y **Sequelize** para la aplicación móvil **OrderTracker / Impresos Bethel** (Flutter).

---

## 🚀 Inicio Rápido

### 1. Requisitos
- **Node.js** v18 o superior instalado (`node -v`).
- (Opcional) **XAMPP** si deseas usar MySQL, o puedes usar **SQLite** (incluido por defecto, sin instalar nada más).

### 2. Instalación de Dependencias
```bash
npm install
```

### 3. Sembrar Datos Iniciales (Seed)
Puebla la base de datos con las categorías, proveedores de prueba, los 11 productos del catálogo y los 12 pedidos de historial de Impresos Bethel:
```bash
npm run seed
```

### 4. Iniciar el Servidor
```bash
# Modo Desarrollo con recarga automática:
npm run dev

# Modo Producción:
npm start
```
El servidor arrancará por defecto en el puerto **3000**:
- **Local:** `http://localhost:3000`
- **Prefijo API:** `http://localhost:3000/api`

---

## 📱 Conexión con la App Flutter (`order_tracker`)

En tu archivo [api_config.dart](file:///C:/Users/amand/OneDrive/Documentos/Proyecto%20Progra/order_tracker/lib/config/api_config.dart) del frontend, ajusta el dominio según la plataforma en la que ejecutas la app:

| Plataforma Flutter | Dominio en `api_config.dart` |
|---|---|
| **Emulador Android** | `http://10.0.2.2:3000` *(Por defecto)* |
| **Windows / Chrome / Web** | `http://localhost:3000` |
| **Celular Físico (Wi-Fi)** | `http://192.168.X.X:3000` *(Tu IP local obtenida con `ipconfig`)* |

---

## 🗄️ Configuración de Base de Datos (`.env`)

En el archivo `.env`:

### Opción A: SQLite (Recomendado para pruebas inmediatas, sin XAMPP)
```env
PORT=3000
NODE_ENV=development
DB_DIALECT=sqlite
DB_STORAGE=./src/config/database.sqlite
```

### Opción B: MySQL con XAMPP
1. Abre el **XAMPP Control Panel** y haz clic en **Start** en el módulo **MySQL**.
2. Configura tu `.env`:
```env
PORT=3000
NODE_ENV=development
DB_DIALECT=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=impresos_bethel
DB_USER=root
DB_PASSWORD=
```
3. Ejecuta `npm run seed` para poblar MySQL.

---

## 🌐 Endpoints de la API

### 🏢 Proveedores (`/api/proveedores`)
- `GET /api/proveedores` — Lista de proveedores con categoría anidada (`Categoria`), compatible con `Proveedor.fromJson` de Flutter.
  - Filtros query opcionales: `?destacado=true`, `?verificado=true`, `?search=bordados`, `?categoriaId=1`.
- `GET /api/proveedores/:id` — Detalle de un proveedor.
- `POST /api/proveedores` — Crear nuevo proveedor.
- `PUT /api/proveedores/:id` — Actualizar datos de proveedor.
- `DELETE /api/proveedores/:id` — Eliminar proveedor.

### 📁 Categorías (`/api/categorias`)
- `GET /api/categorias` — Listado de categorías (Talonarios, Camisetas, Estampados, Bordados, Stickers, Sellos, Útiles escolares).
- `GET /api/categorias/:id` — Detalle con proveedores y productos asociados.
- `POST /api/categorias` — Registrar nueva categoría.

### 📦 Catálogo de Productos (`/api/productos`)
- `GET /api/productos` — Listado de productos de Impresos Bethel.
  - Filtros: `?categoria=Camisetas`, `?search=taza`, `?esPersonalizable=true`.
- `GET /api/productos/:id` — Detalle del producto.
- `POST /api/productos` — Crear nuevo producto.
- `PUT /api/productos/:id` — Actualizar producto.
- `DELETE /api/productos/:id` — Eliminar producto.

### 📋 Pedidos y Seguimiento (`/api/pedidos`)
- `GET /api/pedidos` — Historial de pedidos completo.
  - Filtros: `?estado=enProceso`, `?estado=listo`, `?cliente=Farmacia`.
- `GET /api/pedidos/:codigo` — Detalle de un pedido por código (ej. `BET-1048`) o por ID.
- `POST /api/pedidos` — Crear nuevo pedido desde el carrito de la app (autogenera código `BET-XXXX`).
- `PATCH /api/pedidos/:codigo/estado` — Actualizar estado (`pendiente`, `enProceso`, `listo`, `entregado`, `cancelado`).

### 🔐 Autenticación (`/api/auth`)
- `POST /api/auth/register` — Registro de nuevo cliente (`nombre`, `email`, `password`).
- `POST /api/auth/login` — Inicio de sesión con JWT token (`email`, `password`).
- `GET /api/auth/profile` — Obtener perfil del usuario autenticado (Header `Authorization: Bearer <token>`).

### 🩺 Estado del Servidor
- `GET /api/health` — Verificación de salud y conexión a la base de datos.
- `GET /` — Documentación JSON interactiva de bienvenida.

---

## 📂 Estructura del Proyecto

```
fixit-backend/
├── package.json
├── .env
├── .env.example
├── .gitignore
├── README.md
└── src/
    ├── app.js                 # Express, CORS, Morgan y Rutas
    ├── server.js              # Arranque del servidor HTTP
    ├── config/
    │   └── database.js        # Conexión Sequelize (MySQL / SQLite)
    ├── models/                # Modelos de base de datos
    │   ├── index.js
    │   ├── categoria.model.js
    │   ├── proveedor.model.js
    │   ├── producto.model.js
    │   ├── pedido.model.js
    │   └── user.model.js
    ├── controllers/           # Lógica de negocio
    │   ├── proveedor.controller.js
    │   ├── categoria.controller.js
    │   ├── producto.controller.js
    │   ├── pedido.controller.js
    │   └── auth.controller.js
    ├── routes/                # Definición de rutas REST
    │   ├── index.js
    │   ├── proveedor.routes.js
    │   ├── categoria.routes.js
    │   ├── producto.routes.js
    │   ├── pedido.routes.js
    │   └── auth.routes.js
    ├── middlewares/           # Errores y protección JWT
    │   ├── auth.middleware.js
    │   └── errorHandler.js
    └── seeders/
        └── seed.js            # Poblador inicial de datos
```
