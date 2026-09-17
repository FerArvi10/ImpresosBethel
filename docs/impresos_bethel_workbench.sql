-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: impresos_bethel
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `impresos_bethel`
--

/*!40000 DROP DATABASE IF EXISTS `impresos_bethel`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `impresos_bethel` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `impresos_bethel`;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Bordados','Bordados computarizados de alta precisión','2026-09-17 03:06:10','2026-09-17 03:06:10'),(2,'Talonarios','Talonarios membretados autorizados por SAR','2026-09-17 03:06:10','2026-09-17 03:06:10'),(3,'Sellos','Sellos automáticos y fechadores','2026-09-17 03:06:10','2026-09-17 03:06:10'),(4,'Camisetas','Prendas personalizadas y uniformes','2026-09-17 03:06:10','2026-09-17 03:06:10'),(5,'Estampados','Sublimación y vinil textil','2026-09-17 03:06:10','2026-09-17 03:06:10'),(6,'Stickers','Etiquetas y calcomanías troqueladas','2026-09-17 03:06:10','2026-09-17 03:06:10'),(7,'Útiles escolares','Librería, papelería y suministros','2026-09-17 03:06:10','2026-09-17 03:06:10');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `cliente` varchar(150) NOT NULL,
  `clienteEmail` varchar(120) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `fecha` varchar(50) NOT NULL,
  `tipoTrabajo` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','enProceso','listo','entregado','cancelado') DEFAULT 'pendiente',
  `cantidad` int(11) DEFAULT 1,
  `iconoNombre` varchar(50) DEFAULT 'receipt_long',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`items`)),
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `usuarioId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `usuarioId` (`usuarioId`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`usuarioId`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'BET-1048','Distribuidora San José',NULL,NULL,'16 Ago 2026','Talonarios','5 Talonarios de facturas membretadas SAR con numeración 001-500',600.00,'enProceso',5,'receipt_long',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(2,'BET-1047','Farmacia El Ahorro',NULL,NULL,'15 Ago 2026','Stickers','200 Stickers troquelados con laminado brillante para etiquetado',340.00,'listo',200,'local_offer',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(3,'BET-1046','Academia de Fútbol Los Leones',NULL,NULL,'14 Ago 2026','Camisetas','18 Camisetas deportivas estampadas con nombre y dorsal',2880.00,'enProceso',18,'checkroom',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(4,'BET-1045','Bufete Jurídico Méndez',NULL,NULL,'13 Ago 2026','Sellos','2 Sellos automáticos Trodat para firmas y visto bueno',390.00,'entregado',2,'approval',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(5,'BET-1044','Cafetería Aroma Real',NULL,NULL,'11 Ago 2026','Estampados','24 Tazas de cerámica sublimadas con logo e ilustración vintage',2640.00,'entregado',24,'coffee',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(6,'BET-1043','Constructora del Valle',NULL,NULL,'09 Ago 2026','Bordados','15 Gorras bordadas con logotipo 3D en hilo color oro',2100.00,'entregado',15,'auto_awesome',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(7,'BET-1042','Colegio Cristiano Betania',NULL,NULL,'07 Ago 2026','Útiles escolares','50 Cuadernos universitarios personalizados con portada institucional',2400.00,'entregado',50,'menu_book',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(8,'BET-1041','Taller Mecánico Rápido',NULL,NULL,'04 Ago 2026','Talonarios','3 Talonarios de orden de servicio en papel autocopiativo',360.00,'entregado',3,'receipt_long',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(9,'BET-1040','Restaurante Sabor Criollo',NULL,NULL,'01 Ago 2026','Camisetas','10 Camisetas polo bordadas para personal de meseros',2200.00,'entregado',10,'checkroom',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(10,'BET-1039','Librería y Papelería Éxito',NULL,NULL,'28 Jul 2026','Útiles escolares','30 Sets de lapiceros y marcadores para inventario',1050.00,'entregado',30,'edit',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(11,'BET-1038','Gimnasio FitZone',NULL,NULL,'25 Jul 2026','Estampados','35 Camisetas de licra estampadas con vinil reflectivo',3325.00,'entregado',35,'brush',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL),(12,'BET-1037','Inmobiliaria Los Pinos',NULL,NULL,'20 Jul 2026','Talonarios','2 Roll-Ups publicitarios de 85x200cm con estructura de aluminio',1300.00,'entregado',2,'view_carousel',NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10',NULL);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `categoria` varchar(100) NOT NULL,
  `categoriaId` int(11) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `esPersonalizable` tinyint(1) DEFAULT 0,
  `descripcion` text DEFAULT NULL,
  `iconoNombre` varchar(50) DEFAULT 'receipt_long',
  `tiempoEntrega` varchar(100) DEFAULT '2 a 3 días hábiles',
  `stockDisponible` int(11) DEFAULT 25,
  `imagenUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `categoriaId` (`categoriaId`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoriaId`) REFERENCES `categorias` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Talonario de Facturas','Talonarios',2,120.00,1,'Talonario membretado con numeración consecutiva, original y copia autocopiativa. Autorizado según normas fiscales del SAR con logo personalizado.','receipt_long','2 días hábiles',50,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(2,'Camiseta Polo Bordada','Camisetas',4,220.00,1,'Camiseta tipo polo de piqué 100% algodón, bordado de alta precisión en pecho izquierdo y manga. Ideal para uniformes empresariales.','checkroom','3 a 4 días hábiles',30,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(3,'Camiseta Serigrafiada','Camisetas',4,160.00,1,'Camiseta de algodón suave cuello redondo con estampado serigráfico a full color de alta durabilidad y resistencia al lavado.','dry_cleaning','2 días hábiles',45,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(4,'Estampado en Vinil Textil','Estampados',5,95.00,1,'Estampado de diseño tipográfico o vectorial en vinil textil termotransferible con acabado mate o metalizado para prendas oscuras o claras.','brush','24 horas',60,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(5,'Gorra Bordada Personalizada','Bordados',1,140.00,1,'Gorra de 6 paneles estilo camionero o cerrada, con bordado 3D o plano en el frontal. Broche ajustable metálico o de velcro.','auto_awesome','3 días hábiles',35,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(6,'Stickers Troquelados (Pack 50)','Stickers',6,85.00,1,'Pack de 50 stickers en vinil adhesivo con acabado brillante o mate, resistentes al agua y al sol, cortados con la silueta de tu logotipo.','local_offer','24 a 48 horas',100,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(7,'Sello Automático Autoentintable','Sellos',3,195.00,1,'Sello automático de bolsillo o escritorio marca Trodat con almohadilla de tinta azul o negra recargable. Grabado láser de alta nitidez.','approval','24 horas',20,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(8,'Cuaderno Universitario Espiral','Útiles escolares',7,48.00,0,'Cuaderno de 100 hojas cuadrícula 5mm, pasta semirrígida plastificada y doble anillo metálico. Ideal para estudiantes y oficina.','menu_book','Inmediata',80,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(9,'Set de Lapiceros Gel (Pack 6)','Útiles escolares',7,35.00,0,'Set de 6 bolígrafos de gel 0.7mm de tinta fluida y secado rápido en tonos negro, azul y rojo con grip ergonómico.','edit','Inmediata',65,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(10,'Taza de Cerámica Sublimada','Estampados',5,110.00,1,'Taza blanca de 11 oz de cerámica de alta calidad con impresión por sublimación panorámica a full color, apta para microondas.','coffee','24 a 48 horas',40,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(11,'Pendón Publicitario Roll-Up','Talonarios',2,650.00,1,'Banner publicitario retráctil de 85x200 cm impreso en lona frontlit de alta resolución con estructura de aluminio y bolso de transporte.','view_carousel','2 a 3 días hábiles',15,NULL,'2026-09-17 03:06:10','2026-09-17 03:06:10');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombreNegocio` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `departamento` varchar(100) DEFAULT NULL,
  `precioDesde` decimal(10,2) DEFAULT NULL,
  `calificacion` decimal(3,1) DEFAULT 5.0,
  `totalResenas` int(11) DEFAULT 0,
  `verificado` tinyint(1) DEFAULT 0,
  `destacado` tinyint(1) DEFAULT 0,
  `disponible` tinyint(1) DEFAULT 1,
  `fotoUrl` varchar(255) DEFAULT NULL,
  `categoriaId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `categoriaId` (`categoriaId`),
  CONSTRAINT `proveedores_ibfk_1` FOREIGN KEY (`categoriaId`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Textiles & Bordados Cortés','Especialistas en bordados computarizados de alta densidad, gorras, camisas tipo polo y uniformes industriales.','+504 9876-5432','San Pedro Sula','Cortés',180.00,4.8,34,1,1,1,'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500',1,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(2,'Imprenta y Serigrafía La Central','Talonarios fiscales autorizados por el SAR, facturación continua, stickers troquelados y empaques.','+504 9555-1234','Tegucigalpa','Francisco Morazán',120.00,4.9,58,1,1,1,'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500',2,'2026-09-17 03:06:10','2026-09-17 03:06:10'),(3,'Papelería & Suministros Bethel','Materiales escolares y de oficina, papel bond membretado, sellos automáticos y tintas de serigrafía.','+504 8888-9900','La Ceiba','Atlántida',45.00,4.6,19,1,0,1,'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500',3,'2026-09-17 03:06:10','2026-09-17 03:06:10');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `apellido` varchar(120) DEFAULT '',
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('cliente','administrador','proveedor') DEFAULT 'cliente',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Yerson Alvarenga','','yerson@bethel.hn','$2a$10$xh8tpzbvdyNRmanSUSbCJOpixp8li18nGl6mCnTsmJZW1k3z0VcUG','cliente','2026-09-17 03:06:10','2026-09-17 03:06:10'),(2,'Administrador Bethel','','admin@bethel.hn','$2a$10$8PuEfYh2Qq6ZyTB2PqSsGuZKie9nT0GKc6JDPtfIOFIbesfljhMUa','administrador','2026-09-17 03:06:10','2026-09-17 03:06:10');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-16 21:06:36
