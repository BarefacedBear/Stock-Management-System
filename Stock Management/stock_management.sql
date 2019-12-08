CREATE DATABASE  IF NOT EXISTS `stock_management` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `stock_management`;
-- MySQL dump 10.13  Distrib 5.7.28, for Linux (x86_64)
--
-- Host: localhost    Database: stock_management
-- ------------------------------------------------------
-- Server version	5.7.28-0ubuntu0.18.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `autoid`
--

DROP TABLE IF EXISTS `autoid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoid` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autoid`
--

LOCK TABLES `autoid` WRITE;
/*!40000 ALTER TABLE `autoid` DISABLE KEYS */;
INSERT INTO `autoid` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);
/*!40000 ALTER TABLE `autoid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_customers`
--

DROP TABLE IF EXISTS `company_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_customers` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  `CATEGORY` varchar(15) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_customers`
--

LOCK TABLES `company_customers` WRITE;
/*!40000 ALTER TABLE `company_customers` DISABLE KEYS */;
INSERT INTO `company_customers` VALUES (1,'Adidas','DISTRIBUTOR','adidas@gmail.com','$5$rounds=535000$YJKnDe3nMRW.cPvq$I1NDpuGmSs15A.IKwtN.DDCPmtizP4B9XwuifkW6XrA'),(2,'Avishek','OUTLET','avishek@gmail.com','$5$rounds=535000$HaZOysleZ0gjuJoi$iwjZD7xpVCy3lkUBvTzqy/NZOw9cEX/7wztrEs2BDY5');
/*!40000 ALTER TABLE `company_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_users`
--

DROP TABLE IF EXISTS `company_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_users` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_users`
--

LOCK TABLES `company_users` WRITE;
/*!40000 ALTER TABLE `company_users` DISABLE KEYS */;
INSERT INTO `company_users` VALUES (6,'Google','google@gmail.com','$5$rounds=535000$m3TXuuDY36ZaWoOm$m4Lb8VgzLMPXQmFcHyhYrJT1WpDETo.CIgHUaj1zsg9'),(7,'Google','google@gmail.com','$5$rounds=535000$1YYw8DEJg5RvGB19$rwExlswVr35V0Blm86BigkKKcNVLAehy1ZhQCQhckq5');
/*!40000 ALTER TABLE `company_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_warehouse`
--

DROP TABLE IF EXISTS `company_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_warehouse` (
  `cpID` varchar(12) NOT NULL DEFAULT '',
  `PRODUCT_NAME` varchar(30) DEFAULT NULL,
  `QTY` int(6) DEFAULT NULL,
  `PRICE_PER_UNIT` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`cpID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_warehouse`
--

LOCK TABLES `company_warehouse` WRITE;
/*!40000 ALTER TABLE `company_warehouse` DISABLE KEYS */;
INSERT INTO `company_warehouse` VALUES ('CP1','Sunglass',850,1500.00),('CP2','Backpack',1400,3500.00);
/*!40000 ALTER TABLE `company_warehouse` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tg_company_warehouse_id
BEFORE INSERT ON company_warehouse
FOR EACH ROW
BEGIN
INSERT INTO autoid VALUES(NULL);
SET NEW.cpID = CONCAT('CP',LPAD(LAST_INSERT_ID(),1,''));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `distributor_warehouse`
--

DROP TABLE IF EXISTS `distributor_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `distributor_warehouse` (
  `dpID` varchar(12) NOT NULL DEFAULT '',
  `cpID` varchar(12) DEFAULT NULL,
  `QTY` int(6) DEFAULT NULL,
  `COST_PRICE` decimal(10,2) DEFAULT NULL,
  `SELL_PRICE` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`dpID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributor_warehouse`
--

LOCK TABLES `distributor_warehouse` WRITE;
/*!40000 ALTER TABLE `distributor_warehouse` DISABLE KEYS */;
INSERT INTO `distributor_warehouse` VALUES ('DP4','CP1',130,1500.00,2050.00),('DP5','CP2',880,3500.00,4599.00);
/*!40000 ALTER TABLE `distributor_warehouse` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tg_distributor_warehouse_id
BEFORE INSERT ON distributor_warehouse
FOR EACH ROW
BEGIN
INSERT INTO autoid VALUES(NULL);
SET NEW.dpID = CONCAT('DP',LPAD(LAST_INSERT_ID(),1,''));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `outlet_warehouse`
--

DROP TABLE IF EXISTS `outlet_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outlet_warehouse` (
  `opID` varchar(12) NOT NULL DEFAULT '',
  `dpID` varchar(12) DEFAULT NULL,
  `QTY` int(6) DEFAULT NULL,
  `COST_PRICE` decimal(10,2) DEFAULT NULL,
  `SELL_PRICE` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`opID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outlet_warehouse`
--

LOCK TABLES `outlet_warehouse` WRITE;
/*!40000 ALTER TABLE `outlet_warehouse` DISABLE KEYS */;
INSERT INTO `outlet_warehouse` VALUES ('OP8','DP4',20,2050.00,3050.00);
/*!40000 ALTER TABLE `outlet_warehouse` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tg_outlet_warehouse_id
BEFORE INSERT ON outlet_warehouse
FOR EACH ROW
BEGIN
INSERT INTO autoid VALUES(NULL);
SET NEW.opID = CONCAT('OP',LPAD(LAST_INSERT_ID(),1,''));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `registration`
--

DROP TABLE IF EXISTS `registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registration` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  `CATEGORY` varchar(15) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration`
--

LOCK TABLES `registration` WRITE;
/*!40000 ALTER TABLE `registration` DISABLE KEYS */;
INSERT INTO `registration` VALUES (3,'LinkedIn','OUTLET','linked@gmail.com','$5$rounds=535000$.opvgmEOpPvBv/VL$5X0LQaOntSZElHTKIAostm/ptLIHcfeZ/YPukiB3ER8'),(4,'Ashoke','DISTRIBUTOR','ashoke@gmail.com','$5$rounds=535000$AHFF6WQmtZ4dmav2$Z8GobEE6X/BRvPxGRphPbqFVAq/AnQwdZpy.sLhRr.4');
/*!40000 ALTER TABLE `registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'stock_management'
--

--
-- Dumping routines for database 'stock_management'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-22 23:45:07
