require('dotenv').config();
const { sequelize, conectarBD } = require('../config/database');
const { Categoria, Proveedor, Producto, Pedido, User } = require('../models');

async function seedDatabase() {
  try {
    console.log('🌱 Iniciando sembrado de datos para Impresos Bethel...');
    await conectarBD();

    // Sincronizar y limpiar tablas para inserción limpia
    await sequelize.sync({ force: true });
    console.log('🧹 Base de datos reiniciada y esquemas creados.');

    // 1. Categorías
    console.log('📁 Insertando Categorías...');
    const categorias = await Categoria.bulkCreate([
      { id: 1, nombre: 'Bordados', descripcion: 'Bordados computarizados de alta precisión' },
      { id: 2, nombre: 'Talonarios', descripcion: 'Talonarios membretados autorizados por SAR' },
      { id: 3, nombre: 'Sellos', descripcion: 'Sellos automáticos y fechadores' },
      { id: 4, nombre: 'Camisetas', descripcion: 'Prendas personalizadas y uniformes' },
      { id: 5, nombre: 'Estampados', descripcion: 'Sublimación y vinil textil' },
      { id: 6, nombre: 'Stickers', descripcion: 'Etiquetas y calcomanías troqueladas' },
      { id: 7, nombre: 'Útiles escolares', descripcion: 'Librería, papelería y suministros' },
    ]);
    console.log(`✅ ${categorias.length} Categorías insertadas.`);

    // 2. Proveedores
    console.log('🏢 Insertando Proveedores...');
    const proveedores = await Proveedor.bulkCreate([
      {
        id: 1,
        nombreNegocio: 'Textiles & Bordados Cortés',
        descripcion: 'Especialistas en bordados computarizados de alta densidad, gorras, camisas tipo polo y uniformes industriales.',
        telefono: '+504 9876-5432',
        ciudad: 'San Pedro Sula',
        departamento: 'Cortés',
        precioDesde: 180.00,
        calificacion: 4.8,
        totalResenas: 34,
        verificado: true,
        destacado: true,
        disponible: true,
        categoriaId: 1,
        fotoUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500',
      },
      {
        id: 2,
        nombreNegocio: 'Imprenta y Serigrafía La Central',
        descripcion: 'Talonarios fiscales autorizados por el SAR, facturación continua, stickers troquelados y empaques.',
        telefono: '+504 9555-1234',
        ciudad: 'Tegucigalpa',
        departamento: 'Francisco Morazán',
        precioDesde: 120.00,
        calificacion: 4.9,
        totalResenas: 58,
        verificado: true,
        destacado: true,
        disponible: true,
        categoriaId: 2,
        fotoUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500',
      },
      {
        id: 3,
        nombreNegocio: 'Papelería & Suministros Bethel',
        descripcion: 'Materiales escolares y de oficina, papel bond membretado, sellos automáticos y tintas de serigrafía.',
        telefono: '+504 8888-9900',
        ciudad: 'La Ceiba',
        departamento: 'Atlántida',
        precioDesde: 45.00,
        calificacion: 4.6,
        totalResenas: 19,
        verificado: true,
        destacado: false,
        disponible: true,
        categoriaId: 3,
        fotoUrl: 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500',
      },
    ]);
    console.log(`✅ ${proveedores.length} Proveedores insertados.`);

    // 3. Catálogo de Productos
    console.log('📦 Insertando Productos del Catálogo...');
    const productos = await Producto.bulkCreate([
      {
        id: 1,
        nombre: 'Talonario de Facturas',
        categoria: 'Talonarios',
        categoriaId: 2,
        precio: 120.00,
        esPersonalizable: true,
        descripcion: 'Talonario membretado con numeración consecutiva, original y copia autocopiativa. Autorizado según normas fiscales del SAR con logo personalizado.',
        iconoNombre: 'receipt_long',
        tiempoEntrega: '2 días hábiles',
        stockDisponible: 50,
      },
      {
        id: 2,
        nombre: 'Camiseta Polo Bordada',
        categoria: 'Camisetas',
        categoriaId: 4,
        precio: 220.00,
        esPersonalizable: true,
        descripcion: 'Camiseta tipo polo de piqué 100% algodón, bordado de alta precisión en pecho izquierdo y manga. Ideal para uniformes empresariales.',
        iconoNombre: 'checkroom',
        tiempoEntrega: '3 a 4 días hábiles',
        stockDisponible: 30,
      },
      {
        id: 3,
        nombre: 'Camiseta Serigrafiada',
        categoria: 'Camisetas',
        categoriaId: 4,
        precio: 160.00,
        esPersonalizable: true,
        descripcion: 'Camiseta de algodón suave cuello redondo con estampado serigráfico a full color de alta durabilidad y resistencia al lavado.',
        iconoNombre: 'dry_cleaning',
        tiempoEntrega: '2 días hábiles',
        stockDisponible: 45,
      },
      {
        id: 4,
        nombre: 'Estampado en Vinil Textil',
        categoria: 'Estampados',
        categoriaId: 5,
        precio: 95.00,
        esPersonalizable: true,
        descripcion: 'Estampado de diseño tipográfico o vectorial en vinil textil termotransferible con acabado mate o metalizado para prendas oscuras o claras.',
        iconoNombre: 'brush',
        tiempoEntrega: '24 horas',
        stockDisponible: 60,
      },
      {
        id: 5,
        nombre: 'Gorra Bordada Personalizada',
        categoria: 'Bordados',
        categoriaId: 1,
        precio: 140.00,
        esPersonalizable: true,
        descripcion: 'Gorra de 6 paneles estilo camionero o cerrada, con bordado 3D o plano en el frontal. Broche ajustable metálico o de velcro.',
        iconoNombre: 'auto_awesome',
        tiempoEntrega: '3 días hábiles',
        stockDisponible: 35,
      },
      {
        id: 6,
        nombre: 'Stickers Troquelados (Pack 50)',
        categoria: 'Stickers',
        categoriaId: 6,
        precio: 85.00,
        esPersonalizable: true,
        descripcion: 'Pack de 50 stickers en vinil adhesivo con acabado brillante o mate, resistentes al agua y al sol, cortados con la silueta de tu logotipo.',
        iconoNombre: 'local_offer',
        tiempoEntrega: '24 a 48 horas',
        stockDisponible: 100,
      },
      {
        id: 7,
        nombre: 'Sello Automático Autoentintable',
        categoria: 'Sellos',
        categoriaId: 3,
        precio: 195.00,
        esPersonalizable: true,
        descripcion: 'Sello automático de bolsillo o escritorio marca Trodat con almohadilla de tinta azul o negra recargable. Grabado láser de alta nitidez.',
        iconoNombre: 'approval',
        tiempoEntrega: '24 horas',
        stockDisponible: 20,
      },
      {
        id: 8,
        nombre: 'Cuaderno Universitario Espiral',
        categoria: 'Útiles escolares',
        categoriaId: 7,
        precio: 48.00,
        esPersonalizable: false,
        descripcion: 'Cuaderno de 100 hojas cuadrícula 5mm, pasta semirrígida plastificada y doble anillo metálico. Ideal para estudiantes y oficina.',
        iconoNombre: 'menu_book',
        tiempoEntrega: 'Inmediata',
        stockDisponible: 80,
      },
      {
        id: 9,
        nombre: 'Set de Lapiceros Gel (Pack 6)',
        categoria: 'Útiles escolares',
        categoriaId: 7,
        precio: 35.00,
        esPersonalizable: false,
        descripcion: 'Set de 6 bolígrafos de gel 0.7mm de tinta fluida y secado rápido en tonos negro, azul y rojo con grip ergonómico.',
        iconoNombre: 'edit',
        tiempoEntrega: 'Inmediata',
        stockDisponible: 65,
      },
      {
        id: 10,
        nombre: 'Taza de Cerámica Sublimada',
        categoria: 'Estampados',
        categoriaId: 5,
        precio: 110.00,
        esPersonalizable: true,
        descripcion: 'Taza blanca de 11 oz de cerámica de alta calidad con impresión por sublimación panorámica a full color, apta para microondas.',
        iconoNombre: 'coffee',
        tiempoEntrega: '24 a 48 horas',
        stockDisponible: 40,
      },
      {
        id: 11,
        nombre: 'Pendón Publicitario Roll-Up',
        categoria: 'Talonarios',
        categoriaId: 2,
        precio: 650.00,
        esPersonalizable: true,
        descripcion: 'Banner publicitario retráctil de 85x200 cm impreso en lona frontlit de alta resolución con estructura de aluminio y bolso de transporte.',
        iconoNombre: 'view_carousel',
        tiempoEntrega: '2 a 3 días hábiles',
        stockDisponible: 15,
      },
    ]);
    console.log(`✅ ${productos.length} Productos insertados.`);

    // 4. Historial de Pedidos
    console.log('📋 Insertando Historial de Pedidos...');
    const pedidos = await Pedido.bulkCreate([
      {
        codigo: 'BET-1048',
        cliente: 'Distribuidora San José',
        fecha: '16 Ago 2026',
        tipoTrabajo: 'Talonarios',
        descripcion: '5 Talonarios de facturas membretadas SAR con numeración 001-500',
        total: 600.00,
        estado: 'enProceso',
        cantidad: 5,
        iconoNombre: 'receipt_long',
      },
      {
        codigo: 'BET-1047',
        cliente: 'Farmacia El Ahorro',
        fecha: '15 Ago 2026',
        tipoTrabajo: 'Stickers',
        descripcion: '200 Stickers troquelados con laminado brillante para etiquetado',
        total: 340.00,
        estado: 'listo',
        cantidad: 200,
        iconoNombre: 'local_offer',
      },
      {
        codigo: 'BET-1046',
        cliente: 'Academia de Fútbol Los Leones',
        fecha: '14 Ago 2026',
        tipoTrabajo: 'Camisetas',
        descripcion: '18 Camisetas deportivas estampadas con nombre y dorsal',
        total: 2880.00,
        estado: 'enProceso',
        cantidad: 18,
        iconoNombre: 'checkroom',
      },
      {
        codigo: 'BET-1045',
        cliente: 'Bufete Jurídico Méndez',
        fecha: '13 Ago 2026',
        tipoTrabajo: 'Sellos',
        descripcion: '2 Sellos automáticos Trodat para firmas y visto bueno',
        total: 390.00,
        estado: 'entregado',
        cantidad: 2,
        iconoNombre: 'approval',
      },
      {
        codigo: 'BET-1044',
        cliente: 'Cafetería Aroma Real',
        fecha: '11 Ago 2026',
        tipoTrabajo: 'Estampados',
        descripcion: '24 Tazas de cerámica sublimadas con logo e ilustración vintage',
        total: 2640.00,
        estado: 'entregado',
        cantidad: 24,
        iconoNombre: 'coffee',
      },
      {
        codigo: 'BET-1043',
        cliente: 'Constructora del Valle',
        fecha: '09 Ago 2026',
        tipoTrabajo: 'Bordados',
        descripcion: '15 Gorras bordadas con logotipo 3D en hilo color oro',
        total: 2100.00,
        estado: 'entregado',
        cantidad: 15,
        iconoNombre: 'auto_awesome',
      },
      {
        codigo: 'BET-1042',
        cliente: 'Colegio Cristiano Betania',
        fecha: '07 Ago 2026',
        tipoTrabajo: 'Útiles escolares',
        descripcion: '50 Cuadernos universitarios personalizados con portada institucional',
        total: 2400.00,
        estado: 'entregado',
        cantidad: 50,
        iconoNombre: 'menu_book',
      },
      {
        codigo: 'BET-1041',
        cliente: 'Taller Mecánico Rápido',
        fecha: '04 Ago 2026',
        tipoTrabajo: 'Talonarios',
        descripcion: '3 Talonarios de orden de servicio en papel autocopiativo',
        total: 360.00,
        estado: 'entregado',
        cantidad: 3,
        iconoNombre: 'receipt_long',
      },
      {
        codigo: 'BET-1040',
        cliente: 'Restaurante Sabor Criollo',
        fecha: '01 Ago 2026',
        tipoTrabajo: 'Camisetas',
        descripcion: '10 Camisetas polo bordadas para personal de meseros',
        total: 2200.00,
        estado: 'entregado',
        cantidad: 10,
        iconoNombre: 'checkroom',
      },
      {
        codigo: 'BET-1039',
        cliente: 'Librería y Papelería Éxito',
        fecha: '28 Jul 2026',
        tipoTrabajo: 'Útiles escolares',
        descripcion: '30 Sets de lapiceros y marcadores para inventario',
        total: 1050.00,
        estado: 'entregado',
        cantidad: 30,
        iconoNombre: 'edit',
      },
      {
        codigo: 'BET-1038',
        cliente: 'Gimnasio FitZone',
        fecha: '25 Jul 2026',
        tipoTrabajo: 'Estampados',
        descripcion: '35 Camisetas de licra estampadas con vinil reflectivo',
        total: 3325.00,
        estado: 'entregado',
        cantidad: 35,
        iconoNombre: 'brush',
      },
      {
        codigo: 'BET-1037',
        cliente: 'Inmobiliaria Los Pinos',
        fecha: '20 Jul 2026',
        tipoTrabajo: 'Talonarios',
        descripcion: '2 Roll-Ups publicitarios de 85x200cm con estructura de aluminio',
        total: 1300.00,
        estado: 'entregado',
        cantidad: 2,
        iconoNombre: 'view_carousel',
      },
    ]);
    console.log(`✅ ${pedidos.length} Pedidos de historial insertados.`);

    // 5. Usuarios iniciales
    console.log('👤 Insertando Usuarios...');
    await User.create({
      nombre: 'Yerson Alvarenga',
      email: 'yerson@bethel.hn',
      password: 'password123',
      rol: 'cliente',
    });

    await User.create({
      nombre: 'Administrador Bethel',
      email: 'admin@bethel.hn',
      password: 'admin123',
      rol: 'administrador',
    });
    console.log('✅ Usuarios de prueba creados (yerson@bethel.hn y admin@bethel.hn).');

    console.log('🎉 ¡Datos sembrados con éxito! El backend está 100% listo.');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error al sembrar la base de datos:', error);
    process.exit(1);
  }
}

seedDatabase();
