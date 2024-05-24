-- MySQL dump 10.13  Distrib 8.3.0, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: jardineria_IUD_staging
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Categoria_producto`
--

DROP TABLE IF EXISTS `Categoria_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria_producto` (
  `Id_Categoria` int NOT NULL AUTO_INCREMENT,
  `Desc_Categoria` varchar(50) NOT NULL,
  `descripcion_texto` text,
  `descripcion_html` text,
  `imagen` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`Id_Categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria_producto`
--

LOCK TABLES `Categoria_producto` WRITE;
/*!40000 ALTER TABLE `Categoria_producto` DISABLE KEYS */;
INSERT INTO `Categoria_producto` VALUES (1,'Herbaceas','Plantas para jardin decorativas',NULL,NULL),(2,'Herramientas','2 para todo tipo de acción',NULL,NULL),(3,'Aromaticas','Plantas aromáticas',NULL,NULL),(4,'Frutales','Árboles pequeños de producción frutal',NULL,NULL),(5,'Ornamentales','Plantas vistosas para la decoración del jardín',NULL,NULL);
/*!40000 ALTER TABLE `Categoria_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `ID_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre_cliente` varchar(50) NOT NULL,
  `nombre_contacto` varchar(30) DEFAULT NULL,
  `apellido_contacto` varchar(30) DEFAULT NULL,
  `telefono` varchar(15) NOT NULL,
  `fax` varchar(15) NOT NULL,
  `linea_direccion1` varchar(50) NOT NULL,
  `linea_direccion2` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) NOT NULL,
  `region` varchar(50) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `ID_empleado_rep_ventas` int DEFAULT NULL,
  `limite_credito` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`ID_cliente`),
  KEY `ID_empleado_rep_ventas` (`ID_empleado_rep_ventas`),
  CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`ID_empleado_rep_ventas`) REFERENCES `empleado` (`ID_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `ID_pedido` int NOT NULL,
  `ID_producto` varchar(15) NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unidad` decimal(15,2) NOT NULL,
  `numero_linea` smallint NOT NULL,
  PRIMARY KEY (`ID_pedido`,`ID_producto`),
  KEY `ID_producto` (`ID_producto`),
  CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`ID_pedido`) REFERENCES `pedido` (`ID_pedido`),
  CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`ID_producto`) REFERENCES `producto` (`ID_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `ID_empleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido1` varchar(50) NOT NULL,
  `apellido2` varchar(50) DEFAULT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `ID_oficina` int NOT NULL,
  `ID_jefe` int DEFAULT NULL,
  `puesto` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_empleado`),
  KEY `ID_oficina` (`ID_oficina`),
  KEY `ID_jefe` (`ID_jefe`),
  CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`ID_oficina`) REFERENCES `oficina` (`ID_oficina`),
  CONSTRAINT `empleado_ibfk_2` FOREIGN KEY (`ID_jefe`) REFERENCES `empleado` (`ID_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleado`
--

LOCK TABLES `empleado` WRITE;
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` VALUES (1,'Marcos','Magaña','Perez','3897','marcos@jardineria.es',8,NULL,'Director General'),(2,'Ruben','López','Martinez','2899','rlopez@jardineria.es',8,1,'Subdirector Marketing'),(3,'Alberto','Soria','Carrasco','2837','asoria@jardineria.es',8,2,'Subdirector Ventas'),(4,'Maria','Solís','Jerez','2847','msolis@jardineria.es',8,2,'Secretaria'),(5,'Felipe','Rosas','Marquez','2844','frosas@jardineria.es',8,3,'Representante Ventas'),(6,'Juan Carlos','Ortiz','Serrano','2845','cortiz@jardineria.es',8,3,'Representante Ventas'),(7,'Carlos','Soria','Jimenez','2444','csoria@jardineria.es',4,3,'Director Oficina'),(8,'Mariano','López','Murcia','2442','mlopez@jardineria.es',4,7,'Representante Ventas'),(9,'Lucio','Campoamor','Martín','2442','lcampoamor@jardineria.es',4,7,'Representante Ventas'),(10,'Hilario','Rodriguez','Huertas','2444','hrodriguez@jardineria.es',4,7,'Representante Ventas'),(11,'Emmanuel','Magaña','Perez','2518','manu@jardineria.es',1,3,'Director Oficina'),(12,'José Manuel','Martinez','De la Osa','2519','jmmart@hotmail.es',1,11,'Representante Ventas'),(13,'David','Palma','Aceituno','2519','dpalma@jardineria.es',1,11,'Representante Ventas'),(14,'Oscar','Palma','Aceituno','2519','opalma@jardineria.es',1,11,'Representante Ventas'),(15,'Francois','Fignon','','9981','ffignon@gardening.com',5,3,'Director Oficina'),(16,'Lionel','Narvaez','','9982','lnarvaez@gardening.com',5,15,'Representante Ventas'),(17,'Laurent','Serra','','9982','lserra@gardening.com',5,15,'Representante Ventas'),(18,'Michael','Bolton','','7454','mbolton@gardening.com',6,3,'Director Oficina'),(19,'Walter Santiago','Sanchez','Lopez','7454','wssanchez@gardening.com',6,18,'Representante Ventas'),(20,'Hilary','Washington','','7565','hwashington@gardening.com',2,3,'Director Oficina'),(21,'Marcus','Paxton','','7565','mpaxton@gardening.com',2,20,'Representante Ventas'),(22,'Lorena','Paxton','','7665','lpaxton@gardening.com',2,20,'Representante Ventas'),(23,'Nei','Nishikori','','8734','nnishikori@gardening.com',9,3,'Director Oficina'),(24,'Narumi','Riko','','8734','nriko@gardening.com',9,23,'Representante Ventas'),(25,'Takuma','Nomura','','8735','tnomura@gardening.com',9,23,'Representante Ventas'),(26,'Amy','Johnson','','3321','ajohnson@gardening.com',3,3,'Director Oficina'),(27,'Larry','Westfalls','','3322','lwestfalls@gardening.com',3,26,'Representante Ventas'),(28,'John','Walton','','3322','jwalton@gardening.com',3,26,'Representante Ventas'),(29,'Kevin','Fallmer','','3210','kfalmer@gardening.com',7,3,'Director Oficina'),(30,'Julian','Bellinelli','','3211','jbellinelli@gardening.com',7,29,'Representante Ventas'),(31,'Mariko','Kishi','','3211','mkishi@gardening.com',7,29,'Representante Ventas');
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oficina`
--

DROP TABLE IF EXISTS `oficina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oficina` (
  `ID_oficina` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(10) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `pais` varchar(50) NOT NULL,
  `region` varchar(50) DEFAULT NULL,
  `codigo_postal` varchar(10) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `linea_direccion1` varchar(50) NOT NULL,
  `linea_direccion2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_oficina`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oficina`
--

LOCK TABLES `oficina` WRITE;
/*!40000 ALTER TABLE `oficina` DISABLE KEYS */;
INSERT INTO `oficina` VALUES (1,'BCN-ES','Barcelona','España','Barcelona','08019','+34 93 3561182','Avenida Diagonal, 38','3A escalera Derecha'),(2,'BOS-USA','Boston','EEUU','MA','02108','+1 215 837 0825','1550 Court Place','Suite 102'),(3,'LON-UK','Londres','Inglaterra','EMEA','EC2N 1HN','+44 20 78772041','52 Old Broad Street','Ground Floor'),(4,'MAD-ES','Madrid','España','Madrid','28032','+34 91 7514487','Bulevar Indalecio Prieto, 32',''),(5,'PAR-FR','Paris','Francia','EMEA','75017','+33 14 723 4404','29 Rue Jouffroy d\'abbans',''),(6,'SFC-USA','San Francisco','EEUU','CA','94080','+1 650 219 4782','100 Market Street','Suite 300'),(7,'SYD-AU','Sydney','Australia','APAC','NSW 2010','+61 2 9264 2451','5-11 Wentworth Avenue','Floor #2'),(8,'TAL-ES','Talavera de la Reina','España','Castilla-LaMancha','45632','+34 925 867231','Francisco Aguirre, 32','5º piso (exterior)'),(9,'TOK-JP','Tokyo','Japón','Chiyoda-Ku','102-8578','+81 33 224 5000','4-1 Kioicho','');
/*!40000 ALTER TABLE `oficina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `ID_cliente` int NOT NULL,
  `forma_pago` varchar(40) NOT NULL,
  `id_transaccion` varchar(50) NOT NULL,
  `fecha_pago` date NOT NULL,
  `total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`ID_cliente`,`id_transaccion`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`ID_cliente`) REFERENCES `cliente` (`ID_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `ID_pedido` int NOT NULL AUTO_INCREMENT,
  `fecha_pedido` date NOT NULL,
  `fecha_esperada` date NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `estado` varchar(15) NOT NULL,
  `comentarios` text,
  `ID_cliente` int NOT NULL,
  PRIMARY KEY (`ID_pedido`),
  KEY `ID_cliente` (`ID_cliente`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`ID_cliente`) REFERENCES `cliente` (`ID_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `ID_producto` varchar(15) NOT NULL,
  `nombre` varchar(70) NOT NULL,
  `Categoria` int NOT NULL,
  `dimensiones` varchar(25) DEFAULT NULL,
  `proveedor` varchar(50) DEFAULT NULL,
  `descripcion` text,
  `cantidad_en_stock` smallint NOT NULL,
  `precio_venta` decimal(15,2) NOT NULL,
  `precio_proveedor` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`ID_producto`),
  KEY `Categoria` (`Categoria`),
  CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`Categoria`) REFERENCES `Categoria_producto` (`Id_Categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-05  6:39:18
