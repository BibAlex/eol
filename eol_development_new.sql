-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: eol_development
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.12.04.1

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
-- Table structure for table `agent_roles`
--

DROP TABLE IF EXISTS `agent_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_roles` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='Identifies how agent is linked to data_object';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_roles`
--

LOCK TABLES `agent_roles` WRITE;
/*!40000 ALTER TABLE `agent_roles` DISABLE KEYS */;
INSERT INTO `agent_roles` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18);
/*!40000 ALTER TABLE `agent_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agents`
--

DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `full_name` text NOT NULL,
  `given_name` varchar(255) DEFAULT NULL,
  `family_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `homepage` text NOT NULL,
  `logo_url` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `logo_cache_url` bigint(20) unsigned DEFAULT NULL,
  `project` varchar(255) DEFAULT NULL,
  `organization` varchar(255) DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `yahoo_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `full_name` (`full_name`(200))
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COMMENT='Agents are content partners and used for object attribution';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents`
--

LOCK TABLES `agents` WRITE;
/*!40000 ALTER TABLE `agents` DISABLE KEYS */;
INSERT INTO `agents` VALUES (1,'IUCN',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:16','2014-04-09 11:33:16'),(2,'Catalogue of Life',NULL,NULL,NULL,'http://www.catalogueoflife.org/','',219000,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:17','2014-04-09 11:33:17'),(3,'National Center for Biotechnology Information',NULL,NULL,NULL,'http://www.ncbi.nlm.nih.gov/','',921800,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:17','2014-04-09 11:33:17'),(4,'Biology of Aging',NULL,NULL,NULL,'','',318700,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:17','2014-04-09 11:33:17'),(5,'Fiona Parisian',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:18','2014-04-09 11:33:18'),(6,'Spencer Bergstrom',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:20','2014-04-09 11:33:20'),(7,'GBIF',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:20','2014-04-09 11:33:20'),(8,'Camren Rhys',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:21','2014-04-09 11:33:21'),(9,'Ahmad Murphy',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:32','2014-04-09 11:33:32'),(10,'Global Biodiversity Information Facility (GBIF)',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:37','2014-04-09 11:33:37'),(11,'Roxane Connelly',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:37','2014-04-09 11:33:37'),(12,'Mariana Runolfsson',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:38','2014-04-09 11:33:38'),(13,'Joshuah Ernser',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:38','2014-04-09 11:33:38'),(14,'Antonia Nolan',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:44','2014-04-09 11:33:44'),(15,'Eugene Mosciski',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:44','2014-04-09 11:33:44'),(16,'Kaitlin Larkin',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:48','2014-04-09 11:33:48'),(17,'Otho Willms',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:48','2014-04-09 11:33:48'),(18,'Camila Deckow',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:51','2014-04-09 11:33:51'),(19,'Colt Stracke',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:51','2014-04-09 11:33:51'),(20,'Mathew Deckow',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:54','2014-04-09 11:33:54'),(21,'Electa Na',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:54','2014-04-09 11:33:54'),(22,'Damaris Torphy',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:58','2014-04-09 11:33:58'),(23,'Aidan Mills',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:33:58','2014-04-09 11:33:58'),(24,'Dora Pollich',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:04','2014-04-09 11:34:04'),(25,'Emmanuelle Beatty',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:06','2014-04-09 11:34:06'),(26,'Sam Hettinger',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:06','2014-04-09 11:34:06'),(27,'Betty Okuneva',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:08','2014-04-09 11:34:08'),(28,'Reuben Olson',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:08','2014-04-09 11:34:08'),(29,'Ashley West',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:09','2014-04-09 11:34:09'),(30,'Vicente Schowalter',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:09','2014-04-09 11:34:09'),(31,'Heber Hill',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:10','2014-04-09 11:34:10'),(32,'Maybell Schneider',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:10','2014-04-09 11:34:10'),(33,'Okey McCullough',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:16','2014-04-09 11:34:16'),(34,'Leonardo Schamberger',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:16','2014-04-09 11:34:16'),(35,'Gerhard Bode',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:18','2014-04-09 11:34:18'),(36,'Cicero Stehr',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:18','2014-04-09 11:34:18'),(37,'Maritza Kuhic',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:21','2014-04-09 11:34:21'),(38,'Alvah Wisozk',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:21','2014-04-09 11:34:21'),(39,'Wyatt Hansen',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:21','2014-04-09 11:34:21'),(40,'Ming Spencer',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:21','2014-04-09 11:34:21'),(41,'Ralph Wiggum',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(42,'Shane Eichmann',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(43,'George Rolfson',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(44,'Chanel Keller',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(45,'Rosalia Toy',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(46,'Admin User',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:26','2014-04-09 11:34:26'),(47,'Christie Ankunding',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:28','2014-04-09 11:34:28'),(48,'Madelynn Beatty',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:28','2014-04-09 11:34:28'),(49,'Jeramie Botsford',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:31','2014-04-09 11:34:31'),(50,'test curator',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:31','2014-04-09 11:34:31'),(51,'Lavada Mann',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:32','2014-04-09 11:34:32'),(52,'Kailey Ankunding',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:32','2014-04-09 11:34:32'),(53,'Herbert Senger',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:33','2014-04-09 11:34:33'),(54,'Rolfe Luettgen',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:33','2014-04-09 11:34:33'),(55,'Kali Lubowitz',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:36','2014-04-09 11:34:36'),(56,'Jacky Welch',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:36','2014-04-09 11:34:36'),(57,'Marilie Harvey',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:40','2014-04-09 11:34:40'),(58,'Jon Schultz',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:40','2014-04-09 11:34:40'),(59,'Rachel Keebler',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:44','2014-04-09 11:34:44'),(60,'Scot Hudson',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:44','2014-04-09 11:34:44'),(61,'Rhea Leffler',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:47','2014-04-09 11:34:47'),(62,'Greta Gleason',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:47','2014-04-09 11:34:47'),(63,'Dameon Schmidt',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:51','2014-04-09 11:34:51'),(64,'Rasheed Skiles',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:51','2014-04-09 11:34:51'),(65,'Bertrand Gleason',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:54','2014-04-09 11:34:54'),(66,'Seao Cummerata',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:54','2014-04-09 11:34:54'),(67,'Janif Stamm',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:58','2014-04-09 11:34:58'),(68,'Helmes Beier',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:34:58','2014-04-09 11:34:58'),(69,'Fionb Dickens',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:01','2014-04-09 11:35:01'),(70,'Spences Kulas',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:01','2014-04-09 11:35:01'),(71,'Camreo Franecki',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:04','2014-04-09 11:35:04'),(72,'Ahmae Kuhic',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:05','2014-04-09 11:35:05'),(73,'Roxanf Padberg',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:09','2014-04-09 11:35:09'),(74,'Marianb Haley',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:09','2014-04-09 11:35:09'),(75,'Joshuai Gorczany',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:13','2014-04-09 11:35:13'),(76,'Antonib Hoeger',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:13','2014-04-09 11:35:13'),(77,'Eugenf Cronio',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:16','2014-04-09 11:35:16'),(78,'Kaitlio Reinges',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:16','2014-04-09 11:35:16'),(79,'Othp Jacobt',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:19','2014-04-09 11:35:19'),(80,'Camilb Cronb',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:20','2014-04-09 11:35:20'),(81,'Colu Parisiao',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:30','2014-04-09 11:35:30'),(82,'Mathex Bergstron',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:52','2014-04-09 11:35:52'),(83,'Electb Rhyt',NULL,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-04 11:35:53','2014-04-09 11:35:53'),(84,'user1',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-10 08:56:35','0000-00-00 00:00:00'),(85,'user1',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-10 09:02:13','0000-00-00 00:00:00'),(86,'user1',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-10 09:19:58','0000-00-00 00:00:00'),(87,'user2',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-10 09:35:27','0000-00-00 00:00:00'),(88,'user1',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-10 09:50:38','0000-00-00 00:00:00'),(89,'admin1',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-04-27 13:04:15','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agents_data_objects`
--

DROP TABLE IF EXISTS `agents_data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents_data_objects` (
  `data_object_id` int(10) unsigned NOT NULL,
  `agent_id` int(10) unsigned NOT NULL,
  `agent_role_id` tinyint(3) unsigned NOT NULL,
  `view_order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`,`agent_id`,`agent_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Agents are associated with data objects in various roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents_data_objects`
--

LOCK TABLES `agents_data_objects` WRITE;
/*!40000 ALTER TABLE `agents_data_objects` DISABLE KEYS */;
INSERT INTO `agents_data_objects` VALUES (2,2,1,0),(3,2,1,0),(4,2,1,0),(5,2,1,0),(6,2,1,0),(7,2,1,0),(8,2,1,0),(9,2,1,0),(10,2,1,0),(11,2,1,0),(12,2,1,0),(13,2,1,0),(14,2,1,0),(15,2,1,0),(16,2,1,0),(17,2,1,0),(18,2,1,0),(19,2,1,0),(20,2,1,0),(21,2,1,0),(22,2,1,0),(23,2,1,0),(24,2,1,0),(25,2,1,0),(26,2,1,0),(27,2,1,0),(28,2,1,0),(29,2,1,0),(30,2,1,0),(31,2,1,0),(32,2,1,0),(33,2,1,0),(34,2,1,0),(35,2,1,0),(36,2,1,0),(37,2,1,0),(38,2,1,0),(39,2,1,0),(40,2,1,0),(41,2,1,0),(42,2,1,0),(43,2,1,0),(44,2,1,0),(45,2,1,0),(46,2,1,0),(47,2,1,0),(48,2,1,0),(49,2,1,0),(50,2,1,0),(51,2,1,0),(52,2,1,0),(53,2,1,0),(54,2,1,0),(55,2,1,0),(56,2,1,0),(57,2,1,0),(58,2,1,0),(59,2,1,0),(60,2,1,0),(61,2,1,0),(62,2,1,0),(63,2,1,0),(64,2,1,0),(65,2,1,0),(66,2,1,0),(67,2,1,0),(68,2,1,0),(69,2,1,0),(70,2,1,0),(71,2,1,0),(72,2,1,0),(73,2,1,0),(74,2,1,0),(75,2,1,0),(76,2,1,0),(77,2,1,0),(78,2,1,0),(79,2,1,0),(80,2,1,0),(81,2,1,0),(82,2,1,0),(83,2,1,0),(84,2,1,0),(85,2,1,0),(86,2,1,0),(87,2,1,0),(88,2,1,0),(89,2,1,0),(92,10,1,0),(93,10,1,0),(94,10,1,0),(95,10,1,0),(96,10,1,0),(97,10,1,0),(98,10,1,0),(99,10,1,0),(100,10,1,0),(101,2,1,0),(102,2,1,0),(103,2,1,0),(104,2,1,0),(105,2,1,0),(106,2,1,0),(107,2,1,0),(108,2,1,0),(109,2,1,0),(110,2,1,0),(111,2,1,0),(112,2,1,0),(113,2,1,0),(114,2,1,0),(115,2,1,0),(116,2,1,0),(117,2,1,0),(118,2,1,0),(119,2,1,0),(120,2,1,0),(121,2,1,0),(122,2,1,0),(123,2,1,0),(124,2,1,0),(125,2,1,0),(126,2,1,0),(127,2,1,0),(128,2,1,0),(129,2,1,0),(130,2,1,0),(131,2,1,0),(132,2,1,0),(133,2,1,0),(134,2,1,0),(135,2,1,0),(136,2,1,0),(137,2,1,0),(138,2,1,0),(139,2,1,0),(140,2,1,0),(141,2,1,0),(142,2,1,0),(143,2,1,0),(144,2,1,0),(145,2,1,0),(146,2,1,0),(147,2,1,0),(148,2,1,0),(149,2,1,0),(150,2,1,0),(151,2,1,0),(152,2,1,0),(153,2,1,0),(154,2,1,0),(155,2,1,0),(156,2,1,0),(157,2,1,0),(158,2,1,0),(159,2,1,0),(160,2,1,0),(161,2,1,0),(162,2,1,0),(163,2,1,0),(164,2,1,0),(165,2,1,0),(166,2,1,0),(167,2,1,0),(168,2,1,0),(169,2,1,0),(170,2,1,0),(171,2,1,0),(172,2,1,0),(173,2,1,0),(174,2,1,0),(175,2,1,0),(176,2,1,0),(177,2,1,0),(178,2,1,0),(179,2,1,0),(180,2,1,0),(181,2,1,0),(182,2,1,0),(183,2,1,0),(184,2,1,0),(185,2,1,0),(186,2,1,0),(187,2,1,0),(188,2,1,0),(189,2,1,0),(190,2,1,0),(191,2,1,0),(192,2,1,0),(193,2,1,0),(194,2,1,0),(195,2,1,0),(196,2,1,0),(197,2,1,0),(198,2,1,0),(199,2,1,0),(200,2,1,0),(201,2,1,0),(202,2,1,0),(203,2,1,0),(204,2,1,0),(205,2,1,0),(206,2,1,0),(207,2,1,0),(208,2,1,0),(209,2,1,0),(210,2,1,0),(211,2,1,0),(212,2,1,0),(213,2,1,0),(214,2,1,0),(215,2,1,0),(216,2,1,0),(217,2,1,0),(218,2,1,0),(219,2,1,0),(220,2,1,0),(221,2,1,0),(222,2,1,0),(223,2,1,0),(224,2,1,0),(225,2,1,0),(226,2,1,0),(227,2,1,0),(228,2,1,0),(229,2,1,0),(230,2,1,0),(231,2,1,0),(232,2,1,0),(233,2,1,0),(234,2,1,0),(235,2,1,0);
/*!40000 ALTER TABLE `agents_data_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agents_hierarchy_entries`
--

DROP TABLE IF EXISTS `agents_hierarchy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents_hierarchy_entries` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `agent_id` int(10) unsigned NOT NULL,
  `agent_role_id` tinyint(3) unsigned NOT NULL,
  `view_order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`agent_id`,`agent_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Agents are associated with hierarchy entries in various roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents_hierarchy_entries`
--

LOCK TABLES `agents_hierarchy_entries` WRITE;
/*!40000 ALTER TABLE `agents_hierarchy_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `agents_hierarchy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agents_synonyms`
--

DROP TABLE IF EXISTS `agents_synonyms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents_synonyms` (
  `synonym_id` int(10) unsigned NOT NULL,
  `agent_id` int(10) unsigned NOT NULL,
  `agent_role_id` tinyint(3) unsigned NOT NULL,
  `view_order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`synonym_id`,`agent_id`,`agent_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Agents are associated with synonyms in various roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents_synonyms`
--

LOCK TABLES `agents_synonyms` WRITE;
/*!40000 ALTER TABLE `agents_synonyms` DISABLE KEYS */;
INSERT INTO `agents_synonyms` VALUES (23,1,4,1),(24,2,4,1),(25,1,4,1),(26,2,4,1),(27,1,4,1),(28,2,4,1),(29,1,4,1),(30,2,4,1),(31,1,4,1),(32,2,4,1),(33,1,4,1),(34,2,4,1),(35,1,4,1),(36,2,4,1),(37,2,4,1),(38,2,4,1),(39,2,4,1),(40,2,4,1),(41,2,4,1),(42,1,4,1),(43,2,4,1),(44,1,4,1),(45,1,4,1),(46,2,4,1),(47,2,4,1),(48,1,4,1),(49,1,4,1),(50,2,4,1),(51,2,4,1),(52,2,4,1),(53,1,4,1),(54,2,4,1),(55,1,4,1),(56,2,4,1),(57,1,4,1),(58,2,4,1),(59,1,4,1),(60,2,4,1),(61,1,4,1),(62,2,4,1),(63,1,4,1),(64,2,4,1),(65,1,4,1),(66,2,4,1),(67,1,4,1),(68,2,4,1),(69,1,4,1),(70,2,4,1),(71,1,4,1),(72,1,4,1),(73,2,4,1),(74,2,4,1),(75,2,4,1),(76,2,4,1),(77,2,4,1),(78,2,4,1),(79,2,4,1),(80,1,4,1),(81,2,4,1),(82,1,4,1),(83,2,4,1),(84,1,4,1),(85,2,4,1),(86,1,4,1),(87,2,4,1),(88,1,4,1);
/*!40000 ALTER TABLE `agents_synonyms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audiences`
--

DROP TABLE IF EXISTS `audiences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiences` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Controlled list for determining the "expertise" of a data object';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiences`
--

LOCK TABLES `audiences` WRITE;
/*!40000 ALTER TABLE `audiences` DISABLE KEYS */;
INSERT INTO `audiences` VALUES (1),(2),(3);
/*!40000 ALTER TABLE `audiences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audiences_data_objects`
--

DROP TABLE IF EXISTS `audiences_data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiences_data_objects` (
  `data_object_id` int(10) unsigned NOT NULL,
  `audience_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`,`audience_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A data object can have zero to many target audiences';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiences_data_objects`
--

LOCK TABLES `audiences_data_objects` WRITE;
/*!40000 ALTER TABLE `audiences_data_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `audiences_data_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `canonical_forms`
--

DROP TABLE IF EXISTS `canonical_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `canonical_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `string` varchar(300) NOT NULL COMMENT 'a canonical form of a scientific name is the name parts without authorship, rank information, or anthing except the latinized name parts. These are for the most part algorithmically generated',
  `name_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `string` (`string`(255)),
  KEY `index_canonical_forms_on_name_id` (`name_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COMMENT='Every name string has one canonical form - a simplified version of the string';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `canonical_forms`
--

LOCK TABLES `canonical_forms` WRITE;
/*!40000 ALTER TABLE `canonical_forms` DISABLE KEYS */;
INSERT INTO `canonical_forms` VALUES (1,'Estasperioreseli etquidemis',NULL),(2,'Animalia',NULL),(3,'Animals',NULL),(4,'Autrecusandaees repudiandaeica',NULL),(5,'ravenous clover',NULL),(6,'Nihileri voluptasus',NULL),(7,'red suntus',NULL),(8,'Dignissimosii inutes',NULL),(9,'darning needle',NULL),(10,'Fugais utharumatus',NULL),(11,'tiger',NULL),(12,'Minuseli ullamens',NULL),(13,'Tiger moth',NULL),(14,'Dignissimosatus nobisosyne',NULL),(15,'Tiger lilly',NULL),(16,'Tiger water lilly',NULL),(17,'lilly of the tiger',NULL),(18,'Tiger flower',NULL),(19,'Tiger-stripe lilly',NULL),(20,'Tiger-eye lilly',NULL),(21,'Expeditaalia evenietelia',NULL),(22,'Earumeles beataeata',NULL),(23,'Culpaensis sapienteesi',NULL),(24,'frizzlebek',NULL),(25,'Utomnisesi sequialis',NULL),(26,'purple dust crab',NULL),(27,'Autaliquideri minimais',NULL),(28,'Autema officiaalius',NULL),(29,'Etconsequaturelia autenimalia',NULL),(30,'wumpus',NULL),(31,'wompus',NULL),(32,'wampus',NULL),(33,'Eukaryota',NULL),(34,'eukaryotes',NULL),(35,'Metazoa',NULL),(36,'opisthokonts',NULL),(37,'Quoautesi natuseri',NULL),(38,'cloud swallow',NULL),(39,'Voluptatumeri esseensis',NULL),(40,'spiny possom',NULL),(41,'Ameti maioresis',NULL),(42,'common desert mouse',NULL),(43,'Ipsamalius distinctioerox',NULL),(44,'fisher',NULL),(45,'Maximees veritatisatus',NULL),(46,'chartruse turtle',NULL),(47,'Molestiaeus rationealia',NULL),(48,'horny toad',NULL),(49,'Fugitens dolorealius',NULL),(50,'scarlet vermillion',NULL),(51,'Quisquamator sequieles',NULL),(52,'Mozart\'s nemesis',NULL),(53,'Bacteria',NULL),(54,'bugs',NULL),(55,'grime',NULL),(56,'critters',NULL),(57,'bakteria',NULL),(58,'die buggen',NULL),(59,'das greim',NULL),(60,'baseteir',NULL),(61,'le grimme',NULL),(62,'ler petit bugge',NULL),(63,'Essees eaqueata',NULL),(64,'quick brown fox',NULL),(65,'Animiens atdoloribuseron',NULL),(66,'painted horse',NULL),(67,'Adaliasii iurea',NULL),(68,'thirsty aphid',NULL),(69,'Nonnumquamerus numquamerus',NULL),(70,'bloody eel',NULL);
/*!40000 ALTER TABLE `canonical_forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changeable_object_types`
--

DROP TABLE IF EXISTS `changeable_object_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changeable_object_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ch_object_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changeable_object_types`
--

LOCK TABLES `changeable_object_types` WRITE;
/*!40000 ALTER TABLE `changeable_object_types` DISABLE KEYS */;
INSERT INTO `changeable_object_types` VALUES (1,'comment','2014-04-09 13:33:21','2014-04-09 13:33:21'),(2,'data_object','2014-04-09 13:33:21','2014-04-09 13:33:21'),(3,'synonym','2014-04-09 13:33:21','2014-04-09 13:33:21'),(4,'taxon_concept_name','2014-04-09 13:33:21','2014-04-09 13:33:21'),(5,'tag','2014-04-09 13:33:21','2014-04-09 13:33:21'),(6,'users_data_object','2014-04-09 13:33:21','2014-04-09 13:33:21'),(7,'hierarchy_entry','2014-04-09 13:33:21','2014-04-09 13:33:21'),(8,'curated_data_objects_hierarchy_entry','2014-04-09 13:33:21','2014-04-09 13:33:21'),(9,'data_objects_hierarchy_entry','2014-04-09 13:33:21','2014-04-09 13:33:21'),(10,'users_submitted_text','2014-04-09 13:33:21','2014-04-09 13:33:21'),(11,'curated_taxon_concept_preferred_entry','2014-04-09 13:33:21','2014-04-09 13:33:21'),(12,'taxon_concept','2014-04-09 13:33:21','2014-04-09 13:33:21'),(13,'classification_curation','2014-04-09 13:33:21','2014-04-09 13:33:21'),(14,'data_point_uri','2014-04-09 13:33:21','2014-04-09 13:33:21'),(15,'user_added_data','2014-04-09 13:33:21','2014-04-09 13:33:21');
/*!40000 ALTER TABLE `changeable_object_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ckeditor_assets`
--

DROP TABLE IF EXISTS `ckeditor_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ckeditor_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_file_name` varchar(255) NOT NULL,
  `data_content_type` varchar(255) DEFAULT NULL,
  `data_file_size` int(11) DEFAULT NULL,
  `assetable_id` int(11) DEFAULT NULL,
  `assetable_type` varchar(30) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ckeditor_assetable_type` (`assetable_type`,`type`,`assetable_id`),
  KEY `idx_ckeditor_assetable` (`assetable_type`,`assetable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ckeditor_assets`
--

LOCK TABLES `ckeditor_assets` WRITE;
/*!40000 ALTER TABLE `ckeditor_assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ckeditor_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classification_curations`
--

DROP TABLE IF EXISTS `classification_curations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification_curations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exemplar_id` int(11) DEFAULT NULL,
  `source_id` int(11) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `forced` tinyint(1) DEFAULT NULL,
  `error` varchar(256) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification_curations`
--

LOCK TABLES `classification_curations` WRITE;
/*!40000 ALTER TABLE `classification_curations` DISABLE KEYS */;
/*!40000 ALTER TABLE `classification_curations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_items`
--

DROP TABLE IF EXISTS `collection_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `collected_item_type` varchar(32) DEFAULT NULL,
  `collected_item_id` int(11) DEFAULT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `annotation` text,
  `added_by_user_id` int(11) unsigned DEFAULT NULL,
  `sort_field` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collection_id_object_type_object_id` (`collection_id`,`collected_item_type`,`collected_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_items`
--

LOCK TABLES `collection_items` WRITE;
/*!40000 ALTER TABLE `collection_items` DISABLE KEYS */;
INSERT INTO `collection_items` VALUES (1,'Test Data Object','DataObject',236,5709,'2014-04-09 13:35:30','2014-04-09 13:35:30',NULL,NULL,NULL);
/*!40000 ALTER TABLE `collection_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_items_collection_jobs`
--

DROP TABLE IF EXISTS `collection_items_collection_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_items_collection_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_item_id` int(11) NOT NULL,
  `collection_job_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `join_index` (`collection_item_id`,`collection_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_items_collection_jobs`
--

LOCK TABLES `collection_items_collection_jobs` WRITE;
/*!40000 ALTER TABLE `collection_items_collection_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_items_collection_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_items_refs`
--

DROP TABLE IF EXISTS `collection_items_refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_items_refs` (
  `collection_item_id` int(11) NOT NULL,
  `ref_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_items_refs`
--

LOCK TABLES `collection_items_refs` WRITE;
/*!40000 ALTER TABLE `collection_items_refs` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_items_refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_jobs`
--

DROP TABLE IF EXISTS `collection_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` varchar(8) NOT NULL,
  `user_id` int(11) NOT NULL,
  `collection_id` int(11) NOT NULL,
  `item_count` int(11) DEFAULT NULL,
  `all_items` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `finished_at` datetime DEFAULT NULL,
  `overwrite` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_jobs`
--

LOCK TABLES `collection_jobs` WRITE;
/*!40000 ALTER TABLE `collection_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_jobs_collections`
--

DROP TABLE IF EXISTS `collection_jobs_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_jobs_collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) DEFAULT NULL,
  `collection_job_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collection_jobs_collections_index` (`collection_id`,`collection_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_jobs_collections`
--

LOCK TABLES `collection_jobs_collections` WRITE;
/*!40000 ALTER TABLE `collection_jobs_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_jobs_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_types`
--

DROP TABLE IF EXISTS `collection_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_types` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `lft` smallint(5) unsigned DEFAULT NULL,
  `rgt` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `lft` (`lft`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_types`
--

LOCK TABLES `collection_types` WRITE;
/*!40000 ALTER TABLE `collection_types` DISABLE KEYS */;
INSERT INTO `collection_types` VALUES (1,0,0,1),(2,0,2,3),(3,0,4,9),(4,3,5,6),(5,3,7,8),(6,0,10,17),(7,6,11,12),(8,6,13,14),(9,6,15,16),(10,0,18,19),(11,0,20,21);
/*!40000 ALTER TABLE `collection_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_types_collections`
--

DROP TABLE IF EXISTS `collection_types_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_types_collections` (
  `collection_type_id` smallint(5) unsigned NOT NULL,
  `collection_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`collection_type_id`,`collection_id`),
  KEY `collection_id` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_types_collections`
--

LOCK TABLES `collection_types_collections` WRITE;
/*!40000 ALTER TABLE `collection_types_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_types_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_types_hierarchies`
--

DROP TABLE IF EXISTS `collection_types_hierarchies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_types_hierarchies` (
  `collection_type_id` smallint(5) unsigned NOT NULL,
  `hierarchy_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`collection_type_id`,`hierarchy_id`),
  KEY `collection_id` (`hierarchy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_types_hierarchies`
--

LOCK TABLES `collection_types_hierarchies` WRITE;
/*!40000 ALTER TABLE `collection_types_hierarchies` DISABLE KEYS */;
INSERT INTO `collection_types_hierarchies` VALUES (1,1),(2,1),(4,14),(9,14),(11,14),(7,15),(10,15);
/*!40000 ALTER TABLE `collection_types_hierarchies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `special_collection_id` int(11) DEFAULT NULL,
  `published` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_cache_url` bigint(20) unsigned DEFAULT NULL,
  `logo_file_name` varchar(255) DEFAULT NULL,
  `logo_content_type` varchar(255) DEFAULT NULL,
  `logo_file_size` int(10) unsigned DEFAULT '0',
  `description` text,
  `sort_style_id` int(11) DEFAULT NULL,
  `relevance` tinyint(4) DEFAULT '1',
  `view_style_id` int(11) DEFAULT NULL,
  `show_references` tinyint(1) DEFAULT '1',
  `collection_items_count` int(11) NOT NULL DEFAULT '0',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5716 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections`
--

LOCK TABLES `collections` WRITE;
/*!40000 ALTER TABLE `collections` DISABLE KEYS */;
INSERT INTO `collections` VALUES (66,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:38','2014-04-09 13:33:38',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,66,1),(67,'Helmer Crona\'s Watch List',2,1,'2014-04-09 13:33:40','2014-04-09 13:33:40',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,67,1),(68,'Mariana Runolfsson\'s Watch List',2,1,'2014-04-09 13:33:40','2014-04-09 13:33:40',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,68,1),(69,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:41','2014-04-09 13:33:41',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,69,1),(70,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:41','2014-04-09 13:33:41',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,70,1),(71,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:42','2014-04-09 13:33:42',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,71,1),(72,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:43','2014-04-09 13:33:43',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,72,1),(73,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:43','2014-04-09 13:33:43',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,73,1),(74,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:33:43','2014-04-09 13:33:43',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,74,1),(75,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:44','2014-04-09 13:33:44',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,75,1),(76,'Helmer Crona\'s Watch List',2,1,'2014-04-09 13:33:45','2014-04-09 13:33:45',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,76,1),(77,'Antonia Nolan\'s Watch List',2,1,'2014-04-09 13:33:45','2014-04-09 13:33:45',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,77,1),(78,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:45','2014-04-09 13:33:45',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,78,1),(79,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:46','2014-04-09 13:33:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,79,1),(80,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:46','2014-04-09 13:33:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,80,1),(81,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:46','2014-04-09 13:33:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,81,1),(82,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:47','2014-04-09 13:33:47',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,82,1),(83,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:33:47','2014-04-09 13:33:47',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,83,1),(84,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,84,1),(85,'Roxane Connelly\'s Watch List',2,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,85,1),(86,'Iucn Reinger\'s Watch List',2,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,86,1),(87,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,87,1),(88,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:49','2014-04-09 13:33:49',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,88,1),(89,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:50','2014-04-09 13:33:50',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,89,1),(90,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:50','2014-04-09 13:33:50',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,90,1),(91,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:50','2014-04-09 13:33:50',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,91,1),(92,'Otho Willms\'s Watch List',2,1,'2014-04-09 13:33:50','2014-04-09 13:33:50',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,92,1),(93,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:51','2014-04-09 13:33:51',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,93,1),(94,'Ahmad Murphy\'s Watch List',2,1,'2014-04-09 13:33:52','2014-04-09 13:33:52',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,94,1),(95,'Antonia Nolan\'s Watch List',2,1,'2014-04-09 13:33:52','2014-04-09 13:33:52',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,95,1),(96,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:52','2014-04-09 13:33:52',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,96,1),(97,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:52','2014-04-09 13:33:52',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,97,1),(98,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:53','2014-04-09 13:33:53',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,98,1),(99,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:53','2014-04-09 13:33:53',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,99,1),(100,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:54','2014-04-09 13:33:54',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,100,1),(101,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:33:54','2014-04-09 13:33:54',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,101,1),(102,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:54','2014-04-09 13:33:54',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,102,1),(103,'Janie Jacobs\'s Watch List',2,1,'2014-04-09 13:33:55','2014-04-09 13:33:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,103,1),(104,'Helmer Crona\'s Watch List',2,1,'2014-04-09 13:33:55','2014-04-09 13:33:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,104,1),(105,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:55','2014-04-09 13:33:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,105,1),(106,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:56','2014-04-09 13:33:56',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,106,1),(107,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:57','2014-04-09 13:33:57',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,107,1),(108,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:57','2014-04-09 13:33:57',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,108,1),(109,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:57','2014-04-09 13:33:57',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,109,1),(110,'Electa Na\'s Watch List',2,1,'2014-04-09 13:33:58','2014-04-09 13:33:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,110,1),(111,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:33:58','2014-04-09 13:33:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,111,1),(112,'Mathew Deckow\'s Watch List',2,1,'2014-04-09 13:33:59','2014-04-09 13:33:59',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,112,1),(113,'Mathew Deckow\'s Watch List',2,1,'2014-04-09 13:33:59','2014-04-09 13:33:59',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,113,1),(114,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:33:59','2014-04-09 13:33:59',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,114,1),(115,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:00','2014-04-09 13:34:00',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,115,1),(116,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:01','2014-04-09 13:34:01',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,116,1),(117,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:01','2014-04-09 13:34:01',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,117,1),(118,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:01','2014-04-09 13:34:01',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,118,1),(119,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:02','2014-04-09 13:34:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,119,1),(120,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:02','2014-04-09 13:34:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,120,1),(121,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:02','2014-04-09 13:34:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,121,1),(122,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:02','2014-04-09 13:34:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,122,1),(123,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:03','2014-04-09 13:34:03',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,123,1),(124,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:03','2014-04-09 13:34:03',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,124,1),(125,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:04','2014-04-09 13:34:04',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,125,1),(126,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:04','2014-04-09 13:34:04',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,126,1),(127,'Dora Pollich\'s Watch List',2,1,'2014-04-09 13:34:05','2014-04-09 13:34:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,127,1),(128,'Sam Hettinger\'s Watch List',2,1,'2014-04-09 13:34:06','2014-04-09 13:34:06',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,128,1),(129,'Reuben Olson\'s Watch List',2,1,'2014-04-09 13:34:08','2014-04-09 13:34:08',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,129,1),(130,'Vicente Schowalter\'s Watch List',2,1,'2014-04-09 13:34:09','2014-04-09 13:34:09',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,130,1),(131,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:10','2014-04-09 13:34:10',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,131,1),(132,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:10','2014-04-09 13:34:10',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,132,1),(133,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:12','2014-04-09 13:34:12',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,133,1),(134,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:12','2014-04-09 13:34:12',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,134,1),(135,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:12','2014-04-09 13:34:12',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,135,1),(136,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:13','2014-04-09 13:34:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,136,1),(137,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:13','2014-04-09 13:34:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,137,1),(138,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:13','2014-04-09 13:34:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,138,1),(139,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:13','2014-04-09 13:34:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,139,1),(140,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:14','2014-04-09 13:34:14',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,140,1),(141,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:14','2014-04-09 13:34:14',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,141,1),(142,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:15','2014-04-09 13:34:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,142,1),(143,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:15','2014-04-09 13:34:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,143,1),(144,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:15','2014-04-09 13:34:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,144,1),(145,'Leonardo Schamberger\'s Watch List',2,1,'2014-04-09 13:34:16','2014-04-09 13:34:16',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,145,1),(146,'Leonardo Schamberger\'s Watch List',2,1,'2014-04-09 13:34:16','2014-04-09 13:34:16',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,146,1),(147,'Leonardo Schamberger\'s Watch List',2,1,'2014-04-09 13:34:17','2014-04-09 13:34:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,147,1),(148,'Leonardo Schamberger\'s Watch List',2,1,'2014-04-09 13:34:18','2014-04-09 13:34:18',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,148,1),(149,'Cicero Stehr\'s Watch List',2,1,'2014-04-09 13:34:18','2014-04-09 13:34:18',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,149,1),(150,'Iucn Reinger\'s Watch List',2,1,'2014-04-09 13:34:19','2014-04-09 13:34:19',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,150,1),(151,'Maritza Kuhic\'s Watch List',2,1,'2014-04-09 13:34:21','2014-04-09 13:34:21',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,151,1),(152,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:21','2014-04-09 13:34:21',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,152,1),(153,'Aidan Mills\'s Watch List',2,1,'2014-04-09 13:34:22','2014-04-09 13:34:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,153,1),(154,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:22','2014-04-09 13:34:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,154,1),(155,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:22','2014-04-09 13:34:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,155,1),(156,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:23','2014-04-09 13:34:23',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,156,1),(157,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:23','2014-04-09 13:34:23',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,157,1),(158,'Ming Spencer\'s Watch List',2,1,'2014-04-09 13:34:23','2014-04-09 13:34:23',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,158,1),(159,'Maritza Kuhic\'s Watch List',2,1,'2014-04-09 13:34:24','2014-04-09 13:34:24',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,159,1),(160,'Ralph Wiggum\'s Watch List',2,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,160,1),(161,'Benton Corwin\'s Watch List',2,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,161,1),(162,'Admin User\'s Watch List',2,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,162,1),(163,'Admin User\'s Watch List',2,1,'2014-04-09 13:34:27','2014-04-09 13:34:27',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,163,1),(164,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:28','2014-04-09 13:34:28',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,164,1),(165,'Kaitlin Larkin\'s Watch List',2,1,'2014-04-09 13:34:29','2014-04-09 13:34:29',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,165,1),(166,'Cicero Stehr\'s Watch List',2,1,'2014-04-09 13:34:29','2014-04-09 13:34:29',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,166,1),(167,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:29','2014-04-09 13:34:29',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,167,1),(168,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:29','2014-04-09 13:34:29',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,168,1),(169,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:30','2014-04-09 13:34:30',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,169,1),(170,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:30','2014-04-09 13:34:30',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,170,1),(171,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:31','2014-04-09 13:34:31',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,171,1),(172,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:31','2014-04-09 13:34:31',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,172,1),(173,'Test Curator\'s Watch List',2,1,'2014-04-09 13:34:31','2014-04-09 13:34:31',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,173,1),(174,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:33','2014-04-09 13:34:33',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,174,1),(175,'Ashley West\'s Watch List',2,1,'2014-04-09 13:34:33','2014-04-09 13:34:33',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,175,1),(176,'Maritza Kuhic\'s Watch List',2,1,'2014-04-09 13:34:34','2014-04-09 13:34:34',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,176,1),(177,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:34','2014-04-09 13:34:34',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,177,1),(178,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:34','2014-04-09 13:34:34',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,178,1),(179,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:35','2014-04-09 13:34:35',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,179,1),(180,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:35','2014-04-09 13:34:35',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,180,1),(181,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:35','2014-04-09 13:34:35',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,181,1),(182,'Rolfe Luettgen\'s Watch List',2,1,'2014-04-09 13:34:36','2014-04-09 13:34:36',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,182,1),(183,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:36','2014-04-09 13:34:36',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,183,1),(184,'Madelynn Beatty\'s Watch List',2,1,'2014-04-09 13:34:37','2014-04-09 13:34:37',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,184,1),(185,'Okey Mc Cullough\'s Watch List',2,1,'2014-04-09 13:34:37','2014-04-09 13:34:37',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,185,1),(186,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:37','2014-04-09 13:34:37',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,186,1),(187,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:38','2014-04-09 13:34:38',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,187,1),(188,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:38','2014-04-09 13:34:38',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,188,1),(189,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:38','2014-04-09 13:34:38',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,189,1),(190,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:39','2014-04-09 13:34:39',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,190,1),(191,'Jacky Welch\'s Watch List',2,1,'2014-04-09 13:34:39','2014-04-09 13:34:39',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,191,1),(192,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,192,1),(193,'Duane Leuschke\'s Watch List',2,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,193,1),(194,'Mariana Runolfsson\'s Watch List',2,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,194,1),(195,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:41','2014-04-09 13:34:41',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,195,1),(196,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:41','2014-04-09 13:34:41',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,196,1),(197,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:42','2014-04-09 13:34:42',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,197,1),(198,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:42','2014-04-09 13:34:42',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,198,1),(199,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:42','2014-04-09 13:34:42',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,199,1),(200,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:34:43','2014-04-09 13:34:43',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,200,1),(201,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,201,1),(202,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,202,1),(203,'Maritza Kuhic\'s Watch List',2,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,203,1),(204,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,204,1),(205,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:45','2014-04-09 13:34:45',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,205,1),(206,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:45','2014-04-09 13:34:45',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,206,1),(207,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:46','2014-04-09 13:34:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,207,1),(208,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:46','2014-04-09 13:34:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,208,1),(209,'Scot Hudson\'s Watch List',2,1,'2014-04-09 13:34:46','2014-04-09 13:34:46',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,209,1),(210,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:47','2014-04-09 13:34:47',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,210,1),(211,'Cicero Stehr\'s Watch List',2,1,'2014-04-09 13:34:47','2014-04-09 13:34:47',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,211,1),(212,'Ahmad Murphy\'s Watch List',2,1,'2014-04-09 13:34:48','2014-04-09 13:34:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,212,1),(213,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:48','2014-04-09 13:34:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,213,1),(214,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:48','2014-04-09 13:34:48',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,214,1),(215,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:49','2014-04-09 13:34:49',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,215,1),(216,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:49','2014-04-09 13:34:49',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,216,1),(217,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:49','2014-04-09 13:34:49',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,217,1),(218,'Greta Gleason\'s Watch List',2,1,'2014-04-09 13:34:50','2014-04-09 13:34:50',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,218,1),(219,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,219,1),(220,'Rhea Leffler\'s Watch List',2,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,220,1),(221,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,221,1),(222,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,222,1),(223,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:52','2014-04-09 13:34:52',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,223,1),(224,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:53','2014-04-09 13:34:53',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,224,1),(225,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:53','2014-04-09 13:34:53',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,225,1),(226,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:53','2014-04-09 13:34:53',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,226,1),(227,'Rasheed Skiles\'s Watch List',2,1,'2014-04-09 13:34:54','2014-04-09 13:34:54',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,227,1),(228,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:54','2014-04-09 13:34:54',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,228,1),(229,'Iucn Reinger\'s Watch List',2,1,'2014-04-09 13:34:55','2014-04-09 13:34:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,229,1),(230,'Electa Na\'s Watch List',2,1,'2014-04-09 13:34:55','2014-04-09 13:34:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,230,1),(231,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:55','2014-04-09 13:34:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,231,1),(232,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:55','2014-04-09 13:34:55',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,232,1),(233,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:56','2014-04-09 13:34:56',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,233,1),(234,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:56','2014-04-09 13:34:56',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,234,1),(235,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:56','2014-04-09 13:34:56',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,235,1),(236,'Seao Cummerata\'s Watch List',2,1,'2014-04-09 13:34:57','2014-04-09 13:34:57',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,236,1),(237,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,237,1),(238,'Mariana Runolfsson\'s Watch List',2,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,238,1),(239,'Admin User\'s Watch List',2,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,239,1),(240,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,240,1),(241,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:34:59','2014-04-09 13:34:59',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,241,1),(242,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:34:59','2014-04-09 13:34:59',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,242,1),(243,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:35:00','2014-04-09 13:35:00',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,243,1),(244,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:35:00','2014-04-09 13:35:00',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,244,1),(245,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:35:00','2014-04-09 13:35:00',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,245,1),(246,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:01','2014-04-09 13:35:01',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,246,1),(247,'Jon Schultz\'s Watch List',2,1,'2014-04-09 13:35:02','2014-04-09 13:35:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,247,1),(248,'Maybell Schneider\'s Watch List',2,1,'2014-04-09 13:35:02','2014-04-09 13:35:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,248,1),(249,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:02','2014-04-09 13:35:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,249,1),(250,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:02','2014-04-09 13:35:02',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,250,1),(251,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:03','2014-04-09 13:35:03',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,251,1),(252,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:03','2014-04-09 13:35:03',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,252,1),(253,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:04','2014-04-09 13:35:04',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,253,1),(254,'Spences Kulas\'s Watch List',2,1,'2014-04-09 13:35:04','2014-04-09 13:35:04',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,254,1),(255,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,255,1),(256,'Ralph Wiggum\'s Watch List',2,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,256,1),(257,'Benton Corwin\'s Watch List',2,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,257,1),(258,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,258,1),(259,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,259,1),(260,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:06','2014-04-09 13:35:06',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,260,1),(261,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:07','2014-04-09 13:35:07',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,261,1),(262,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:07','2014-04-09 13:35:07',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,262,1),(263,'Ahmae Kuhic\'s Watch List',2,1,'2014-04-09 13:35:07','2014-04-09 13:35:07',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,263,1),(264,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,264,1),(265,'Joshuah Ernser\'s Watch List',2,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,265,1),(266,'Eugene Mosciski\'s Watch List',2,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,266,1),(267,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:10','2014-04-09 13:35:10',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,267,1),(268,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:10','2014-04-09 13:35:10',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,268,1),(269,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:11','2014-04-09 13:35:11',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,269,1),(270,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:11','2014-04-09 13:35:11',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,270,1),(271,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:11','2014-04-09 13:35:11',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,271,1),(272,'Marianb Haley\'s Watch List',2,1,'2014-04-09 13:35:12','2014-04-09 13:35:12',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,272,1),(273,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,273,1),(274,'Helmes Beier\'s Watch List',2,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,274,1),(275,'Colt Stracke\'s Watch List',2,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,275,1),(276,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,276,1),(277,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:14','2014-04-09 13:35:14',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,277,1),(278,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:15','2014-04-09 13:35:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,278,1),(279,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:15','2014-04-09 13:35:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,279,1),(280,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:15','2014-04-09 13:35:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,280,1),(281,'Antonib Hoeger\'s Watch List',2,1,'2014-04-09 13:35:15','2014-04-09 13:35:15',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,281,1),(282,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:16','2014-04-09 13:35:16',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,282,1),(283,'Leonardo Schamberger\'s Watch List',2,1,'2014-04-09 13:35:17','2014-04-09 13:35:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,283,1),(284,'Janie Jacobs\'s Watch List',2,1,'2014-04-09 13:35:17','2014-04-09 13:35:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,284,1),(285,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:17','2014-04-09 13:35:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,285,1),(286,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:17','2014-04-09 13:35:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,286,1),(287,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:18','2014-04-09 13:35:18',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,287,1),(288,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:18','2014-04-09 13:35:18',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,288,1),(289,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:19','2014-04-09 13:35:19',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,289,1),(290,'Kaitlio Reinges\'s Watch List',2,1,'2014-04-09 13:35:19','2014-04-09 13:35:19',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,290,1),(291,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,291,1),(292,'Maritza Kuhic\'s Watch List',2,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,292,1),(293,'Okey Mc Cullough\'s Watch List',2,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,293,1),(294,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,294,1),(295,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,295,1),(296,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:21','2014-04-09 13:35:21',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,296,1),(297,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:22','2014-04-09 13:35:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,297,1),(298,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:22','2014-04-09 13:35:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,298,1),(299,'Camilb Cronb\'s Watch List',2,1,'2014-04-09 13:35:22','2014-04-09 13:35:22',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,299,1),(5709,'Cape Cod',NULL,1,'2014-04-09 13:35:30','2014-04-09 13:35:31',NULL,NULL,NULL,0,NULL,9,1,NULL,1,1,NULL,NULL),(5714,'User1\'s Watch List',2,1,'2014-04-10 09:50:38','2014-04-10 09:50:38',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,5714,1),(5715,'Admin1\'s Watch List',2,1,'2014-04-27 13:04:16','2014-04-27 13:04:17',NULL,NULL,NULL,0,NULL,NULL,1,NULL,1,0,5715,1);
/*!40000 ALTER TABLE `collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections_communities`
--

DROP TABLE IF EXISTS `collections_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collections_communities` (
  `collection_id` int(11) DEFAULT NULL,
  `community_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections_communities`
--

LOCK TABLES `collections_communities` WRITE;
/*!40000 ALTER TABLE `collections_communities` DISABLE KEYS */;
/*!40000 ALTER TABLE `collections_communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections_users`
--

DROP TABLE IF EXISTS `collections_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collections_users` (
  `collection_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections_users`
--

LOCK TABLES `collections_users` WRITE;
/*!40000 ALTER TABLE `collections_users` DISABLE KEYS */;
INSERT INTO `collections_users` VALUES (66,7),(67,3),(68,6),(69,7),(70,7),(71,7),(72,7),(73,7),(74,7),(75,9),(76,3),(77,8),(78,9),(79,9),(80,9),(81,9),(82,9),(83,9),(84,11),(85,5),(86,1),(87,11),(88,11),(89,11),(90,11),(91,11),(92,11),(93,13),(94,4),(95,8),(96,13),(97,13),(98,13),(99,13),(100,13),(101,13),(102,15),(103,2),(104,3),(105,15),(106,15),(107,15),(108,15),(109,15),(110,15),(111,17),(112,14),(113,14),(114,17),(115,17),(116,17),(117,17),(118,17),(119,17),(120,17),(121,17),(122,17),(123,17),(124,17),(125,17),(126,17),(127,18),(128,20),(129,22),(130,24),(131,26),(132,26),(133,26),(134,26),(135,26),(136,26),(137,26),(138,26),(139,26),(140,26),(141,26),(142,26),(143,26),(144,26),(145,28),(146,28),(147,28),(148,28),(149,30),(150,1),(151,31),(152,33),(153,17),(154,33),(155,33),(156,33),(157,33),(158,33),(159,31),(160,34),(161,35),(162,37),(163,37),(164,39),(165,10),(166,30),(167,39),(168,39),(169,39),(170,39),(171,39),(172,39),(173,41),(174,44),(175,23),(176,31),(177,44),(178,44),(179,44),(180,44),(181,44),(182,44),(183,46),(184,39),(185,27),(186,46),(187,46),(188,46),(189,46),(190,46),(191,46),(192,48),(193,42),(194,6),(195,48),(196,48),(197,48),(198,48),(199,48),(200,48),(201,50),(202,13),(203,31),(204,50),(205,50),(206,50),(207,50),(208,50),(209,50),(210,52),(211,30),(212,4),(213,52),(214,52),(215,52),(216,52),(217,52),(218,52),(219,54),(220,51),(221,26),(222,54),(223,54),(224,54),(225,54),(226,54),(227,54),(228,56),(229,1),(230,15),(231,56),(232,56),(233,56),(234,56),(235,56),(236,56),(237,58),(238,6),(239,37),(240,58),(241,58),(242,58),(243,58),(244,58),(245,58),(246,60),(247,48),(248,26),(249,60),(250,60),(251,60),(252,60),(253,60),(254,60),(255,62),(256,34),(257,35),(258,62),(259,62),(260,62),(261,62),(262,62),(263,62),(264,64),(265,7),(266,9),(267,64),(268,64),(269,64),(270,64),(271,64),(272,64),(273,66),(274,58),(275,13),(276,66),(277,66),(278,66),(279,66),(280,66),(281,66),(282,68),(283,28),(284,2),(285,68),(286,68),(287,68),(288,68),(289,68),(290,68),(291,70),(292,31),(293,27),(294,70),(295,70),(296,70),(297,70),(298,70),(299,70),(5709,71),(5714,78),(5715,79);
/*!40000 ALTER TABLE `collections_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_type` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `visible_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `from_curator` tinyint(1) NOT NULL,
  `hidden` tinyint(4) DEFAULT '0',
  `reply_to_type` varchar(32) DEFAULT NULL,
  `reply_to_id` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT '0',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `last_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_parent_id` (`parent_id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (78,3,7,'TaxonConcept','This is a witty comment on the Animalia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:40','2014-04-09 13:33:40','2014-04-06 07:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(79,6,7,'TaxonConcept','This is a witty comment on the Animalia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:40','2014-04-09 13:33:40','2014-04-06 06:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(80,7,2,'DataObject','Enim eos provident et ducimus eveniet. Tenetur qui itaque. Qui recusandae assumenda. Asperiores nulla sequi tempora itaque doloribus a est.','2014-04-09 13:33:41','2014-04-09 13:33:41','2014-04-06 05:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(81,7,3,'DataObject','Nisi ea vitae enim. Harum repellendus reprehenderit distinctio tenetur saepe. Ut recusandae est porro sed.','2014-04-09 13:33:41','2014-04-09 13:33:41','2014-04-06 04:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(82,7,7,'DataObject','Asperiores tempora a. Fugiat ut neque voluptatem est eaque et. Placeat aut voluptas velit ea.','2014-04-09 13:33:42','2014-04-09 13:33:42','2014-04-06 03:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(83,7,8,'DataObject','Enim vel cum rerum. Reiciendis tenetur magni ea molestiae quo. Sunt earum voluptate impedit deserunt ut fugiat eos.','2014-04-09 13:33:43','2014-04-09 13:33:43','2014-04-06 02:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(84,7,9,'DataObject','Rem doloribus et voluptatem in sit. Molestiae reprehenderit veritatis eveniet qui quisquam tempore quis. Iste velit beatae aut voluptates. Aliquid delectus voluptatum et impedit similique temporibus. Deleniti velit aut delectus omnis eius temporibus tempora.','2014-04-09 13:33:43','2014-04-09 13:33:43','2014-04-06 01:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(85,7,10,'DataObject','Est et molestias dolor. Sunt ab reprehenderit nihil. Unde minima quos expedita sit optio sequi.','2014-04-09 13:33:43','2014-04-09 13:33:43','2014-04-06 00:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(86,3,8,'TaxonConcept','This is a witty comment on the Autrecusandaees repudiandaeica taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:45','2014-04-09 13:33:45','2014-04-05 23:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(87,8,8,'TaxonConcept','This is a witty comment on the Autrecusandaees repudiandaeica taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:45','2014-04-09 13:33:45','2014-04-05 22:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(88,9,11,'DataObject','Aliquid deleniti aut. Earum sit voluptatibus nihil praesentium impedit perspiciatis. Illum officiis iusto facere cumque esse beatae. Omnis voluptatem velit. Velit deleniti dolor.','2014-04-09 13:33:45','2014-04-09 13:33:45','2014-04-05 21:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(89,9,12,'DataObject','Amet soluta recusandae nobis. Quia dolorem voluptatem velit ut odio dolore. Distinctio inventore eaque.','2014-04-09 13:33:46','2014-04-09 13:33:46','2014-04-05 20:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(90,9,16,'DataObject','Blanditiis ut sit itaque eos veritatis quisquam sapiente. Quasi necessitatibus velit animi. Consequatur dolorum dignissimos magni impedit veniam harum numquam. Veniam adipisci et. Recusandae molestias quia ipsa aspernatur consequatur error sed.','2014-04-09 13:33:46','2014-04-09 13:33:46','2014-04-05 19:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(91,9,17,'DataObject','Sit quis voluptatum non. Minima fugit veniam non hic. Non eaque quia inventore qui consequatur ea. Consequuntur exercitationem et aut id saepe dolor.','2014-04-09 13:33:46','2014-04-09 13:33:46','2014-04-05 18:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(92,9,18,'DataObject','Blanditiis iure aliquid reprehenderit reiciendis cumque dolores. Et tempore nobis ducimus doloribus id sit. Corrupti eum excepturi et odio. Et debitis unde eligendi rem ut.','2014-04-09 13:33:47','2014-04-09 13:33:47','2014-04-05 17:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(93,9,19,'DataObject','Et sed sed ut nemo. Doloremque dignissimos et qui modi facere autem ab. Aspernatur dignissimos sapiente. Quis tempora consequatur nihil nulla modi.','2014-04-09 13:33:47','2014-04-09 13:33:47','2014-04-05 16:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(94,5,9,'TaxonConcept','This is a witty comment on the Nihileri voluptasus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:48','2014-04-09 13:33:48','2014-04-05 15:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(95,1,9,'TaxonConcept','This is a witty comment on the Nihileri voluptasus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:48','2014-04-09 13:33:48','2014-04-05 14:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(96,11,20,'DataObject','Quos voluptatibus et culpa omnis unde nobis debitis. Iure doloremque unde voluptatem quidem vero. Vitae qui aspernatur quibusdam adipisci necessitatibus molestiae placeat.','2014-04-09 13:33:48','2014-04-09 13:33:48','2014-04-05 13:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(97,11,21,'DataObject','Inventore est et provident accusamus praesentium. Unde nisi suscipit dolorum. Distinctio ipsa est molestiae. Ullam praesentium illo. Autem minus voluptatem quas tempore vel suscipit molestias.','2014-04-09 13:33:49','2014-04-09 13:33:49','2014-04-05 12:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(98,11,25,'DataObject','Adipisci cum quaerat. Ipsam voluptate consequatur eum rem ipsa quis. Sed laboriosam delectus repellat ut ducimus. Rerum voluptatum esse.','2014-04-09 13:33:50','2014-04-09 13:33:50','2014-04-05 11:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(99,11,26,'DataObject','Eaque et ut beatae. Facilis ut tempore iste pariatur. Et quibusdam maxime vitae deserunt. Voluptatem reprehenderit odio in eveniet. Ut tenetur accusamus.','2014-04-09 13:33:50','2014-04-09 13:33:50','2014-04-05 10:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(100,11,27,'DataObject','Facere quos harum voluptas qui. Ea qui exercitationem eius pariatur nesciunt dolores. Necessitatibus sapiente accusamus earum libero rerum veniam quia. Nam dolore sapiente cum magni. Hic reiciendis voluptatem ratione error.','2014-04-09 13:33:50','2014-04-09 13:33:50','2014-04-05 09:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(101,11,28,'DataObject','Accusantium assumenda aut ipsa rerum voluptatem. In sed sunt omnis accusamus magni consequuntur. Molestiae eaque qui in ut quibusdam.','2014-04-09 13:33:50','2014-04-09 13:33:50','2014-04-05 08:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(102,4,10,'TaxonConcept','This is a witty comment on the Dignissimosii inutes taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:52','2014-04-09 13:33:52','2014-04-05 07:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(103,8,10,'TaxonConcept','This is a witty comment on the Dignissimosii inutes taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:52','2014-04-09 13:33:52','2014-04-05 06:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(104,13,29,'DataObject','Saepe sit qui atque fuga. Et possimus quaerat. Beatae ullam cum eum consequatur et. Ullam porro incidunt expedita.','2014-04-09 13:33:52','2014-04-09 13:33:52','2014-04-05 05:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(105,13,30,'DataObject','Itaque aut perspiciatis voluptatem unde. Voluptatem vitae tempore necessitatibus et. Aut pariatur optio accusamus odit at autem.','2014-04-09 13:33:52','2014-04-09 13:33:52','2014-04-05 04:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(106,13,34,'DataObject','Eos voluptas porro sit aperiam rerum vitae. Doloribus quisquam vero. Ut voluptatum delectus repellat nesciunt accusantium facilis deserunt.','2014-04-09 13:33:53','2014-04-09 13:33:53','2014-04-05 03:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(107,13,35,'DataObject','Molestiae et cumque sit atque ipsum magnam ipsam. Dolores sed at. Voluptas vitae consectetur quae atque ratione. Sapiente adipisci eligendi qui distinctio ex voluptatem. Eos velit rem quia quae porro quidem odio.','2014-04-09 13:33:53','2014-04-09 13:33:53','2014-04-05 02:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(108,13,36,'DataObject','Modi in fugit quidem autem ullam. Atque voluptates illo. Culpa autem ea quam quo facere architecto optio.','2014-04-09 13:33:54','2014-04-09 13:33:54','2014-04-05 01:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(109,13,37,'DataObject','Eaque fugiat velit ut et atque a quia. Quidem tempora id accusamus beatae. Cum qui est minima. Itaque iusto facere voluptatem. Aspernatur et velit unde rerum in.','2014-04-09 13:33:54','2014-04-09 13:33:54','2014-04-05 00:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(110,2,11,'TaxonConcept','This is a witty comment on the Fugais utharumatus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:55','2014-04-09 13:33:55','2014-04-04 23:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(111,3,11,'TaxonConcept','This is a witty comment on the Fugais utharumatus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:55','2014-04-09 13:33:55','2014-04-04 22:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(112,15,38,'DataObject','Sit fugit est beatae quos non. Adipisci beatae rerum. Est voluptatem nisi illo dolorem. Voluptatem velit illum quis magnam repudiandae.','2014-04-09 13:33:55','2014-04-09 13:33:55','2014-04-04 21:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(113,15,39,'DataObject','Fugiat repudiandae quas iste temporibus delectus. Aut nisi ea qui ut. Enim incidunt accusamus enim.','2014-04-09 13:33:56','2014-04-09 13:33:56','2014-04-04 20:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(114,15,43,'DataObject','A ex facilis temporibus qui facere incidunt ut. Consequatur iure quia sit optio sit. Voluptates sit ea aut voluptatem magnam provident natus. Totam accusamus dolore dolor velit sint ut atque.','2014-04-09 13:33:57','2014-04-09 13:33:57','2014-04-04 19:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(115,15,44,'DataObject','Aperiam minima ducimus est ut fugit omnis est. Expedita necessitatibus molestiae dolorum qui. Dignissimos quo error. Voluptatem cupiditate velit suscipit facere perferendis quos iste. Et libero explicabo vitae aspernatur dolores nesciunt.','2014-04-09 13:33:57','2014-04-09 13:33:57','2014-04-04 18:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(116,15,45,'DataObject','Dolores ducimus asperiores ut maiores enim non enim. Non fugit ipsum quo. Dolorem ipsum occaecati voluptas libero. Est repudiandae harum soluta. Dicta amet fugiat dolorem eius debitis.','2014-04-09 13:33:57','2014-04-09 13:33:57','2014-04-04 17:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(117,15,46,'DataObject','Ratione quo sed incidunt. Iure sunt eos doloribus non perferendis voluptas incidunt. Deleniti dolor veritatis atque inventore commodi.','2014-04-09 13:33:58','2014-04-09 13:33:58','2014-04-04 16:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(118,14,12,'TaxonConcept','This is a witty comment on the Minuseli ullamens taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 15:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(119,14,12,'TaxonConcept','This is a witty comment on the Minuseli ullamens taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 14:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(120,17,47,'DataObject','First comment','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 13:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(121,17,47,'DataObject','Officiis voluptatem iusto veniam occaecati possimus placeat. Possimus pariatur repellat. Et et corporis rerum. Dolor fugiat odit nisi. Nulla qui facere soluta et omnis ad.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 12:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(122,17,47,'DataObject','Aut voluptate deleniti. Officia in cumque magni. Molestias praesentium voluptatem natus. Impedit sit aut. Quasi nam sit.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 11:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(123,17,47,'DataObject','Et doloribus tempora. Omnis molestiae mollitia expedita ducimus numquam iure. Quasi culpa est quibusdam doloribus perferendis. Recusandae ea eos consequatur. Vel minima aspernatur.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 10:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(124,17,47,'DataObject','Inventore earum id consequatur qui aut. Iste aspernatur sed omnis. Ratione mollitia optio. Eaque sed dignissimos.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 09:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(125,17,47,'DataObject','Totam velit voluptas. Est est est voluptatibus et expedita mollitia non. Aliquam quis ut ea doloremque tempore natus molestias.','2014-04-09 13:33:59','2014-04-09 13:33:59','2014-04-04 08:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(126,17,47,'DataObject','Autem voluptatum qui quae incidunt asperiores occaecati similique. Beatae libero et modi eos aut dolorem. Qui aut consectetur explicabo ut qui. Debitis aliquid provident.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 07:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(127,17,47,'DataObject','Ut possimus doloribus nulla ut qui quo. Quis placeat mollitia ut. Ut et ad dolor voluptatem velit. Temporibus culpa expedita praesentium hic.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 06:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(128,17,47,'DataObject','Reprehenderit provident ipsa quod laudantium. Perspiciatis fugiat ex mollitia voluptas. Hic et similique natus autem. Minus aut quis enim temporibus officia.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 05:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(129,17,47,'DataObject','Corrupti blanditiis sequi. Autem sequi dolorem architecto. Consequatur eos voluptatum inventore debitis. Repudiandae consectetur sapiente quis qui nisi repellat quos. Unde aperiam quis molestiae qui accusantium quia quisquam.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 04:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(130,17,47,'DataObject','Dolorem corrupti sed. Nam est atque laboriosam dolor voluptatem et. In rerum possimus voluptatem qui at. Dolorum et vel omnis sit voluptatem.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 03:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(131,17,47,'DataObject','In eum dolor sed temporibus qui. Qui ut vel cumque aut. Repellat saepe esse temporibus ut magnam minima.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 02:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(132,17,48,'DataObject','Asperiores voluptatem quam ab. Aut et quia ad velit. Eum vitae ullam eos aut dolorem praesentium numquam.','2014-04-09 13:34:00','2014-04-09 13:34:00','2014-04-04 01:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(133,17,49,'DataObject','Sint ducimus unde sint esse. Veniam ipsam possimus necessitatibus consequatur sit quis. Consequatur quo et enim possimus.','2014-04-09 13:34:01','2014-04-09 13:34:01','2014-04-04 00:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(134,17,50,'DataObject','Iste omnis soluta facilis eligendi asperiores dignissimos. Quasi inventore blanditiis eligendi consequatur. Placeat vitae autem qui.','2014-04-09 13:34:01','2014-04-09 13:34:01','2014-04-03 23:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(135,17,51,'DataObject','Quo assumenda facere. Nesciunt dolores non. Vitae quod cupiditate ex est officiis tempora. Suscipit qui nobis ut. Ipsum enim aut quis.','2014-04-09 13:34:01','2014-04-09 13:34:01','2014-04-03 22:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(136,17,52,'DataObject','Amet eos cupiditate earum vel. Sed tempore quisquam. Deserunt odit debitis cumque voluptates.','2014-04-09 13:34:02','2014-04-09 13:34:02','2014-04-03 21:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(137,17,53,'DataObject','Accusantium aut labore fugiat enim et qui. Qui quia a et velit reprehenderit quis. Animi eius non inventore dolores. Et aspernatur sed sint non porro nesciunt mollitia.','2014-04-09 13:34:02','2014-04-09 13:34:02','2014-04-03 20:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(138,17,54,'DataObject','Iste aspernatur omnis quibusdam. Repudiandae amet voluptatem dolor. Tempora omnis fugiat vel nihil. Quo maxime cumque dolorem totam dolores porro facilis. Error et repellat qui.','2014-04-09 13:34:02','2014-04-09 13:34:02','2014-04-03 19:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(139,17,55,'DataObject','Quis consequatur eum soluta maiores dignissimos ad. Ea laboriosam adipisci quibusdam sunt. Ut voluptates quia cupiditate harum. Aliquid est qui ut quos cumque aperiam. Harum quibusdam sed voluptas aut sapiente quam.','2014-04-09 13:34:02','2014-04-09 13:34:02','2014-04-03 18:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(140,17,59,'DataObject','Minus temporibus reiciendis sunt ratione quo recusandae. Aut natus odio iusto velit ea non. Distinctio deserunt et expedita. Reprehenderit laborum ipsam deleniti et omnis.','2014-04-09 13:34:03','2014-04-09 13:34:03','2014-04-03 17:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(141,17,60,'DataObject','Architecto veniam libero eveniet. Et beatae non rem est. Dicta a amet quasi quia. Similique nihil laboriosam qui quos. Et sit voluptas ad.','2014-04-09 13:34:03','2014-04-09 13:34:03','2014-04-03 16:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(142,17,61,'DataObject','Sint minus occaecati accusamus error ab. Vel dolores ducimus soluta sunt. Et nam similique in dolore voluptatum.','2014-04-09 13:34:04','2014-04-09 13:34:04','2014-04-03 15:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(143,17,62,'DataObject','Mollitia numquam qui corporis quidem iste voluptate. Itaque enim saepe est eum quisquam sed. Autem praesentium voluptatem deserunt fugiat optio. Illum in fugit.','2014-04-09 13:34:04','2014-04-09 13:34:04','2014-04-03 14:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(144,18,47,'DataObject','Second comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 13:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(145,18,47,'DataObject','Third comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 12:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(146,18,47,'DataObject','Forth comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 11:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(147,18,47,'DataObject','Fifth comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 10:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(148,18,47,'DataObject','Sixth comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 09:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(149,18,47,'DataObject','Seventh comment','2014-04-09 13:34:05','2014-04-09 13:34:05','2014-04-03 08:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(150,18,47,'DataObject','Eighth comment','2014-04-09 13:34:06','2014-04-09 13:34:06','2014-04-03 07:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(151,18,47,'DataObject','Nineth comment','2014-04-09 13:34:06','2014-04-09 13:34:06','2014-04-03 06:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(152,18,47,'DataObject','Tenth comment','2014-04-09 13:34:06','2014-04-09 13:34:06','2014-04-03 05:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(153,18,47,'DataObject','Eleventh comment','2014-04-09 13:34:06','2014-04-09 13:34:06','2014-04-03 04:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(154,18,47,'DataObject','Twelveth comment','2014-04-09 13:34:06','2014-04-09 13:34:06','2014-04-03 03:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(155,26,66,'DataObject','Illum nostrum sint esse sed tempora. Eaque voluptatem quod et consequatur voluptate nam. Eum id enim modi impedit adipisci ea. Ipsam eos rem corrupti pariatur sit.','2014-04-09 13:34:10','2014-04-09 13:34:10','2014-04-03 02:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(156,26,66,'DataObject','Eius id sunt. Dolorem debitis et libero autem. Occaecati id sunt non quo. Autem accusamus porro.','2014-04-09 13:34:10','2014-04-09 13:34:10','2014-04-03 01:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(157,26,66,'DataObject','Aut sit officiis eveniet voluptates amet minus labore. Consequatur nisi numquam distinctio omnis rerum. Sed voluptas illo eius.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-03 00:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(158,26,66,'DataObject','Sunt et fugit cum. Alias similique illum at omnis. Neque sed nam error eum. Dolores sed ea dignissimos quis quia aut.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 23:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(159,26,66,'DataObject','Omnis voluptatem veniam blanditiis et minus. Ullam ipsa minima facere molestiae ut provident. Doloremque repellat libero omnis id delectus. Excepturi et at sint. Suscipit rerum magni.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 22:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(160,26,66,'DataObject','Et vero molestiae consequuntur rerum ut ipsa fugiat. Debitis facilis harum quia doloribus accusantium. Harum sed quam soluta. Similique dolores molestias voluptas rerum cumque qui.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 21:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(161,26,66,'DataObject','Est officia hic totam consequatur neque. Natus et nam porro quos et velit. Voluptatem quis necessitatibus deleniti est. Aut mollitia pariatur quis.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 20:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(162,26,66,'DataObject','Et est blanditiis enim veniam modi. Error voluptates dolorem eveniet laudantium minima quis sequi. Sit voluptatibus velit necessitatibus. Officiis est aut aut cumque laborum. Perferendis molestias eum sint est ut.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 19:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(163,26,66,'DataObject','Doloremque quisquam iusto. Provident quibusdam incidunt quisquam ratione qui qui. Veritatis sit velit non quibusdam qui. Quis et pariatur eum culpa repudiandae.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 18:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(164,26,66,'DataObject','Fugiat et exercitationem reprehenderit. Nisi non eum officiis consequuntur maiores. Error et et velit veniam libero ut. Minus excepturi vel impedit tempore.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 17:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(165,26,66,'DataObject','Minus ut temporibus omnis saepe beatae. Eius nemo ut. Qui enim eligendi a.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 16:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(166,26,66,'DataObject','Sint amet velit. Deleniti et quod quae vero. Omnis vitae enim. Suscipit dolor dolorem. Nisi magni quia culpa.','2014-04-09 13:34:11','2014-04-09 13:34:11','2014-04-02 15:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(167,26,67,'DataObject','Vel rerum reiciendis. Cumque voluptatibus placeat voluptate ipsa dolorem. Officiis soluta reprehenderit ut doloribus cupiditate.','2014-04-09 13:34:12','2014-04-09 13:34:12','2014-04-02 14:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(168,26,68,'DataObject','Atque est voluptatem. Id laboriosam adipisci aut dolorem sapiente. Mollitia tempore pariatur sed. Corporis enim vero in quo est.','2014-04-09 13:34:12','2014-04-09 13:34:12','2014-04-02 13:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(169,26,69,'DataObject','Reiciendis architecto et iste. Iusto est eligendi dolorem rerum ducimus. Sunt repellat assumenda porro delectus. Omnis incidunt labore sit ab modi voluptatem ipsam. Omnis dolorem sunt.','2014-04-09 13:34:12','2014-04-09 13:34:12','2014-04-02 12:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(170,26,70,'DataObject','Quia voluptas saepe quibusdam. Laudantium eum omnis voluptatem error. Et ut omnis. Molestias soluta temporibus eligendi eos modi non aut.','2014-04-09 13:34:13','2014-04-09 13:34:13','2014-04-02 11:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(171,26,71,'DataObject','Molestiae qui recusandae dolor vero cupiditate asperiores nostrum. Tenetur facere sint. Vel facilis quisquam.','2014-04-09 13:34:13','2014-04-09 13:34:13','2014-04-02 10:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(172,26,72,'DataObject','Sit tenetur sapiente perspiciatis architecto iusto voluptas magnam. Harum ea nulla ea quasi commodi voluptatem. Voluptatem dolor fugiat quam ut. Sit consequuntur aut aut similique accusamus accusantium hic. Nemo id optio iste.','2014-04-09 13:34:13','2014-04-09 13:34:13','2014-04-02 09:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(173,26,73,'DataObject','Delectus voluptas molestias sed magni. Doloremque soluta quo iure quaerat libero quia sit. Nam omnis quia veniam necessitatibus voluptatum voluptatem. Et facilis consequuntur deleniti ipsum ad. Et commodi rerum.','2014-04-09 13:34:13','2014-04-09 13:34:13','2014-04-02 08:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(174,26,74,'DataObject','Voluptatem aut itaque ducimus magni. Modi est numquam necessitatibus et magni. Voluptatem fugiat alias et suscipit fugit.','2014-04-09 13:34:14','2014-04-09 13:34:14','2014-04-02 07:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(175,26,78,'DataObject','Laudantium harum amet ea. Velit quo et iusto. Et eligendi dicta voluptatem accusantium temporibus.','2014-04-09 13:34:14','2014-04-09 13:34:14','2014-04-02 06:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(176,26,79,'DataObject','Rerum quam dolores dolores. Quaerat ipsam explicabo modi excepturi dolorem. Ut est tempore ut nam voluptatibus ut soluta. Aut soluta incidunt quis voluptas molestias. Perferendis assumenda culpa et omnis nobis qui.','2014-04-09 13:34:15','2014-04-09 13:34:15','2014-04-02 05:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(177,26,80,'DataObject','A asperiores modi at. Voluptatibus autem sint dolore soluta eligendi eveniet eaque. Ratione beatae sint sed iure culpa. Voluptatum sit voluptates doloribus quos voluptatem mollitia.','2014-04-09 13:34:15','2014-04-09 13:34:15','2014-04-02 04:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(178,26,81,'DataObject','Tenetur consequuntur ab et. Assumenda qui consequuntur sunt. Architecto atque aut dolores ab sapiente voluptate eligendi. Eius ratione magni numquam est nobis officiis.','2014-04-09 13:34:15','2014-04-09 13:34:15','2014-04-02 03:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(179,28,82,'DataObject','Voluptatem quidem architecto velit et. Voluptatum optio ullam quisquam. Mollitia deserunt ipsam. Sunt aut possimus totam reiciendis esse omnis. Accusantium aut quia expedita sequi numquam molestias sint.','2014-04-09 13:34:16','2014-04-09 13:34:16','2014-04-02 02:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(180,28,88,'DataObject','Necessitatibus qui dolor. Perferendis et voluptatem sequi aliquid et. Praesentium vitae quos. Cum vel accusamus nihil quaerat.','2014-04-09 13:34:17','2014-04-09 13:34:17','2014-04-02 01:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(181,28,89,'DataObject','Enim consequuntur unde quas nisi eos explicabo dolorem. Et vel cumque porro et et. Quisquam amet quo ex suscipit aperiam excepturi. Et perferendis ducimus iure quia voluptatem dolorum. Culpa praesentium molestiae ipsam dignissimos laboriosam exercitationem.','2014-04-09 13:34:18','2014-04-09 13:34:18','2014-04-02 00:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(182,1,88,'DataObject','this is a comment applied to the old overview','2014-04-09 13:34:19','2014-04-09 13:34:19','2014-04-01 23:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(183,1,88,'DataObject','this is an invisible comment applied to the old overview',NULL,'2014-04-09 13:34:19','2014-04-01 22:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(184,1,82,'DataObject','this is a comment applied to the old image','2014-04-09 13:34:20','2014-04-09 13:34:20','2014-04-01 21:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(185,1,82,'DataObject','this is an invisible comment applied to the old image',NULL,'2014-04-09 13:34:20','2014-04-01 20:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(186,1,90,'DataObject','brand new comment on the re-harvested overview','2014-04-09 13:34:20','2014-04-09 13:34:20','2014-04-01 19:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(187,1,90,'DataObject','and an invisible comment on the re-harvested overview',NULL,'2014-04-09 13:34:20','2014-04-01 18:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(188,1,91,'DataObject','lovely comment added after re-harvesting to the image','2014-04-09 13:34:21','2014-04-09 13:34:21','2014-04-01 17:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(189,1,91,'DataObject','even wittier invisible comments on image after the harvest was redone.',NULL,'2014-04-09 13:34:21','2014-04-01 16:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(190,17,18,'TaxonConcept','This is a witty comment on the Autaliquideri minimais taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:22','2014-04-09 13:34:22','2014-04-01 15:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(191,33,92,'DataObject','Ab est et et quidem ut. Non et vitae eaque. Velit ut aut natus autem. Maxime ipsam asperiores ut et corporis.','2014-04-09 13:34:22','2014-04-09 13:34:22','2014-04-01 14:35:28',0,0,NULL,NULL,0,NULL,NULL,NULL),(192,33,93,'DataObject','Perspiciatis quia eveniet fuga et non in ut. Culpa quia ex corrupti necessitatibus assumenda quaerat. Rerum quis dolores facilis pariatur non. Impedit rerum explicabo modi ut omnis rem. Provident ut qui aperiam consequatur nostrum.','2014-04-09 13:34:22','2014-04-09 13:34:22','2014-04-01 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(193,33,97,'DataObject','Vel exercitationem odit corporis ut repellat. Enim deleniti consequatur veritatis doloremque ipsa iste dolorum. Nam suscipit dicta adipisci natus eum labore repudiandae. Exercitationem asperiores nobis est consectetur at qui totam.','2014-04-09 13:34:23','2014-04-09 13:34:23','2014-04-01 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(194,33,98,'DataObject','Et et repudiandae et ut reiciendis reprehenderit. Dolor modi laudantium quas debitis distinctio sed. Et eligendi corrupti maxime quia vel reiciendis qui. Est soluta rem incidunt itaque aut veniam.','2014-04-09 13:34:23','2014-04-09 13:34:23','2014-04-01 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(195,33,99,'DataObject','Impedit ex sint nihil fugiat reprehenderit magnam. Deleniti ut tenetur. Est sit tenetur animi nisi mollitia. Ex officiis dolorem earum et.','2014-04-09 13:34:23','2014-04-09 13:34:23','2014-04-01 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(196,31,99,'DataObject','First comment','2014-04-09 13:34:24','2014-04-09 13:34:24','2014-04-01 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(197,31,99,'DataObject','Second comment','2014-04-09 13:34:24','2014-04-09 13:34:24','2014-04-01 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(198,31,99,'DataObject','Third comment','2014-04-09 13:34:24','2014-04-09 13:34:24','2014-04-01 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(199,31,99,'DataObject','Forth comment','2014-04-09 13:34:24','2014-04-09 13:34:24','2014-04-01 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(200,31,99,'DataObject','Fifth comment','2014-04-09 13:34:24','2014-04-09 13:34:24','2014-04-01 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(201,31,99,'DataObject','Sixth comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-04-01 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(202,31,99,'DataObject','Seventh comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-04-01 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(203,31,99,'DataObject','Eighth comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-04-01 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(204,31,99,'DataObject','Ninth comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-04-01 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(205,31,99,'DataObject','Tenth comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-04-01 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(206,31,99,'DataObject','Eleventh comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-03-31 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(207,31,99,'DataObject','Twelfth comment','2014-04-09 13:34:25','2014-04-09 13:34:25','2014-03-31 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(208,35,100,'DataObject','Eum corrupti dolorum rerum animi atque ea et. Et quasi fugiat atque optio deserunt quo. Cumque quis enim et dignissimos laborum qui est. Fuga explicabo porro illum sapiente. Fugiat et esse.','2014-04-09 13:34:26','2014-04-09 13:34:26','2014-03-31 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(209,10,20,'TaxonConcept','This is a witty comment on the Etconsequaturelia autenimalia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:29','2014-04-09 13:34:29','2014-03-31 20:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(210,30,20,'TaxonConcept','This is a witty comment on the Etconsequaturelia autenimalia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:29','2014-04-09 13:34:29','2014-03-31 19:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(211,39,101,'DataObject','Quod qui magni nobis eum quidem illum. Quisquam aut porro qui veniam id voluptatibus. Totam saepe sint omnis. Consequuntur excepturi accusantium sunt quae.','2014-04-09 13:34:29','2014-04-09 13:34:29','2014-03-31 18:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(212,39,102,'DataObject','Et numquam voluptatum facere similique quis. Reprehenderit maxime repellendus animi. Voluptate deserunt inventore et est ut. Dolores nesciunt qui consequatur eos cum deleniti.','2014-04-09 13:34:29','2014-04-09 13:34:29','2014-03-31 17:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(213,39,106,'DataObject','Qui inventore dolorem minus est. Ad veritatis veniam fuga fugiat et. Tempore aut quae voluptates ex. Consequatur dolor vel cupiditate vero est quaerat. Ut aut dolor saepe omnis quis beatae.','2014-04-09 13:34:30','2014-04-09 13:34:30','2014-03-31 16:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(214,39,107,'DataObject','Quae impedit natus sed doloribus quia facilis sunt. Est eos voluptas. Dolores aut dolorum amet iste labore.','2014-04-09 13:34:30','2014-04-09 13:34:30','2014-03-31 15:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(215,39,108,'DataObject','Dignissimos iusto voluptate aliquid laudantium reiciendis omnis. Tenetur tempore dolores blanditiis sint ab et. Doloremque et quo et.','2014-04-09 13:34:31','2014-04-09 13:34:31','2014-03-31 14:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(216,39,109,'DataObject','Magnam ut voluptates in velit distinctio occaecati odio. Aut deleniti omnis vero. Adipisci voluptates ut in quos et cumque dolore.','2014-04-09 13:34:31','2014-04-09 13:34:31','2014-03-31 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(217,23,21,'TaxonConcept','This is a witty comment on the Eukaryota taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:33','2014-04-09 13:34:33','2014-03-31 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(218,31,21,'TaxonConcept','This is a witty comment on the Eukaryota taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:34','2014-04-09 13:34:34','2014-03-31 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(219,44,110,'DataObject','Aut fugit iste qui officiis tempore ad eum. Cumque quam debitis rem dolore earum. Hic nulla eligendi error quia quo officia veniam. Expedita inventore possimus dicta aut qui.','2014-04-09 13:34:34','2014-04-09 13:34:34','2014-03-31 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(220,44,111,'DataObject','Ullam qui ab qui pariatur mollitia. Voluptatum aliquid ab voluptatem. Nobis sed voluptate corporis totam praesentium eum. Aperiam quibusdam eos.','2014-04-09 13:34:34','2014-04-09 13:34:34','2014-03-31 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(221,44,115,'DataObject','Eum quasi numquam quos animi aliquam impedit odio. Et officiis sint voluptatem nobis aliquam. Placeat quod quo. Fugit maxime assumenda et praesentium. Quaerat occaecati similique dolorem ea aut voluptatem molestiae.','2014-04-09 13:34:35','2014-04-09 13:34:35','2014-03-31 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(222,44,116,'DataObject','Beatae et quia reiciendis repellendus consequuntur. Aspernatur quibusdam sapiente eveniet quo. Tempore ea quod rem nesciunt. Omnis nesciunt et enim et aspernatur ea.','2014-04-09 13:34:35','2014-04-09 13:34:35','2014-03-31 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(223,44,117,'DataObject','Non consequatur dolorem vel placeat et at aut. Accusantium esse quas dolores qui fugiat dolore. Error voluptatem maiores atque sequi. Odit delectus aperiam esse autem. Modi est qui id incidunt ab dignissimos.','2014-04-09 13:34:35','2014-04-09 13:34:35','2014-03-31 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(224,44,118,'DataObject','Dolorum dolore dolor. Fugit deserunt provident corrupti est rerum et. Aut recusandae est dolor qui. Laborum ea et et ut autem quos.','2014-04-09 13:34:36','2014-04-09 13:34:36','2014-03-31 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(225,39,22,'TaxonConcept','This is a witty comment on the Quoautesi natuseri taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:37','2014-04-09 13:34:37','2014-03-31 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(226,27,22,'TaxonConcept','This is a witty comment on the Quoautesi natuseri taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:37','2014-04-09 13:34:37','2014-03-31 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(227,46,119,'DataObject','Quidem vel laborum. Ea suscipit omnis ut. Qui fuga laboriosam fugiat quia ut repellendus.','2014-04-09 13:34:37','2014-04-09 13:34:37','2014-03-31 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(228,46,120,'DataObject','Sequi inventore nihil repudiandae et eaque assumenda. Voluptatem itaque aperiam. Ex consequuntur dignissimos quaerat. Iusto animi accusantium.','2014-04-09 13:34:38','2014-04-09 13:34:38','2014-03-31 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(229,46,124,'DataObject','Aliquid beatae iusto doloribus placeat assumenda. Culpa tempore aliquid quas et. Veritatis asperiores temporibus aut deleniti.','2014-04-09 13:34:38','2014-04-09 13:34:38','2014-03-31 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(230,46,125,'DataObject','Voluptatem assumenda aut enim numquam. Et pariatur est. Consequatur dignissimos magnam quod.','2014-04-09 13:34:38','2014-04-09 13:34:38','2014-03-30 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(231,46,126,'DataObject','Numquam a ut deserunt at ea. Voluptatem error ipsa maiores. Vel dolorem nobis dolore. Eum nesciunt quas.','2014-04-09 13:34:39','2014-04-09 13:34:39','2014-03-30 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(232,46,127,'DataObject','Voluptatibus et est sunt. Sint vel consequuntur vel iure non. Qui incidunt quaerat similique dolorum reprehenderit non pariatur.','2014-04-09 13:34:39','2014-04-09 13:34:39','2014-03-30 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(233,42,23,'TaxonConcept','This is a witty comment on the Voluptatumeri esseensis taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:40','2014-04-09 13:34:40','2014-03-30 20:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(234,6,23,'TaxonConcept','This is a witty comment on the Voluptatumeri esseensis taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:40','2014-04-09 13:34:40','2014-03-30 19:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(235,48,128,'DataObject','Fuga eos aut nulla et praesentium. Ut omnis molestiae nihil. Corporis ab doloribus tempora et quas voluptatum ut. Non eveniet dolorem.','2014-04-09 13:34:41','2014-04-09 13:34:41','2014-03-30 18:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(236,48,129,'DataObject','Quia voluptatem quis. Voluptatem accusantium veritatis et illo. Debitis cupiditate quaerat molestias est ratione quidem.','2014-04-09 13:34:41','2014-04-09 13:34:41','2014-03-30 17:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(237,48,133,'DataObject','Deleniti nulla sit aut consectetur corrupti quo ex. Architecto eveniet cupiditate et nesciunt doloribus nihil non. Amet doloremque voluptas voluptatem nostrum natus.','2014-04-09 13:34:42','2014-04-09 13:34:42','2014-03-30 16:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(238,48,134,'DataObject','Deleniti voluptatum quod corrupti. Qui recusandae corrupti itaque voluptas dolor modi facere. Id nihil magni non. Quis magni accusantium provident iste.','2014-04-09 13:34:42','2014-04-09 13:34:42','2014-03-30 15:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(239,48,135,'DataObject','Debitis ut saepe. At qui placeat aspernatur. Quia eveniet aut esse rerum exercitationem quae.','2014-04-09 13:34:42','2014-04-09 13:34:42','2014-03-30 14:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(240,48,136,'DataObject','Error repudiandae corporis at et illum repellat sapiente. Perferendis quis rerum aut dignissimos laborum labore error. Magnam et nobis sed rerum nihil incidunt.','2014-04-09 13:34:43','2014-04-09 13:34:43','2014-03-30 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(241,13,24,'TaxonConcept','This is a witty comment on the Ameti maioresis taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:44','2014-04-09 13:34:44','2014-03-30 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(242,31,24,'TaxonConcept','This is a witty comment on the Ameti maioresis taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:44','2014-04-09 13:34:44','2014-03-30 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(243,50,137,'DataObject','Expedita ratione veritatis. Neque similique dicta nihil magni. Laborum est nulla voluptatem maxime magni sint.','2014-04-09 13:34:44','2014-04-09 13:34:44','2014-03-30 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(244,50,138,'DataObject','Repellat adipisci et vero assumenda voluptatem. Et ipsa enim non neque quia blanditiis id. Maxime consectetur natus fugit voluptatem ullam. Commodi ex in voluptate assumenda maiores laborum iste. Magni hic adipisci dolor.','2014-04-09 13:34:45','2014-04-09 13:34:45','2014-03-30 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(245,50,142,'DataObject','Architecto hic quo est laudantium ut. Voluptatibus hic consequuntur modi natus id sit. Dignissimos facilis magni. Tenetur dolor eos. Aspernatur illo porro qui dolores.','2014-04-09 13:34:45','2014-04-09 13:34:45','2014-03-30 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(246,50,143,'DataObject','Corrupti esse sed necessitatibus nobis assumenda quaerat. Autem doloribus quidem perspiciatis occaecati harum. Sequi ut voluptas nisi. Labore nisi optio numquam ut. Voluptatum vel culpa ut autem ut tenetur.','2014-04-09 13:34:46','2014-04-09 13:34:46','2014-03-30 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(247,50,144,'DataObject','Quo quia pariatur vero qui ipsum cupiditate. Non quam nesciunt aperiam quo voluptatem praesentium cum. Voluptas saepe rerum totam voluptas sit. Repellendus id labore ex voluptatem quo expedita.','2014-04-09 13:34:46','2014-04-09 13:34:46','2014-03-30 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(248,50,145,'DataObject','Rerum unde quibusdam vero officia. Ut et ut. Quis placeat eum ipsa. Nulla rem ad dicta voluptas sed. Dolorum error nihil.','2014-04-09 13:34:46','2014-04-09 13:34:46','2014-03-30 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(249,30,25,'TaxonConcept','This is a witty comment on the Ipsamalius distinctioerox taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:47','2014-04-09 13:34:47','2014-03-30 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(250,4,25,'TaxonConcept','This is a witty comment on the Ipsamalius distinctioerox taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:48','2014-04-09 13:34:48','2014-03-30 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(251,52,146,'DataObject','Maiores quam qui sapiente dolores. Tempore veritatis explicabo nesciunt error possimus ad. Tempora vero est ut aliquid enim.','2014-04-09 13:34:48','2014-04-09 13:34:48','2014-03-30 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(252,52,147,'DataObject','A doloribus qui voluptas accusantium incidunt magnam consequatur. Voluptas eos inventore. Aperiam est tempore repudiandae. Saepe illum consequatur quam repellendus aliquid.','2014-04-09 13:34:48','2014-04-09 13:34:48','2014-03-30 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(253,52,151,'DataObject','Incidunt totam quo ut ex harum perferendis. Quam voluptates totam laborum impedit doloribus sunt. Non natus rerum corrupti. Quas voluptatem distinctio molestiae ullam. Iure itaque voluptatem.','2014-04-09 13:34:49','2014-04-09 13:34:49','2014-03-30 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(254,52,152,'DataObject','Accusamus consequuntur eaque nihil et cumque et aut. Est nam vel fugit quidem. Occaecati quo minus. Saepe et dolorem debitis qui. Sunt nobis iusto magni nihil voluptatibus sint.','2014-04-09 13:34:49','2014-04-09 13:34:49','2014-03-29 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(255,52,153,'DataObject','Et quaerat qui autem unde est. Consequatur consectetur voluptas. Quaerat maiores ducimus iusto eligendi sapiente quod. Itaque in quia minus temporibus error commodi. Tenetur repellat quae aut sit exercitationem dolorem minima.','2014-04-09 13:34:49','2014-04-09 13:34:49','2014-03-29 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(256,52,154,'DataObject','Labore laudantium illum et saepe qui et dolores. Asperiores suscipit aperiam iste eum ipsa sequi porro. Consequatur quo quia. Nihil dolor exercitationem eos placeat ex.','2014-04-09 13:34:50','2014-04-09 13:34:50','2014-03-29 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(257,51,26,'TaxonConcept','This is a witty comment on the Maximees veritatisatus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:51','2014-04-09 13:34:51','2014-03-29 20:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(258,26,26,'TaxonConcept','This is a witty comment on the Maximees veritatisatus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:51','2014-04-09 13:34:51','2014-03-29 19:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(259,54,155,'DataObject','Praesentium eos omnis odio. Neque voluptatibus aspernatur dolores. Id amet est cumque dignissimos qui aliquid.','2014-04-09 13:34:51','2014-04-09 13:34:51','2014-03-29 18:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(260,54,156,'DataObject','Numquam fuga non est fugit quam. Sed sapiente labore. Perferendis voluptatem nulla maiores qui ratione.','2014-04-09 13:34:52','2014-04-09 13:34:52','2014-03-29 17:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(261,54,160,'DataObject','Quae et aut sunt quasi suscipit. Officiis ea corrupti. Sint ut qui nulla. Quam eos nulla incidunt architecto temporibus dolorum nesciunt.','2014-04-09 13:34:53','2014-04-09 13:34:53','2014-03-29 16:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(262,54,161,'DataObject','Rem ut optio quidem et provident. Qui vero excepturi provident quibusdam explicabo sed. Nam voluptatibus itaque quo.','2014-04-09 13:34:53','2014-04-09 13:34:53','2014-03-29 15:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(263,54,162,'DataObject','Dicta ipsam architecto quis voluptas consequatur deleniti. Amet eos fugiat velit molestiae id natus et. Qui eum veritatis molestiae tempora natus alias.','2014-04-09 13:34:53','2014-04-09 13:34:53','2014-03-29 14:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(264,54,163,'DataObject','Ducimus beatae sed cum. Enim nesciunt iste quas aliquam et. Earum et odit expedita non.','2014-04-09 13:34:54','2014-04-09 13:34:54','2014-03-29 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(265,1,27,'TaxonConcept','This is a witty comment on the Molestiaeus rationealia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:55','2014-04-09 13:34:55','2014-03-29 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(266,15,27,'TaxonConcept','This is a witty comment on the Molestiaeus rationealia taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:55','2014-04-09 13:34:55','2014-03-29 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(267,56,164,'DataObject','Illo placeat repellat esse. Assumenda eos aperiam. Reiciendis laboriosam eveniet perferendis minima corporis debitis. Voluptas sunt quia impedit. Ratione omnis at deserunt est.','2014-04-09 13:34:55','2014-04-09 13:34:55','2014-03-29 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(268,56,165,'DataObject','Doloremque similique suscipit et nostrum. Ea culpa ipsam exercitationem. Atque sunt minus mollitia quia quaerat deserunt. Delectus recusandae ratione et necessitatibus. Libero aspernatur et excepturi ab quod.','2014-04-09 13:34:55','2014-04-09 13:34:55','2014-03-29 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(269,56,169,'DataObject','Possimus dolorem vero architecto perspiciatis qui laborum. Est laboriosam facere sed earum illum. Nam neque debitis illum rerum architecto ea.','2014-04-09 13:34:56','2014-04-09 13:34:56','2014-03-29 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(270,56,170,'DataObject','Rem non animi aliquam odio earum maiores. Officiis ut delectus harum et placeat eum. Repellendus ut similique libero. Explicabo aut consectetur ab porro nihil dolores.','2014-04-09 13:34:56','2014-04-09 13:34:56','2014-03-29 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(271,56,171,'DataObject','Perspiciatis porro est ut. Ullam optio nostrum rerum autem quia inventore. Natus voluptatem velit.','2014-04-09 13:34:56','2014-04-09 13:34:56','2014-03-29 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(272,56,172,'DataObject','Totam sunt culpa. Reiciendis ut saepe modi. Aut illum ut molestias modi ipsum aliquid eos.','2014-04-09 13:34:57','2014-04-09 13:34:57','2014-03-29 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(273,6,28,'TaxonConcept','This is a witty comment on the Fugitens dolorealius taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:58','2014-04-09 13:34:58','2014-03-29 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(274,37,28,'TaxonConcept','This is a witty comment on the Fugitens dolorealius taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:34:58','2014-04-09 13:34:58','2014-03-29 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(275,58,173,'DataObject','Exercitationem eligendi maxime. Aut dolore perspiciatis porro qui. Officia quod a maxime officiis doloremque accusamus quia. Ut dolorem aut. Et consequuntur nobis eos aut hic voluptatem.','2014-04-09 13:34:58','2014-04-09 13:34:58','2014-03-29 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(276,58,174,'DataObject','Possimus qui minus ut sapiente voluptatibus enim distinctio. Quod cum nihil odio quis atque fugiat. Consequatur unde cupiditate adipisci. Quia eos dolores ut nihil autem. Inventore quia et aspernatur consequatur qui placeat.','2014-04-09 13:34:59','2014-04-09 13:34:59','2014-03-29 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(277,58,178,'DataObject','Architecto asperiores voluptatem et esse in laborum. Sint recusandae odio inventore et consequatur facere. Eos alias mollitia repellendus eius. Et aut itaque autem iste et non.','2014-04-09 13:34:59','2014-04-09 13:34:59','2014-03-29 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(278,58,179,'DataObject','Aliquam ea et. Et porro iure. Sint et quod. Unde et molestias eum excepturi in quia.','2014-04-09 13:35:00','2014-04-09 13:35:00','2014-03-28 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(279,58,180,'DataObject','Et autem est voluptatibus est. Dolorem qui neque cupiditate veritatis dolor accusantium omnis. Et aut molestias sint ipsum eum dolorem consequatur. Quis sunt nisi.','2014-04-09 13:35:00','2014-04-09 13:35:00','2014-03-28 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(280,58,181,'DataObject','Repellendus facere ad accusamus eaque occaecati nisi explicabo. Nostrum rem aut sapiente perspiciatis possimus. Aut perspiciatis consequuntur.','2014-04-09 13:35:00','2014-04-09 13:35:00','2014-03-28 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(281,48,29,'TaxonConcept','This is a witty comment on the Quisquamator sequieles taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:02','2014-04-09 13:35:02','2014-03-28 20:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(282,26,29,'TaxonConcept','This is a witty comment on the Quisquamator sequieles taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:02','2014-04-09 13:35:02','2014-03-28 19:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(283,60,182,'DataObject','Quod et est quo. Reiciendis perspiciatis quia ut eius autem dolores voluptatem. Molestiae laudantium omnis.','2014-04-09 13:35:02','2014-04-09 13:35:02','2014-03-28 18:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(284,60,183,'DataObject','Suscipit eos quibusdam temporibus qui. Asperiores quod corrupti voluptates animi impedit nam facere. Et et esse ut. Eveniet ducimus dolorem dolore sunt.','2014-04-09 13:35:02','2014-04-09 13:35:02','2014-03-28 17:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(285,60,187,'DataObject','Voluptatem consequatur odit quaerat ea. Velit consequatur fuga ducimus. Nam quasi reprehenderit itaque quia quia quos.','2014-04-09 13:35:03','2014-04-09 13:35:03','2014-03-28 16:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(286,60,188,'DataObject','Cumque ea enim sed aperiam. Consequatur dolores voluptatibus quibusdam qui ut. Saepe eveniet sint vel est ratione.','2014-04-09 13:35:03','2014-04-09 13:35:03','2014-03-28 15:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(287,60,189,'DataObject','Iusto enim aperiam fuga rerum pariatur provident autem. Molestiae eligendi et eos totam nesciunt. Ab ut velit. Qui voluptatem vel pariatur autem consequuntur.','2014-04-09 13:35:04','2014-04-09 13:35:04','2014-03-28 14:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(288,60,190,'DataObject','Itaque natus qui numquam. Debitis tempora molestiae tenetur. Qui labore consequatur consequatur voluptas aliquam dolorum.','2014-04-09 13:35:04','2014-04-09 13:35:04','2014-03-28 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(289,34,30,'TaxonConcept','This is a witty comment on the Bacteria taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:05','2014-04-09 13:35:05','2014-03-28 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(290,35,30,'TaxonConcept','This is a witty comment on the Bacteria taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:05','2014-04-09 13:35:05','2014-03-28 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(291,62,191,'DataObject','Voluptatem aspernatur repellendus et soluta quasi. Et modi esse magnam ducimus sunt quidem quis. Itaque qui ratione tenetur non omnis quaerat. Voluptas sint labore dolores aut aut ad. Est saepe ipsum nemo doloremque officia.','2014-04-09 13:35:05','2014-04-09 13:35:05','2014-03-28 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(292,62,192,'DataObject','Accusantium alias exercitationem quia omnis. Consectetur qui quia dolores itaque. Cupiditate qui dolorem explicabo ad. Dolorum animi debitis est dolore.','2014-04-09 13:35:05','2014-04-09 13:35:05','2014-03-28 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(293,62,196,'DataObject','Quod aut consequatur adipisci. Ea eligendi et nostrum neque. Quia aspernatur sunt iste aut beatae.','2014-04-09 13:35:06','2014-04-09 13:35:06','2014-03-28 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(294,62,197,'DataObject','Quam quibusdam voluptatum tempore. Qui vel qui. Distinctio et in officia et maxime. Consequuntur enim laborum quos.','2014-04-09 13:35:07','2014-04-09 13:35:07','2014-03-28 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(295,62,198,'DataObject','Ullam excepturi nisi doloremque quia. Velit facilis rerum ab placeat. Sed qui vitae provident reiciendis non. Impedit voluptates consectetur adipisci.','2014-04-09 13:35:07','2014-04-09 13:35:07','2014-03-28 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(296,62,199,'DataObject','Repellendus vero ut sint temporibus nisi ea sed. Quas aperiam sed est provident. Ut minima quasi dicta. Eius possimus perferendis exercitationem totam porro error.','2014-04-09 13:35:07','2014-04-09 13:35:07','2014-03-28 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(297,7,31,'TaxonConcept','This is a witty comment on the Essees eaqueata taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:09','2014-04-09 13:35:09','2014-03-28 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(298,9,31,'TaxonConcept','This is a witty comment on the Essees eaqueata taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:09','2014-04-09 13:35:09','2014-03-28 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(299,64,200,'DataObject','Modi nihil fugiat culpa. Sed nemo voluptas. Corrupti eum minus voluptates sed recusandae. Modi corporis nam.','2014-04-09 13:35:10','2014-04-09 13:35:10','2014-03-28 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(300,64,201,'DataObject','Fugiat rerum dolore nesciunt qui mollitia quod est. Dolores et vel repudiandae reprehenderit et perspiciatis. Illum culpa qui doloribus. Dolorum omnis deleniti rem quibusdam eius.','2014-04-09 13:35:10','2014-04-09 13:35:10','2014-03-28 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(301,64,205,'DataObject','Quas cum dolorem tempora animi minima non omnis. Eaque illum qui ducimus aut perspiciatis accusamus. Quos voluptas labore numquam et exercitationem.','2014-04-09 13:35:11','2014-04-09 13:35:11','2014-03-28 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(302,64,206,'DataObject','Ducimus minus quae est non dolorum aut. Libero facilis quidem quas ipsum quis nemo. Qui sit ut et dolores et illo.','2014-04-09 13:35:11','2014-04-09 13:35:11','2014-03-27 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(303,64,207,'DataObject','Ut molestias ducimus accusantium ea corporis molestiae nihil. Earum tempore distinctio sequi sit non numquam voluptatum. Enim nobis eaque itaque rem. Facere laudantium minus temporibus et soluta odit. Placeat atque aspernatur itaque sit ducimus voluptatem modi.','2014-04-09 13:35:11','2014-04-09 13:35:11','2014-03-27 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(304,64,208,'DataObject','Beatae porro assumenda accusamus. Velit dolor nisi ut. Ut deserunt reiciendis et ut dolores. Et aut porro hic libero quia omnis ipsum. Dolor similique aut placeat qui dolore.','2014-04-09 13:35:12','2014-04-09 13:35:12','2014-03-27 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(305,58,32,'TaxonConcept','This is a witty comment on the Animiens atdoloribuseron taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:13','2014-04-09 13:35:13','2014-03-27 20:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(306,13,32,'TaxonConcept','This is a witty comment on the Animiens atdoloribuseron taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:13','2014-04-09 13:35:13','2014-03-27 19:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(307,66,209,'DataObject','Et labore neque debitis dolorem natus dolor. Aut occaecati consequatur vel et non provident aliquid. At voluptas cum et sint accusamus quisquam occaecati. At dolorum odio et non eos.','2014-04-09 13:35:13','2014-04-09 13:35:13','2014-03-27 18:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(308,66,210,'DataObject','Quis velit ratione nam nesciunt qui. Ut aut minima nostrum aut recusandae ea aliquid. Ratione sint corporis. Doloremque dignissimos et ex consequatur velit explicabo.','2014-04-09 13:35:14','2014-04-09 13:35:14','2014-03-27 17:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(309,66,214,'DataObject','Similique dignissimos aliquam ad iste ea saepe minus. Laborum aliquid in nostrum sit. Beatae ipsam eius saepe enim harum possimus. Reprehenderit sunt quo autem excepturi libero.','2014-04-09 13:35:15','2014-04-09 13:35:15','2014-03-27 16:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(310,66,215,'DataObject','Ea vel quo aut molestiae. Aut voluptate error ut inventore impedit atque. Et quia ipsam non consequatur. Dolorem omnis quibusdam aspernatur. Assumenda laborum mollitia quo.','2014-04-09 13:35:15','2014-04-09 13:35:15','2014-03-27 15:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(311,66,216,'DataObject','Excepturi est commodi. Consequuntur tempora non commodi minus quas voluptatem vitae. Ipsum inventore voluptatibus.','2014-04-09 13:35:15','2014-04-09 13:35:15','2014-03-27 14:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(312,66,217,'DataObject','Laudantium omnis velit possimus numquam. Ut voluptas eos velit veniam ducimus. Vitae laborum pariatur nulla. Excepturi amet omnis ipsa molestias corrupti illum et.','2014-04-09 13:35:15','2014-04-09 13:35:15','2014-03-27 13:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(313,28,33,'TaxonConcept','This is a witty comment on the Adaliasii iurea taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:17','2014-04-09 13:35:17','2014-03-27 12:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(314,2,33,'TaxonConcept','This is a witty comment on the Adaliasii iurea taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:17','2014-04-09 13:35:17','2014-03-27 11:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(315,68,218,'DataObject','Adipisci id ea libero aut consequatur qui. In nihil iste facilis non blanditiis. Veniam hic fugit iure et quaerat eum quod.','2014-04-09 13:35:17','2014-04-09 13:35:17','2014-03-27 10:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(316,68,219,'DataObject','Enim iste aut rerum fugiat. In perferendis dolorem omnis. Modi fugit qui accusamus enim asperiores et ut. Recusandae enim laboriosam. Alias deserunt sunt reiciendis repellat quia saepe.','2014-04-09 13:35:17','2014-04-09 13:35:17','2014-03-27 09:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(317,68,223,'DataObject','Velit molestiae vel fugit quia earum numquam. Dignissimos non velit provident quas quisquam hic error. Aut magni officiis et aliquid sed nostrum quos.','2014-04-09 13:35:18','2014-04-09 13:35:18','2014-03-27 08:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(318,68,224,'DataObject','Quae quod odio et facilis eos et. Odio adipisci soluta assumenda quasi iure dolorum quae. Accusantium commodi rerum quis quae. Rerum impedit ut.','2014-04-09 13:35:18','2014-04-09 13:35:18','2014-03-27 07:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(319,68,225,'DataObject','Et consectetur qui repellat rem. Qui impedit non voluptas eius nesciunt. Laborum et repellendus vero nesciunt aut. Ipsam accusamus sed omnis aperiam. Voluptas accusantium minima.','2014-04-09 13:35:19','2014-04-09 13:35:19','2014-03-27 06:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(320,68,226,'DataObject','Consequuntur sit commodi sit illum ea nam. Maxime iure voluptatem nemo dolores possimus. Laudantium atque neque et eligendi recusandae modi. Deserunt nobis provident omnis repudiandae voluptas.','2014-04-09 13:35:19','2014-04-09 13:35:19','2014-03-27 05:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(321,31,34,'TaxonConcept','This is a witty comment on the Nonnumquamerus numquamerus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:20','2014-04-09 13:35:20','2014-03-27 04:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(322,27,34,'TaxonConcept','This is a witty comment on the Nonnumquamerus numquamerus taxon concept. Any resemblance to comments real or imagined is coincidental.','2014-04-09 13:35:20','2014-04-09 13:35:20','2014-03-27 03:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(323,70,227,'DataObject','Vero quis accusamus rerum quaerat. Non ea et natus. Debitis at corrupti illo placeat quia. Eum in debitis ipsam blanditiis.','2014-04-09 13:35:20','2014-04-09 13:35:20','2014-03-27 02:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(324,70,228,'DataObject','Vitae iure explicabo ut quia vero debitis nemo. Et dolor adipisci consequuntur quos nesciunt. Suscipit vel corrupti voluptatibus aut aspernatur ea minus. Id beatae esse quidem. Eos porro sint.','2014-04-09 13:35:20','2014-04-09 13:35:20','2014-03-27 01:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(325,70,232,'DataObject','Vel et voluptate et similique ipsum qui doloremque. Sequi omnis temporibus mollitia fugit. Ut eius doloremque hic et quia tempore. Provident numquam odit quis sed ad. Sequi ab et excepturi sit numquam eum.','2014-04-09 13:35:21','2014-04-09 13:35:21','2014-03-27 00:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(326,70,233,'DataObject','Ex accusantium ut ipsum at et. Voluptas error ut dolores quidem et ab cumque. Sint qui veritatis in suscipit tenetur. Expedita dolores qui a consequatur placeat et. Consequatur id occaecati voluptatum quo amet doloremque dolorum.','2014-04-09 13:35:22','2014-04-09 13:35:22','2014-03-26 23:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(327,70,234,'DataObject','Minus quas ipsam tempora tenetur voluptates. Ipsam id adipisci hic voluptatem voluptatem in. Debitis inventore eos exercitationem quasi asperiores nihil. Odio debitis esse necessitatibus voluptatem.','2014-04-09 13:35:22','2014-04-09 13:35:22','2014-03-26 22:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL),(328,70,235,'DataObject','Architecto doloremque sed officia magni aut cumque qui. Sunt repellat accusamus cumque non vel. Est quia aliquam aut maiores quo optio eos.','2014-04-09 13:35:22','2014-04-09 13:35:22','2014-03-26 21:35:29',0,0,NULL,NULL,0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_cache_url` bigint(20) unsigned DEFAULT NULL,
  `logo_file_name` varchar(255) DEFAULT NULL,
  `logo_content_type` varchar(255) DEFAULT NULL,
  `logo_file_size` int(10) unsigned DEFAULT '0',
  `published` tinyint(1) DEFAULT '1',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
INSERT INTO `communities` VALUES (1,'EOL Curators','This is a special community intended for EOL curators to discuss matters related to curation on the Encylopedia of Life.','2014-04-09 13:33:15','2014-04-09 13:33:15',NULL,NULL,NULL,0,1,NULL,NULL);
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_roles`
--

DROP TABLE IF EXISTS `contact_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact_roles` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='For content partner agent_contacts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_roles`
--

LOCK TABLES `contact_roles` WRITE;
/*!40000 ALTER TABLE `contact_roles` DISABLE KEYS */;
INSERT INTO `contact_roles` VALUES (1),(2),(3);
/*!40000 ALTER TABLE `contact_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_subjects`
--

DROP TABLE IF EXISTS `contact_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipients` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_subjects`
--

LOCK TABLES `contact_subjects` WRITE;
/*!40000 ALTER TABLE `contact_subjects` DISABLE KEYS */;
INSERT INTO `contact_subjects` VALUES (1,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(2,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(3,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(4,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(5,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(6,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(7,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(8,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(9,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(10,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(11,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13'),(12,'junk@example.com',1,'2014-04-07 13:33:13','2014-04-09 13:33:13');
/*!40000 ALTER TABLE `contact_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_subject_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `comments` text,
  `ip_address` varchar(255) DEFAULT NULL,
  `referred_page` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `taxon_group` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_page_archives`
--

DROP TABLE IF EXISTS `content_page_archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_page_archives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_page_id` int(11) DEFAULT NULL,
  `page_name` varchar(255) NOT NULL DEFAULT '',
  `content_section_id` int(11) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '1',
  `original_creation_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `open_in_new_window` tinyint(1) DEFAULT '0',
  `last_update_user_id` int(11) NOT NULL DEFAULT '2',
  `parent_content_page_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_page_archives`
--

LOCK TABLES `content_page_archives` WRITE;
/*!40000 ALTER TABLE `content_page_archives` DISABLE KEYS */;
INSERT INTO `content_page_archives` VALUES (1,21,'test_translation',NULL,1,'2014-04-30 11:26:51','2014-04-30 11:59:05','2014-04-30 11:59:05',0,79,NULL),(2,14,'test page',NULL,1,'2014-04-27 11:44:09','2014-04-30 12:04:42','2014-04-30 12:04:42',0,79,NULL),(3,20,'testlanguage',NULL,1,'2014-04-27 13:25:07','2014-04-30 12:06:20','2014-04-30 12:06:20',0,79,NULL),(4,23,'test_create_delete',NULL,1,'2014-04-30 12:29:42','2014-04-30 12:42:34','2014-04-30 12:42:34',0,79,NULL),(5,18,'test6',NULL,0,'2014-04-27 12:45:28','2014-04-30 14:00:06','2014-04-30 14:00:06',0,79,NULL),(6,19,'testadmin1',NULL,0,'2014-04-27 13:10:07','2014-04-30 14:02:39','2014-04-30 14:02:39',0,79,NULL);
/*!40000 ALTER TABLE `content_page_archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_pages`
--

DROP TABLE IF EXISTS `content_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_name` varchar(255) NOT NULL DEFAULT '',
  `sort_order` int(11) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `open_in_new_window` tinyint(1) DEFAULT '0',
  `last_update_user_id` int(11) NOT NULL DEFAULT '2',
  `parent_content_page_id` int(11) DEFAULT NULL,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `section_active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_pages`
--

LOCK TABLES `content_pages` WRITE;
/*!40000 ALTER TABLE `content_pages` DISABLE KEYS */;
INSERT INTO `content_pages` VALUES (1,'Home',1,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(2,'Who We Are',9,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(3,'Working Groups',1,1,0,1,2,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(4,'Working Group A',1,1,0,1,3,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(5,'Working Group B',2,1,0,1,3,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(6,'Working Group C',3,1,0,1,3,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(7,'Working Group D',4,1,0,1,3,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(8,'Working Group E',5,1,0,1,3,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(9,'Contact Us',8,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(10,'Screencasts',7,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(11,'Press Releases',6,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(12,'terms_of_use',5,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(13,'curator_central',11,1,0,1,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(15,'test2',4,1,0,78,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(16,'test3',3,1,0,78,NULL,NULL,NULL,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(17,'test4',2,1,0,78,NULL,17,1,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(22,'test_delete',10,1,0,79,NULL,22,1,'2014-07-01 12:43:20','2014-07-01 12:43:20'),(27,'test_created_at',12,1,0,79,NULL,27,1,'2014-07-01 11:40:25','2014-07-01 11:40:25');
/*!40000 ALTER TABLE `content_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_partner_agreements`
--

DROP TABLE IF EXISTS `content_partner_agreements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_partner_agreements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_partner_id` int(10) unsigned NOT NULL,
  `template` text NOT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT '1',
  `number_of_views` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_viewed` datetime DEFAULT NULL,
  `mou_url` varchar(255) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `signed_on_date` datetime DEFAULT NULL,
  `signed_by` varchar(255) DEFAULT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_partner_agreements`
--

LOCK TABLES `content_partner_agreements` WRITE;
/*!40000 ALTER TABLE `content_partner_agreements` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_partner_agreements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_partner_contacts`
--

DROP TABLE IF EXISTS `content_partner_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_partner_contacts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content_partner_id` int(10) unsigned NOT NULL,
  `contact_role_id` tinyint(3) unsigned NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `title` varchar(20) NOT NULL,
  `given_name` varchar(255) NOT NULL,
  `family_name` varchar(255) NOT NULL,
  `homepage` varchar(255) CHARACTER SET ascii NOT NULL,
  `email` varchar(75) NOT NULL,
  `telephone` varchar(30) CHARACTER SET ascii NOT NULL,
  `address` text NOT NULL,
  `email_reports_frequency_hours` int(11) DEFAULT '24',
  `last_report_email` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='For content partners, specifying people to contact (each one has an agent_contact_role)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_partner_contacts`
--

LOCK TABLES `content_partner_contacts` WRITE;
/*!40000 ALTER TABLE `content_partner_contacts` DISABLE KEYS */;
INSERT INTO `content_partner_contacts` VALUES (1,1,1,'unique13string unique14string','Call me SIR','unique13string','unique14string','http://whatever.org','unique13string.unique14string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:33:17','2014-04-09 13:33:17'),(2,2,1,'unique15string unique16string','Call me SIR','unique15string','unique16string','http://whatever.org','unique15string.unique16string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:33:17','2014-04-09 13:33:17'),(3,4,1,'unique21string unique22string','Call me SIR','unique21string','unique22string','http://whatever.org','unique21string.unique22string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:33:37','2014-04-09 13:33:37'),(4,5,1,'unique23string unique24string','Call me SIR','unique23string','unique24string','http://whatever.org','unique23string.unique24string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:34:26','2014-04-09 13:34:26'),(5,6,1,'unique25string unique26string','Call me SIR','unique25string','unique26string','http://whatever.org','unique25string.unique26string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:34:26','2014-04-09 13:34:26'),(6,7,1,'unique27string unique28string','Call me SIR','unique27string','unique28string','http://whatever.org','unique27string.unique28string@example.com','555-222-1111','1234 Doesntmatter St',24,NULL,'2014-04-09 13:34:33','2014-04-09 13:34:33');
/*!40000 ALTER TABLE `content_partner_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_partner_statuses`
--

DROP TABLE IF EXISTS `content_partner_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_partner_statuses` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_partner_statuses`
--

LOCK TABLES `content_partner_statuses` WRITE;
/*!40000 ALTER TABLE `content_partner_statuses` DISABLE KEYS */;
INSERT INTO `content_partner_statuses` VALUES (1),(2),(3),(4);
/*!40000 ALTER TABLE `content_partner_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_partners`
--

DROP TABLE IF EXISTS `content_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_partners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content_partner_status_id` tinyint(4) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `full_name` text,
  `display_name` varchar(255) DEFAULT NULL,
  `acronym` varchar(20) DEFAULT NULL,
  `homepage` varchar(255) DEFAULT NULL,
  `description_of_data` text,
  `description` text NOT NULL,
  `notes` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `public` tinyint(1) NOT NULL DEFAULT '0',
  `admin_notes` text,
  `logo_cache_url` bigint(20) unsigned DEFAULT NULL,
  `logo_file_name` varchar(255) DEFAULT NULL,
  `logo_content_type` varchar(255) DEFAULT NULL,
  `logo_file_size` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_partners`
--

LOCK TABLES `content_partners` WRITE;
/*!40000 ALTER TABLE `content_partners` DISABLE KEYS */;
INSERT INTO `content_partners` VALUES (1,1,1,'IUCN',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:33:17','2014-04-09 11:33:17',1,NULL,NULL,NULL,NULL,0),(2,1,2,'Catalogue of Life',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:33:17','2014-04-09 11:33:17',1,NULL,NULL,NULL,NULL,0),(3,1,3,'Biology of Aging',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:33:17','2014-04-09 11:33:17',1,NULL,NULL,NULL,NULL,0),(4,1,5,'Global Biodiversity Information Facility (GBIF)',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:33:37','2014-04-09 11:33:37',1,NULL,NULL,NULL,NULL,0),(5,1,34,'Partner name',NULL,NULL,NULL,'Civil Protection!','description of the partner','','2014-04-04 11:34:26','2014-04-09 11:34:26',1,NULL,NULL,NULL,NULL,0),(6,1,35,'Test ContenPartner',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:34:26','2014-04-09 11:34:26',1,NULL,NULL,NULL,NULL,0),(7,1,42,'NCBI',NULL,NULL,NULL,'Civil Protection!','Our Testing Content Partner','','2014-04-04 11:34:32','2014-04-09 11:34:33',1,NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `content_partners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_table_items`
--

DROP TABLE IF EXISTS `content_table_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_table_items` (
  `content_table_id` int(11) NOT NULL,
  `toc_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_table_items`
--

LOCK TABLES `content_table_items` WRITE;
/*!40000 ALTER TABLE `content_table_items` DISABLE KEYS */;
INSERT INTO `content_table_items` VALUES (1,2,NULL,NULL),(1,19,NULL,NULL),(1,20,NULL,NULL),(1,4,NULL,NULL),(1,34,NULL,NULL),(1,22,NULL,NULL),(1,16,NULL,NULL),(1,8,NULL,NULL),(1,29,NULL,NULL),(1,25,NULL,NULL),(1,31,NULL,NULL),(1,10,NULL,NULL),(1,30,NULL,NULL),(1,33,NULL,NULL),(1,11,NULL,NULL),(1,36,NULL,NULL),(1,6,NULL,NULL),(1,1,NULL,NULL),(1,15,NULL,NULL),(1,28,NULL,NULL),(1,32,NULL,NULL),(1,35,NULL,NULL),(1,9,NULL,NULL),(2,2,NULL,NULL),(2,19,NULL,NULL),(2,20,NULL,NULL),(2,4,NULL,NULL),(2,34,NULL,NULL),(2,22,NULL,NULL),(2,16,NULL,NULL),(2,8,NULL,NULL),(2,29,NULL,NULL),(2,25,NULL,NULL),(2,31,NULL,NULL),(2,10,NULL,NULL),(2,30,NULL,NULL),(2,33,NULL,NULL),(2,11,NULL,NULL),(2,36,NULL,NULL),(2,6,NULL,NULL),(2,1,NULL,NULL),(2,15,NULL,NULL),(2,28,NULL,NULL),(2,32,NULL,NULL),(2,35,NULL,NULL),(2,9,NULL,NULL);
/*!40000 ALTER TABLE `content_table_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_tables`
--

DROP TABLE IF EXISTS `content_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_tables`
--

LOCK TABLES `content_tables` WRITE;
/*!40000 ALTER TABLE `content_tables` DISABLE KEYS */;
INSERT INTO `content_tables` VALUES (2,'2014-04-09 13:35:23','2014-04-09 13:35:23');
/*!40000 ALTER TABLE `content_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_uploads`
--

DROP TABLE IF EXISTS `content_uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_uploads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) DEFAULT NULL,
  `link_name` varchar(70) DEFAULT NULL,
  `attachment_cache_url` bigint(20) DEFAULT NULL,
  `attachment_extension` varchar(10) DEFAULT NULL,
  `attachment_content_type` varchar(255) DEFAULT NULL,
  `attachment_file_name` varchar(255) DEFAULT NULL,
  `attachment_file_size` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_uploads`
--

LOCK TABLES `content_uploads` WRITE;
/*!40000 ALTER TABLE `content_uploads` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_uploads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curated_data_objects_hierarchy_entries`
--

DROP TABLE IF EXISTS `curated_data_objects_hierarchy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curated_data_objects_hierarchy_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `data_object_id` int(10) unsigned NOT NULL,
  `data_object_guid` varchar(32) NOT NULL,
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `vetted_id` int(11) NOT NULL,
  `visibility_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `data_object_id` (`data_object_id`),
  KEY `data_object_id_hierarchy_entry_id` (`data_object_id`,`hierarchy_entry_id`),
  KEY `index_curated_data_objects_hierarchy_entries_on_data_object_guid` (`data_object_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curated_data_objects_hierarchy_entries`
--

LOCK TABLES `curated_data_objects_hierarchy_entries` WRITE;
/*!40000 ALTER TABLE `curated_data_objects_hierarchy_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `curated_data_objects_hierarchy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curated_hierarchy_entry_relationships`
--

DROP TABLE IF EXISTS `curated_hierarchy_entry_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curated_hierarchy_entry_relationships` (
  `hierarchy_entry_id_1` int(10) unsigned NOT NULL,
  `hierarchy_entry_id_2` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `equivalent` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id_1`,`hierarchy_entry_id_2`),
  KEY `hierarchy_entry_id_2` (`hierarchy_entry_id_2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curated_hierarchy_entry_relationships`
--

LOCK TABLES `curated_hierarchy_entry_relationships` WRITE;
/*!40000 ALTER TABLE `curated_hierarchy_entry_relationships` DISABLE KEYS */;
/*!40000 ALTER TABLE `curated_hierarchy_entry_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curated_structured_data`
--

DROP TABLE IF EXISTS `curated_structured_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curated_structured_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `predicate` varchar(255) NOT NULL,
  `object` varchar(255) NOT NULL,
  `vetted_id` int(11) NOT NULL,
  `visibility_id` int(11) NOT NULL,
  `comment_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `subject` (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curated_structured_data`
--

LOCK TABLES `curated_structured_data` WRITE;
/*!40000 ALTER TABLE `curated_structured_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `curated_structured_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curated_taxon_concept_preferred_entries`
--

DROP TABLE IF EXISTS `curated_taxon_concept_preferred_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curated_taxon_concept_preferred_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taxon_concept_id` (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curated_taxon_concept_preferred_entries`
--

LOCK TABLES `curated_taxon_concept_preferred_entries` WRITE;
/*!40000 ALTER TABLE `curated_taxon_concept_preferred_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `curated_taxon_concept_preferred_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curator_activity_logs_untrust_reasons`
--

DROP TABLE IF EXISTS `curator_activity_logs_untrust_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curator_activity_logs_untrust_reasons` (
  `curator_activity_log_id` int(11) NOT NULL,
  `untrust_reason_id` int(11) NOT NULL,
  PRIMARY KEY (`curator_activity_log_id`,`untrust_reason_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curator_activity_logs_untrust_reasons`
--

LOCK TABLES `curator_activity_logs_untrust_reasons` WRITE;
/*!40000 ALTER TABLE `curator_activity_logs_untrust_reasons` DISABLE KEYS */;
/*!40000 ALTER TABLE `curator_activity_logs_untrust_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curator_levels`
--

DROP TABLE IF EXISTS `curator_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curator_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `rating_weight` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curator_levels`
--

LOCK TABLES `curator_levels` WRITE;
/*!40000 ALTER TABLE `curator_levels` DISABLE KEYS */;
INSERT INTO `curator_levels` VALUES (1,'Master Curator',1),(2,'Full Curator',1),(3,'Assistant Curator',1);
/*!40000 ALTER TABLE `curator_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_object_data_object_tags`
--

DROP TABLE IF EXISTS `data_object_data_object_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_object_data_object_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_object_id` int(11) NOT NULL,
  `data_object_tag_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `data_object_guid` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_data_object_data_object_tags_1` (`data_object_guid`,`data_object_tag_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_object_data_object_tags`
--

LOCK TABLES `data_object_data_object_tags` WRITE;
/*!40000 ALTER TABLE `data_object_data_object_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_object_data_object_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_object_tags`
--

DROP TABLE IF EXISTS `data_object_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_object_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `is_public` tinyint(1) DEFAULT NULL,
  `total_usage_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_object_tags`
--

LOCK TABLES `data_object_tags` WRITE;
/*!40000 ALTER TABLE `data_object_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_object_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_object_translations`
--

DROP TABLE IF EXISTS `data_object_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_object_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `data_object_id` int(10) unsigned NOT NULL,
  `original_data_object_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_object_id` (`data_object_id`),
  KEY `original_data_object_id` (`original_data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_object_translations`
--

LOCK TABLES `data_object_translations` WRITE;
/*!40000 ALTER TABLE `data_object_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_object_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects`
--

DROP TABLE IF EXISTS `data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` varchar(32) CHARACTER SET ascii NOT NULL COMMENT 'this guid is generated by EOL. A 32 character hexadecimal',
  `identifier` varchar(255) DEFAULT NULL,
  `provider_mangaed_id` varchar(255) DEFAULT NULL,
  `data_type_id` smallint(5) unsigned NOT NULL,
  `data_subtype_id` smallint(5) unsigned DEFAULT NULL,
  `mime_type_id` smallint(5) unsigned NOT NULL,
  `object_title` varchar(255) NOT NULL COMMENT 'a string title for the object. Generally not used for images',
  `language_id` smallint(5) unsigned NOT NULL,
  `metadata_language_id` smallint(5) unsigned DEFAULT NULL,
  `license_id` tinyint(3) unsigned NOT NULL,
  `rights_statement` varchar(300) NOT NULL COMMENT 'a brief statement of the copyright protection for this object',
  `rights_holder` text NOT NULL COMMENT 'a string stating the owner of copyright for this object',
  `bibliographic_citation` text NOT NULL,
  `source_url` text COMMENT 'a url where users are to be redirected to learn more about this data object',
  `description` mediumtext NOT NULL,
  `description_linked` mediumtext,
  `object_url` text COMMENT 'recommended; the url which resolves to this data object. Generally used only for images, video, and other multimedia',
  `object_cache_url` bigint(20) unsigned DEFAULT NULL COMMENT 'an integer representation of the EOL local cache of the object. For example, a value may be 200902090812345 - that will be split by middleware into the parts 2009/02/09/08/12345 which represents the storage directory structure. The directory structure represents year/month/day/hour/unique_id',
  `thumbnail_url` varchar(255) CHARACTER SET ascii NOT NULL COMMENT 'not required; the url which resolves to a thumbnail representation of this object. Generally used only for images, video, and other multimedia',
  `thumbnail_cache_url` bigint(20) unsigned DEFAULT NULL COMMENT 'an integer representation of the EOL local cache of the thumbnail',
  `location` varchar(255) NOT NULL,
  `latitude` double NOT NULL COMMENT 'the latitude at which the object was first collected/captured. We have no standard way of represdenting this. Usually measured in decimal values, but could also be degrees',
  `longitude` double NOT NULL COMMENT 'the longitude at which the object was first collected/captured',
  `altitude` double NOT NULL COMMENT 'the altitude at which the object was first collected/captured',
  `object_created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'date when the object was originally created. Information contained within the resource',
  `object_modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'date when the object was last modified. Information contained within the resource',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date when the object was added to the EOL index',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'date when the object was last modified within the EOL index. This should pretty much always equal the created_at date, therefore is likely not necessary',
  `available_at` timestamp NULL DEFAULT NULL,
  `data_rating` float NOT NULL DEFAULT '2.5',
  `published` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'required; boolean; set to 1 if the object is currently published',
  `curated` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'required; boolean; set to 1 if the object has ever been curated',
  `derived_from` text,
  `spatial_location` text,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `data_type_id` (`data_type_id`),
  KEY `index_data_objects_on_guid` (`guid`),
  KEY `index_data_objects_on_published` (`published`),
  KEY `created_at` (`created_at`),
  KEY `identifier` (`identifier`),
  KEY `object_url` (`object_url`(255))
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects`
--

LOCK TABLES `data_objects` WRITE;
/*!40000 ALTER TABLE `data_objects` DISABLE KEYS */;
INSERT INTO `data_objects` VALUES (1,'c08f43e2d58a4835bc8c966fcad535c6','',NULL,2,NULL,1,'',1,NULL,3,'Test rights statement','Test rights holder','','','Test Data Object',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:30','2014-04-07 11:33:30','2014-04-04 11:33:30','2014-04-09 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(2,'23dd883607d8498ebc9182d1bab82a4e','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Optio rerum aut asperiores autem.',NULL,'',201111170140453,'',NULL,'',0,0,0,'2014-04-04 11:33:40','2014-04-07 11:33:40','2014-04-04 11:33:40','2014-04-09 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(3,'14a4d703bab14165922495eeacb5da3a','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Eveniet dolor laudantium ut fugiat aliquam sunt.',NULL,'',201111021131069,'',NULL,'',0,0,0,'2014-04-04 11:33:41','2014-04-07 11:33:41','2014-04-04 11:33:41','2014-04-09 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(4,'e79ab2e3834f4e50bebe5cdb962cad46','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Aliquid ipsam quisquam impedit odit in harum possimus fuga.',NULL,'',200811131321659,'',NULL,'',0,0,0,'2014-04-04 11:33:42','2014-04-07 11:33:42','2014-04-04 11:33:42','2014-04-09 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(5,'aa43a2357bd6453fbd54f5aec3e608a1','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Dolorum ratione velit aut aut.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:33:42','2014-04-07 11:33:42','2014-04-04 11:33:42','2014-04-09 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(6,'37607d309995489f9560d2e7feb9910c','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Quis velit maiores tenetur voluptas molestiae possimus unde.',NULL,'',201105040554365,'',NULL,'',0,0,0,'2014-04-04 11:33:42','2014-04-07 11:33:42','2014-04-04 11:33:42','2014-04-09 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(7,'63ab9cebc927427d84fe3336e12b563b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Animalia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:42','2014-04-07 11:33:42','2014-04-04 11:33:42','2014-04-09 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(8,'a81e9470c8904e8cb55579c24baed5aa','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Animalia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:42','2014-04-07 11:33:42','2014-04-04 11:33:42','2014-04-09 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(9,'5ceeebc55be6462d961edd8d8172ca7b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Qui qui ut. Est eveniet sit nam voluptatem. In saepe eius qui cum accusantium omnis. Velit possimus corrupti vitae molestias voluptatem autem. Occaecati reprehenderit excepturi laudantium iure iste ut eos.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:43','2014-04-07 11:33:43','2014-04-04 11:33:43','2014-04-09 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(10,'fb2915aae94b4b57973a46f47052dcdc','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Libero et omnis corrupti similique laborum occaecati voluptate. Veritatis impedit vel distinctio illum voluptatibus modi. Dolor dolore architecto debitis molestiae nobis deleniti placeat. Cupiditate omnis eveniet dolorem qui corporis est non.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:43','2014-04-07 11:33:43','2014-04-04 11:33:43','2014-04-09 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(11,'97305d09dc6640bc8fc9cf65d7864b41','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Doloribus animi adipisci consequatur voluptatibus.',NULL,'',201111021106221,'',NULL,'',0,0,0,'2014-04-04 11:33:45','2014-04-07 11:33:45','2014-04-04 11:33:45','2014-04-09 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(12,'fbfb8534c48349b792c9702024979d04','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Eos et aut sapiente et vel tempora deleniti.',NULL,'',201205220000616,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(13,'551cc02f3ab84be5ba026817e5b06bae','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Quo id voluptas consequatur voluptatem voluptatibus.',NULL,'',200811131394659,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(14,'9cb45daa87d4478fae00e6c950ccf474','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Consequatur ut suscipit velit et et officiis modi sunt.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(15,'da0e1b91ac1b4f8d83735a90150660f2','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Qui excepturi quia necessitatibus non.',NULL,'',201105040529974,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(16,'feb147f78b1a4e8a8f9333827a527f86','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Autrecusandaees repudiandaeica</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(17,'d1aabcd60206426f8afe2d97091a6dd3','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Autrecusandaees repudiandaeica</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:46','2014-04-07 11:33:46','2014-04-04 11:33:46','2014-04-08 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(18,'c9279d42b69b476987b1582e4958e537','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Asperiores iste quis quia magni omnis qui. Consequatur soluta quisquam ut praesentium accusamus possimus ut. Laborum consequuntur omnis.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:47','2014-04-07 11:33:47','2014-04-04 11:33:47','2014-04-08 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(19,'93cafff09feb47aeb0d1ebeb07e0589b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Sed accusamus possimus excepturi. Dicta error cumque. In consequatur ut omnis ut.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:47','2014-04-07 11:33:47','2014-04-04 11:33:47','2014-04-08 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(20,'eafb2280c8fd46c9b91f66ae7a2c021c','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Voluptatibus numquam odit soluta qui neque rerum necessitatibus.',NULL,'',201301212386289,'',NULL,'',0,0,0,'2014-04-04 11:33:48','2014-04-07 11:33:48','2014-04-04 11:33:48','2014-04-08 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(21,'4f2f310b6fc14b4e9c7b698c13634df7','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Hic voluptatum in ex placeat consequatur.',NULL,'',201201030187595,'',NULL,'',0,0,0,'2014-04-04 11:33:49','2014-04-07 11:33:49','2014-04-04 11:33:49','2014-04-08 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(22,'8d0b528cae8a4c1eb982953e0b86c6f5','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Saepe iste laboriosam sit.',NULL,'',200811131367814,'',NULL,'',0,0,0,'2014-04-04 11:33:49','2014-04-07 11:33:49','2014-04-04 11:33:49','2014-04-08 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(23,'b3479e9ce99f47179d0956cfcd64ebd0','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Non quia quia eos sit atque doloribus aut.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:33:49','2014-04-07 11:33:49','2014-04-04 11:33:49','2014-04-08 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(24,'093898bc5edc4ac083048cfdca945012','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Pariatur aut possimus sint ex odit ipsa.',NULL,'',201105040538097,'',NULL,'',0,0,0,'2014-04-04 11:33:49','2014-04-07 11:33:49','2014-04-04 11:33:49','2014-04-08 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(25,'175ab8f0db7c458b9068598809cf808c','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Nihileri voluptasus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:49','2014-04-07 11:33:49','2014-04-04 11:33:49','2014-04-08 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(26,'a8a6c1fec92d48bfa0d77d62d6223f5a','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Nihileri voluptasus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:50','2014-04-07 11:33:50','2014-04-04 11:33:50','2014-04-08 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(27,'c44e25a2587d41c7bc45a33d3cd96c2f','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Repudiandae eius omnis id. Expedita fugiat est eius. Iste molestiae odit.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:50','2014-04-07 11:33:50','2014-04-04 11:33:50','2014-04-08 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(28,'456636ffaa4545cb8cff3a812236eb41','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Sit quo velit accusantium earum. Sequi corrupti illum. Sit error sunt nesciunt autem. Veritatis a et nesciunt et omnis maiores.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:50','2014-04-07 11:33:50','2014-04-04 11:33:50','2014-04-08 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(29,'be6747695fe649389072376e1ba655b6','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Quo expedita autem quia possimus ea.',NULL,'',201111012278143,'',NULL,'',0,0,0,'2014-04-04 11:33:52','2014-04-07 11:33:52','2014-04-04 11:33:52','2014-04-08 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(30,'ca68c56b264440a0a46cac1d5d24fe8e','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Fuga dolorem ratione ab excepturi nesciunt.',NULL,'',201111020864905,'',NULL,'',0,0,0,'2014-04-04 11:33:52','2014-04-07 11:33:52','2014-04-04 11:33:52','2014-04-08 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(31,'9c0d11198f154bd28fe25b411bd7d877','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Maxime saepe dicta quia.',NULL,'',200811131351121,'',NULL,'',0,0,0,'2014-04-04 11:33:52','2014-04-07 11:33:52','2014-04-04 11:33:52','2014-04-08 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(32,'11ae50cffd594cc59a3856cd510a99b5','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Reiciendis quidem et aut tempore saepe qui consequatur dolores.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:33:52','2014-04-07 11:33:52','2014-04-04 11:33:52','2014-04-08 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(33,'4ad7bce804bc481ca41ab19b49065ca5','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Assumenda ab odio atque aut blanditiis quia sit.',NULL,'',201105040535175,'',NULL,'',0,0,0,'2014-04-04 11:33:53','2014-04-07 11:33:53','2014-04-04 11:33:53','2014-04-08 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(34,'db32e7bdd8a8432293b2583fabdb991c','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Dignissimosii inutes</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:53','2014-04-07 11:33:53','2014-04-04 11:33:53','2014-04-08 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(35,'e425194f75524048bdee17370f98fc56','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Dignissimosii inutes</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:53','2014-04-07 11:33:53','2014-04-04 11:33:53','2014-04-08 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(36,'ac5a957a6d164ac68dca659502a9e9d4','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Nesciunt alias in cumque quia quasi ea illo. Nemo commodi atque vitae est ab autem. Ipsa dolorem placeat occaecati.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:53','2014-04-07 11:33:53','2014-04-04 11:33:53','2014-04-07 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(37,'c238d66f6bfd4bac9699cb55b8f76ecc','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Rerum maiores quia ipsam laborum optio omnis. Officiis eligendi quod sint tempora est. Quae odit et qui repudiandae mollitia sed et. Voluptas cupiditate atque quas quibusdam.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:54','2014-04-07 11:33:54','2014-04-04 11:33:54','2014-04-07 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(38,'e0362f3b6b80416c8c93a77b78a228dd','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Sed omnis similique aliquid doloremque incidunt est quas natus.',NULL,'',201204040068862,'',NULL,'',0,0,0,'2014-04-04 11:33:55','2014-04-07 11:33:55','2014-04-04 11:33:55','2014-04-07 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(39,'a01d8c47a35248608e50361e0c3772bf','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Dolorem at unde deleniti rerum quia quo tenetur blanditiis.',NULL,'',201208120076649,'',NULL,'',0,0,0,'2014-04-04 11:33:56','2014-04-07 11:33:56','2014-04-04 11:33:56','2014-04-07 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(40,'273b3f7b52df45f0b57ea7f2da59edfa','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Voluptatibus ea et eum in quia ut iure ipsum.',NULL,'',200811131388288,'',NULL,'',0,0,0,'2014-04-04 11:33:56','2014-04-07 11:33:56','2014-04-04 11:33:56','2014-04-07 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(41,'5a6f8ee11f7b4016bcb54520966ac6e6','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Ea enim inventore earum error sequi et qui.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:33:56','2014-04-07 11:33:56','2014-04-04 11:33:56','2014-04-07 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(42,'fbeebdec83e1497b942d7ed21830e2f0','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Deleniti labore perferendis et illum non non quia aut.',NULL,'',201105040549841,'',NULL,'',0,0,0,'2014-04-04 11:33:56','2014-04-07 11:33:56','2014-04-04 11:33:56','2014-04-07 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(43,'1f2733de9be445ffa91e5cea851ac516','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Fugais utharumatus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:56','2014-04-07 11:33:56','2014-04-04 11:33:56','2014-04-07 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(44,'bec2396af0654a4d8d6cf3a1c9e8e54a','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Fugais utharumatus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:57','2014-04-07 11:33:57','2014-04-04 11:33:57','2014-04-07 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(45,'f10e43512fc446e491ae03149fdfcbfa','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Architecto dicta corporis iusto quibusdam incidunt quidem. Voluptatem ipsam est aliquam. Ea deleniti quidem vel. Dolorum reiciendis sit.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:57','2014-04-07 11:33:57','2014-04-04 11:33:57','2014-04-07 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(46,'c937f03bf97a478d8150616e36241296','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Illo dolor quia est est sapiente qui. Iure enim neque aut molestiae id voluptatem. Saepe sit magnam earum enim ex tempore. Quidem adipisci voluptate eaque qui.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:33:57','2014-04-07 11:33:57','2014-04-04 11:33:57','2014-04-07 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(47,'d3d9836ced1d4baf8bac875cd9d15425','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Ut doloribus natus quis at eveniet.',NULL,'',201202050005388,'',NULL,'',0,0,0,'2014-04-04 11:33:59','2014-04-07 11:33:59','2014-04-04 11:33:59','2014-04-07 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(48,'7bac0efe6ccf4f2cb1f53b476cb67045','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','inappropriate',NULL,'',201111011778717,'',NULL,'',0,0,0,'2014-04-04 11:34:00','2014-04-07 11:34:00','2014-04-04 11:34:00','2014-04-07 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(49,'58ebfb8891ea461f89d19f650f86215b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','untrusted',NULL,'',201203220059150,'',NULL,'',0,0,0,'2014-04-04 11:34:01','2014-04-07 11:34:01','2014-04-04 11:34:01','2014-04-07 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(50,'4b73680bd71c488fb6e5a0e5433996ed','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','unknown',NULL,'',201212102306393,'',NULL,'',0,0,0,'2014-04-04 11:34:01','2014-04-07 11:34:01','2014-04-04 11:34:01','2014-04-07 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(51,'a96638cb5d7f4292ae9f0c397f679093','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible',NULL,'',201111021567463,'',NULL,'',0,0,0,'2014-04-04 11:34:01','2014-04-07 11:34:01','2014-04-04 11:34:01','2014-04-07 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(52,'f86a47272b3e43e2bec5a12379b339f4','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','preview',NULL,'',201111020587617,'',NULL,'',0,0,0,'2014-04-04 11:34:01','2014-04-07 11:34:01','2014-04-04 11:34:01','2014-04-07 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(53,'66a5696cc57f4012bb3e15caffdfa92d','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible, unknown',NULL,'',201205210185638,'',NULL,'',0,0,0,'2014-04-04 11:34:02','2014-04-07 11:34:02','2014-04-04 11:34:02','2014-04-07 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(54,'5aa7ab90707e47d2b17f26f009243cdd','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible, untrusted',NULL,'',201111011190361,'',NULL,'',0,0,0,'2014-04-04 11:34:02','2014-04-07 11:34:02','2014-04-04 11:34:02','2014-04-07 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(55,'bba64d0ae1bb48ff9d73759005513e7a','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','preview, unknown',NULL,'',201111011511951,'',NULL,'',0,0,0,'2014-04-04 11:34:02','2014-04-07 11:34:02','2014-04-04 11:34:02','2014-04-07 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(56,'e2a7533d78394938976199db7a88b962','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Nobis ex fugiat possimus porro voluptatem.',NULL,'',200811131382797,'',NULL,'',0,0,0,'2014-04-04 11:34:03','2014-04-07 11:34:03','2014-04-04 11:34:03','2014-04-07 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(57,'f87543dbf2544594b78570d23a1ab2cc','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Laboriosam facilis fugiat culpa mollitia.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:03','2014-04-07 11:34:03','2014-04-04 11:34:03','2014-04-07 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(58,'fa04df9ea59f44b1bf388a4243973f05','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Error provident magnam fugit eligendi.',NULL,'',201105040560889,'',NULL,'',0,0,0,'2014-04-04 11:34:03','2014-04-07 11:34:03','2014-04-04 11:34:03','2014-04-07 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(59,'8e02f3681a0b4dea81f257424a882cd1','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Minuseli ullamens</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:03','2014-04-07 11:34:03','2014-04-04 11:34:03','2014-04-07 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(60,'d894ae4dfebc482eaef3283fb88811e5','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Minuseli ullamens</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:03','2014-04-07 11:34:03','2014-04-04 11:34:03','2014-04-06 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(61,'a8bd7018de5648ba825a82851c2e87b3','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Doloremque dolore minus placeat non quis vel. Non natus ex laborum quod consectetur. Qui voluptates dolores voluptas quia numquam ullam. Pariatur soluta sit harum eos. Libero quaerat exercitationem modi labore velit voluptatem et.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:04','2014-04-07 11:34:04','2014-04-04 11:34:04','2014-04-06 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(62,'dd054962dbbe4e3a8ca5119f4fb62695','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Maxime libero aliquid. Nesciunt est sit praesentium ab adipisci facilis. Velit cupiditate suscipit. Quibusdam et quas id aspernatur provident exercitationem.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:04','2014-04-07 11:34:04','2014-04-04 11:34:04','2014-04-06 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(63,'4b33e9aa864c4d6a98b673e9454647d9','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Quia temporibus autem maxime.',NULL,'',201105040555104,'',NULL,'',0,0,0,'2014-04-04 11:34:07','2014-04-07 11:34:07','2014-04-04 11:34:07','2014-04-06 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(64,'1c3de7c846d949a7b4867e1ca15d2a4b','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Et ad in officiis ducimus aut odio.',NULL,'',201105040573195,'',NULL,'',0,0,0,'2014-04-04 11:34:08','2014-04-07 11:34:08','2014-04-04 11:34:08','2014-04-06 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(65,'f0efa7cfd4464fcc9c7d200961abfd4b','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Possimus nam facere libero.',NULL,'',201105040594149,'',NULL,'',0,0,0,'2014-04-04 11:34:09','2014-04-07 11:34:09','2014-04-04 11:34:09','2014-04-06 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(66,'e27e4168cc37488ca9bfd965c9a09b95','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Illo reprehenderit odio cumque nesciunt.',NULL,'',201208172341618,'',NULL,'',0,0,0,'2014-04-04 11:34:10','2014-04-07 11:34:10','2014-04-04 11:34:10','2014-04-06 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(67,'94bbfbc0d15643c0954eb51b53e885d3','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','inappropriate',NULL,'',201111021299859,'',NULL,'',0,0,0,'2014-04-04 11:34:12','2014-04-07 11:34:12','2014-04-04 11:34:12','2014-04-06 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(68,'87eb8d373ae6482bb2b418a7965793d9','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','untrusted',NULL,'',201205150031711,'',NULL,'',0,0,0,'2014-04-04 11:34:12','2014-04-07 11:34:12','2014-04-04 11:34:12','2014-04-06 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(69,'372e3be273e747159aaac47d3a21af70','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','unknown',NULL,'',201112230179863,'',NULL,'',0,0,0,'2014-04-04 11:34:12','2014-04-07 11:34:12','2014-04-04 11:34:12','2014-04-06 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(70,'fb674ed06cc7449a868ce7fd5f4a13b9','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible',NULL,'',201111012244809,'',NULL,'',0,0,0,'2014-04-04 11:34:12','2014-04-07 11:34:12','2014-04-04 11:34:12','2014-04-06 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(71,'7f3481f9beb8456ba23162b917438a8b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','preview',NULL,'',201111011330372,'',NULL,'',0,0,0,'2014-04-04 11:34:13','2014-04-07 11:34:13','2014-04-04 11:34:13','2014-04-06 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(72,'0b32a48915114217a889184234354bc9','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible, unknown',NULL,'',201212282365864,'',NULL,'',0,0,0,'2014-04-04 11:34:13','2014-04-07 11:34:13','2014-04-04 11:34:13','2014-04-06 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(73,'45e0c6ecdbe14cc7bce51ba13469645b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','invisible, untrusted',NULL,'',201111030123051,'',NULL,'',0,0,0,'2014-04-04 11:34:13','2014-04-07 11:34:13','2014-04-04 11:34:13','2014-04-06 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(74,'f96ab7c60e944a10ab3861b9a409bf19','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','preview, unknown',NULL,'',201111020413030,'',NULL,'',0,0,0,'2014-04-04 11:34:13','2014-04-07 11:34:13','2014-04-04 11:34:13','2014-04-06 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(75,'ac7f4668af4c4738aa5376186ef4a37c','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Aut totam et iusto laborum accusantium qui modi dicta.',NULL,'',200811131390600,'',NULL,'',0,0,0,'2014-04-04 11:34:14','2014-04-07 11:34:14','2014-04-04 11:34:14','2014-04-06 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(76,'f0eb77a3fe1942ed8590e7e6452a80e7','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Asperiores laudantium assumenda suscipit ea et.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:14','2014-04-07 11:34:14','2014-04-04 11:34:14','2014-04-06 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(77,'cda8e4dfba6d49cf8d00851ed0d06c86','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Sapiente optio voluptas inventore voluptatum.',NULL,'',201105040549843,'',NULL,'',0,0,0,'2014-04-04 11:34:14','2014-04-07 11:34:14','2014-04-04 11:34:14','2014-04-06 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(78,'827a29c3b404496d8004c7ac89ca586b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Culpaensis sapienteesi</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:14','2014-04-07 11:34:14','2014-04-04 11:34:14','2014-04-06 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(79,'0b0a24f522c648968c2164f8ff243616','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Culpaensis sapienteesi</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:14','2014-04-07 11:34:14','2014-04-04 11:34:14','2014-04-06 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(80,'4299256a2a0447d482c18867065bf90f','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Veritatis amet nemo aperiam a et iusto. Consequatur a qui enim expedita. Perferendis officiis molestias dignissimos. Totam est molestiae non quis est. Fugiat nam numquam.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:15','2014-04-07 11:34:15','2014-04-04 11:34:15','2014-04-06 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(81,'0ce1db82e2cf4891b7322a1c37c3971f','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Beatae sequi quod nam aut est praesentium corrupti. Et et quidem quo facilis illum. Soluta quibusdam odit aut fugit ullam molestiae voluptatem. Molestias autem repudiandae odio corrupti voluptatum qui.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:15','2014-04-07 11:34:15','2014-04-04 11:34:15','2014-04-06 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(82,'64e398018b82432aa087895c30ae5cae','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','1st image description for re-harvest',NULL,'',201205300022426,'',NULL,'',0,0,0,'2014-04-04 11:34:16','2014-04-07 11:34:16','2014-04-04 11:34:16','2014-04-06 01:35:27',NULL,1,0,0,NULL,NULL,NULL,NULL),(83,'11a833e8e1d44f7eb402799f98f15ac8','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Odit quod repellat voluptatibus fuga.',NULL,'',200811131333916,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-06 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(84,'fad920e0014c4601a975e5951b781ea9','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Neque ut accusantium voluptatibus tempora voluptatum deserunt.',NULL,'',200811131393000,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-05 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(85,'83834342a8cf4beb8b81d3c50bae1be3','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Libero labore omnis optio autem hic nostrum.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-05 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(86,'8dff677590eb4aa085ede9fc38ac2bfb','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Deleniti exercitationem quo provident dolore eos et.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-05 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(87,'4e59c1dc9bc74fe699c33bf70e389f2d','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Incidunt quos porro sed.',NULL,'',201105040554365,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-05 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(88,'337539d3a50d4f718e2a18a356c6a433','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','overview text for re-harvest',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-04 11:34:17','2014-04-05 19:35:27',NULL,1,0,0,NULL,NULL,NULL,NULL),(89,'9c128aa730dc4fecbae8f8bcb3c71bac','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','description text for re-harvest',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:18','2014-04-07 11:34:18','2014-04-04 11:34:18','2014-04-05 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(90,'337539d3a50d4f718e2a18a356c6a433','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','overview text for re-harvest',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:17','2014-04-07 11:34:17','2014-04-09 11:34:20','2014-04-05 17:35:27',NULL,1,1,0,NULL,NULL,NULL,NULL),(91,'64e398018b82432aa087895c30ae5cae','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','1st image description for re-harvest',NULL,'',201205300022426,'',NULL,'',0,0,0,'2014-04-04 11:34:16','2014-04-07 11:34:16','2014-04-09 11:34:20','2014-04-05 16:35:27',NULL,1,1,0,NULL,NULL,NULL,NULL),(92,'75e0a17d758e4ba4b230491def8327d2','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Nulla modi a sunt illum nobis aliquid.',NULL,'',201204050041265,'',NULL,'',0,0,0,'2014-04-04 11:34:22','2014-04-07 11:34:22','2014-04-04 11:34:22','2014-04-05 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(93,'dcb32a0b230947c7bf4e0d16d6cf1909','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Dolores dolor optio repellat enim numquam.',NULL,'',201210012385079,'',NULL,'',0,0,0,'2014-04-04 11:34:22','2014-04-07 11:34:22','2014-04-04 11:34:22','2014-04-05 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(94,'1c1c0c08ddc04d77ac87c0e5e917904d','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Voluptas possimus dicta delectus nesciunt cumque fugiat eos.',NULL,'',200811131347554,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(95,'44dddd3a82fe426ebc0cbe52c955d7cd','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Minima ut et dolorum.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(96,'d294c44a3df64b23bfb5f0880defc378','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Et sunt in ratione numquam ipsam.',NULL,'',201105040529974,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(97,'d664eaf77d2f49bb89ce75cd2f9b52ec','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Quaerat totam sapiente occaecati nulla maiores nisi. Illum aspernatur ut odio placeat praesentium dolore. Unde voluptatem vero perspiciatis possimus. Nam laboriosam enim molestiae laudantium iste mollitia.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(98,'7aac523cba824abebdc5bf6059502a8e','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Cumque quas voluptas magni consequatur quam. Voluptatem adipisci ipsa repellat hic. Quaerat magnam porro tenetur. Cum sed laborum.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(99,'9b3f4482c8e24f82922dfe1e13c7889b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Enim est cupiditate sit. Id eos est est. Eos asperiores delectus. Numquam fuga minus aliquam illo ut. A sed officia.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:23','2014-04-07 11:34:23','2014-04-04 11:34:23','2014-04-05 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(100,'39f330c057284245a74fc946422bb677','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','This should only be seen by ContentPartner Our Testing Content Partner',NULL,'',201205150083147,'',NULL,'',0,0,0,'2014-04-04 11:34:26','2014-04-07 11:34:26','2014-04-04 11:34:26','2014-04-05 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(101,'8db7c8e38ce84e38b230de0db88884fc','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Quos eligendi in quae.',NULL,'',201211260100253,'',NULL,'',0,0,0,'2014-04-04 11:34:29','2014-04-07 11:34:29','2014-04-04 11:34:29','2014-04-05 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(102,'1bec60d1e9a5456b953fa8bdf032422b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Ea illum sed aut.',NULL,'',201112100017714,'',NULL,'',0,0,0,'2014-04-04 11:34:29','2014-04-07 11:34:29','2014-04-04 11:34:29','2014-04-05 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(103,'fe806b48af2d4343bd6f00e81b9e2e42','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Officiis quis dolore tempore dolorum praesentium.',NULL,'',200811131354820,'',NULL,'',0,0,0,'2014-04-04 11:34:30','2014-04-07 11:34:30','2014-04-04 11:34:30','2014-04-05 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(104,'f322d8c14ce6499990e5581f77c452b8','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Similique aut quis ipsa iure.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:30','2014-04-07 11:34:30','2014-04-04 11:34:30','2014-04-05 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(105,'54a55929713e4a9091a1364084da8426','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Veniam rem voluptatem laudantium et fugit.',NULL,'',201105040538097,'',NULL,'',0,0,0,'2014-04-04 11:34:30','2014-04-07 11:34:30','2014-04-04 11:34:30','2014-04-05 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(106,'193dd7d9f0cf4e3595d7d88718dd6684','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Etconsequaturelia autenimalia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:30','2014-04-07 11:34:30','2014-04-04 11:34:30','2014-04-05 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(107,'8223084eb05641ed9157ff33f1a9c4b2','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Etconsequaturelia autenimalia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:30','2014-04-07 11:34:30','2014-04-04 11:34:30','2014-04-05 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(108,'746a9420be114dfebd0f451a8b67858e','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Cupiditate eligendi recusandae est. Id dolor numquam magni deleniti consequuntur nulla explicabo. Consequatur laborum vitae.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:31','2014-04-07 11:34:31','2014-04-04 11:34:31','2014-04-04 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(109,'68a971f6410844b5a10cf37fee278b32','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Soluta in aut expedita molestias incidunt quia maiores. Iure veniam accusamus fugit quam commodi. Alias ea dolor. Cupiditate assumenda officia qui amet rerum nihil.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:31','2014-04-07 11:34:31','2014-04-04 11:34:31','2014-04-04 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(110,'b855e20d8982493fb7799a2051b409aa','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Et voluptate assumenda harum.',NULL,'',201209082397624,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(111,'f85c3326a1a64575b5f572a76aee921b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Qui consequatur commodi qui doloribus ex.',NULL,'',201111020312732,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(112,'079451a4ebbd4041920c54cb1d19699c','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Omnis natus voluptates placeat voluptas soluta.',NULL,'',200811131391764,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(113,'9912624cf52a408686c732359f2fe129','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Labore in similique et ut nihil ex a.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(114,'ba14df63fc86409387ae908cd56b5478','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Optio numquam expedita rerum ut est reiciendis.',NULL,'',201105040535175,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(115,'fe6a1316bffb458ead0322b0bb3b5b47','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Eukaryota</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:34','2014-04-07 11:34:34','2014-04-04 11:34:34','2014-04-04 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(116,'99be157fe6e3483d9faee637b0441306','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Eukaryota</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:35','2014-04-07 11:34:35','2014-04-04 11:34:35','2014-04-04 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(117,'ab36c91c2daf48f88b39e0625c444d30','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Dolorem velit id error laborum et iste et. Eum id ex. Aspernatur ut vitae itaque quidem molestiae quae. Impedit quos et similique.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:35','2014-04-07 11:34:35','2014-04-04 11:34:35','2014-04-04 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(118,'7a497b6bd7cc401abd88763d87b43e4a','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Et sed rem ut ut voluptates maxime sit. Facere culpa et omnis voluptas voluptatum. Distinctio harum et laboriosam iure. Harum voluptatibus rem. Porro molestiae veritatis voluptatum quia.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:36','2014-04-07 11:34:36','2014-04-04 11:34:36','2014-04-04 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(119,'a62d7e5b6edc4c3385c1f9c488cee404','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Delectus et ea consequuntur.',NULL,'',201201250367476,'',NULL,'',0,0,0,'2014-04-04 11:34:37','2014-04-07 11:34:37','2014-04-04 11:34:37','2014-04-04 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(120,'6fab8c9f45894618871973d1b0b87a82','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Non voluptas eum dolorum eveniet repudiandae eaque.',NULL,'',201202010281247,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(121,'fe5a92866d0d42a382f6926063042ec5','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Ab in quia et neque dolorem omnis qui odit.',NULL,'',200811131316882,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(122,'c370e3c1c03f4486a225547caab1e96f','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Fugit voluptatem unde inventore.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(123,'16c395614a9047b98e4191bb1bfcc2f6','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Ullam est molestias ipsam.',NULL,'',201105040549841,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(124,'b3ce4f5aaec34668954b7db696a34a3b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Quoautesi natuseri</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(125,'67c8a00c6178448b8b830fe3535e0d83','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Quoautesi natuseri</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:38','2014-04-07 11:34:38','2014-04-04 11:34:38','2014-04-04 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(126,'f8507374a0f845e6b9cefbd94dfe1cbb','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Iure exercitationem dolor nulla quam et ratione. Voluptatem ab et omnis aspernatur omnis. Et voluptate sed voluptates similique deserunt nesciunt.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:39','2014-04-07 11:34:39','2014-04-04 11:34:39','2014-04-04 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(127,'013a3701e2524a61bc91a8d357f46541','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Doloremque pariatur quo at esse odio quis. Natus quisquam ipsum. Quos odit nemo.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:39','2014-04-07 11:34:39','2014-04-04 11:34:39','2014-04-04 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(128,'121bf906795448b7a8b11992e5699fca','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Quod culpa voluptatem voluptates id.',NULL,'',201202230021720,'',NULL,'',0,0,0,'2014-04-04 11:34:41','2014-04-07 11:34:41','2014-04-04 11:34:41','2014-04-04 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(129,'762e745c70234c0b9ed6bd0c816f9bd9','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Dolor at illum maiores voluptatibus ut tempora recusandae.',NULL,'',201301230017775,'',NULL,'',0,0,0,'2014-04-04 11:34:41','2014-04-07 11:34:41','2014-04-04 11:34:41','2014-04-04 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(130,'d8ad64a56e124d45bb8abdce6949f162','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Laborum voluptatem aut incidunt ut.',NULL,'',200811131328300,'',NULL,'',0,0,0,'2014-04-04 11:34:41','2014-04-07 11:34:41','2014-04-04 11:34:41','2014-04-04 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(131,'ddc64b550a724c829f30f7f45379765c','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Qui rem cum architecto et ut.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:41','2014-04-07 11:34:41','2014-04-04 11:34:41','2014-04-04 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(132,'7dea42da919e4354b3c1f1cdec7255c9','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Laboriosam aut magni consequatur ducimus maiores aut.',NULL,'',201105040560889,'',NULL,'',0,0,0,'2014-04-04 11:34:42','2014-04-07 11:34:42','2014-04-04 11:34:42','2014-04-03 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(133,'1fa2d0c5290b45daae38d47a75a4117a','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Voluptatumeri esseensis</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:42','2014-04-07 11:34:42','2014-04-04 11:34:42','2014-04-03 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(134,'4cdfedec337d4bc0b07e174c95ee5057','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Voluptatumeri esseensis</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:42','2014-04-07 11:34:42','2014-04-04 11:34:42','2014-04-03 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(135,'abce087e9df74eac89ad034f847b7761','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Eius non cum molestiae exercitationem. Sed ullam facere aut. Tenetur quas quia dolorum delectus magni aspernatur. Cupiditate rerum molestias temporibus. Tenetur sed illum commodi repudiandae sunt.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:42','2014-04-07 11:34:42','2014-04-04 11:34:42','2014-04-03 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(136,'0ea519f0868a49df8a202df4c9a4e7ef','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Voluptate numquam voluptatem aut. Illum eos qui sed quibusdam commodi dolore et. Aut quasi quis commodi possimus adipisci aliquam rerum. Modi et nobis eaque libero facere.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:43','2014-04-07 11:34:43','2014-04-04 11:34:43','2014-04-03 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(137,'ca80bc34588747f3b6e8beedd24e4084','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Vero et harum dolores.',NULL,'',201111011191042,'',NULL,'',0,0,0,'2014-04-04 11:34:44','2014-04-07 11:34:44','2014-04-04 11:34:44','2014-04-03 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(138,'be99140b6eb447b1bee0059b8bde1d3c','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Facere fugit est neque voluptatem quo quaerat molestias.',NULL,'',201203290041772,'',NULL,'',0,0,0,'2014-04-04 11:34:45','2014-04-07 11:34:45','2014-04-04 11:34:45','2014-04-03 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(139,'459b9e3f11c34be28f687dee200715ac','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Fuga ut sit voluptas laboriosam vel nemo eum.',NULL,'',200811131392039,'',NULL,'',0,0,0,'2014-04-04 11:34:45','2014-04-07 11:34:45','2014-04-04 11:34:45','2014-04-03 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(140,'475f22f94ee4487c91f61d78cbbf84a2','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Saepe alias nesciunt aut mollitia sunt.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:45','2014-04-07 11:34:45','2014-04-04 11:34:45','2014-04-03 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(141,'a907c02443f34545abaf9b17c109fa82','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Odio ducimus error dolores occaecati incidunt saepe et temporibus.',NULL,'',201105040555104,'',NULL,'',0,0,0,'2014-04-04 11:34:45','2014-04-07 11:34:45','2014-04-04 11:34:45','2014-04-03 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(142,'ed9fb2e58da14badb5e472b88eaabc79','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Ameti maioresis</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:45','2014-04-07 11:34:45','2014-04-04 11:34:45','2014-04-03 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(143,'f4e6d94178f74ea5bd820a87199c596b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Ameti maioresis</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:46','2014-04-07 11:34:46','2014-04-04 11:34:46','2014-04-03 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(144,'bc3de7983ecd4ba78a8b2e8c01a778ba','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Quasi laudantium minima ut nesciunt voluptas molestias excepturi. Doloremque consequatur voluptates. Ipsa beatae nesciunt qui fuga. Incidunt non deserunt eos odit ut. Magnam temporibus dignissimos aperiam et est suscipit.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:46','2014-04-07 11:34:46','2014-04-04 11:34:46','2014-04-03 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(145,'52a240b3683f4bffa96ef6e63d4fc942','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Aut iure voluptatem ipsam repellendus dolorem. Explicabo architecto nam ratione doloremque. Molestiae voluptatem ut porro tempora velit. Quia totam excepturi sit voluptatem. Tenetur impedit dicta enim.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:46','2014-04-07 11:34:46','2014-04-04 11:34:46','2014-04-03 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(146,'a6328adef5fb4e9e98b3dd42272e4296','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Voluptatem eaque quam nostrum rem incidunt qui.',NULL,'',201202010290745,'',NULL,'',0,0,0,'2014-04-04 11:34:48','2014-04-07 11:34:48','2014-04-04 11:34:48','2014-04-03 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(147,'e7c85514117c42bebf2e1b9162d0ba3f','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Ratione eveniet similique quia officiis.',NULL,'',201201041249064,'',NULL,'',0,0,0,'2014-04-04 11:34:48','2014-04-07 11:34:48','2014-04-04 11:34:48','2014-04-03 08:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(148,'aa1324ecde9f426c9238fa5db979f41a','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Quia doloremque tempora voluptatum perferendis.',NULL,'',200811131350808,'',NULL,'',0,0,0,'2014-04-04 11:34:48','2014-04-07 11:34:48','2014-04-04 11:34:48','2014-04-03 07:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(149,'6a78fe463cb24aa783c20f360cf6dd9e','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Voluptatem sit molestiae nobis.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:49','2014-04-07 11:34:49','2014-04-04 11:34:49','2014-04-03 06:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(150,'bf92ecf9eb7c40a09b32b68156c63bf1','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Qui architecto ducimus et ipsam eum iure.',NULL,'',201105040573195,'',NULL,'',0,0,0,'2014-04-04 11:34:49','2014-04-07 11:34:49','2014-04-04 11:34:49','2014-04-03 05:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(151,'81e58f31937e41d4b549a4777cdac9c6','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Ipsamalius distinctioerox</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:49','2014-04-07 11:34:49','2014-04-04 11:34:49','2014-04-03 04:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(152,'9efd59e23ce0448992ddb216540230ce','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Ipsamalius distinctioerox</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:49','2014-04-07 11:34:49','2014-04-04 11:34:49','2014-04-03 03:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(153,'8378a06d18eb40c1889a9bb6eda454ba','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Voluptas veniam mollitia voluptatem nulla. Autem enim voluptatum cum provident omnis ducimus. Adipisci ullam recusandae.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:49','2014-04-07 11:34:49','2014-04-04 11:34:49','2014-04-03 02:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(154,'a452270f9bb14c0b8d8d872ce824f220','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','At quasi et sapiente tenetur voluptas ex. Dolore molestias et voluptatem. Officia cumque ad perferendis ut nostrum sapiente excepturi.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:50','2014-04-07 11:34:50','2014-04-04 11:34:50','2014-04-03 01:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(155,'c8c4c60c4e474778b235e10cf248de37','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Expedita soluta et sapiente aut nobis ut natus illo.',NULL,'',201208062341539,'',NULL,'',0,0,0,'2014-04-04 11:34:51','2014-04-07 11:34:51','2014-04-04 11:34:51','2014-04-03 00:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(156,'2fe9e7ab3bb54619b5362e0351988337','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Et voluptas omnis tempora ut sed quis nesciunt repellendus.',NULL,'',201207020117313,'',NULL,'',0,0,0,'2014-04-04 11:34:52','2014-04-07 11:34:52','2014-04-04 11:34:52','2014-04-02 23:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(157,'7e5ebb18907b42239d4f8f7afb345c10','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Sint necessitatibus et explicabo officiis magnam.',NULL,'',200811131333809,'',NULL,'',0,0,0,'2014-04-04 11:34:52','2014-04-07 11:34:52','2014-04-04 11:34:52','2014-04-02 22:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(158,'e77bbbb9607041448342769b27a19c80','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Quae sit qui architecto doloremque dolorem maxime rerum.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:52','2014-04-07 11:34:52','2014-04-04 11:34:52','2014-04-02 21:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(159,'8f93984ff35b483f9b8dd28fdb1d2b66','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Rem iusto odit distinctio vitae placeat.',NULL,'',201105040594149,'',NULL,'',0,0,0,'2014-04-04 11:34:52','2014-04-07 11:34:52','2014-04-04 11:34:52','2014-04-02 20:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(160,'32d5bf0f223e4b8e99be829d9690af93','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Maximees veritatisatus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:52','2014-04-07 11:34:52','2014-04-04 11:34:52','2014-04-02 19:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(161,'ebc8487ccd804ec5ba9fdfc797254c64','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Maximees veritatisatus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:53','2014-04-07 11:34:53','2014-04-04 11:34:53','2014-04-02 18:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(162,'3e21c6bbbc6a444daa8e5ebd3f5599ce','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Voluptatem cum iste qui voluptatem tenetur quo. Laboriosam est laborum qui eius excepturi. Sint quia soluta voluptatem laborum et.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:53','2014-04-07 11:34:53','2014-04-04 11:34:53','2014-04-02 17:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(163,'7c5569b9074344a0b8662d7e5213496c','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Consequatur ea omnis pariatur odio ratione quia et. Quis aut sint nihil dignissimos iusto nobis. Eaque qui quisquam est doloremque. Placeat possimus soluta. Excepturi quis ad.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:54','2014-04-07 11:34:54','2014-04-04 11:34:54','2014-04-02 16:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(164,'cebe8bce3e9e47d280e9d138e3f1617d','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Voluptate error iste similique unde.',NULL,'',201206100250227,'',NULL,'',0,0,0,'2014-04-04 11:34:55','2014-04-07 11:34:55','2014-04-04 11:34:55','2014-04-02 15:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(165,'7de524da02244b549a18941cd0a7d64a','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Veritatis eius voluptatem id quasi sit quas minima.',NULL,'',201111012019618,'',NULL,'',0,0,0,'2014-04-04 11:34:55','2014-04-07 11:34:55','2014-04-04 11:34:55','2014-04-02 14:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(166,'babde63e41474710b2b7ed820fd1d7d0','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Molestiae rerum aut quis facere accusamus odit optio.',NULL,'',200811131349975,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 13:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(167,'0dffb4bdd5ae4466b39c539e05c616d0','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Autem ipsum magni ipsam quos qui eligendi ut.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 12:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(168,'1480fb071411459c97caa3d398211f0e','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Ad ipsa est fuga et maiores eum facilis.',NULL,'',201105040549843,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 11:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(169,'77d6782d818d48f4879bf29f2b16c260','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Molestiaeus rationealia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 10:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(170,'cdf2c07aadb54e95ad20e300edf61dbd','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Molestiaeus rationealia</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 09:35:27',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(171,'0a2cc239004f4ac4addedc963798a4b5','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Dolore ipsum vero nobis esse non. Voluptatem pariatur exercitationem quas odio autem sint. Est consequatur laudantium officia architecto enim officiis.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:56','2014-04-07 11:34:56','2014-04-04 11:34:56','2014-04-02 08:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(172,'eb963a3134d14621846b2a11a0223979','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Quam reiciendis ipsum voluptatem quas. Aut assumenda in molestias. Inventore debitis cupiditate id.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:57','2014-04-07 11:34:57','2014-04-04 11:34:57','2014-04-02 07:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(173,'2daded19036c4f2ca0a75482e011599d','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Quibusdam veritatis earum at illum pariatur eum.',NULL,'',201111021549802,'',NULL,'',0,0,0,'2014-04-04 11:34:58','2014-04-07 11:34:58','2014-04-04 11:34:58','2014-04-02 06:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(174,'0ebf909f9a1b4c4a8778f6654df9e3c7','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Autem distinctio voluptatem cum.',NULL,'',201212282365133,'',NULL,'',0,0,0,'2014-04-04 11:34:59','2014-04-07 11:34:59','2014-04-04 11:34:59','2014-04-02 05:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(175,'7a72c7fa07684e67b4e4f610f7696492','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','In sunt ipsum ea velit dolor ratione.',NULL,'',200811131317614,'',NULL,'',0,0,0,'2014-04-04 11:34:59','2014-04-07 11:34:59','2014-04-04 11:34:59','2014-04-02 04:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(176,'3eabc98948c14747809a267c43b10b37','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Libero est deleniti rerum iste ut pariatur facere rerum.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:34:59','2014-04-07 11:34:59','2014-04-04 11:34:59','2014-04-02 03:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(177,'7df0aed0905546b0a0ee725bce788ee6','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Neque temporibus odio vitae et ea omnis.',NULL,'',201105040554365,'',NULL,'',0,0,0,'2014-04-04 11:34:59','2014-04-07 11:34:59','2014-04-04 11:34:59','2014-04-02 02:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(178,'f6b729020a53471eb00d19ef47d5bb16','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Fugitens dolorealius</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:34:59','2014-04-07 11:34:59','2014-04-04 11:34:59','2014-04-02 01:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(179,'e13820714ea948d290edff8c9562302f','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Fugitens dolorealius</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:00','2014-04-07 11:35:00','2014-04-04 11:35:00','2014-04-02 00:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(180,'2dfbba6de3fb43f1a6edcdfc62653842','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Tempora incidunt qui cum eum. Architecto nihil et accusantium doloremque molestiae sunt. Nihil tenetur facilis neque necessitatibus exercitationem officiis nisi.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:00','2014-04-07 11:35:00','2014-04-04 11:35:00','2014-04-01 23:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(181,'a05bd07c86cf4e7898963e72b5720d5d','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Aperiam quo esse explicabo. Doloribus asperiores quis sunt possimus amet. Maiores architecto doloremque. Cupiditate non illum. Odit sed voluptas provident sed nam.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:00','2014-04-07 11:35:00','2014-04-04 11:35:00','2014-04-01 22:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(182,'d1a40309f83e4adf883d8c5fbdcbfd0a','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Et accusantium minima voluptatem eum odio veniam tempora.',NULL,'',201203270178402,'',NULL,'',0,0,0,'2014-04-04 11:35:02','2014-04-07 11:35:02','2014-04-04 11:35:02','2014-04-01 21:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(183,'597b0ab1065644b7ae02181b1ddd1d1b','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Veritatis aspernatur sunt qui omnis exercitationem sequi necessitatibus.',NULL,'',201111020456873,'',NULL,'',0,0,0,'2014-04-04 11:35:02','2014-04-07 11:35:02','2014-04-04 11:35:02','2014-04-01 20:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(184,'059e38bb38cc44c78301e519cd7019a5','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Doloremque et occaecati sunt nisi aspernatur provident aut.',NULL,'',200811131356003,'',NULL,'',0,0,0,'2014-04-04 11:35:03','2014-04-07 11:35:03','2014-04-04 11:35:03','2014-04-01 19:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(185,'d10ad8fb4c9f4e43aa630cfec6356855','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Ea laborum doloremque porro aspernatur et.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:03','2014-04-07 11:35:03','2014-04-04 11:35:03','2014-04-01 18:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(186,'91b8738499564c77abbc9ffc1e3ad1b4','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Quia dolorem cupiditate quo.',NULL,'',201105040529974,'',NULL,'',0,0,0,'2014-04-04 11:35:03','2014-04-07 11:35:03','2014-04-04 11:35:03','2014-04-01 17:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(187,'3c677888404443d9ac06f732fd4c0316','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Quisquamator sequieles</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:03','2014-04-07 11:35:03','2014-04-04 11:35:03','2014-04-01 16:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(188,'a32b638ba7aa406ebf5fb94d1238abed','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Quisquamator sequieles</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:03','2014-04-07 11:35:03','2014-04-04 11:35:03','2014-04-01 15:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(189,'70903b52308e4692a4d78ab780a7c0b3','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Iure quis qui. Ut voluptatem sit iure porro autem. Neque facilis quod est. Praesentium distinctio inventore temporibus doloribus corporis repellendus aut. Qui cum neque ea ratione.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:04','2014-04-07 11:35:04','2014-04-04 11:35:04','2014-04-01 14:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(190,'8f14a9a6817a41e9a30260002e4243eb','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Neque voluptatem laboriosam perferendis. Ut veritatis expedita est. Aut at et dolor consequatur. Et assumenda soluta at quos unde corporis. Iusto iure et dolorem.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:04','2014-04-07 11:35:04','2014-04-04 11:35:04','2014-04-01 13:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(191,'c628fdcf0ef84f07be85a727e51dda1f','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Voluptatem minima nesciunt rerum.',NULL,'',201111020680528,'',NULL,'',0,0,0,'2014-04-04 11:35:05','2014-04-07 11:35:05','2014-04-04 11:35:05','2014-04-01 12:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(192,'86f8e4ce34444c20980330bc72c08e50','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Sed vel et numquam.',NULL,'',201111020677567,'',NULL,'',0,0,0,'2014-04-04 11:35:05','2014-04-07 11:35:05','2014-04-04 11:35:05','2014-04-01 11:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(193,'be35c4dc6e7b445bab849b3e83a02a03','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Architecto occaecati cupiditate vel vel natus.',NULL,'',200811131372942,'',NULL,'',0,0,0,'2014-04-04 11:35:06','2014-04-07 11:35:06','2014-04-04 11:35:06','2014-04-01 10:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(194,'9e74c08793224bce839cb862712ec22f','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Voluptatem et commodi accusamus a dolore ad cupiditate.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:06','2014-04-07 11:35:06','2014-04-04 11:35:06','2014-04-01 09:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(195,'5bba6f012fa8457fb57f3b7944853e13','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Quas nostrum ut deserunt repudiandae.',NULL,'',201105040538097,'',NULL,'',0,0,0,'2014-04-04 11:35:06','2014-04-07 11:35:06','2014-04-04 11:35:06','2014-04-01 08:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(196,'d8697be1ead04f13a90b876b97c25cf3','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Bacteria</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:06','2014-04-07 11:35:06','2014-04-04 11:35:06','2014-04-01 07:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(197,'82a800a036294960bf423cb80845019a','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Bacteria</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:06','2014-04-07 11:35:06','2014-04-04 11:35:06','2014-04-01 06:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(198,'62fd28f23560445e83d348e87610e622','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Ut quia nulla. Quasi ut corporis. Unde minus perferendis eum possimus.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:07','2014-04-07 11:35:07','2014-04-04 11:35:07','2014-04-01 05:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(199,'0c27bcfd815942538b149c8b5e4f7bd7','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Illum qui reiciendis. Nesciunt eligendi et. Totam vitae aut omnis tenetur culpa id. Vel est omnis rerum ut et quis error. Quasi soluta sequi asperiores ipsa in repellendus non.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:07','2014-04-07 11:35:07','2014-04-04 11:35:07','2014-04-01 04:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(200,'14aaa545881143589f7bdcd72691a909','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Ut nihil aliquid aliquam.',NULL,'',201201290348969,'',NULL,'',0,0,0,'2014-04-04 11:35:10','2014-04-07 11:35:10','2014-04-04 11:35:10','2014-04-01 03:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(201,'3ab4d09aed3d4c6a853819f8bb0e4750','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Vero sit harum quia soluta consequuntur consequatur dolor similique.',NULL,'',201111240192495,'',NULL,'',0,0,0,'2014-04-04 11:35:10','2014-04-07 11:35:10','2014-04-04 11:35:10','2014-04-01 02:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(202,'be58318c4161458eb3f9de5f349c9b05','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Ad sit aut ea ut ut debitis illum.',NULL,'',200811131393363,'',NULL,'',0,0,0,'2014-04-04 11:35:10','2014-04-07 11:35:10','2014-04-04 11:35:10','2014-04-01 01:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(203,'1fe59f85fd354b3fb3570a357bd5d010','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Assumenda velit impedit quia nisi.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:10','2014-04-07 11:35:10','2014-04-04 11:35:10','2014-04-01 00:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(204,'fc85f18f0ea249b3a9dd60ffd1727def','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Dolore animi corporis aliquid modi et possimus.',NULL,'',201105040535175,'',NULL,'',0,0,0,'2014-04-04 11:35:11','2014-04-07 11:35:11','2014-04-04 11:35:11','2014-03-31 23:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(205,'7bbd446694ca48b099e886185e7fd49b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Essees eaqueata</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:11','2014-04-07 11:35:11','2014-04-04 11:35:11','2014-03-31 22:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(206,'c5c6b1f9796843848c19b5863330f8a5','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Essees eaqueata</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:11','2014-04-07 11:35:11','2014-04-04 11:35:11','2014-03-31 21:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(207,'037a09b0e5b443abb83b791e0ed4d397','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Quia dolor ut et rerum. Itaque molestias culpa commodi accusantium. Inventore et veniam quaerat. Ratione nobis hic iusto dolores nemo.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:11','2014-04-07 11:35:11','2014-04-04 11:35:11','2014-03-31 20:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(208,'d93768effab1459a90a2b901db840fbe','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Deserunt quo dolor rerum nostrum odio cumque. Repellat odit vel veniam saepe. Doloribus et nostrum nobis adipisci harum aperiam voluptate.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:12','2014-04-07 11:35:12','2014-04-04 11:35:12','2014-03-31 19:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(209,'109ff3a3db0c4199b8d1f79c66cbd77f','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Deserunt velit quisquam tenetur aut.',NULL,'',201206250194550,'',NULL,'',0,0,0,'2014-04-04 11:35:13','2014-04-07 11:35:13','2014-04-04 11:35:13','2014-03-31 18:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(210,'41fdaeb05f044836b70186ebfe6cd42d','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Consequatur dolor voluptas corporis optio voluptatem non quia et.',NULL,'',201201070101022,'',NULL,'',0,0,0,'2014-04-04 11:35:14','2014-04-07 11:35:14','2014-04-04 11:35:14','2014-03-31 17:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(211,'1f8f500764824a25aef59fe31a1d858e','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Architecto corrupti dolor quo velit.',NULL,'',200811131382901,'',NULL,'',0,0,0,'2014-04-04 11:35:14','2014-04-07 11:35:14','2014-04-04 11:35:14','2014-03-31 16:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(212,'7f14c72597c240379a22b573d388bd2a','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Praesentium sed occaecati ut.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:14','2014-04-07 11:35:14','2014-04-04 11:35:14','2014-03-31 15:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(213,'ecb4869d4fec4676b899a4eb5be6a768','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Molestiae maxime ut eum corporis tenetur est.',NULL,'',201105040549841,'',NULL,'',0,0,0,'2014-04-04 11:35:14','2014-04-07 11:35:14','2014-04-04 11:35:14','2014-03-31 14:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(214,'c15a4aec19244ac5b995ec839d1e20de','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Animiens atdoloribuseron</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:14','2014-04-07 11:35:14','2014-04-04 11:35:14','2014-03-31 13:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(215,'9aa95c6454334a60b46f573383829bf6','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Animiens atdoloribuseron</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:15','2014-04-07 11:35:15','2014-04-04 11:35:15','2014-03-31 12:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(216,'57c674744d2d45c88a5179b0754db2ed','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Est magni aut nihil rerum accusamus. Ipsam et error fugiat. Quam repudiandae ab inventore distinctio autem.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:15','2014-04-07 11:35:15','2014-04-04 11:35:15','2014-03-31 11:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(217,'d01022271fca407c922fb310641262e3','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Unde dignissimos similique et placeat omnis quae. Cum rem ea. Et similique rerum.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:15','2014-04-07 11:35:15','2014-04-04 11:35:15','2014-03-31 10:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(218,'e8972a235a5c42aca40c562525ba913d','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Aut accusantium quas exercitationem qui.',NULL,'',201301070350990,'',NULL,'',0,0,0,'2014-04-04 11:35:17','2014-04-07 11:35:17','2014-04-04 11:35:17','2014-03-31 09:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(219,'36c1ff3964c64971a6598cff0cf1cadd','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Vel corporis accusantium et modi iste nam provident.',NULL,'',201205060097570,'',NULL,'',0,0,0,'2014-04-04 11:35:17','2014-04-07 11:35:17','2014-04-04 11:35:17','2014-03-31 08:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(220,'a49589c5bdb24c32bc384badd25b99e0','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Fugit labore voluptate voluptas culpa maiores nobis earum itaque.',NULL,'',200811131355461,'',NULL,'',0,0,0,'2014-04-04 11:35:18','2014-04-07 11:35:18','2014-04-04 11:35:18','2014-03-31 07:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(221,'23ce13811b6546f6a0d610ff5bb709a8','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Optio aliquid delectus facere eius doloribus tenetur.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:18','2014-04-07 11:35:18','2014-04-04 11:35:18','2014-03-31 06:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(222,'5d31d8eec9874f6bad299c335ca2e096','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Ex hic tempora voluptatem porro dolor.',NULL,'',201105040560889,'',NULL,'',0,0,0,'2014-04-04 11:35:18','2014-04-07 11:35:18','2014-04-04 11:35:18','2014-03-31 05:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(223,'d06b5c071a6c4c1390c5509e4d2ebc12','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Adaliasii iurea</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:18','2014-04-07 11:35:18','2014-04-04 11:35:18','2014-03-31 04:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(224,'8a468dd3e97e49799c171457fabee159','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Adaliasii iurea</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:18','2014-04-07 11:35:18','2014-04-04 11:35:18','2014-03-31 03:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(225,'c5582e6eef9d418d95f630ac8f8ad153','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Vel dolorem voluptatibus quod. Rerum vero et consequuntur excepturi repellat. Harum quia voluptatum. Quia provident odio est velit officiis esse error. Possimus ipsum sint voluptate.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:19','2014-04-07 11:35:19','2014-04-04 11:35:19','2014-03-31 02:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(226,'1bda16dc88af44c0936ffd97fe67d6e6','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Corrupti voluptatum aut dolor nam est fugit explicabo. Laborum fuga explicabo quisquam. Quia suscipit ipsum fugit. Ex quia sit et. Asperiores voluptatem necessitatibus qui quidem aut sint.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:19','2014-04-07 11:35:19','2014-04-04 11:35:19','2014-03-31 01:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(227,'f161b0adaa4b49a6a5c375a60dd69241','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Placeat consequatur velit quos non quis itaque.',NULL,'',201111021659647,'',NULL,'',0,0,0,'2014-04-04 11:35:20','2014-04-07 11:35:20','2014-04-04 11:35:20','2014-03-31 00:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(228,'0899d16b4744472f8cd9d87a28fffc36','',NULL,2,NULL,1,'',1,NULL,1,'Test rights statement','','','','Blanditiis vel laboriosam fugit vero sapiente in qui eum.',NULL,'',201111210127467,'',NULL,'',0,0,0,'2014-04-04 11:35:20','2014-04-07 11:35:20','2014-04-04 11:35:20','2014-03-30 23:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(229,'1310185d00bc48e99c8f49e4e7a9c570','',NULL,7,NULL,5,'',1,NULL,1,'Test rights statement','','','','Sit quia qui laborum et dolores id ullam earum.',NULL,'',200811131374742,'',NULL,'',0,0,0,'2014-04-04 11:35:21','2014-04-07 11:35:21','2014-04-04 11:35:21','2014-03-30 22:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(230,'f7552b968da34ec3941cb9224f40d64c','',NULL,6,NULL,5,'',1,NULL,1,'Test rights statement','','','','Necessitatibus harum incidunt iste cum.',NULL,'',0,'',NULL,'',0,0,0,'2014-04-04 11:35:21','2014-04-07 11:35:21','2014-04-04 11:35:21','2014-03-30 21:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(231,'9f5f2b48bd994d5a9e3be18252f541ba','',NULL,3,NULL,2,'',1,NULL,1,'Test rights statement','','','','Est qui modi qui.',NULL,'',201105040555104,'',NULL,'',0,0,0,'2014-04-04 11:35:21','2014-04-07 11:35:21','2014-04-04 11:35:21','2014-03-30 20:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(232,'6cd4e4a06cb94aaa9eaefb82623130ad','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an overview of the <b>Nonnumquamerus numquamerus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:21','2014-04-07 11:35:21','2014-04-04 11:35:21','2014-03-30 19:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(233,'2d82b1c6f67441a4958b718e5dd40d1b','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','This is an description of the <b>Nonnumquamerus numquamerus</b> hierarchy entry.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:21','2014-04-07 11:35:21','2014-04-04 11:35:21','2014-03-30 18:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(234,'cfeccf9cd12e4fa2ac670c679239be76','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Consequatur enim facere asperiores illum occaecati qui. Aperiam incidunt consequuntur dignissimos veniam omnis reprehenderit. Porro suscipit velit est corrupti aliquid expedita.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:22','2014-04-07 11:35:22','2014-04-04 11:35:22','2014-03-30 17:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(235,'2cf098a91c164c8ab2e215fc3533a227','',NULL,1,NULL,3,'',1,NULL,3,'Test rights statement','Someone','','','Voluptas ut officia. Rerum harum soluta molestiae dolores eius nisi omnis. Amet modi nisi et veniam dolore fuga reiciendis. Totam inventore voluptatem. Quaerat nulla totam qui.',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:22','2014-04-07 11:35:22','2014-04-04 11:35:22','2014-03-30 16:35:28',NULL,2.5,1,0,NULL,NULL,NULL,NULL),(236,'fc5ff4446800453d82ba3f14ed9c9209','',NULL,2,NULL,1,'',1,NULL,3,'Test rights statement','Test rights holder','','','Test Data Object',NULL,'',NULL,'',NULL,'',0,0,0,'2014-04-04 11:35:30','2014-04-07 11:35:30','2014-04-04 11:35:30','2014-04-06 11:35:30',NULL,2.5,1,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `data_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_harvest_events`
--

DROP TABLE IF EXISTS `data_objects_harvest_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_harvest_events` (
  `harvest_event_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `guid` varchar(32) CHARACTER SET ascii NOT NULL,
  `status_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`harvest_event_id`,`data_object_id`),
  KEY `index_data_objects_harvest_events_on_guid` (`guid`),
  KEY `index_data_objects_harvest_events_on_data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_harvest_events`
--

LOCK TABLES `data_objects_harvest_events` WRITE;
/*!40000 ALTER TABLE `data_objects_harvest_events` DISABLE KEYS */;
INSERT INTO `data_objects_harvest_events` VALUES (2,2,'071624effac247d8b4b151e25c8a7a22',1),(2,3,'036709213a0222e79baaa47b0fac5d31',1),(2,4,'3034a822f52ed6314e5f48e0eb0771bb',1),(2,5,'cbb5a63492bec05ef3ebeaa336828df9',1),(2,6,'addf5a562ff7f654639495269dd688e2',1),(2,7,'ada5f240edf208495c24a158c39dd408',1),(2,8,'b2df316b85d5dd70005963f113caf2f7',1),(2,9,'09fce7fe6be648963467407c8ece22b4',1),(2,10,'196722ceb68e8ea0942cc67b867e48f2',1),(2,11,'75828f7204beb1b6dec010f46ad4554c',1),(2,12,'10701e80e73a27097e7969b1937424b4',1),(2,13,'44caa65af9630f5e59f6d2a259f4f15c',1),(2,14,'21b936e34b890ff52aac88cf6e0de2ae',1),(2,15,'0143cc0029c2ea025df4744a8c2d604a',1),(2,16,'7c1dde51596224033ad39202b595a88f',1),(2,17,'5536ecddcf5ea271fd477e58e848d739',1),(2,18,'2a91e3240dce48c5bfdcf584f103696b',1),(2,19,'4fc0c0bcee12ffbfdb37b590ccb63a1f',1),(2,20,'92fb7689e6bf8952d4cdc2106e29ace9',1),(2,21,'393b22684e10afbe8fb29b6bdf73ca28',1),(2,22,'0541af00e9b302be577b2373049e21ca',1),(2,23,'43bc311620b2048b533ebdb6faccd637',1),(2,24,'043f7a16372b5f24159569b0a17ea1e4',1),(2,25,'022b9032f99f8127ebfa5b1ba0ec31d2',1),(2,26,'f575e9cb55edd32c088187dfdf26d5f8',1),(2,27,'3d44aae23ab0d5dc6417e5c716f02c22',1),(2,28,'a4944f6ebab109e18a60bfbca10f2316',1),(2,29,'65d1bc7ee36e68a67dc91666be8512bf',1),(2,30,'a3aa03c063cc31b283d50cdeda2cf6de',1),(2,31,'5adb2a1546a75aabe8ce7e4ed9b58f83',1),(2,32,'70f41b525d0941812ebc5884ca28dd1f',1),(2,33,'ba93e115de78806c69572278cf9da5fc',1),(2,34,'9c710bfaabea6ae4930d06924be53611',1),(2,35,'56a5576b9ef6577ff974571770c11a4c',1),(2,36,'db4ccdf426f05405fd80dc97311a39fe',1),(2,37,'c7a87125024e5e213bf85b7ead3d586e',1),(2,38,'6b9a8615a0063183de1858d3b13ad5fe',1),(2,39,'47a928df44452c21a8c97000bd440c2d',1),(2,40,'94057017ec827743165ddff7e3eee3ff',1),(2,41,'41a1e21c1514f352fa40f227e1930aa2',1),(2,42,'5e1baeefa6ffea68f18bb7468b6761aa',1),(2,43,'2151e30ec316e0dda96dd2223237fe5d',1),(2,44,'f72f3a0039561e6d589367619c72c7b1',1),(2,45,'467e52cbe805d403c75b9bf0071e6205',1),(2,46,'b47746b27d7b9d5e459b94141a91adf2',1),(2,47,'39ab52b39e66e2189ecad50cbaad292d',1),(2,48,'e889b0c9bf54e11cb85484c7efe5f881',1),(2,49,'044cf4a1986e66037330502e8ab64def',1),(2,50,'b425871b28f1e522f3580470d2012a02',1),(2,51,'35c416c88a4f45aa2620a3fa473171ec',1),(2,52,'3410192db82f8d3ac0ff683a152ebe6c',1),(2,53,'05ca088a77c4a37fe0699a6700d4e328',1),(2,54,'0704446b009bf9deeaa02f85eadef573',1),(2,55,'518b3437a371d7e7e84b2743b7a48162',1),(2,56,'abdd53b375ff2af6b4a4af7ead69fdc1',1),(2,57,'a4623843f47b856d867f126c74a07b99',1),(2,58,'164537fe7d096f6fc383471dd6a66fa5',1),(2,59,'db00ac6eb88b2095a40c930f6367eae3',1),(2,60,'8c091603f4fc075c48e8ae826414c504',1),(2,61,'cc099090a341880b4f051c6bb6e80935',1),(2,62,'55e234ed55ef9d83a6239c239a3b8f47',1),(2,63,'09d213ecc921c2cd80cc7618c8238aff',1),(2,64,'aa02e9091bbf0e88b9e9bd30af8fe3cf',1),(2,65,'ebc3a9adf92f1afa20d78e00069dd4c5',1),(2,66,'066dccdfcf3241123e681a33ca5aadc9',1),(2,67,'0fbc699cebcc35cfaeed034ba58ff25d',1),(2,68,'eb624261e13ab685a18a733e861af931',1),(2,69,'754d053598d17be027ab409aef15e48e',1),(2,70,'4f9bbfcb283d2ee1d79c23bfc5dbcbdd',1),(2,71,'83c345670eb0cc0c18639c7776fb551d',1),(2,72,'8132894e7fb1065dd12efdc0c47f1e5b',1),(2,73,'e85c1ff992020930758e38f658a35702',1),(2,74,'a0f81cbf5f8eabfb8683b928b38b8717',1),(2,75,'f48f4d68d132a4474386558ec0e6d230',1),(2,76,'b76a4b300fe8f95883e3976ed2903134',1),(2,77,'077dbe926bf4925cfbdf68ed8e097c10',1),(2,78,'d51d76fe9a1851f3877c2fc1cf5038d1',1),(2,79,'484b8d075f3f938b7b29d4057902d1b6',1),(2,80,'3945643c8917ac9a442228336c6d3609',1),(2,81,'c52b9c42f8179a74fcfa8b7b31d44927',1),(2,82,'e87bd87d51cc465a6a3836093be272e2',1),(2,83,'00fb8de00fe75f56595ae276c801f78f',1),(2,84,'60cf7fff7aa45e73cc1bf47438fe9064',1),(2,85,'934742e605d26d3792acf56d8321ee51',1),(2,86,'ac92f09a195be7c66ce98ed06f4c51b7',1),(2,87,'031ddfc32d8c51d24d24791883ca79de',1),(2,88,'20004ecfd89dc0c2f2032a093147f318',1),(2,89,'ea08e0e9f244a7e4424231eca8d75bf6',1),(2,101,'96644afb3116f8a601e87255edea873b',1),(2,102,'7933067541d5cfc292b82db5ce3a2e59',1),(2,103,'d7137fdd40bc04ad29be8cc0ce2f6777',1),(2,104,'c9526d1592fa76cab1511e6a0d49a05e',1),(2,105,'ea1f702aa80a70c0bdb5600da74a98af',1),(2,106,'0841acacf83467b156991826441883b8',1),(2,107,'7ad3df041c11db541605e41ec10e20d9',1),(2,108,'362bba29cb38ce0e8f9bc4e01e3ce309',1),(2,109,'9c66674cb74f0bba07dc1f5f7c96189b',1),(2,110,'6d94edb281eeef039e7b0ea2aa669ffd',1),(2,111,'1be39b519ca23d1c25dd7feed1e226ef',1),(2,112,'a500edcf3de35f63f49ec8afc3b0f617',1),(2,113,'98466c8eaf0ee2b32b93f1b9fea57532',1),(2,114,'6f764467a9830f47b62b544ce6da6399',1),(2,115,'4837b9895ca6a6eed1e25e34062b7908',1),(2,116,'5525f1c437a05eb19107462733299068',1),(2,117,'0d13c98f551329f4a1d1ef4d721e0169',1),(2,118,'bbb92717af62133de445c1e91267b8ef',1),(2,119,'43c5539bfb09473e0b48cd718b6cd7f4',1),(2,120,'040d15f72286a2d0bc89f2d475ea1fc8',1),(2,121,'bdf508dab4359dc9c77128712acc2982',1),(2,122,'2fce5ce50ae401112f6fc6a6661ff3a2',1),(2,123,'41b08ada5aec03a1b3ed09a44fc39a4b',1),(2,124,'26e432986d26ef70f222d97a4b5604f5',1),(2,125,'0bbe44cf0d0e3613b89ce92dede4f72e',1),(2,126,'ae9b300951773c9d6e01a067e05a4079',1),(2,127,'f2aa56f3bdbb50214cec42660f123b29',1),(2,128,'09f04fed903c5e7930f81add1dbd2063',1),(2,129,'b6d1d2f532a9ddedf5fe942cb1857805',1),(2,130,'b8952a3ef6fb68e4c2376c8176d773b4',1),(2,131,'15a147028b503363363c34a4ef52bff6',1),(2,132,'a65bc3f5f321c9439d8579faf9bc2526',1),(2,133,'7ab24e28699967487c500188469ef4c3',1),(2,134,'a1388c32bddc958ca1264e0cf5c95a3e',1),(2,135,'fb3d5cb02e1ed6e47c22251f2f6d0703',1),(2,136,'58e247fdb524d935ecee0f007e8cebb1',1),(2,137,'83018147ee74cf10a9150119ce3389db',1),(2,138,'0b0ebce0eb103c6f97249476841be17e',1),(2,139,'8721b2cb0e7f60859937b865db92ddcf',1),(2,140,'df75f0f85fc0603f899876c62fce0571',1),(2,141,'01e247e50249a536da6f3ba064809766',1),(2,142,'ad3b21a4cd699d6def13f75ceb4417b2',1),(2,143,'92b6b69337f599667b369881da35410d',1),(2,144,'f8c677703bea2f804d80fc6650deb790',1),(2,145,'ce3d386aa48dd60f13cc9b16e3ca9cf3',1),(2,146,'d5e1d938f1eb4efb92b05fae3785afd1',1),(2,147,'159302eb88ec3e5cff8ea887566f375f',1),(2,148,'094c0bd3530c88038f5d275b8f128d18',1),(2,149,'fd13c2cd2bf150ac22e06bc63c565b9c',1),(2,150,'059c1c84208f8a8c4b49bb3f5c721995',1),(2,151,'b3477ef3443fe6bf046d263db345b482',1),(2,152,'8a0e5989d78d72901acf2e4a93767314',1),(2,153,'60c4e0b52bae60c342f89d6a89b87bc4',1),(2,154,'9152bb834823e8e223d6fcd8aa8c51ff',1),(2,155,'e27380871a5a9db872f773ec8faa72f4',1),(2,156,'b50c7acb962ed9c7d1ab6f74179e24a9',1),(2,157,'a39a7a140858f2dd798b3b4d4bb5c8bb',1),(2,158,'5b07dc132c4e3215955d21ce7ffbe63d',1),(2,159,'ef6d432a10bb0487a2487402149a9c79',1),(2,160,'ae969f5a34458fc86f0242cd9cdcefd0',1),(2,161,'207875454da74c9170a7b6cd241a11a4',1),(2,162,'8867630a1e63c68ed2af8cab0bbd649b',1),(2,163,'5a3f614f93ac104212c368cddfbf2a10',1),(2,164,'c6df65764fda2a563bb49aed44a4f20d',1),(2,165,'48cfa6ba014a20ad73e69fd04d8f054a',1),(2,166,'e245a0a735c043c0791edac8c6b49acc',1),(2,167,'53459f1367ac8e0119050cafb7687db6',1),(2,168,'5d67fd45d5248fc21d39241a026c9fee',1),(2,169,'337fa1f4102353e2c72aa048ed553956',1),(2,170,'ae82ace7fbcbb2254fbdafca0b917bf1',1),(2,171,'6ba234b5ff42c1c5ce91faf92ccc52e5',1),(2,172,'bb414743a0cdea51d67a5aeef5080aa2',1),(2,173,'427cc981732fbc8cad36895e204deeb1',1),(2,174,'c1d7f05019a5c5e5dae95b1d218dfe0e',1),(2,175,'0b88530609e408ca18e801bd25a8c355',1),(2,176,'71f3028eb61e0e7ac1da559eea1f8b0e',1),(2,177,'88bfea1b27ff5917ba06ff997f7ed0be',1),(2,178,'d562051bd5bc2d313efbbbef0d034c11',1),(2,179,'679ea6376e618705b69ebec040ffd51f',1),(2,180,'fdad7c88404b734353bec19059b75c3e',1),(2,181,'bf9eb00f7ef2448b92a42ed7797dc0d8',1),(2,182,'a50486b391d9ea67735d28bff28a2a8d',1),(2,183,'e89c6924a8a85ae251dec2c93d5da599',1),(2,184,'b919746beab46abc3f923e418c13f716',1),(2,185,'333100b809d52274e4356ed144a16d3e',1),(2,186,'575deca28cb18b16d3429323e42f6fb6',1),(2,187,'f889017e9ea406b7bebd81be374dff1b',1),(2,188,'36a6a5cf2dc80c7100f399754992d1e9',1),(2,189,'871174fb798bb8abc8235fb8e619b88b',1),(2,190,'846a6fe69f6e1b10376a289f78edf36f',1),(2,191,'674d13cdc6984a7903b8fa6accdd37a2',1),(2,192,'cfd02be113f0f61922a0e6ba9fe2741b',1),(2,193,'3b52d73363872f731e2dbf494faf3904',1),(2,194,'34aab2fd7caf40319af60599d2ad096d',1),(2,195,'79c0ac85a94374732d95f8900367362f',1),(2,196,'6964cff82d49a18ec076f1f9ee1a2035',1),(2,197,'c505adf993205b902980e7fe4d4f0f54',1),(2,198,'c4bd16ca3c2b470816dbc6632eed7751',1),(2,199,'08d20816bff12f285d85fb7d8972afb2',1),(2,200,'23b099b07ffe5c16643721ae323ec25c',1),(2,201,'9090a80029dcd02682dbdf92a3a9b626',1),(2,202,'02b253b85a47643a7b7894ddfe82d28c',1),(2,203,'5c93f0d81bd17f87af9d0c4d2402487e',1),(2,204,'b470e3241c0ea42ea3c6c2fb0abe9aeb',1),(2,205,'4c07e6ebdec33157f91aef533a5c14e0',1),(2,206,'aaa5ded05cd9f3826938b7c388982b39',1),(2,207,'5ffbf70c1ec6ddff4bb977a087f72234',1),(2,208,'3136d38dc98e05f6c625afe156199373',1),(2,209,'a90e3d6953a00d789e44807d953d7e27',1),(2,210,'67606cadb3729936fcc5a4e78df01741',1),(2,211,'536c20ad3152dab57c5b1bb80add9dc5',1),(2,212,'c5d87ad5ef963e3bbb6dcdfa9a505dac',1),(2,213,'bc74858632b905ee28b5eaae20e5fc43',1),(2,214,'c0f209e62e36a75c6f6c4d6459ba40eb',1),(2,215,'213308ff18cd38f0cc7d56ff42b0c158',1),(2,216,'a7cc648a783e2648aeb9c1cb136816ce',1),(2,217,'0007654c376c667903bcfd2ad3a84b60',1),(2,218,'fbe7ffe1745dd555e6ff2d9abf54dce6',1),(2,219,'f0939d540700e7d07f1a97aed396ebe2',1),(2,220,'d496d71d10156fe7b1dacf3ba76278d6',1),(2,221,'19d18d119c49bc529274ff137aaa8c72',1),(2,222,'bf08ba40493080a3d3be069ca120f802',1),(2,223,'9459acb757c44621d26f208737dfc140',1),(2,224,'0fa6e821b6629e64beefabdce5fc828e',1),(2,225,'876bcbaa4fb8e10845c3394b44c34ee4',1),(2,226,'787c5559ae0ac121ff76ddcecde3887d',1),(2,227,'0755bbba55478632ea92362c521a189f',1),(2,228,'09737a6d59593664457040dce22289d5',1),(2,229,'1e5f296d9ae3acb174b7e4f64e22c9d7',1),(2,230,'a6e1b443d1f58b3255138ce6a8420a1a',1),(2,231,'a234ee49ebd053d1acce70843fa45ce3',1),(2,232,'4307c0235abe05e44035545a756ffdb6',1),(2,233,'385b60d297d0afe9a0405ebdd73a6758',1),(2,234,'799372f6c057c4ba7c43e499fc3fcb8b',1),(2,235,'e3c1653e73f1cf641e2d0b642ded3d31',1),(3,82,'e87bd87d51cc465a6a3836093be272e2',1),(4,88,'20004ecfd89dc0c2f2032a093147f318',1),(5,92,'d8d74c43d515d8101ffedb68f9b2ef55',1),(5,93,'1d8ab93babbbb1eff458daa236230f1d',1),(5,94,'f5bfef17151af635ea1985638bff8fdc',1),(5,95,'0c5e9068ccffa3a8b220eaf409f212e8',1),(5,96,'4f899caf14be6828453d09974650b261',1),(5,97,'6b806dd35fbc1efc463bef08a8a16b6b',1),(5,98,'cfeab3a3fe458749d0a88b23990d63e6',1),(5,99,'3c96b1534b4eb39fdde5226512b02da4',1),(5,100,'2e2bfe5a8397cdf91a738627c7a7b097',1);
/*!40000 ALTER TABLE `data_objects_harvest_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_hierarchy_entries`
--

DROP TABLE IF EXISTS `data_objects_hierarchy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_hierarchy_entries` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `vetted_id` int(11) NOT NULL,
  `visibility_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`data_object_id`),
  KEY `data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_hierarchy_entries`
--

LOCK TABLES `data_objects_hierarchy_entries` WRITE;
/*!40000 ALTER TABLE `data_objects_hierarchy_entries` DISABLE KEYS */;
INSERT INTO `data_objects_hierarchy_entries` VALUES (1,1,1,2,NULL),(2,2,1,2,NULL),(2,3,1,2,NULL),(2,4,1,2,NULL),(2,5,1,2,NULL),(2,6,1,2,NULL),(2,7,1,2,NULL),(2,8,1,2,NULL),(2,9,1,2,NULL),(2,10,1,2,NULL),(3,11,1,2,NULL),(3,12,1,2,NULL),(3,13,1,2,NULL),(3,14,1,2,NULL),(3,15,1,2,NULL),(3,16,1,2,NULL),(3,17,1,2,NULL),(3,18,1,2,NULL),(3,19,1,2,NULL),(4,20,1,2,NULL),(4,21,1,2,NULL),(4,22,1,2,NULL),(4,23,1,2,NULL),(4,24,1,2,NULL),(4,25,1,2,NULL),(4,26,1,2,NULL),(4,27,1,2,NULL),(4,28,1,2,NULL),(5,29,1,2,NULL),(5,30,1,2,NULL),(5,31,1,2,NULL),(5,32,1,2,NULL),(5,33,1,2,NULL),(5,34,1,2,NULL),(5,35,1,2,NULL),(5,36,1,2,NULL),(5,37,1,2,NULL),(6,38,1,2,NULL),(6,39,1,2,NULL),(6,40,1,2,NULL),(6,41,1,2,NULL),(6,42,1,2,NULL),(6,43,1,2,NULL),(6,44,1,2,NULL),(6,45,1,2,NULL),(6,46,1,2,NULL),(7,47,1,2,NULL),(7,48,4,2,NULL),(7,49,3,2,NULL),(7,50,2,2,NULL),(7,51,1,1,NULL),(7,52,1,3,NULL),(7,53,2,1,NULL),(7,54,3,1,NULL),(7,55,2,3,NULL),(7,56,1,2,NULL),(7,57,1,2,NULL),(7,58,1,2,NULL),(7,59,1,2,NULL),(7,60,1,2,NULL),(7,61,1,2,NULL),(7,62,1,2,NULL),(8,63,1,2,NULL),(9,64,1,2,NULL),(10,65,1,2,NULL),(11,66,1,2,NULL),(11,67,4,2,NULL),(11,68,3,2,NULL),(11,69,2,2,NULL),(11,70,1,1,NULL),(11,71,1,3,NULL),(11,72,2,1,NULL),(11,73,3,1,NULL),(11,74,2,3,NULL),(11,75,3,2,NULL),(11,76,3,2,NULL),(11,77,1,2,NULL),(11,78,1,2,NULL),(11,79,1,2,NULL),(11,80,1,2,NULL),(11,81,1,2,NULL),(12,82,1,2,NULL),(12,83,1,2,NULL),(12,84,2,2,NULL),(12,85,2,2,NULL),(12,86,3,2,NULL),(12,87,1,2,NULL),(12,88,1,2,NULL),(12,89,1,2,NULL),(12,90,1,2,NULL),(12,91,1,2,NULL),(13,92,1,2,NULL),(13,93,1,2,NULL),(13,94,1,2,NULL),(13,95,1,2,NULL),(13,96,1,2,NULL),(13,97,1,2,NULL),(13,98,1,2,NULL),(13,99,1,2,NULL),(14,100,2,3,NULL),(17,101,1,2,NULL),(17,102,1,2,NULL),(17,103,1,2,NULL),(17,104,1,2,NULL),(17,105,1,2,NULL),(17,106,1,2,NULL),(17,107,1,2,NULL),(17,108,1,2,NULL),(17,109,1,2,NULL),(24,110,1,2,NULL),(24,111,1,2,NULL),(24,112,1,2,NULL),(24,113,1,2,NULL),(24,114,1,2,NULL),(24,115,1,2,NULL),(24,116,1,2,NULL),(24,117,1,2,NULL),(24,118,1,2,NULL),(26,119,1,2,NULL),(26,120,1,2,NULL),(26,121,1,2,NULL),(26,122,1,2,NULL),(26,123,1,2,NULL),(26,124,1,2,NULL),(26,125,1,2,NULL),(26,126,1,2,NULL),(26,127,1,2,NULL),(27,128,1,2,NULL),(27,129,1,2,NULL),(27,130,1,2,NULL),(27,131,1,2,NULL),(27,132,1,2,NULL),(27,133,1,2,NULL),(27,134,1,2,NULL),(27,135,1,2,NULL),(27,136,1,2,NULL),(28,137,1,2,NULL),(28,138,1,2,NULL),(28,139,1,2,NULL),(28,140,1,2,NULL),(28,141,1,2,NULL),(28,142,1,2,NULL),(28,143,1,2,NULL),(28,144,1,2,NULL),(28,145,1,2,NULL),(29,146,1,2,NULL),(29,147,1,2,NULL),(29,148,1,2,NULL),(29,149,1,2,NULL),(29,150,1,2,NULL),(29,151,1,2,NULL),(29,152,1,2,NULL),(29,153,1,2,NULL),(29,154,1,2,NULL),(30,155,1,2,NULL),(30,156,1,2,NULL),(30,157,1,2,NULL),(30,158,1,2,NULL),(30,159,1,2,NULL),(30,160,1,2,NULL),(30,161,1,2,NULL),(30,162,1,2,NULL),(30,163,1,2,NULL),(31,164,1,2,NULL),(31,165,1,2,NULL),(31,166,1,2,NULL),(31,167,1,2,NULL),(31,168,1,2,NULL),(31,169,1,2,NULL),(31,170,1,2,NULL),(31,171,1,2,NULL),(31,172,1,2,NULL),(32,173,1,2,NULL),(32,174,1,2,NULL),(32,175,1,2,NULL),(32,176,1,2,NULL),(32,177,1,2,NULL),(32,178,1,2,NULL),(32,179,1,2,NULL),(32,180,1,2,NULL),(32,181,1,2,NULL),(33,182,1,2,NULL),(33,183,1,2,NULL),(33,184,1,2,NULL),(33,185,1,2,NULL),(33,186,1,2,NULL),(33,187,1,2,NULL),(33,188,1,2,NULL),(33,189,1,2,NULL),(33,190,1,2,NULL),(34,191,1,2,NULL),(34,192,1,2,NULL),(34,193,1,2,NULL),(34,194,1,2,NULL),(34,195,1,2,NULL),(34,196,1,2,NULL),(34,197,1,2,NULL),(34,198,1,2,NULL),(34,199,1,2,NULL),(35,200,1,2,NULL),(35,201,1,2,NULL),(35,202,1,2,NULL),(35,203,1,2,NULL),(35,204,1,2,NULL),(35,205,1,2,NULL),(35,206,1,2,NULL),(35,207,1,2,NULL),(35,208,1,2,NULL),(36,209,1,2,NULL),(36,210,1,2,NULL),(36,211,1,2,NULL),(36,212,1,2,NULL),(36,213,1,2,NULL),(36,214,1,2,NULL),(36,215,1,2,NULL),(36,216,1,2,NULL),(36,217,1,2,NULL),(37,218,1,2,NULL),(37,219,1,2,NULL),(37,220,1,2,NULL),(37,221,1,2,NULL),(37,222,1,2,NULL),(37,223,1,2,NULL),(37,224,1,2,NULL),(37,225,1,2,NULL),(37,226,1,2,NULL),(38,227,1,2,NULL),(38,228,1,2,NULL),(38,229,1,2,NULL),(38,230,1,2,NULL),(38,231,1,2,NULL),(38,232,1,2,NULL),(38,233,1,2,NULL),(38,234,1,2,NULL),(38,235,1,2,NULL);
/*!40000 ALTER TABLE `data_objects_hierarchy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_info_items`
--

DROP TABLE IF EXISTS `data_objects_info_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_info_items` (
  `data_object_id` int(10) unsigned NOT NULL,
  `info_item_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`,`info_item_id`),
  KEY `info_item_id` (`info_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_info_items`
--

LOCK TABLES `data_objects_info_items` WRITE;
/*!40000 ALTER TABLE `data_objects_info_items` DISABLE KEYS */;
INSERT INTO `data_objects_info_items` VALUES (7,1),(16,1),(25,1),(34,1),(43,1),(59,1),(78,1),(88,1),(97,1),(98,1),(106,1),(115,1),(124,1),(133,1),(142,1),(151,1),(160,1),(169,1),(178,1),(187,1),(196,1),(205,1),(214,1),(223,1),(232,1),(8,2),(17,2),(26,2),(35,2),(44,2),(60,2),(79,2),(89,2),(99,2),(107,2),(116,2),(125,2),(134,2),(143,2),(152,2),(161,2),(170,2),(179,2),(188,2),(197,2),(206,2),(215,2),(224,2),(233,2),(99,3),(198,3),(198,4),(8,5),(17,5),(26,5),(35,5),(44,5),(60,5),(79,5),(89,5),(99,5),(107,5),(116,5),(125,5),(134,5),(143,5),(152,5),(161,5),(170,5),(179,5),(188,5),(197,5),(206,5),(215,5),(224,5),(233,5),(8,6),(17,6),(26,6),(35,6),(44,6),(60,6),(79,6),(89,6),(99,6),(107,6),(116,6),(125,6),(134,6),(143,6),(152,6),(161,6),(170,6),(179,6),(188,6),(197,6),(206,6),(215,6),(224,6),(233,6),(8,7),(17,7),(26,7),(35,7),(44,7),(60,7),(79,7),(89,7),(99,7),(107,7),(116,7),(125,7),(134,7),(143,7),(152,7),(161,7),(170,7),(179,7),(188,7),(197,7),(206,7),(215,7),(224,7),(233,7),(28,9),(8,10),(17,10),(26,10),(35,10),(44,10),(60,10),(79,10),(89,10),(99,10),(107,10),(116,10),(125,10),(134,10),(143,10),(152,10),(161,10),(170,10),(179,10),(188,10),(197,10),(206,10),(215,10),(224,10),(233,10),(8,12),(17,12),(26,12),(35,12),(44,12),(60,12),(79,12),(89,12),(99,12),(107,12),(116,12),(125,12),(134,12),(143,12),(152,12),(161,12),(170,12),(179,12),(188,12),(197,12),(206,12),(215,12),(224,12),(233,12),(8,13),(17,13),(26,13),(35,13),(44,13),(60,13),(79,13),(89,13),(99,13),(107,13),(116,13),(125,13),(134,13),(143,13),(152,13),(161,13),(170,13),(179,13),(188,13),(197,13),(206,13),(215,13),(224,13),(233,13),(97,17);
/*!40000 ALTER TABLE `data_objects_info_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_link_types`
--

DROP TABLE IF EXISTS `data_objects_link_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_link_types` (
  `data_object_id` int(10) unsigned NOT NULL,
  `link_type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`),
  KEY `data_type_id` (`link_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_link_types`
--

LOCK TABLES `data_objects_link_types` WRITE;
/*!40000 ALTER TABLE `data_objects_link_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_objects_link_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_refs`
--

DROP TABLE IF EXISTS `data_objects_refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_refs` (
  `data_object_id` int(10) unsigned NOT NULL,
  `ref_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`,`ref_id`),
  KEY `do_id_ref_id` (`data_object_id`,`ref_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_refs`
--

LOCK TABLES `data_objects_refs` WRITE;
/*!40000 ALTER TABLE `data_objects_refs` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_objects_refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_table_of_contents`
--

DROP TABLE IF EXISTS `data_objects_table_of_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_table_of_contents` (
  `data_object_id` int(10) unsigned NOT NULL,
  `toc_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`data_object_id`,`toc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_table_of_contents`
--

LOCK TABLES `data_objects_table_of_contents` WRITE;
/*!40000 ALTER TABLE `data_objects_table_of_contents` DISABLE KEYS */;
INSERT INTO `data_objects_table_of_contents` VALUES (7,1),(8,5),(9,19),(10,41),(16,1),(17,5),(18,10),(19,37),(25,1),(26,5),(27,58),(28,27),(34,1),(35,5),(36,8),(37,16),(43,1),(44,5),(45,6),(46,48),(59,1),(60,5),(61,12),(62,37),(78,1),(79,5),(80,33),(81,53),(88,1),(89,5),(90,1),(97,1),(98,1),(99,5),(106,1),(107,5),(108,45),(109,16),(115,1),(116,5),(117,22),(118,20),(124,1),(125,5),(126,11),(127,44),(133,1),(134,5),(135,12),(136,29),(142,1),(143,5),(144,49),(145,30),(151,1),(152,5),(153,13),(154,34),(160,1),(161,5),(162,50),(163,12),(169,1),(170,5),(171,51),(172,51),(178,1),(179,5),(180,8),(181,44),(187,1),(188,5),(189,48),(190,17),(196,1),(197,5),(198,7),(199,55),(205,1),(206,5),(207,16),(208,38),(214,1),(215,5),(216,24),(217,51),(223,1),(224,5),(225,53),(226,41),(232,1),(233,5),(234,24),(235,52);
/*!40000 ALTER TABLE `data_objects_table_of_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_objects_taxon_concepts`
--

DROP TABLE IF EXISTS `data_objects_taxon_concepts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_objects_taxon_concepts` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`,`data_object_id`),
  KEY `data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_objects_taxon_concepts`
--

LOCK TABLES `data_objects_taxon_concepts` WRITE;
/*!40000 ALTER TABLE `data_objects_taxon_concepts` DISABLE KEYS */;
INSERT INTO `data_objects_taxon_concepts` VALUES (7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8),(7,9),(7,10),(8,11),(8,12),(8,13),(8,14),(8,15),(8,16),(8,17),(8,18),(8,19),(9,20),(9,21),(9,22),(9,23),(9,24),(9,25),(9,26),(9,27),(9,28),(10,29),(10,30),(10,31),(10,32),(10,33),(10,34),(10,35),(10,36),(10,37),(11,38),(11,39),(11,40),(11,41),(11,42),(11,43),(11,44),(11,45),(11,46),(12,47),(12,48),(12,49),(12,50),(12,51),(12,52),(12,53),(12,54),(12,55),(12,56),(12,57),(12,58),(12,59),(12,60),(12,61),(12,62),(13,63),(14,64),(15,65),(16,66),(16,67),(16,68),(16,69),(16,70),(16,71),(16,72),(16,73),(16,74),(16,75),(16,76),(16,77),(16,78),(16,79),(16,80),(16,81),(17,82),(17,83),(17,84),(17,85),(17,86),(17,87),(17,88),(17,89),(17,90),(17,91),(18,92),(18,93),(18,94),(18,95),(18,96),(18,97),(18,98),(18,99),(18,100),(20,101),(20,102),(20,103),(20,104),(20,105),(20,106),(20,107),(20,108),(20,109),(21,110),(21,111),(21,112),(21,113),(21,114),(21,115),(21,116),(21,117),(21,118),(22,119),(22,120),(22,121),(22,122),(22,123),(22,124),(22,125),(22,126),(22,127),(23,128),(23,129),(23,130),(23,131),(23,132),(23,133),(23,134),(23,135),(23,136),(24,137),(24,138),(24,139),(24,140),(24,141),(24,142),(24,143),(24,144),(24,145),(25,146),(25,147),(25,148),(25,149),(25,150),(25,151),(25,152),(25,153),(25,154),(26,155),(26,156),(26,157),(26,158),(26,159),(26,160),(26,161),(26,162),(26,163),(27,164),(27,165),(27,166),(27,167),(27,168),(27,169),(27,170),(27,171),(27,172),(28,173),(28,174),(28,175),(28,176),(28,177),(28,178),(28,179),(28,180),(28,181),(29,182),(29,183),(29,184),(29,185),(29,186),(29,187),(29,188),(29,189),(29,190),(30,191),(30,192),(30,193),(30,194),(30,195),(30,196),(30,197),(30,198),(30,199),(31,200),(31,201),(31,202),(31,203),(31,204),(31,205),(31,206),(31,207),(31,208),(32,209),(32,210),(32,211),(32,212),(32,213),(32,214),(32,215),(32,216),(32,217),(33,218),(33,219),(33,220),(33,221),(33,222),(33,223),(33,224),(33,225),(33,226),(34,227),(34,228),(34,229),(34,230),(34,231),(34,232),(34,233),(34,234),(34,235);
/*!40000 ALTER TABLE `data_objects_taxon_concepts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_point_uris`
--

DROP TABLE IF EXISTS `data_point_uris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_point_uris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uri` varchar(255) DEFAULT NULL,
  `taxon_concept_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `vetted_id` int(11) DEFAULT '1',
  `visibility_id` int(11) DEFAULT '2',
  `class_type` varchar(255) DEFAULT NULL,
  `predicate` varchar(255) DEFAULT NULL,
  `object` varchar(255) DEFAULT NULL,
  `unit_of_measure` varchar(255) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `user_added_data_id` int(11) DEFAULT NULL,
  `predicate_known_uri_id` int(11) DEFAULT NULL,
  `object_known_uri_id` int(11) DEFAULT NULL,
  `unit_of_measure_known_uri_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_data_point_uris_on_uri_and_taxon_concept_id` (`uri`,`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_point_uris`
--

LOCK TABLES `data_point_uris` WRITE;
/*!40000 ALTER TABLE `data_point_uris` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_point_uris` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_search_files`
--

DROP TABLE IF EXISTS `data_search_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_search_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `q` varchar(512) DEFAULT NULL,
  `uri` varchar(512) NOT NULL,
  `from` float DEFAULT NULL,
  `to` float DEFAULT NULL,
  `sort` varchar(64) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `known_uri_id` int(11) NOT NULL,
  `language_id` int(11) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `hosted_file_url` varchar(255) DEFAULT NULL,
  `row_count` int(10) unsigned DEFAULT NULL,
  `unit_uri` varchar(255) DEFAULT NULL,
  `taxon_concept_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_data_search_files_on_user_id` (`user_id`),
  KEY `index_data_search_files_on_known_uri_id` (`known_uri_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_search_files`
--

LOCK TABLES `data_search_files` WRITE;
/*!40000 ALTER TABLE `data_search_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_search_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_types`
--

DROP TABLE IF EXISTS `data_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_types` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `schema_value` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_types`
--

LOCK TABLES `data_types` WRITE;
/*!40000 ALTER TABLE `data_types` DISABLE KEYS */;
INSERT INTO `data_types` VALUES (1,'http://purl.org/dc/dcmitype/Text'),(2,'http://purl.org/dc/dcmitype/StillImage'),(3,'http://purl.org/dc/dcmitype/Sound'),(4,'http://purl.org/dc/dcmitype/MovingImage'),(5,'GBIF Image'),(6,'YouTube'),(7,'Flash'),(8,'IUCN'),(9,'Map'),(10,'Link');
/*!40000 ALTER TABLE `data_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eol_statistics`
--

DROP TABLE IF EXISTS `eol_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eol_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `members_count` mediumint(9) DEFAULT NULL,
  `communities_count` mediumint(9) DEFAULT NULL,
  `collections_count` mediumint(9) DEFAULT NULL,
  `pages_count` int(11) DEFAULT NULL,
  `pages_with_content` int(11) DEFAULT NULL,
  `pages_with_text` int(11) DEFAULT NULL,
  `pages_with_image` int(11) DEFAULT NULL,
  `pages_with_map` mediumint(9) DEFAULT NULL,
  `pages_with_video` mediumint(9) DEFAULT NULL,
  `pages_with_sound` mediumint(9) DEFAULT NULL,
  `pages_without_text` mediumint(9) DEFAULT NULL,
  `pages_without_image` mediumint(9) DEFAULT NULL,
  `pages_with_image_no_text` mediumint(9) DEFAULT NULL,
  `pages_with_text_no_image` mediumint(9) DEFAULT NULL,
  `base_pages` int(11) DEFAULT NULL,
  `pages_with_at_least_a_trusted_object` int(11) DEFAULT NULL,
  `pages_with_at_least_a_curatorial_action` mediumint(9) DEFAULT NULL,
  `pages_with_BHL_links` mediumint(9) DEFAULT NULL,
  `pages_with_BHL_links_no_text` mediumint(9) DEFAULT NULL,
  `pages_with_BHL_links_only` mediumint(9) DEFAULT NULL,
  `content_partners` mediumint(9) DEFAULT NULL,
  `content_partners_with_published_resources` mediumint(9) DEFAULT NULL,
  `content_partners_with_published_trusted_resources` mediumint(9) DEFAULT NULL,
  `published_resources` mediumint(9) DEFAULT NULL,
  `published_trusted_resources` mediumint(9) DEFAULT NULL,
  `published_unreviewed_resources` mediumint(9) DEFAULT NULL,
  `newly_published_resources_in_the_last_30_days` mediumint(9) DEFAULT NULL,
  `data_objects` int(11) DEFAULT NULL,
  `data_objects_texts` int(11) DEFAULT NULL,
  `data_objects_images` int(11) DEFAULT NULL,
  `data_objects_videos` mediumint(9) DEFAULT NULL,
  `data_objects_sounds` mediumint(9) DEFAULT NULL,
  `data_objects_maps` mediumint(9) DEFAULT NULL,
  `data_objects_trusted` int(11) DEFAULT NULL,
  `data_objects_unreviewed` int(11) DEFAULT NULL,
  `data_objects_untrusted` mediumint(9) DEFAULT NULL,
  `data_objects_trusted_or_unreviewed_but_hidden` mediumint(9) DEFAULT NULL,
  `udo_published` mediumint(9) DEFAULT NULL,
  `udo_published_by_curators` mediumint(9) DEFAULT NULL,
  `udo_published_by_non_curators` mediumint(9) DEFAULT NULL,
  `rich_pages` mediumint(9) DEFAULT NULL,
  `hotlist_pages` mediumint(9) DEFAULT NULL,
  `rich_hotlist_pages` mediumint(9) DEFAULT NULL,
  `redhotlist_pages` mediumint(9) DEFAULT NULL,
  `rich_redhotlist_pages` mediumint(9) DEFAULT NULL,
  `pages_with_score_10_to_39` mediumint(9) DEFAULT NULL,
  `pages_with_score_less_than_10` mediumint(9) DEFAULT NULL,
  `curators` mediumint(9) DEFAULT NULL,
  `curators_assistant` mediumint(9) DEFAULT NULL,
  `curators_full` mediumint(9) DEFAULT NULL,
  `curators_master` mediumint(9) DEFAULT NULL,
  `active_curators` mediumint(9) DEFAULT NULL,
  `pages_curated_by_active_curators` mediumint(9) DEFAULT NULL,
  `objects_curated_in_the_last_30_days` mediumint(9) DEFAULT NULL,
  `curator_actions_in_the_last_30_days` mediumint(9) DEFAULT NULL,
  `lifedesk_taxa` mediumint(9) DEFAULT NULL,
  `lifedesk_data_objects` mediumint(9) DEFAULT NULL,
  `marine_pages` mediumint(9) DEFAULT NULL,
  `marine_pages_in_col` mediumint(9) DEFAULT NULL,
  `marine_pages_with_objects` mediumint(9) DEFAULT NULL,
  `marine_pages_with_objects_vetted` mediumint(9) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '2014-04-09 11:01:02',
  `total_triples` int(10) unsigned DEFAULT NULL,
  `total_occurrences` int(10) unsigned DEFAULT NULL,
  `total_measurements` int(10) unsigned DEFAULT NULL,
  `total_associations` int(10) unsigned DEFAULT NULL,
  `total_measurement_types` int(10) unsigned DEFAULT NULL,
  `total_association_types` int(10) unsigned DEFAULT NULL,
  `total_taxa_with_data` int(10) unsigned DEFAULT NULL,
  `total_user_added_data` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eol_statistics`
--

LOCK TABLES `eol_statistics` WRITE;
/*!40000 ALTER TABLE `eol_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `eol_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_logs`
--

DROP TABLE IF EXISTS `error_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exception_name` varchar(250) DEFAULT NULL,
  `backtrace` text,
  `url` varchar(250) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_error_logs_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_logs`
--

LOCK TABLES `error_logs` WRITE;
/*!40000 ALTER TABLE `error_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_files`
--

DROP TABLE IF EXISTS `failed_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_url` varchar(255) DEFAULT NULL,
  `output_file_name` varchar(255) DEFAULT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `object_type` varchar(255) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_files`
--

LOCK TABLES `failed_files` WRITE;
/*!40000 ALTER TABLE `failed_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_files_parameters`
--

DROP TABLE IF EXISTS `failed_files_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_files_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `failed_files_id` int(11) DEFAULT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_files_parameters`
--

LOCK TABLES `failed_files_parameters` WRITE;
/*!40000 ALTER TABLE `failed_files_parameters` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_files_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_data_objects`
--

DROP TABLE IF EXISTS `feed_data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_data_objects` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `data_type_id` smallint(5) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`taxon_concept_id`,`data_object_id`),
  KEY `data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_data_objects`
--

LOCK TABLES `feed_data_objects` WRITE;
/*!40000 ALTER TABLE `feed_data_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_data_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_item_types`
--

DROP TABLE IF EXISTS `feed_item_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_item_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_item_types`
--

LOCK TABLES `feed_item_types` WRITE;
/*!40000 ALTER TABLE `feed_item_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_item_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_items`
--

DROP TABLE IF EXISTS `feed_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `body` varchar(255) DEFAULT NULL,
  `feed_type` varchar(255) DEFAULT NULL,
  `feed_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `feed_item_type_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_items`
--

LOCK TABLES `feed_items` WRITE;
/*!40000 ALTER TABLE `feed_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_categories`
--

DROP TABLE IF EXISTS `forum_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `view_order` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_categories`
--

LOCK TABLES `forum_categories` WRITE;
/*!40000 ALTER TABLE `forum_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_posts`
--

DROP TABLE IF EXISTS `forum_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_topic_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `reply_to_post_id` int(11) DEFAULT NULL,
  `edit_count` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_posts`
--

LOCK TABLES `forum_posts` WRITE;
/*!40000 ALTER TABLE `forum_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_topics`
--

DROP TABLE IF EXISTS `forum_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `number_of_posts` int(11) NOT NULL DEFAULT '0',
  `number_of_views` int(11) NOT NULL DEFAULT '0',
  `first_post_id` int(11) DEFAULT NULL,
  `last_post_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_topics`
--

LOCK TABLES `forum_topics` WRITE;
/*!40000 ALTER TABLE `forum_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums`
--

DROP TABLE IF EXISTS `forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `view_order` int(11) NOT NULL DEFAULT '0',
  `number_of_posts` int(11) NOT NULL DEFAULT '0',
  `number_of_topics` int(11) NOT NULL DEFAULT '0',
  `number_of_views` int(11) NOT NULL DEFAULT '0',
  `last_post_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums`
--

LOCK TABLES `forums` WRITE;
/*!40000 ALTER TABLE `forums` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gbif_identifiers_with_maps`
--

DROP TABLE IF EXISTS `gbif_identifiers_with_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gbif_identifiers_with_maps` (
  `gbif_taxon_id` int(11) NOT NULL,
  PRIMARY KEY (`gbif_taxon_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gbif_identifiers_with_maps`
--

LOCK TABLES `gbif_identifiers_with_maps` WRITE;
/*!40000 ALTER TABLE `gbif_identifiers_with_maps` DISABLE KEYS */;
/*!40000 ALTER TABLE `gbif_identifiers_with_maps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glossary_terms`
--

DROP TABLE IF EXISTS `glossary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glossary_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` varchar(255) DEFAULT NULL,
  `definition` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `term` (`term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glossary_terms`
--

LOCK TABLES `glossary_terms` WRITE;
/*!40000 ALTER TABLE `glossary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `glossary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_analytics_page_stats`
--

DROP TABLE IF EXISTS `google_analytics_page_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_analytics_page_stats` (
  `taxon_concept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `year` smallint(4) NOT NULL,
  `month` tinyint(2) NOT NULL,
  `page_views` int(10) unsigned NOT NULL,
  `unique_page_views` int(10) unsigned NOT NULL,
  `time_on_page` time NOT NULL,
  KEY `month_year` (`month`,`year`),
  KEY `taxon_concept_id` (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_analytics_page_stats`
--

LOCK TABLES `google_analytics_page_stats` WRITE;
/*!40000 ALTER TABLE `google_analytics_page_stats` DISABLE KEYS */;
INSERT INTO `google_analytics_page_stats` VALUES (16,2015,4,516,49,'00:55:14'),(16,2015,3,369,56,'00:48:57'),(16,2015,2,459,64,'00:50:18'),(16,2015,1,165,45,'00:31:45'),(16,2014,12,367,65,'00:31:45'),(16,2014,11,819,81,'00:59:14'),(16,2014,10,302,46,'00:19:37'),(16,2014,9,861,40,'00:30:33'),(16,2014,8,7,94,'00:13:35'),(16,2014,7,908,63,'00:21:18'),(16,2014,6,733,69,'00:18:44'),(16,2014,5,594,60,'00:34:49'),(16,2014,4,346,2,'00:14:26'),(16,2014,3,661,27,'00:56:30'),(16,2014,2,771,98,'00:58:28'),(16,2014,1,48,33,'00:28:01'),(16,2013,12,78,74,'00:53:15'),(16,2013,11,550,31,'00:25:20'),(16,2013,10,814,94,'00:58:15'),(16,2013,9,661,56,'00:46:06'),(16,2013,8,632,78,'00:33:19'),(16,2013,7,405,52,'00:07:27'),(16,2013,6,876,95,'00:16:16'),(16,2013,5,748,51,'00:49:44'),(16,2013,4,295,10,'00:57:33');
/*!40000 ALTER TABLE `google_analytics_page_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_analytics_partner_summaries`
--

DROP TABLE IF EXISTS `google_analytics_partner_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_analytics_partner_summaries` (
  `year` smallint(4) NOT NULL DEFAULT '0',
  `month` tinyint(2) NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  `taxa_pages` int(11) DEFAULT NULL,
  `taxa_pages_viewed` int(11) DEFAULT NULL,
  `unique_page_views` int(11) DEFAULT NULL,
  `page_views` int(11) DEFAULT NULL,
  `time_on_page` float(11,2) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`year`,`month`),
  KEY `year` (`year`),
  KEY `month` (`month`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_analytics_partner_summaries`
--

LOCK TABLES `google_analytics_partner_summaries` WRITE;
/*!40000 ALTER TABLE `google_analytics_partner_summaries` DISABLE KEYS */;
INSERT INTO `google_analytics_partner_summaries` VALUES (2013,4,2,603,63,586,5456,910.00),(2013,5,2,416,85,809,1298,95.00),(2013,6,2,460,68,355,9910,320.00),(2013,7,2,131,17,709,254,496.00),(2013,8,2,460,30,346,8929,22.00),(2013,9,2,361,8,203,3235,726.00),(2013,10,2,464,4,510,8557,372.00),(2013,11,2,577,86,473,501,216.00),(2013,12,2,153,76,659,7417,50.00),(2014,1,2,756,53,417,1211,544.00),(2014,2,2,976,59,211,4406,283.00),(2014,3,2,673,2,810,8393,395.00),(2014,4,2,591,51,313,476,37.00),(2014,5,2,201,9,136,4538,30.00),(2014,6,2,132,71,12,3117,645.00),(2014,7,2,303,68,296,111,217.00),(2014,8,2,708,6,63,3721,69.00),(2014,9,2,594,42,404,389,147.00),(2014,10,2,980,6,605,9421,215.00),(2014,11,2,999,83,293,8574,511.00),(2014,12,2,818,80,108,7205,730.00),(2015,1,2,706,17,750,5717,744.00),(2015,2,2,143,63,607,7454,54.00),(2015,3,2,452,54,659,5101,340.00),(2015,4,2,286,48,573,5202,525.00);
/*!40000 ALTER TABLE `google_analytics_partner_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_analytics_partner_taxa`
--

DROP TABLE IF EXISTS `google_analytics_partner_taxa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_analytics_partner_taxa` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `year` smallint(4) NOT NULL,
  `month` tinyint(2) NOT NULL,
  KEY `concept_user_month_year` (`taxon_concept_id`,`user_id`,`month`,`year`),
  KEY `user_month` (`user_id`,`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_analytics_partner_taxa`
--

LOCK TABLES `google_analytics_partner_taxa` WRITE;
/*!40000 ALTER TABLE `google_analytics_partner_taxa` DISABLE KEYS */;
INSERT INTO `google_analytics_partner_taxa` VALUES (16,2,2014,1),(16,2,2015,1),(16,2,2014,2),(16,2,2015,2),(16,2,2014,3),(16,2,2015,3),(16,2,2013,4),(16,2,2014,4),(16,2,2015,4),(16,2,2013,5),(16,2,2014,5),(16,2,2013,6),(16,2,2014,6),(16,2,2013,7),(16,2,2014,7),(16,2,2013,8),(16,2,2014,8),(16,2,2013,9),(16,2,2014,9),(16,2,2013,10),(16,2,2014,10),(16,2,2013,11),(16,2,2014,11),(16,2,2013,12),(16,2,2014,12);
/*!40000 ALTER TABLE `google_analytics_partner_taxa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_analytics_summaries`
--

DROP TABLE IF EXISTS `google_analytics_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_analytics_summaries` (
  `year` smallint(4) NOT NULL,
  `month` tinyint(2) NOT NULL,
  `visits` int(11) DEFAULT NULL,
  `visitors` int(11) DEFAULT NULL,
  `pageviews` int(11) DEFAULT NULL,
  `unique_pageviews` int(11) DEFAULT NULL,
  `ave_pages_per_visit` float DEFAULT NULL,
  `ave_time_on_site` time DEFAULT NULL,
  `ave_time_on_page` time DEFAULT NULL,
  `per_new_visits` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `per_exit` float DEFAULT NULL,
  `taxa_pages` int(11) DEFAULT NULL,
  `taxa_pages_viewed` int(11) DEFAULT NULL,
  `time_on_pages` int(11) DEFAULT NULL,
  PRIMARY KEY (`year`,`month`),
  KEY `year` (`year`),
  KEY `month` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_analytics_summaries`
--

LOCK TABLES `google_analytics_summaries` WRITE;
/*!40000 ALTER TABLE `google_analytics_summaries` DISABLE KEYS */;
INSERT INTO `google_analytics_summaries` VALUES (2013,4,792,7,2847,130,0,'00:34:30','00:23:53',2.7,1.2,0.2,182,44,49),(2013,5,167,28,32,595,9.1,'00:22:27','00:28:55',3.2,1.1,7.7,76,28,521),(2013,6,739,11,7795,93,7.7,'00:02:01','00:52:28',4.5,3.7,3.3,64,37,317),(2013,7,944,93,1679,197,7.6,'00:31:47','00:54:36',0.9,8.1,2.1,339,44,73),(2013,8,410,32,284,462,4.5,'00:38:07','00:41:12',6.6,4.7,5.2,82,97,956),(2013,9,645,6,2510,268,5.2,'00:04:58','00:21:51',4.1,5.2,2.2,854,95,888),(2013,10,586,15,6113,999,0,'00:35:37','00:41:02',1.5,1,3.8,502,59,385),(2013,11,929,2,8819,193,0.9,'00:42:08','00:43:24',1.2,6.2,3.5,34,95,101),(2013,12,476,70,8241,290,5.2,'00:56:13','00:45:39',0.6,7.6,1.3,471,32,953),(2014,1,692,61,6203,502,1.4,'00:22:46','00:17:41',4.2,9.6,0.5,972,18,415),(2014,2,652,83,431,856,5.1,'00:40:42','00:09:36',6,5.2,2.5,911,85,790),(2014,3,280,71,1801,490,6.3,'00:25:48','00:41:21',5.3,3.6,6.9,504,76,694),(2014,4,268,40,1352,592,1.4,'00:37:14','00:31:59',6.3,1.6,2.7,94,82,111),(2014,5,435,12,8720,284,7.1,'00:06:30','00:03:48',5.6,0.4,8.3,190,9,664),(2014,6,662,56,3056,558,3.4,'00:33:28','00:00:57',6.6,4.1,1.1,697,99,654),(2014,7,812,42,8671,621,5.5,'00:52:14','00:53:31',3.5,3.8,4.6,99,20,873),(2014,8,753,1,3602,45,7.1,'00:13:55','00:23:41',4.7,4.5,6.8,654,56,45),(2014,9,965,46,7773,45,5.1,'00:49:46','00:17:22',4.7,1.9,8.6,370,63,672),(2014,10,903,19,6065,164,5.6,'00:55:34','00:10:57',2.5,7.1,5.8,989,44,271),(2014,11,107,75,733,678,8.6,'00:38:42','00:52:10',7.8,2.2,0.8,859,10,355),(2014,12,13,7,8191,746,5.5,'00:36:32','00:40:46',6.2,1.6,9.1,340,1,683),(2015,1,319,73,1123,983,9.7,'00:15:52','00:36:47',8,8.8,8.2,823,86,355),(2015,2,879,62,8846,754,0,'00:37:52','00:19:20',3.2,8.1,2.4,757,79,598),(2015,3,729,34,1394,802,9.1,'00:02:47','00:04:59',9.5,0.2,0.4,502,79,380),(2015,4,995,64,3663,299,1.2,'00:22:05','00:19:49',5.7,9.7,2.2,229,72,268);
/*!40000 ALTER TABLE `google_analytics_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `harvest_events`
--

DROP TABLE IF EXISTS `harvest_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `harvest_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` int(10) unsigned NOT NULL,
  `began_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `resource_id` (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `harvest_events`
--

LOCK TABLES `harvest_events` WRITE;
/*!40000 ALTER TABLE `harvest_events` DISABLE KEYS */;
INSERT INTO `harvest_events` VALUES (1,2,'2014-04-09 06:33:21','2014-04-09 07:33:21','2014-04-09 08:33:21',0),(2,3,'2014-04-09 06:33:37','2014-04-09 07:33:37','2014-04-09 08:33:37',0),(3,3,'2014-04-09 06:34:20','2014-04-09 07:34:20','2014-04-09 08:34:20',0),(4,3,'2014-04-09 06:34:20','2014-04-09 07:34:20','2014-04-09 08:34:20',0),(5,4,'2014-04-09 06:34:21','2014-04-09 07:34:21','2014-04-09 08:34:21',0),(6,5,'2014-04-09 06:34:26','2014-04-09 07:34:26','2014-04-09 08:34:26',0);
/*!40000 ALTER TABLE `harvest_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `harvest_events_hierarchy_entries`
--

DROP TABLE IF EXISTS `harvest_events_hierarchy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `harvest_events_hierarchy_entries` (
  `harvest_event_id` int(10) unsigned NOT NULL,
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `guid` varchar(32) CHARACTER SET ascii NOT NULL,
  `status_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`harvest_event_id`,`hierarchy_entry_id`),
  KEY `hierarchy_entry_id` (`hierarchy_entry_id`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `harvest_events_hierarchy_entries`
--

LOCK TABLES `harvest_events_hierarchy_entries` WRITE;
/*!40000 ALTER TABLE `harvest_events_hierarchy_entries` DISABLE KEYS */;
INSERT INTO `harvest_events_hierarchy_entries` VALUES (2,2,'',4),(2,3,'',5),(2,4,'',6),(2,5,'',7),(2,6,'',8),(2,7,'',9),(2,8,'',10),(2,9,'',11),(2,10,'',12),(2,11,'',13),(2,12,'',14),(2,17,'',16),(2,24,'',17),(2,26,'',18),(2,27,'',19),(2,28,'',20),(2,29,'',21),(2,30,'',22),(2,31,'',23),(2,32,'',24),(2,33,'',25),(2,34,'',26),(2,35,'',27),(2,36,'',28),(2,37,'',29),(2,38,'',30),(5,13,'',15);
/*!40000 ALTER TABLE `harvest_events_hierarchy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `harvest_process_logs`
--

DROP TABLE IF EXISTS `harvest_process_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `harvest_process_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `process_name` varchar(255) DEFAULT NULL,
  `began_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `harvest_process_logs`
--

LOCK TABLES `harvest_process_logs` WRITE;
/*!40000 ALTER TABLE `harvest_process_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `harvest_process_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchies`
--

DROP TABLE IF EXISTS `hierarchies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` int(10) unsigned NOT NULL COMMENT 'recommended; our internal id of the source agent responsible for the entire hierarchy',
  `label` varchar(255) NOT NULL COMMENT 'recommended; succinct title for the hierarchy (e.g. Catalogue of Life: Annual Checklist 2009)',
  `descriptive_label` varchar(255) DEFAULT NULL,
  `description` text NOT NULL COMMENT 'not required; a more verbose description describing the hierarchy. Could be a paragraph describing what it is and what it contains',
  `indexed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'required; the date which we created and indexed the hierarchy',
  `hierarchy_group_id` int(10) unsigned NOT NULL COMMENT 'not required; there is no hierarchy_groups table, but this field was meant to identify hierarchies of the same source so they can be verioned and older versions retained but not presented',
  `hierarchy_group_version` tinyint(3) unsigned NOT NULL COMMENT 'not required; this is mean to uniquely identify hierarchies within the same group. This version number has been an internal incrementing value',
  `url` varchar(255) CHARACTER SET ascii NOT NULL COMMENT 'not required; a link back to a web page describing this hierarchy',
  `outlink_uri` varchar(255) DEFAULT NULL,
  `ping_host_url` varchar(255) DEFAULT NULL,
  `browsable` int(11) DEFAULT NULL,
  `complete` tinyint(3) unsigned DEFAULT '1',
  `request_publish` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='A container for hierarchy_entries. These are usually taxonomic hierarchies, but can be general collections of assertions about taxa.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchies`
--

LOCK TABLES `hierarchies` WRITE;
/*!40000 ALTER TABLE `hierarchies` DISABLE KEYS */;
INSERT INTO `hierarchies` VALUES (1,4,'LigerCat',NULL,'LigerCat Biomedical Terms Tag Cloud','2014-04-09 06:33:18',0,0,'http://ligercat.ubio.org','http://ligercat.ubio.org/eol/%%ID%%.cloud',NULL,0,1,0),(2,5,'A nested structure of divisions related to their probable evolutionary descent',NULL,'','2014-04-09 06:33:18',0,0,'',NULL,NULL,0,1,0),(3,2,'Species 2000 & ITIS Catalogue of Life: May 2012',NULL,'','2014-04-09 06:33:20',0,0,'',NULL,NULL,1,1,0),(4,2,'Species 2000 & ITIS Catalogue of Life: Annual Checklist 2007',NULL,'','2014-04-09 06:33:20',0,0,'',NULL,NULL,0,1,0),(5,6,'Encyclopedia of Life Contributors',NULL,'','2014-04-09 06:33:20',0,0,'',NULL,NULL,0,1,0),(6,3,'NCBI Taxonomy',NULL,'','2014-04-09 06:33:20',101,2,'',NULL,NULL,1,1,0),(7,7,'GBIF Nub Taxonomy',NULL,'','2014-04-09 06:33:20',0,0,'',NULL,NULL,0,1,0),(8,8,'IUCN',NULL,'','2014-04-09 06:33:21',0,0,'',NULL,NULL,0,1,0),(9,10,'GBIF Nub Taxonomy',NULL,'','2014-04-09 06:33:37',0,0,'',NULL,NULL,0,1,0),(10,38,'A nested structure of divisions related to their probable evolutionary descent',NULL,'','2014-04-09 06:34:21',0,0,'',NULL,NULL,0,1,0),(11,43,'A nested structure of divisions related to their probable evolutionary descent',NULL,'','2014-04-09 06:34:26',0,0,'',NULL,NULL,0,1,0),(12,42,'A nested structure of divisions related to their probable evolutionary descent',NULL,'','2014-04-09 06:34:26',0,0,'',NULL,NULL,0,1,0),(13,44,'A nested structure of divisions related to their probable evolutionary descent',NULL,'','2014-04-09 06:34:26',0,0,'',NULL,NULL,0,1,0),(14,51,'AntWeb',NULL,'Currently AntWeb contains information on the ant faunas of several areas in the Nearctic and Malagasy biogeographic regions, and global coverage of all ant genera.','2014-04-09 06:34:32',0,0,'http://www.antweb.org/','http://www.antweb.org/specimen.do?name=%%ID%%',NULL,0,1,0),(15,52,'National Center for Biotechnology Information',NULL,'Established in 1988 as a national resource for molecular biology information, NCBI creates public databases, conducts research in computational biology, develops software tools for analyzing genome data, and disseminates biomedical information - all for the better understanding of molecular processes affecting human health and disease','2014-04-09 06:34:32',0,0,'http://www.ncbi.nlm.nih.gov/','http://www.ncbi.nlm.nih.gov/sites/entrez?Db=genomeprj&cmd=ShowDetailView&TermToSearch=%%ID%%',NULL,0,1,0);
/*!40000 ALTER TABLE `hierarchies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchies_content`
--

DROP TABLE IF EXISTS `hierarchies_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchies_content` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `text` tinyint(3) unsigned NOT NULL,
  `text_unpublished` tinyint(3) unsigned NOT NULL,
  `image` tinyint(3) unsigned NOT NULL,
  `image_unpublished` tinyint(3) unsigned NOT NULL,
  `child_image` tinyint(3) unsigned NOT NULL,
  `child_image_unpublished` tinyint(3) unsigned NOT NULL,
  `flash` tinyint(3) unsigned NOT NULL,
  `youtube` tinyint(3) unsigned NOT NULL,
  `map` tinyint(3) unsigned NOT NULL,
  `content_level` tinyint(3) unsigned NOT NULL,
  `image_object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Summarizes the data types available to a given hierarchy entry. Also lists its content level and the data_object_id of the first displayed image.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchies_content`
--

LOCK TABLES `hierarchies_content` WRITE;
/*!40000 ALTER TABLE `hierarchies_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `hierarchies_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entries`
--

DROP TABLE IF EXISTS `hierarchy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` varchar(32) CHARACTER SET ascii NOT NULL,
  `identifier` varchar(255) NOT NULL COMMENT 'recommended; a unique id from the provider for this node',
  `source_url` text,
  `name_id` int(10) unsigned NOT NULL COMMENT 'recommended; the name string for this node. It is possible that nodes have no names, but most of the time they will',
  `parent_id` int(10) unsigned NOT NULL COMMENT 'recommended; the parent_id references the hierarchy_entry_id of the parent of this node. Used to create trees. Root nodes will have a partent_id of 0',
  `hierarchy_id` smallint(5) unsigned NOT NULL COMMENT 'required; the id of the container hierarchy',
  `rank_id` smallint(5) unsigned NOT NULL COMMENT 'recommended; when available, this is the id of the rank string which defines the taxonomic rank of the node',
  `ancestry` varchar(500) CHARACTER SET ascii NOT NULL COMMENT 'not required; perhaps now obsolete. Used to store the materialized path of this node''s ancestors',
  `lft` int(10) unsigned NOT NULL COMMENT 'required; the left value of this node within the hierarchy''s nested set',
  `rgt` int(10) unsigned NOT NULL COMMENT 'required; the right value of this node within the hierarchy''s nested set',
  `depth` tinyint(3) unsigned NOT NULL COMMENT 'recommended; the depth of this node in within the hierarchy''s tree',
  `taxon_concept_id` int(10) unsigned NOT NULL COMMENT 'required; the id of the taxon_concept described by this hierarchy_entry',
  `vetted_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `visibility_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `taxon_remarks` text,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name_id` (`name_id`),
  KEY `parent_id` (`parent_id`),
  KEY `lft` (`lft`),
  KEY `taxon_concept_id` (`taxon_concept_id`),
  KEY `vetted_id` (`vetted_id`),
  KEY `visibility_id` (`visibility_id`),
  KEY `published` (`published`),
  KEY `identifier` (`identifier`),
  KEY `hierarchy_parent` (`hierarchy_id`,`parent_id`),
  KEY `concept_published_visible` (`taxon_concept_id`,`published`,`visibility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entries`
--

LOCK TABLES `hierarchy_entries` WRITE;
/*!40000 ALTER TABLE `hierarchy_entries` DISABLE KEYS */;
INSERT INTO `hierarchy_entries` VALUES (1,'2f2e3f4044de44c6b60117d5caea87ee','','',1,0,3,184,'',1,2,2,1,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(2,'852ce2b77a7843b6b03cdf27e282116d','','',2,0,3,1,'',3,24,0,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(3,'158deefc06554e37b33a778a2b282c8b','','',4,2,3,0,'',4,23,2,8,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(4,'b9b8116125c646b9a389f7b2a4185455','','',6,3,3,0,'',5,22,3,9,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(5,'95ab9c89b29d48eba38bba85dd1d09b6','','',8,4,3,0,'',6,21,4,10,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(6,'6c9a493012c4457fb19e0c0e5a967abe','','',10,5,3,0,'',7,20,5,11,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(7,'fbd861bb2d8248299922ebfe7ca7a1c8','','',12,6,3,0,'',8,9,6,12,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(8,'19f9f1c875b6426193dc2634db3b3673','','',14,6,3,0,'',10,11,6,13,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(9,'a5935ad0d1a24e26b05246c19496b613','','',21,6,3,0,'',12,13,6,14,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(10,'7806c2dce51d4cbbb1a1834b652e5b7a','','',22,6,3,0,'',14,15,6,15,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(11,'47f6fbbbf1594c11bd4de39996bbf218','','',23,6,3,0,'',16,17,6,16,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(12,'a5ee7c4d2b1b43eda92d5779a41919ed','','',25,6,3,0,'',18,19,6,17,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(13,'3e7aec801d5540ca975b3613830abf2d','','',27,0,3,0,'',25,26,6,18,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(14,'ab395cc1817f4ed7bc1e36e446901b13','','',28,0,12,0,'',1,2,0,18,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(15,'93c6bc2432034dc1837ac189b74e887c','13810203','',28,0,9,0,'',1,2,0,18,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(16,'be39f79dbeb94627be3c428d41fa2689','','',29,0,13,184,'',1,2,2,19,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(17,'be8756136e034de4924dcb668b218a72','','',30,0,3,0,'',27,28,6,20,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(18,'b7f9a9048ab344ae9690b421403ce603','20','',30,0,2,184,'',1,2,2,20,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(19,'1c2259ae81ff45fea6e6fc54426eec27','casent0129891','',2,0,14,184,'',1,2,2,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(20,'095411ad2b1e4ea89e2344cb18bfc64b','casent0496198','',2,0,14,184,'',3,4,2,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(21,'18b0d2b24e2e42cfa27e92cd834bfafb','casent0179524','',2,0,14,184,'',5,6,2,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(22,'e7235caaa0bb4048a666c4ef8cdb15ae','13646','',2,0,15,184,'',1,2,2,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:32:58',NULL,NULL,NULL),(23,'b5bbfce3d7684a57993a762d6784bf8a','9551','',2,0,15,184,'',3,4,2,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(24,'318566aa3e9a4d92bd926bca623deaab','','',34,0,6,20,'',1,20,0,21,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(25,'d8e555ec227740d4ab3610e3cd68700c','33154','',36,24,6,1,'',2,19,0,7,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(26,'a0c38fba0353447fa5d2104224ef6825','','',38,25,6,0,'',3,4,1,22,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(27,'a65b3c63710347d09effd7de8d8a7e81','','',40,25,6,0,'',5,18,1,23,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(28,'f3684bff028c4067a03697175d95da54','','',42,27,6,0,'',6,7,2,24,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(29,'c5e8bd988a5447fc8233061a9e7d5f30','','',44,27,6,0,'',8,17,2,25,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(30,'a0b870c31523413daad11bf610c98576','','',46,29,6,0,'',9,10,3,26,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(31,'063d70a4c0964cd897561f20edb2f65e','','',48,29,6,0,'',11,16,3,27,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(32,'b4b7aa8412a64dc0bb2fcd6df01e2dec','','',50,31,6,0,'',12,13,4,28,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(33,'e3c1722c964d4bfb86b285c603d1ec84','','',52,31,6,0,'',14,15,4,29,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(34,'7256d0016381441485d2dffb0cd15cde','','',54,0,6,20,'',21,30,0,30,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(35,'27c601dfa3514ace82362ade8143ddc6','','',66,34,6,0,'',22,29,1,31,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(36,'00218567ee984e8d83c6b6cd7ad5ffca','','',68,35,6,0,'',23,28,2,32,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(37,'1ef7d0f8a82e4084bddc78cf4f418a79','','',70,36,6,0,'',24,27,3,33,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL),(38,'f06e2ac54c3b4ab0851a7e4f83698c03','','',72,37,6,0,'',25,26,4,34,1,1,2,'2014-04-09 11:32:58','2014-04-09 11:35:25',NULL,NULL,NULL);
/*!40000 ALTER TABLE `hierarchy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entries_flattened`
--

DROP TABLE IF EXISTS `hierarchy_entries_flattened`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entries_flattened` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `ancestor_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`ancestor_id`),
  KEY `ancestor_id` (`ancestor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entries_flattened`
--

LOCK TABLES `hierarchy_entries_flattened` WRITE;
/*!40000 ALTER TABLE `hierarchy_entries_flattened` DISABLE KEYS */;
INSERT INTO `hierarchy_entries_flattened` VALUES (3,2),(4,2),(4,3),(5,2),(5,3),(5,4),(6,2),(6,3),(6,4),(6,5),(7,2),(7,3),(7,4),(7,5),(7,6),(8,2),(8,3),(8,4),(8,5),(8,6),(9,2),(9,3),(9,4),(9,5),(9,6),(10,2),(10,3),(10,4),(10,5),(10,6),(11,2),(11,3),(11,4),(11,5),(11,6),(12,2),(12,3),(12,4),(12,5),(12,6),(25,24),(26,24),(26,25),(27,24),(27,25),(28,24),(28,25),(28,27),(29,24),(29,25),(29,27),(30,24),(30,25),(30,27),(30,29),(31,24),(31,25),(31,27),(31,29),(32,24),(32,25),(32,27),(32,29),(32,31),(33,24),(33,25),(33,27),(33,29),(33,31),(35,34),(36,34),(36,35),(37,34),(37,35),(37,36),(38,34),(38,35),(38,36),(38,37);
/*!40000 ALTER TABLE `hierarchy_entries_flattened` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entries_refs`
--

DROP TABLE IF EXISTS `hierarchy_entries_refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entries_refs` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `ref_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`ref_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entries_refs`
--

LOCK TABLES `hierarchy_entries_refs` WRITE;
/*!40000 ALTER TABLE `hierarchy_entries_refs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hierarchy_entries_refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entry_moves`
--

DROP TABLE IF EXISTS `hierarchy_entry_moves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entry_moves` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hierarchy_entry_id` int(11) NOT NULL,
  `classification_curation_id` int(11) NOT NULL,
  `error` varchar(256) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entry_and_curation_index` (`hierarchy_entry_id`,`classification_curation_id`),
  KEY `index_hierarchy_entry_moves_on_hierarchy_entry_id` (`hierarchy_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entry_moves`
--

LOCK TABLES `hierarchy_entry_moves` WRITE;
/*!40000 ALTER TABLE `hierarchy_entry_moves` DISABLE KEYS */;
/*!40000 ALTER TABLE `hierarchy_entry_moves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entry_relationships`
--

DROP TABLE IF EXISTS `hierarchy_entry_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entry_relationships` (
  `hierarchy_entry_id_1` int(10) unsigned NOT NULL,
  `hierarchy_entry_id_2` int(10) unsigned NOT NULL,
  `relationship` varchar(30) NOT NULL,
  `score` double NOT NULL,
  `extra` text NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id_1`,`hierarchy_entry_id_2`),
  KEY `score` (`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entry_relationships`
--

LOCK TABLES `hierarchy_entry_relationships` WRITE;
/*!40000 ALTER TABLE `hierarchy_entry_relationships` DISABLE KEYS */;
/*!40000 ALTER TABLE `hierarchy_entry_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hierarchy_entry_stats`
--

DROP TABLE IF EXISTS `hierarchy_entry_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy_entry_stats` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `text_trusted` mediumint(8) unsigned NOT NULL,
  `text_untrusted` mediumint(8) unsigned NOT NULL,
  `image_trusted` mediumint(8) unsigned NOT NULL,
  `image_untrusted` mediumint(8) unsigned NOT NULL,
  `bhl` mediumint(8) unsigned NOT NULL,
  `all_text_trusted` mediumint(8) unsigned NOT NULL,
  `all_text_untrusted` mediumint(8) unsigned NOT NULL,
  `have_text` mediumint(8) unsigned NOT NULL,
  `all_image_trusted` mediumint(8) unsigned NOT NULL,
  `all_image_untrusted` mediumint(8) unsigned NOT NULL,
  `have_images` mediumint(8) unsigned NOT NULL,
  `all_bhl` int(10) unsigned NOT NULL,
  `total_children` int(10) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hierarchy_entry_stats`
--

LOCK TABLES `hierarchy_entry_stats` WRITE;
/*!40000 ALTER TABLE `hierarchy_entry_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `hierarchy_entry_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_crops`
--

DROP TABLE IF EXISTS `image_crops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_crops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_object_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `original_object_cache_url` bigint(20) unsigned NOT NULL,
  `new_object_cache_url` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_crops`
--

LOCK TABLES `image_crops` WRITE;
/*!40000 ALTER TABLE `image_crops` DISABLE KEYS */;
/*!40000 ALTER TABLE `image_crops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `info_items`
--

DROP TABLE IF EXISTS `info_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `info_items` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `schema_value` varchar(255) CHARACTER SET ascii NOT NULL,
  `toc_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info_items`
--

LOCK TABLES `info_items` WRITE;
/*!40000 ALTER TABLE `info_items` DISABLE KEYS */;
INSERT INTO `info_items` VALUES (1,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#TaxonBiology',1),(2,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#GeneralDescription',5),(3,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Distribution',7),(4,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Habitat',7),(5,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Morphology',5),(6,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Conservation',5),(7,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Uses',5),(8,'http://www.eol.org/voc/table_of_contents#Education',25),(9,'http://www.eol.org/voc/table_of_contents#EducationResources',27),(10,'http://www.eol.org/voc/table_of_contents#IdentificationResources',5),(11,'http://www.eol.org/voc/table_of_contents#Wikipedia',9),(12,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#DiagnosticDescription',5),(13,'http://eol.org/schema/eol_info_items.xml#Taxonomy',5),(14,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Associations',0),(15,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Behaviour',0),(16,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#ConservationStatus',0),(17,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Cyclicity',0),(18,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Cytology',0),(19,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#DiagnosticDescription',0),(20,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Diseases',0),(21,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Dispersal',0),(22,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Evolution',0),(23,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Genetics',0),(24,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Growth',0),(25,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Legislation',0),(26,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#LifeCycle',0),(27,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#LifeExpectancy',0),(28,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#LookAlikes',0),(29,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Management',0),(30,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Migration',0),(31,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#MolecularBiology',0),(32,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Physiology',0),(33,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#PopulationBiology',0),(34,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Procedures',0),(35,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Reproduction',0),(36,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#RiskStatement',0),(37,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Size',0),(38,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Threats',0),(39,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#Trends',0),(40,'http://rs.tdwg.org/ontology/voc/SPMInfoItems#TrophicStrategy',0);
/*!40000 ALTER TABLE `info_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_pages`
--

DROP TABLE IF EXISTS `item_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title_item_id` int(10) unsigned NOT NULL,
  `year` varchar(20) NOT NULL,
  `volume` varchar(20) NOT NULL,
  `issue` varchar(20) NOT NULL,
  `prefix` varchar(20) NOT NULL,
  `number` varchar(20) NOT NULL,
  `url` varchar(255) CHARACTER SET ascii NOT NULL,
  `page_type` varchar(20) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 COMMENT='Used for BHL. The publication items have many pages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_pages`
--

LOCK TABLES `item_pages` WRITE;
/*!40000 ALTER TABLE `item_pages` DISABLE KEYS */;
INSERT INTO `item_pages` VALUES (22,22,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(23,23,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(24,24,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(25,25,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(26,26,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(27,27,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(28,28,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(29,29,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(30,30,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(31,31,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(32,32,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(33,33,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(34,34,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(35,35,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(36,36,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(37,37,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(38,38,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(39,39,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(40,40,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(41,41,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(42,42,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(43,43,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(44,44,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(45,45,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(46,46,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(47,47,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(48,48,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(49,49,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(50,50,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(51,51,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(52,52,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(53,53,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(54,54,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(55,55,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(56,56,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(57,57,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(58,58,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(59,59,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(60,60,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(61,61,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(62,62,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(63,63,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(64,64,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(65,65,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(66,66,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(67,67,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(68,68,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(69,69,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(70,70,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(71,71,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(72,72,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(73,73,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(74,74,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(75,75,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(76,76,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(77,77,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(78,78,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(79,79,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(80,80,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(81,81,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(82,82,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(83,83,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(84,84,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(85,85,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(86,86,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(87,87,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(88,88,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(89,89,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting',''),(90,90,'1999','2','42','Page','6','http://www.biodiversitylibrary.org/page/ThisWontWork.JustTesting','');
/*!40000 ALTER TABLE `item_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_uri_relationships`
--

DROP TABLE IF EXISTS `known_uri_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `known_uri_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_known_uri_id` int(11) NOT NULL,
  `to_known_uri_id` int(11) NOT NULL,
  `relationship_uri` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `from_to_unique` (`from_known_uri_id`,`to_known_uri_id`,`relationship_uri`),
  KEY `to_known_uri_id` (`to_known_uri_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_uri_relationships`
--

LOCK TABLES `known_uri_relationships` WRITE;
/*!40000 ALTER TABLE `known_uri_relationships` DISABLE KEYS */;
INSERT INTO `known_uri_relationships` VALUES (1,1,2,'http://eol.org/schema/allowedValue','2014-04-09 13:33:28','2014-04-09 13:33:28'),(2,1,3,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(3,1,4,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(4,1,5,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(5,1,6,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(6,1,7,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(7,1,8,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(8,1,9,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(9,1,10,'http://eol.org/schema/allowedValue','2014-04-09 13:33:29','2014-04-09 13:33:29'),(10,1,11,'http://eol.org/schema/allowedValue','2014-04-09 13:33:30','2014-04-09 13:33:30'),(11,1,12,'http://eol.org/schema/allowedValue','2014-04-09 13:33:30','2014-04-09 13:33:30'),(12,1,13,'http://eol.org/schema/allowedValue','2014-04-09 13:33:30','2014-04-09 13:33:30'),(13,14,15,'http://eol.org/schema/allowedValue','2014-04-09 13:33:30','2014-04-09 13:33:30'),(14,14,16,'http://eol.org/schema/allowedValue','2014-04-09 13:33:30','2014-04-09 13:33:30');
/*!40000 ALTER TABLE `known_uri_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_uris`
--

DROP TABLE IF EXISTS `known_uris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `known_uris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uri` varchar(2000) NOT NULL,
  `vetted_id` int(11) NOT NULL,
  `visibility_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `exclude_from_exemplars` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT NULL,
  `uri_type_id` int(11) NOT NULL DEFAULT '1',
  `ontology_information_url` varchar(255) DEFAULT NULL,
  `ontology_source_url` varchar(255) DEFAULT NULL,
  `group_by_clade` tinyint(1) DEFAULT NULL,
  `clade_exemplar` tinyint(1) DEFAULT NULL,
  `exemplar_for_same_as` tinyint(1) DEFAULT NULL,
  `value_is_text` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_uri` (`uri`(250))
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_uris`
--

LOCK TABLES `known_uris` WRITE;
/*!40000 ALTER TABLE `known_uris` DISABLE KEYS */;
INSERT INTO `known_uris` VALUES (1,'http://rs.tdwg.org/dwc/terms/measurementUnit',1,2,'2014-04-09 13:33:28','2014-04-09 13:33:28',0,1,4,NULL,NULL,NULL,NULL,NULL,0),(2,'http://purl.obolibrary.org/obo/UO_0000022',1,2,'2014-04-09 13:33:28','2014-04-09 13:33:28',0,2,3,NULL,NULL,NULL,NULL,NULL,0),(3,'http://purl.obolibrary.org/obo/UO_0000021',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,3,3,NULL,NULL,NULL,NULL,NULL,0),(4,'http://purl.obolibrary.org/obo/UO_0000009',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,4,3,NULL,NULL,NULL,NULL,NULL,0),(5,'http://purl.obolibrary.org/obo/UO_0000016',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,5,3,NULL,NULL,NULL,NULL,NULL,0),(6,'http://purl.obolibrary.org/obo/UO_0000015',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,6,3,NULL,NULL,NULL,NULL,NULL,0),(7,'http://purl.obolibrary.org/obo/UO_0000008',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,7,3,NULL,NULL,NULL,NULL,NULL,0),(8,'http://purl.obolibrary.org/obo/UO_0000012',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,8,3,NULL,NULL,NULL,NULL,NULL,0),(9,'http://purl.obolibrary.org/obo/UO_0000027',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,9,3,NULL,NULL,NULL,NULL,NULL,0),(10,'http://purl.obolibrary.org/obo/UO_0000033',1,2,'2014-04-09 13:33:29','2014-04-09 13:33:29',0,10,3,NULL,NULL,NULL,NULL,NULL,0),(11,'http://purl.obolibrary.org/obo/UO_0000036',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,11,3,NULL,NULL,NULL,NULL,NULL,0),(12,'http://eol.org/schema/terms/onetenthdegreescelsius',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,12,3,NULL,NULL,NULL,NULL,NULL,0),(13,'http://eol.org/schema/terms/log10gram',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,13,3,NULL,NULL,NULL,NULL,NULL,0),(14,'http://rs.tdwg.org/dwc/terms/sex',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,14,4,NULL,NULL,NULL,NULL,NULL,0),(15,'http://eol.org/schema/terms/male',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,15,3,NULL,NULL,NULL,NULL,NULL,0),(16,'http://eol.org/schema/terms/female',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,16,3,NULL,NULL,NULL,NULL,NULL,0),(17,'http://purl.org/dc/terms/source',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,17,4,NULL,NULL,NULL,NULL,NULL,0),(18,'http://purl.org/dc/terms/license',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,18,4,NULL,NULL,NULL,NULL,NULL,0),(19,'http://purl.org/dc/terms/bibliographicCitation',1,2,'2014-04-09 13:33:30','2014-04-09 13:33:30',0,19,4,NULL,NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `known_uris` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_uris_toc_items`
--

DROP TABLE IF EXISTS `known_uris_toc_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `known_uris_toc_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `known_uri_id` int(11) NOT NULL,
  `toc_item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_uris_toc_items`
--

LOCK TABLES `known_uris_toc_items` WRITE;
/*!40000 ALTER TABLE `known_uris_toc_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `known_uris_toc_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language_groups`
--

DROP TABLE IF EXISTS `language_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `language_groups` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `representative_language_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language_groups`
--

LOCK TABLES `language_groups` WRITE;
/*!40000 ALTER TABLE `language_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `language_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `iso_639_1` varchar(12) NOT NULL,
  `iso_639_2` varchar(12) NOT NULL,
  `iso_639_3` varchar(12) NOT NULL,
  `source_form` varchar(100) NOT NULL,
  `sort_order` tinyint(4) NOT NULL DEFAULT '1',
  `activated_on` timestamp NULL DEFAULT NULL,
  `language_group_id` smallint(5) unsigned DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `iso_639_1` (`iso_639_1`),
  KEY `iso_639_2` (`iso_639_2`),
  KEY `iso_639_3` (`iso_639_3`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'en','eng','eng','English',1,'2014-04-07 11:33:10',NULL,NULL,NULL),(2,'fr','fre','','Français',1,'2014-04-08 11:33:20',NULL,NULL,NULL),(3,'es','spa','','Español',2,'2014-04-08 11:33:20',NULL,NULL,NULL),(4,'ar','','','العربية',3,'2014-04-08 11:33:20',NULL,NULL,NULL),(5,'','','','Scientific Name',4,NULL,NULL,NULL,NULL),(6,'','','','Unknown',5,NULL,NULL,NULL,NULL),(7,'de','','','',65,'2014-04-08 11:35:08',NULL,NULL,NULL);
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licenses`
--

DROP TABLE IF EXISTS `licenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `licenses` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `source_url` varchar(255) CHARACTER SET ascii NOT NULL,
  `version` varchar(6) CHARACTER SET ascii NOT NULL,
  `logo_url` varchar(255) CHARACTER SET ascii NOT NULL,
  `show_to_content_partners` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `source_url` (`source_url`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licenses`
--

LOCK TABLES `licenses` WRITE;
/*!40000 ALTER TABLE `licenses` DISABLE KEYS */;
INSERT INTO `licenses` VALUES (1,'public domain','http://creativecommons.org/licenses/publicdomain/','1','',1),(2,'all rights reserved','','1','',0),(3,'cc-by 3.0','http://creativecommons.org/licenses/by/3.0/','1','cc_by_small.png',1),(4,'cc-by-sa 3.0','http://creativecommons.org/licenses/by-sa/3.0/','1','cc_by_sa_small.png',1),(5,'cc-by-nc 3.0','http://creativecommons.org/licenses/by-nc/3.0/','1','cc_by_nc_small.png',1),(6,'cc-by-nc-sa 3.0','http://creativecommons.org/licenses/by-nc-sa/3.0/','1','cc_by_nc_sa_small.png',1),(7,'cc-zero 1.0','http://creativecommons.org/publicdomain/zero/1.0/','1','cc_zero_small.png',1),(8,'no known copyright restrictions','http://www.flickr.com/commons/usage/','1','',1),(9,'not applicable','','1','',0);
/*!40000 ALTER TABLE `licenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `link_types`
--

DROP TABLE IF EXISTS `link_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `link_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `link_types`
--

LOCK TABLES `link_types` WRITE;
/*!40000 ALTER TABLE `link_types` DISABLE KEYS */;
INSERT INTO `link_types` VALUES (1,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL),(2,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL),(3,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL),(4,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL),(5,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL),(6,'2014-04-09 13:33:20','2014-04-09 13:33:20',NULL,NULL);
/*!40000 ALTER TABLE `link_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `community_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `manager` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (9,7,1,'2014-04-09 13:33:39','2014-04-09 13:33:39',NULL),(10,9,1,'2014-04-09 13:33:45','2014-04-09 13:33:45',NULL),(11,11,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL),(12,13,1,'2014-04-09 13:33:52','2014-04-09 13:33:52',NULL),(13,15,1,'2014-04-09 13:33:55','2014-04-09 13:33:55',NULL),(14,17,1,'2014-04-09 13:33:59','2014-04-09 13:33:59',NULL),(15,20,1,'2014-04-09 13:34:07','2014-04-09 13:34:07',NULL),(16,22,1,'2014-04-09 13:34:08','2014-04-09 13:34:08',NULL),(17,24,1,'2014-04-09 13:34:09','2014-04-09 13:34:09',NULL),(18,26,1,'2014-04-09 13:34:10','2014-04-09 13:34:10',NULL),(19,28,1,'2014-04-09 13:34:16','2014-04-09 13:34:16',NULL),(20,30,1,'2014-04-09 13:34:19','2014-04-09 13:34:19',NULL),(21,33,1,'2014-04-09 13:34:22','2014-04-09 13:34:22',NULL),(22,37,1,'2014-04-09 13:34:27','2014-04-09 13:34:27',NULL),(23,39,1,'2014-04-09 13:34:29','2014-04-09 13:34:29',NULL),(24,41,1,'2014-04-09 13:34:32','2014-04-09 13:34:32',NULL),(25,44,1,'2014-04-09 13:34:33','2014-04-09 13:34:33',NULL),(26,46,1,'2014-04-09 13:34:37','2014-04-09 13:34:37',NULL),(27,48,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL),(28,50,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL),(29,52,1,'2014-04-09 13:34:47','2014-04-09 13:34:47',NULL),(30,54,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL),(31,56,1,'2014-04-09 13:34:54','2014-04-09 13:34:54',NULL),(32,58,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL),(33,60,1,'2014-04-09 13:35:02','2014-04-09 13:35:02',NULL),(34,62,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL),(35,64,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL),(36,66,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL),(37,68,1,'2014-04-09 13:35:17','2014-04-09 13:35:17',NULL),(38,70,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mime_types`
--

DROP TABLE IF EXISTS `mime_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mime_types` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='Type of data object. Controlled list used in the EOL schema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mime_types`
--

LOCK TABLES `mime_types` WRITE;
/*!40000 ALTER TABLE `mime_types` DISABLE KEYS */;
INSERT INTO `mime_types` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21);
/*!40000 ALTER TABLE `mime_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `name_languages`
--

DROP TABLE IF EXISTS `name_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_languages` (
  `name_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL COMMENT 'required; the language of the string. ''Scientific name'' is a language',
  `parent_name_id` int(10) unsigned NOT NULL COMMENT 'not required; associated a common name or surrogate with its proper scientific name',
  `preferred` tinyint(3) unsigned NOT NULL COMMENT 'not required; identifies if the common names is preferred for the given scientific name in the given language',
  PRIMARY KEY (`name_id`,`language_id`,`parent_name_id`),
  KEY `parent_name_id` (`parent_name_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Used mainly to identify which names are scientific names, and to link up common names';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `name_languages`
--

LOCK TABLES `name_languages` WRITE;
/*!40000 ALTER TABLE `name_languages` DISABLE KEYS */;
/*!40000 ALTER TABLE `name_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `names`
--

DROP TABLE IF EXISTS `names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `names` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `namebank_id` int(10) unsigned NOT NULL COMMENT 'required; this identifies the uBio NameBank id for this string so that we can stay in sync. Many newer names will have this set to 0 as it is unknown if the name is in NameBank',
  `string` varchar(300) NOT NULL COMMENT 'the actual name. This is unique - every unique sequence of characters has one and only one name_id (we should probably add a unique index to this field)',
  `clean_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'there is a one to one reltaionship between a name string and a clean name. The clean name takes the string and lowercases it (uncluding diacriticals), removes leading/trailing whitespace, removes some punctuation (periods and more), and pads remaining pun',
  `italicized` varchar(300) NOT NULL COMMENT 'required; this includes html <i> tags in the proper place to display the string in its italicized form. Generally only species and subspecific names are italizied. Usually algorithmically generated',
  `italicized_verified` tinyint(3) unsigned NOT NULL COMMENT 'required; if an editor verifies the italicized form is correct, or corrects it, this should be set to 1 so it is not algorithmically replaced if we change the algorithm',
  `canonical_form_id` int(10) unsigned NOT NULL COMMENT 'required; every name string has a canonical form',
  `ranked_canonical_form_id` int(10) unsigned DEFAULT NULL,
  `canonical_verified` tinyint(3) unsigned NOT NULL COMMENT 'required; same as with italicized form, if an editor verifies the canonical form we want to maintin their edits if we were to redo the canonical form algorithm',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `canonical_form_id` (`canonical_form_id`),
  KEY `clean_name` (`clean_name`(255))
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8 COMMENT='Represents the name of a taxon';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `names`
--

LOCK TABLES `names` WRITE;
/*!40000 ALTER TABLE `names` DISABLE KEYS */;
INSERT INTO `names` VALUES (1,0,'Nesciunterox autrerumalis','nesciunterox autrerumalis','<i>Nesciunterox autrerumalis</i>',1,1,NULL,1,NULL,1),(2,0,'Animalia Linn.','animalia linn','<i>Animalia</i> Linn.',1,2,2,1,NULL,1),(3,0,'Animals','animals','<i>Animals</i>',0,3,NULL,0,3,NULL),(4,0,'Autrecusandaees repudiandaeica Linnaeus','autrecusandaees repudiandaeica linnaeus','<i>Autrecusandaees repudiandaeica</i> Linnaeus',1,4,4,1,NULL,1),(5,0,'ravenous clover','ravenous clover','<i>ravenous clover</i>',0,5,NULL,0,5,NULL),(6,0,'Nihileri voluptasus G. D\'Amore','nihileri voluptasus g d\'amore','<i>Nihileri voluptasus</i> G. D\'Amore',1,6,6,1,NULL,1),(7,0,'red suntus','red suntus','<i>red suntus</i>',0,7,NULL,0,7,NULL),(8,0,'Dignissimosii inutes R. Bergstrom','dignissimosii inutes r bergstrom','<i>Dignissimosii inutes</i> R. Bergstrom',1,8,8,1,NULL,1),(9,0,'darning needle','darning needle','<i>darning needle</i>',0,9,NULL,0,9,NULL),(10,0,'Fugais utharumatus L.','fugais utharumatus l','<i>Fugais utharumatus</i> L.',1,10,10,1,NULL,1),(11,0,'tiger','tiger','<i>tiger</i>',0,11,NULL,0,11,NULL),(12,0,'Minuseli ullamens Linn','minuseli ullamens linn','<i>Minuseli ullamens</i> Linn',1,12,12,1,NULL,1),(13,0,'Tiger moth','tiger moth','<i>Tiger moth</i>',0,13,NULL,0,13,NULL),(14,0,'Dignissimosatus nobisosyne R. Cartwright','dignissimosatus nobisosyne r cartwright','<i>Dignissimosatus nobisosyne</i> R. Cartwright',1,14,14,1,NULL,1),(15,0,'Tiger lilly','tiger lilly','<i>Tiger lilly</i>',0,15,NULL,0,15,NULL),(16,0,'Tiger water lilly','tiger water lilly','<i>Tiger water lilly</i>',0,16,NULL,0,16,NULL),(17,0,'lilly of the tiger','lilly of the tiger','<i>lilly of the tiger</i>',0,17,NULL,0,17,NULL),(18,0,'Tiger flower','tiger flower','<i>Tiger flower</i>',0,18,NULL,0,18,NULL),(19,0,'Tiger-stripe lilly','tiger - stripe lilly','<i>Tiger-stripe lilly</i>',0,19,NULL,0,19,NULL),(20,0,'Tiger-eye lilly','tiger - eye lilly','<i>Tiger-eye lilly</i>',0,20,NULL,0,20,NULL),(21,0,'Expeditaalia evenietelia L.','expeditaalia evenietelia l','<i>Expeditaalia evenietelia</i> L.',1,21,21,1,NULL,1),(22,0,'Earumeles beataeata Linn.','earumeles beataeata linn','<i>Earumeles beataeata</i> Linn.',1,22,22,1,NULL,1),(23,0,'Culpaensis sapienteesi Linnaeus','culpaensis sapienteesi linnaeus','<i>Culpaensis sapienteesi</i> Linnaeus',1,23,23,1,NULL,1),(24,0,'frizzlebek','frizzlebek','<i>frizzlebek</i>',0,24,NULL,0,24,NULL),(25,0,'Utomnisesi sequialis N. Upton','utomnisesi sequialis n upton','<i>Utomnisesi sequialis</i> N. Upton',1,25,25,1,NULL,1),(26,0,'purple dust crab','purple dust crab','<i>purple dust crab</i>',0,26,NULL,0,26,NULL),(27,0,'Autaliquideri minimais L. Carroll','autaliquideri minimais l carroll','<i>Autaliquideri minimais</i> L. Carroll',1,27,27,1,NULL,1),(28,0,'Beataeelia etnemoiae','beataeelia etnemoiae','<i>Beataeelia etnemoiae</i>',1,27,NULL,1,NULL,1),(29,0,'Autemalius utsimiliqueesi','autemalius utsimiliqueesi','<i>Autemalius utsimiliqueesi</i>',1,28,NULL,1,NULL,1),(30,0,'Etconsequaturelia autenimalia M. Port','etconsequaturelia autenimalia m port','<i>Etconsequaturelia autenimalia</i> M. Port',1,29,29,1,NULL,1),(31,0,'wumpus','wumpus','<i>wumpus</i>',0,30,NULL,0,31,NULL),(32,0,'wompus','wompus','<i>wompus</i>',0,31,NULL,0,32,NULL),(33,0,'wampus','wampus','<i>wampus</i>',0,32,NULL,0,33,NULL),(34,0,'Eukaryota S. Posford','eukaryota s posford','<i>Eukaryota</i> S. Posford',1,33,33,1,NULL,1),(35,0,'eukaryotes','eukaryotes','<i>eukaryotes</i>',0,34,NULL,0,35,NULL),(36,0,'Metazoa','metazoa','<i>Metazoa</i>',1,35,NULL,1,NULL,1),(37,0,'opisthokonts','opisthokonts','<i>opisthokonts</i>',1,36,NULL,1,NULL,1),(38,0,'Quoautesi natuseri Posford & Ram','quoautesi natuseri posford & ram','<i>Quoautesi natuseri</i> Posford & Ram',1,37,37,1,NULL,1),(39,0,'cloud swallow','cloud swallow','<i>cloud swallow</i>',0,38,NULL,0,39,NULL),(40,0,'Voluptatumeri esseensis L.','voluptatumeri esseensis l','<i>Voluptatumeri esseensis</i> L.',1,39,39,1,NULL,1),(41,0,'spiny possom','spiny possom','<i>spiny possom</i>',0,40,NULL,0,41,NULL),(42,0,'Ameti maioresis Linnaeus','ameti maioresis linnaeus','<i>Ameti maioresis</i> Linnaeus',1,41,41,1,NULL,1),(43,0,'common desert mouse','common desert mouse','<i>common desert mouse</i>',0,42,NULL,0,43,NULL),(44,0,'Ipsamalius distinctioerox','ipsamalius distinctioerox','<i>Ipsamalius distinctioerox</i>',1,43,43,1,NULL,1),(45,0,'fisher','fisher','<i>fisher</i>',0,44,NULL,0,45,NULL),(46,0,'Maximees veritatisatus P. Leary','maximees veritatisatus p leary','<i>Maximees veritatisatus</i> P. Leary',1,45,45,1,NULL,1),(47,0,'chartruse turtle','chartruse turtle','<i>chartruse turtle</i>',0,46,NULL,0,47,NULL),(48,0,'Molestiaeus rationealia Padderson','molestiaeus rationealia padderson','<i>Molestiaeus rationealia</i> Padderson',1,47,47,1,NULL,1),(49,0,'horny toad','horny toad','<i>horny toad</i>',0,48,NULL,0,49,NULL),(50,0,'Fugitens dolorealius Linnaeus','fugitens dolorealius linnaeus','<i>Fugitens dolorealius</i> Linnaeus',1,49,49,1,NULL,1),(51,0,'scarlet vermillion','scarlet vermillion','<i>scarlet vermillion</i>',0,50,NULL,0,51,NULL),(52,0,'Quisquamator sequieles L.','quisquamator sequieles l','<i>Quisquamator sequieles</i> L.',1,51,51,1,NULL,1),(53,0,'Mozart\'s nemesis','mozart\'s nemesis','<i>Mozart\'s nemesis</i>',0,52,NULL,0,53,NULL),(54,0,'Bacteria M. Mayer','bacteria m mayer','<i>Bacteria</i> M. Mayer',1,53,53,1,NULL,1),(55,0,'bacteria','bacteria','<i>bacteria</i>',0,53,NULL,0,55,NULL),(56,0,'bugs','bugs','<i>bugs</i>',0,54,NULL,0,56,NULL),(57,0,'grime','grime','<i>grime</i>',0,55,NULL,0,57,NULL),(58,0,'critters','critters','<i>critters</i>',0,56,NULL,0,58,NULL),(59,0,'bakteria','bakteria','<i>bakteria</i>',0,57,NULL,0,59,NULL),(60,0,'die buggen','die buggen','<i>die buggen</i>',0,58,NULL,0,60,NULL),(61,0,'das greim','das greim','<i>das greim</i>',0,59,NULL,0,61,NULL),(62,0,'baseteir','baseteir','<i>baseteir</i>',0,60,NULL,0,62,NULL),(63,0,'le grimme','le grimme','<i>le grimme</i>',0,61,NULL,0,63,NULL),(64,0,'ler petit bugge','ler petit bugge','<i>ler petit bugge</i>',0,62,NULL,0,64,NULL),(65,0,'microbia','microbia','microbia',1,53,NULL,1,NULL,1),(66,0,'Essees eaqueata L.','essees eaqueata l','<i>Essees eaqueata</i> L.',1,63,63,1,NULL,1),(67,0,'quick brown fox','quick brown fox','<i>quick brown fox</i>',0,64,NULL,0,67,NULL),(68,0,'Animiens atdoloribuseron Linn.','animiens atdoloribuseron linn','<i>Animiens atdoloribuseron</i> Linn.',1,65,65,1,NULL,1),(69,0,'painted horse','painted horse','<i>painted horse</i>',0,66,NULL,0,69,NULL),(70,0,'Adaliasii iurea Linnaeus','adaliasii iurea linnaeus','<i>Adaliasii iurea</i> Linnaeus',1,67,67,1,NULL,1),(71,0,'thirsty aphid','thirsty aphid','<i>thirsty aphid</i>',0,68,NULL,0,71,NULL),(72,0,'Nonnumquamerus numquamerus G. D\'Amore','nonnumquamerus numquamerus g d\'amore','<i>Nonnumquamerus numquamerus</i> G. D\'Amore',1,69,69,1,NULL,1),(73,0,'bloody eel','bloody eel','<i>bloody eel</i>',0,70,NULL,0,73,NULL);
/*!40000 ALTER TABLE `names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_items`
--

DROP TABLE IF EXISTS `news_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_name` varchar(255) DEFAULT NULL,
  `display_date` datetime DEFAULT NULL,
  `activated_on` datetime DEFAULT NULL,
  `last_update_user_id` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_items`
--

LOCK TABLES `news_items` WRITE;
/*!40000 ALTER TABLE `news_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `news_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_emailer_settings`
--

DROP TABLE IF EXISTS `notification_emailer_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_emailer_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_daily_emails_sent` datetime DEFAULT NULL,
  `last_weekly_emails_sent` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_emailer_settings`
--

LOCK TABLES `notification_emailer_settings` WRITE;
/*!40000 ALTER TABLE `notification_emailer_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_emailer_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_frequencies`
--

DROP TABLE IF EXISTS `notification_frequencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_frequencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frequency` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_frequencies`
--

LOCK TABLES `notification_frequencies` WRITE;
/*!40000 ALTER TABLE `notification_frequencies` DISABLE KEYS */;
INSERT INTO `notification_frequencies` VALUES (1,'never'),(2,'newsfeed only'),(3,'weekly'),(4,'daily digest'),(5,'send immediately');
/*!40000 ALTER TABLE `notification_frequencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `reply_to_comment` int(11) DEFAULT '5',
  `comment_on_my_profile` int(11) DEFAULT '5',
  `comment_on_my_contribution` int(11) DEFAULT '5',
  `comment_on_my_collection` int(11) DEFAULT '5',
  `comment_on_my_community` int(11) DEFAULT '5',
  `made_me_a_manager` int(11) DEFAULT '5',
  `member_joined_my_community` int(11) DEFAULT '5',
  `comment_on_my_watched_item` int(11) DEFAULT '2',
  `curation_on_my_watched_item` int(11) DEFAULT '2',
  `new_data_on_my_watched_item` int(11) DEFAULT '2',
  `changes_to_my_watched_collection` int(11) DEFAULT '2',
  `changes_to_my_watched_community` int(11) DEFAULT '2',
  `member_joined_my_watched_community` int(11) DEFAULT '2',
  `member_left_my_community` int(11) DEFAULT '2',
  `new_manager_in_my_community` int(11) DEFAULT '2',
  `i_am_being_watched` int(11) DEFAULT '2',
  `eol_newsletter` tinyint(1) DEFAULT '1',
  `last_notification_sent_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (10,7,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:38','2014-04-09 13:33:38'),(11,9,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:44','2014-04-09 13:33:44'),(12,11,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:48','2014-04-09 13:33:48'),(13,13,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:51','2014-04-09 13:33:51'),(14,15,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:54','2014-04-09 13:33:54'),(15,17,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:33:58','2014-04-09 13:33:58'),(16,20,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:06','2014-04-09 13:34:06'),(17,22,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:08','2014-04-09 13:34:08'),(18,24,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:09','2014-04-09 13:34:09'),(19,26,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:10','2014-04-09 13:34:10'),(20,28,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:16','2014-04-09 13:34:16'),(21,30,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:18','2014-04-09 13:34:18'),(22,33,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:21','2014-04-09 13:34:21'),(23,37,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:26','2014-04-09 13:34:26'),(24,39,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:28','2014-04-09 13:34:28'),(25,41,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:31','2014-04-09 13:34:31'),(26,44,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:33','2014-04-09 13:34:33'),(27,46,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:36','2014-04-09 13:34:36'),(28,48,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:40','2014-04-09 13:34:40'),(29,50,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:44','2014-04-09 13:34:44'),(30,52,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:47','2014-04-09 13:34:47'),(31,54,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:51','2014-04-09 13:34:51'),(32,56,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:54','2014-04-09 13:34:54'),(33,58,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:34:58','2014-04-09 13:34:58'),(34,60,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:01','2014-04-09 13:35:01'),(35,62,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:05','2014-04-09 13:35:05'),(36,64,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:09','2014-04-09 13:35:09'),(37,66,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:13','2014-04-09 13:35:13'),(38,68,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:16','2014-04-09 13:35:16'),(39,70,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-09 13:35:20','2014-04-09 13:35:20'),(40,74,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-10 08:56:35','2014-04-10 08:56:35'),(41,75,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-10 09:02:14','2014-04-10 09:02:14'),(42,76,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-10 09:19:58','2014-04-10 09:19:58'),(43,77,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-10 09:35:27','2014-04-10 09:35:27'),(44,78,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-10 09:50:38','2014-04-10 09:50:38'),(45,79,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,2,1,NULL,'2014-04-27 13:04:16','2014-04-27 13:04:16');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_authentications`
--

DROP TABLE IF EXISTS `open_authentications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `guid` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `provider_guid` (`provider`,`guid`),
  UNIQUE KEY `user_id_provider` (`user_id`,`provider`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_authentications`
--

LOCK TABLES `open_authentications` WRITE;
/*!40000 ALTER TABLE `open_authentications` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_authentications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_associations`
--

DROP TABLE IF EXISTS `open_id_authentication_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issued` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `handle` varchar(255) DEFAULT NULL,
  `assoc_type` varchar(255) DEFAULT NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_authentication_associations`
--

LOCK TABLES `open_id_authentication_associations` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_nonces`
--

DROP TABLE IF EXISTS `open_id_authentication_nonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) DEFAULT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_authentication_nonces`
--

LOCK TABLES `open_id_authentication_nonces` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_nonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_nonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_names`
--

DROP TABLE IF EXISTS `page_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_names` (
  `item_page_id` int(10) unsigned NOT NULL,
  `name_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`name_id`,`item_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Used for BHL. Links name strings to BHL page identifiers. Many names on a given page';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_names`
--

LOCK TABLES `page_names` WRITE;
/*!40000 ALTER TABLE `page_names` DISABLE KEYS */;
INSERT INTO `page_names` VALUES (22,2),(23,2),(24,2),(25,4),(26,4),(27,4),(28,6),(29,6),(30,6),(31,8),(32,8),(33,8),(34,10),(35,10),(36,10),(37,12),(38,12),(39,12),(40,21),(41,21),(42,21),(43,27),(44,27),(45,27),(46,30),(47,30),(48,30),(49,34),(50,34),(51,34),(52,38),(53,38),(54,38),(55,40),(56,40),(57,40),(58,42),(59,42),(60,42),(61,44),(62,44),(63,44),(64,46),(65,46),(66,46),(67,48),(68,48),(69,48),(70,50),(71,50),(72,50),(73,52),(74,52),(75,52),(76,54),(77,54),(78,54),(79,66),(80,66),(81,66),(82,68),(83,68),(84,68),(85,70),(86,70),(87,70),(88,72),(89,72),(90,72);
/*!40000 ALTER TABLE `page_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_stats_dataobjects`
--

DROP TABLE IF EXISTS `page_stats_dataobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_stats_dataobjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` varchar(1) DEFAULT 'n',
  `taxa_count` int(11) DEFAULT NULL,
  `vetted_unknown_published_visible_uniqueGuid` int(11) DEFAULT NULL,
  `vetted_untrusted_published_visible_uniqueGuid` int(11) DEFAULT NULL,
  `vetted_unknown_published_notVisible_uniqueGuid` int(11) DEFAULT NULL,
  `vetted_untrusted_published_notVisible_uniqueGuid` int(11) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `time_created` time DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `a_vetted_unknown_published_visible_uniqueGuid` longtext,
  `a_vetted_untrusted_published_visible_uniqueGuid` longtext,
  `a_vetted_unknown_published_notVisible_uniqueGuid` longtext,
  `a_vetted_untrusted_published_notVisible_uniqueGuid` longtext,
  `user_submitted_text` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_stats_dataobjects`
--

LOCK TABLES `page_stats_dataobjects` WRITE;
/*!40000 ALTER TABLE `page_stats_dataobjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `page_stats_dataobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_stats_marine`
--

DROP TABLE IF EXISTS `page_stats_marine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_stats_marine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) DEFAULT '0',
  `names_from_xml` int(11) DEFAULT NULL,
  `names_in_eol` int(11) DEFAULT NULL,
  `marine_pages` int(11) DEFAULT NULL,
  `pages_with_objects` int(11) DEFAULT NULL,
  `pages_with_vetted_objects` int(11) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `time_created` time DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_stats_marine`
--

LOCK TABLES `page_stats_marine` WRITE;
/*!40000 ALTER TABLE `page_stats_marine` DISABLE KEYS */;
/*!40000 ALTER TABLE `page_stats_marine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_stats_taxa`
--

DROP TABLE IF EXISTS `page_stats_taxa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_stats_taxa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxa_count` int(11) DEFAULT NULL,
  `taxa_text` int(11) DEFAULT NULL,
  `taxa_images` int(11) DEFAULT NULL,
  `taxa_text_images` int(11) DEFAULT NULL,
  `taxa_BHL_no_text` int(11) DEFAULT NULL,
  `taxa_links_no_text` int(11) DEFAULT NULL,
  `taxa_images_no_text` int(11) DEFAULT NULL,
  `taxa_text_no_images` int(11) DEFAULT NULL,
  `vet_obj_only_1cat_inCOL` int(11) DEFAULT NULL,
  `vet_obj_only_1cat_notinCOL` int(11) DEFAULT NULL,
  `vet_obj_morethan_1cat_inCOL` int(11) DEFAULT NULL,
  `vet_obj_morethan_1cat_notinCOL` int(11) DEFAULT NULL,
  `vet_obj` int(11) DEFAULT NULL,
  `no_vet_obj2` int(11) DEFAULT NULL,
  `with_BHL` int(11) DEFAULT NULL,
  `vetted_not_published` int(11) DEFAULT NULL,
  `vetted_unknown_published_visible_inCol` int(11) DEFAULT NULL,
  `vetted_unknown_published_visible_notinCol` int(11) DEFAULT NULL,
  `pages_incol` int(11) DEFAULT NULL,
  `pages_not_incol` int(11) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lifedesk_taxa` int(11) DEFAULT NULL,
  `lifedesk_dataobject` int(11) DEFAULT NULL,
  `data_objects_count_per_category` text,
  `content_partners_count_per_category` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_stats_taxa`
--

LOCK TABLES `page_stats_taxa` WRITE;
/*!40000 ALTER TABLE `page_stats_taxa` DISABLE KEYS */;
/*!40000 ALTER TABLE `page_stats_taxa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pending_notifications`
--

DROP TABLE IF EXISTS `pending_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pending_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `notification_frequency_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(64) DEFAULT NULL,
  `reason` varchar(64) DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pending_notifications_on_user_id` (`user_id`),
  KEY `index_pending_notifications_on_sent_at` (`sent_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pending_notifications`
--

LOCK TABLES `pending_notifications` WRITE;
/*!40000 ALTER TABLE `pending_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_count` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,1,'2014-04-09 13:33:28','2014-04-09 13:34:27'),(2,0,'2014-04-09 13:33:28','2014-04-09 13:33:28'),(3,2,'2014-04-09 13:33:28','2014-04-09 13:35:53'),(4,0,'2014-04-09 13:33:28','2014-04-09 13:33:28');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_users`
--

DROP TABLE IF EXISTS `permissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_permissions_users_on_permission_id_and_user_id` (`permission_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_users`
--

LOCK TABLES `permissions_users` WRITE;
/*!40000 ALTER TABLE `permissions_users` DISABLE KEYS */;
INSERT INTO `permissions_users` VALUES (1,37,1,'2014-04-09 13:34:27','2014-04-09 13:34:27'),(2,37,3,'2014-04-09 13:34:27','2014-04-09 13:34:27'),(3,72,3,'2014-04-09 13:35:53','2014-04-09 13:35:53');
/*!40000 ALTER TABLE `permissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publication_titles`
--

DROP TABLE IF EXISTS `publication_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publication_titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `marc_bib_id` varchar(40) NOT NULL,
  `marc_leader` varchar(40) NOT NULL,
  `title` varchar(300) NOT NULL,
  `short_title` varchar(300) NOT NULL,
  `details` varchar(300) NOT NULL,
  `call_number` varchar(40) NOT NULL,
  `start_year` varchar(10) NOT NULL,
  `end_year` varchar(10) NOT NULL,
  `language` varchar(10) NOT NULL,
  `author` varchar(150) NOT NULL,
  `abbreviation` varchar(150) NOT NULL,
  `url` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Used for BHL. The main publications';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publication_titles`
--

LOCK TABLES `publication_titles` WRITE;
/*!40000 ALTER TABLE `publication_titles` DISABLE KEYS */;
INSERT INTO `publication_titles` VALUES (3,'','','Great Big Journal of Fun','Publication','Nifty Titles Are Our Business','','','','','bob','','http://publication.titles.te.st'),(4,'','','The Journal You Cannot Afford','Publication','Nifty Titles Are Our Business','','','','','bob','','http://publication.titles.te.st');
/*!40000 ALTER TABLE `publication_titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `random_hierarchy_images`
--

DROP TABLE IF EXISTS `random_hierarchy_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `random_hierarchy_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_object_id` int(11) NOT NULL,
  `hierarchy_entry_id` int(11) DEFAULT NULL,
  `hierarchy_id` int(11) DEFAULT NULL,
  `taxon_concept_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hierarchy_entry_id` (`hierarchy_entry_id`),
  KEY `hierarchy_id` (`hierarchy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `random_hierarchy_images`
--

LOCK TABLES `random_hierarchy_images` WRITE;
/*!40000 ALTER TABLE `random_hierarchy_images` DISABLE KEYS */;
INSERT INTO `random_hierarchy_images` VALUES (30,2,2,3,7,'<i>Autvoluptatesus temporaalis</i> Factory TestFramework'),(31,11,3,3,8,'<i>Excepturialia omnisa</i> Factory TestFramework'),(32,20,4,3,9,'<i>Estveroalia nihilata</i> Factory TestFramework'),(33,29,5,3,10,'<i>Quiincidunta culpaelia</i> Factory TestFramework'),(34,38,6,3,11,'<i>Providentalia estquaeratens</i> Factory TestFramework'),(35,47,7,3,12,'<i>Placeatalia uteosensis</i> Factory TestFramework'),(36,66,11,3,16,'<i>Ipsaensis architectoalius</i> Factory TestFramework'),(37,82,12,3,17,'<i>Deserunterox facererox</i> Factory TestFramework'),(38,92,13,3,18,'<i>Suntalia estsitalius</i> Factory TestFramework'),(39,101,17,3,20,'<i>Aliasosyne quiadipisciatus</i> Factory TestFramework'),(40,110,24,6,21,'<i>Illoica exexplicaboalia</i> Factory TestFramework'),(41,119,26,6,22,'<i>Laboriosamerus quisis</i> Factory TestFramework'),(42,128,27,6,23,'<i>Optiois molestiasalia</i> Factory TestFramework'),(43,137,28,6,24,'<i>Ipsuma animius</i> Factory TestFramework'),(44,146,29,6,25,'<i>Quiserox eligendii</i> Factory TestFramework'),(45,155,30,6,26,'<i>Eteaiae nullais</i> Factory TestFramework'),(46,164,31,6,27,'<i>Quibusdameli estculpaatut</i> Factory TestFramework'),(47,173,32,6,28,'<i>Estasperioreseli etquidemit</i> Factory TestFramework'),(48,182,33,6,29,'<i>Nesciunterox autrerumalit</i> Factory TestFramework'),(49,191,34,6,30,'<i>Voluptasalius optioerut</i> Factory TestFramework'),(50,200,35,6,31,'<i>Remrerumeron auteterut</i> Factory TestFramework'),(51,209,36,6,32,'<i>Veritatises idofficiisiaf</i> Factory TestFramework'),(52,218,37,6,33,'<i>Accusamusalis pariaturb</i> Factory TestFramework'),(53,227,38,6,34,'<i>Voluptateseri doloremosynf</i> Factory TestFramework');
/*!40000 ALTER TABLE `random_hierarchy_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ranks`
--

DROP TABLE IF EXISTS `ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ranks` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `rank_group_id` smallint(6) NOT NULL COMMENT 'not required; there is no rank_groups table. This is used to group (reconcile) different strings for the same rank',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='Stores taxonomic ranks (ex: phylum, order, class, family...). Used in hierarchy_entries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ranks`
--

LOCK TABLES `ranks` WRITE;
/*!40000 ALTER TABLE `ranks` DISABLE KEYS */;
INSERT INTO `ranks` VALUES (1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0),(11,0),(12,0),(13,0),(14,0),(15,0),(16,0),(17,0),(18,0),(19,0),(20,0);
/*!40000 ALTER TABLE `ranks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_identifier_types`
--

DROP TABLE IF EXISTS `ref_identifier_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_identifier_types` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `label` (`label`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_identifier_types`
--

LOCK TABLES `ref_identifier_types` WRITE;
/*!40000 ALTER TABLE `ref_identifier_types` DISABLE KEYS */;
INSERT INTO `ref_identifier_types` VALUES (3,'bici'),(4,'coden'),(2,'doi'),(5,'eissn'),(6,'handle'),(7,'isbn'),(8,'issn'),(9,'lsid'),(10,'oclc'),(11,'sici'),(1,'url'),(12,'urn');
/*!40000 ALTER TABLE `ref_identifier_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_identifiers`
--

DROP TABLE IF EXISTS `ref_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_identifiers` (
  `ref_id` int(10) unsigned NOT NULL,
  `ref_identifier_type_id` smallint(5) unsigned NOT NULL,
  `identifier` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`ref_id`,`ref_identifier_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_identifiers`
--

LOCK TABLES `ref_identifiers` WRITE;
/*!40000 ALTER TABLE `ref_identifiers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_identifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refs`
--

DROP TABLE IF EXISTS `refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `full_reference` text NOT NULL,
  `provider_mangaed_id` varchar(255) DEFAULT NULL,
  `authors` varchar(255) DEFAULT NULL,
  `editors` varchar(255) DEFAULT NULL,
  `publication_created_at` timestamp NULL DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `page_start` varchar(50) DEFAULT NULL,
  `page_end` varchar(50) DEFAULT NULL,
  `volume` varchar(50) DEFAULT NULL,
  `edition` varchar(50) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `language_id` smallint(5) unsigned DEFAULT NULL,
  `user_submitted` tinyint(1) NOT NULL DEFAULT '0',
  `visibility_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `full_reference` (`full_reference`(200))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores reference full strings. References are linked to data objects and taxa.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refs`
--

LOCK TABLES `refs` WRITE;
/*!40000 ALTER TABLE `refs` DISABLE KEYS */;
/*!40000 ALTER TABLE `refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resource_statuses`
--

DROP TABLE IF EXISTS `resource_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='The status of the resource in harvesting';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resource_statuses`
--

LOCK TABLES `resource_statuses` WRITE;
/*!40000 ALTER TABLE `resource_statuses` DISABLE KEYS */;
INSERT INTO `resource_statuses` VALUES (1,'2014-04-09 13:33:35','2014-04-09 13:33:35'),(2,'2014-04-09 13:33:35','2014-04-09 13:33:35'),(3,'2014-04-09 13:33:35','2014-04-09 13:33:35'),(4,'2014-04-09 13:33:35','2014-04-09 13:33:35'),(5,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(6,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(7,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(8,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(9,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(10,'2014-04-09 13:33:36','2014-04-09 13:33:36'),(11,'2014-04-09 13:33:36','2014-04-09 13:33:36');
/*!40000 ALTER TABLE `resource_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content_partner_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `accesspoint_url` varchar(255) DEFAULT NULL COMMENT 'recommended; the url where the resource can be accessed. Not used when the resource is a file which was uploaded',
  `metadata_url` varchar(255) DEFAULT NULL,
  `dwc_archive_url` varchar(255) DEFAULT NULL,
  `service_type_id` int(11) NOT NULL DEFAULT '1' COMMENT 'recommended; if accesspoint_url is defined, this will indicate what kind of protocal can be expected to be found there. (this is perhaps misued right now)',
  `service_version` varchar(255) DEFAULT NULL,
  `resource_set_code` varchar(255) DEFAULT NULL COMMENT 'not required; if the resource contains several subsets (such as DiGIR providers) theis indicates the set we are to harvest',
  `description` varchar(255) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `language_id` smallint(5) unsigned DEFAULT NULL COMMENT 'not required; the default language of the contents of the resource',
  `subject` varchar(255) NOT NULL,
  `bibliographic_citation` varchar(400) DEFAULT NULL COMMENT 'not required; the default bibliographic citation for all data objects whithin the resource',
  `license_id` tinyint(3) unsigned NOT NULL,
  `rights_statement` varchar(400) DEFAULT NULL,
  `rights_holder` varchar(255) DEFAULT NULL,
  `refresh_period_hours` smallint(5) unsigned DEFAULT NULL COMMENT 'recommended; if the resource is to be harvested regularly, this field indicates how frequent the updates are',
  `resource_modified_at` datetime DEFAULT NULL,
  `resource_created_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `harvested_at` datetime DEFAULT NULL COMMENT 'required; this field is updated each time the resource is harvested',
  `dataset_file_name` varchar(255) DEFAULT NULL,
  `dataset_content_type` varchar(255) DEFAULT NULL,
  `dataset_file_size` int(11) DEFAULT NULL,
  `resource_status_id` int(11) DEFAULT NULL,
  `auto_publish` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'required; boolean; indicates whether the resource is to be published immediately after harvesting',
  `vetted` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text,
  `hierarchy_id` int(10) unsigned DEFAULT NULL,
  `dwc_hierarchy_id` int(10) unsigned DEFAULT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `preview_collection_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `dataset_license_id` int(11) DEFAULT NULL,
  `dataset_rights_holder` varchar(255) DEFAULT NULL,
  `dataset_rights_statement` varchar(400) DEFAULT NULL,
  `dataset_source_url` varchar(255) DEFAULT NULL,
  `dataset_hosted_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hierarchy_id` (`hierarchy_id`),
  KEY `content_partner_id` (`content_partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='Content parters supply resource files which contain data objects and taxa';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
INSERT INTO `resources` VALUES (1,3,'LigerCat resource','http://eol.org/opensearchdescription.xml',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'Test Resource Subject',NULL,3,NULL,NULL,0,NULL,'2014-04-07 13:32:58','2014-04-09 11:33:18',NULL,NULL,NULL,NULL,NULL,0,0,NULL,2,NULL,NULL,NULL,'2014-04-09 11:33:18',NULL,NULL,NULL,NULL,NULL),(2,1,'Initial IUCN Import','http://eol.org/opensearchdescription.xml',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'Test Resource Subject',NULL,3,NULL,NULL,0,NULL,'2014-04-07 13:32:58','2014-04-09 11:33:21',NULL,NULL,NULL,NULL,NULL,0,0,NULL,8,NULL,NULL,NULL,'2014-04-09 11:33:21',NULL,NULL,NULL,NULL,NULL),(3,2,'Bootstrapper','http://eol.org/opensearchdescription.xml',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'Test Resource Subject',NULL,3,NULL,NULL,0,NULL,'2014-04-07 13:32:58','2014-04-09 11:33:37',NULL,NULL,NULL,NULL,8,0,1,NULL,NULL,NULL,NULL,NULL,'2014-04-09 11:33:37',NULL,NULL,NULL,NULL,NULL),(4,4,'Test Framework Import','http://eol.org/opensearchdescription.xml',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'Test Resource Subject',NULL,3,NULL,NULL,0,NULL,'2014-04-07 13:32:58','2014-04-09 11:34:21',NULL,NULL,NULL,NULL,8,0,0,NULL,10,NULL,NULL,NULL,'2014-04-09 11:34:21',NULL,NULL,NULL,NULL,NULL),(5,6,'Test ContentPartner import','http://eol.org/opensearchdescription.xml',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'Test Resource Subject',NULL,3,NULL,NULL,0,NULL,'2014-04-07 13:32:58','2014-04-09 11:34:26',NULL,NULL,NULL,NULL,8,0,1,NULL,11,NULL,NULL,NULL,'2014-04-09 11:34:26',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20090115212906'),('20090115213411'),('20120103141320'),('20120110075736'),('20120110103907'),('20120111211217'),('20120112191907'),('20120112200143'),('20120117213105'),('20120120205849'),('20120131212129'),('20120206154220'),('20120207203935'),('20120208221609'),('20120210202432'),('20120222032338'),('20120223204740'),('20120229152123'),('20120229170021'),('20120301041857'),('20120307204553'),('20120313030838'),('20120315225035'),('20120322050318'),('20120322201426'),('20120322203550'),('20120328143839'),('20120409142449'),('20120411135611'),('20120416134434'),('20120416205738'),('20120424162745'),('20120425185543'),('20120502204941'),('20120508144927'),('20120509164521'),('20120511145911'),('20120523132153'),('20120524195141'),('20120606174130'),('20120612185023'),('20120620180925'),('20120621170001'),('20120702161131'),('20120711180628'),('20120711191923'),('20120717195215'),('20120723173028'),('20120725174440'),('20120726181117'),('20120803133442'),('20120822130345'),('20120824212655'),('20120831194556'),('20120913212558'),('20120921163501'),('20121017193823'),('20121024195217'),('20121214213208'),('20121214213210'),('20121226211903'),('20130114173940'),('20130115161931'),('20130122175125'),('20130131151206'),('20130213150346'),('20130218224336'),('20130221155225'),('20130312205157'),('20130314154506'),('20130316220630'),('20130405164819'),('20130409183346'),('20130417184926'),('20130507192132'),('20130513160049'),('20130514165519'),('20130516163352'),('20130616133515'),('20130616133666'),('20130621154953'),('20130625164819'),('20130705175328'),('20130716181945'),('20130719150708'),('20130814154004'),('20130821135151'),('20130822141249'),('20130822212627'),('20130828134735'),('20130903164208'),('20131003131947'),('20131007005920'),('20131015172505'),('20131016162919'),('20131017205031'),('20131018135212'),('20131114214249'),('20131127153518'),('20131220005325'),('20131223163226'),('20140107210209'),('20140123190941'),('20140207155052'),('20140209080829'),('20140209081037'),('20140209081242'),('20140209081429'),('20140209081622'),('20140209081840'),('20140209084025'),('20140209084158'),('20140209084302'),('20140209084355'),('20140209084455'),('20140310085028'),('20140310085128'),('20140310115645'),('20140312114707'),('20140312115721'),('20140312121102'),('20140312121257'),('20140313064713'),('20140325065558'),('20140325070235'),('20140403110536'),('20140403120503'),('20140407080915'),('20140407092701'),('20140407094958'),('20140408122111'),('20140415130656'),('20140427114814'),('20140429091351'),('20140429121129'),('20140505080315'),('20140507100145'),('20140515083925'),('20140515085813'),('20140515090408'),('20140515111945'),('20140623132125'),('20140629105333'),('20140701094451'),('20140701095308');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_suggestions`
--

DROP TABLE IF EXISTS `search_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_suggestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` varchar(255) NOT NULL DEFAULT '',
  `language_label` varchar(255) NOT NULL DEFAULT 'en',
  `taxon_id` varchar(255) NOT NULL DEFAULT '',
  `notes` text,
  `content_notes` varchar(255) NOT NULL DEFAULT '',
  `sort_order` int(11) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_suggestions`
--

LOCK TABLES `search_suggestions` WRITE;
/*!40000 ALTER TABLE `search_suggestions` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_suggestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_types` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='What type of protocol the content partners are exposing';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1);
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_configuration_options`
--

DROP TABLE IF EXISTS `site_configuration_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_configuration_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_site_configuration_options_on_parameter` (`parameter`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_configuration_options`
--

LOCK TABLES `site_configuration_options` WRITE;
/*!40000 ALTER TABLE `site_configuration_options` DISABLE KEYS */;
INSERT INTO `site_configuration_options` VALUES (1,'email_actions_to_curators','','2014-04-09 13:33:09','2014-04-09 13:33:09'),(2,'email_actions_to_curators_address','','2014-04-09 13:33:09','2014-04-09 13:33:09'),(3,'global_site_warning','','2014-04-09 13:33:09','2014-04-09 13:33:09'),(4,'all_users_can_see_data','false','2014-04-09 13:33:09','2014-04-09 13:33:09'),(5,'reference_parsing_enabled','','2014-04-09 13:33:09','2014-04-09 13:33:09'),(6,'reference_parser_pid','','2014-04-09 13:33:10','2014-04-09 13:33:10'),(7,'reference_parser_endpoint','','2014-04-09 13:33:10','2014-04-09 13:33:10'),(8,'notification_error_user_id','','2014-04-09 13:33:10','2014-04-09 13:33:10');
/*!40000 ALTER TABLE `site_configuration_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sort_styles`
--

DROP TABLE IF EXISTS `sort_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sort_styles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sort_styles`
--

LOCK TABLES `sort_styles` WRITE;
/*!40000 ALTER TABLE `sort_styles` DISABLE KEYS */;
INSERT INTO `sort_styles` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);
/*!40000 ALTER TABLE `sort_styles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `special_collections`
--

DROP TABLE IF EXISTS `special_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `special_collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `special_collections`
--

LOCK TABLES `special_collections` WRITE;
/*!40000 ALTER TABLE `special_collections` DISABLE KEYS */;
INSERT INTO `special_collections` VALUES (1,'Focus'),(2,'Watch');
/*!40000 ALTER TABLE `special_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statuses` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='Generic status table designed to be used in several places. Now only used in harvest_event tables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30);
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_responses`
--

DROP TABLE IF EXISTS `survey_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_id` varchar(255) DEFAULT NULL,
  `user_response` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_responses`
--

LOCK TABLES `survey_responses` WRITE;
/*!40000 ALTER TABLE `survey_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `survey_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_events`
--

DROP TABLE IF EXISTS `sync_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_md5_hash` varchar(255) DEFAULT NULL,
  `success_at` datetime DEFAULT NULL,
  `received_at` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `failed_reason` varchar(255) DEFAULT NULL,
  `UUID` varchar(36) DEFAULT NULL,
  `is_pull` tinyint(1) DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `status_code` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_events`
--

LOCK TABLES `sync_events` WRITE;
/*!40000 ALTER TABLE `sync_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_log_action_parameters`
--

DROP TABLE IF EXISTS `sync_log_action_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_log_action_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `peer_log_id` int(11) DEFAULT NULL,
  `param_object_type_id` int(11) DEFAULT NULL,
  `param_object_id` int(11) DEFAULT NULL,
  `param_object_site_id` int(11) DEFAULT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `value` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_log_action_parameters`
--

LOCK TABLES `sync_log_action_parameters` WRITE;
/*!40000 ALTER TABLE `sync_log_action_parameters` DISABLE KEYS */;
INSERT INTO `sync_log_action_parameters` VALUES (1,1,NULL,NULL,NULL,'language','1','2014-07-01 11:40:27','2014-07-01 11:40:27'),(2,1,NULL,NULL,NULL,'parent_content_page_origin_id',NULL,'2014-07-01 11:40:27','2014-07-01 11:40:27'),(3,1,NULL,NULL,NULL,'parent_content_page_site_id',NULL,'2014-07-01 11:40:27','2014-07-01 11:40:27'),(4,1,NULL,NULL,NULL,'page_name','test_created_at','2014-07-01 11:40:27','2014-07-01 11:40:27'),(5,1,NULL,NULL,NULL,'active','1','2014-07-01 11:40:28','2014-07-01 11:40:28'),(6,1,NULL,NULL,NULL,'sort_order','12','2014-07-01 11:40:28','2014-07-01 11:40:28'),(7,1,NULL,NULL,NULL,'title','test_created_at','2014-07-01 11:40:28','2014-07-01 11:40:28'),(8,1,NULL,NULL,NULL,'main_content','<p>test_created_at</p>\r\n','2014-07-01 11:40:28','2014-07-01 11:40:28'),(9,1,NULL,NULL,NULL,'left_content','','2014-07-01 11:40:28','2014-07-01 11:40:28'),(10,1,NULL,NULL,NULL,'meta_keywords','','2014-07-01 11:40:28','2014-07-01 11:40:28'),(11,1,NULL,NULL,NULL,'meta_description','','2014-07-01 11:40:28','2014-07-01 11:40:28'),(12,1,NULL,NULL,NULL,'active_translation','1','2014-07-01 11:40:28','2014-07-01 11:40:28');
/*!40000 ALTER TABLE `sync_log_action_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_object_actions`
--

DROP TABLE IF EXISTS `sync_object_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_object_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_action` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_object_actions`
--

LOCK TABLES `sync_object_actions` WRITE;
/*!40000 ALTER TABLE `sync_object_actions` DISABLE KEYS */;
INSERT INTO `sync_object_actions` VALUES (1,'create','2014-04-10 09:50:39','2014-04-10 09:50:39'),(2,'activate','2014-04-27 10:58:48','2014-04-27 10:58:48'),(3,'delete','2014-04-30 11:59:06','2014-04-30 11:59:06');
/*!40000 ALTER TABLE `sync_object_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_object_types`
--

DROP TABLE IF EXISTS `sync_object_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_object_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_object_types`
--

LOCK TABLES `sync_object_types` WRITE;
/*!40000 ALTER TABLE `sync_object_types` DISABLE KEYS */;
INSERT INTO `sync_object_types` VALUES (1,'User','2014-04-10 09:50:39','2014-04-10 09:50:39'),(2,'content_page','2014-04-27 11:44:13','2014-04-27 11:44:13');
/*!40000 ALTER TABLE `sync_object_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_peer_logs`
--

DROP TABLE IF EXISTS `sync_peer_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_peer_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_site_id` int(11) DEFAULT NULL,
  `user_site_object_id` int(11) DEFAULT NULL,
  `action_taken_at` datetime DEFAULT NULL,
  `sync_object_action_id` int(11) DEFAULT NULL,
  `sync_object_type_id` int(11) DEFAULT NULL,
  `sync_object_id` int(11) DEFAULT NULL,
  `sync_object_site_id` int(11) DEFAULT NULL,
  `sync_event_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_peer_logs`
--

LOCK TABLES `sync_peer_logs` WRITE;
/*!40000 ALTER TABLE `sync_peer_logs` DISABLE KEYS */;
INSERT INTO `sync_peer_logs` VALUES (1,1,79,'2014-07-01 11:40:27',1,2,27,1,1,'2014-07-01 11:40:27','2014-07-01 11:40:27');
/*!40000 ALTER TABLE `sync_peer_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_uuids`
--

DROP TABLE IF EXISTS `sync_uuids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_uuids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `current_uuid` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_uuids`
--

LOCK TABLES `sync_uuids` WRITE;
/*!40000 ALTER TABLE `sync_uuids` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_uuids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `synonym_relations`
--

DROP TABLE IF EXISTS `synonym_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `synonym_relations` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `synonym_relations`
--

LOCK TABLES `synonym_relations` WRITE;
/*!40000 ALTER TABLE `synonym_relations` DISABLE KEYS */;
INSERT INTO `synonym_relations` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),(41),(42),(43),(44),(45),(46),(47),(48),(49);
/*!40000 ALTER TABLE `synonym_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `synonyms`
--

DROP TABLE IF EXISTS `synonyms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `synonyms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name_id` int(10) unsigned NOT NULL,
  `synonym_relation_id` tinyint(3) unsigned NOT NULL COMMENT 'the relationship this synonym has with the preferred name for this node',
  `language_id` smallint(5) unsigned NOT NULL COMMENT 'generally only set when the synonym is a common name',
  `hierarchy_entry_id` int(10) unsigned NOT NULL COMMENT 'associated node in the hierarchy',
  `preferred` tinyint(3) unsigned NOT NULL COMMENT 'set to 1 if this is a common name and is the preferred common name for the node in its language',
  `hierarchy_id` smallint(5) unsigned NOT NULL COMMENT 'this is redundant as it can be found via the synonym''s hierarchy_entry. I think its here for legacy reasons, but we can probably get rid of it',
  `vetted_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `taxon_remarks` text,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `last_change` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_names` (`name_id`,`synonym_relation_id`,`language_id`,`hierarchy_entry_id`,`hierarchy_id`),
  KEY `hierarchy_entry_id` (`hierarchy_entry_id`),
  KEY `name_id` (`name_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COMMENT='Used to assigned taxonomic synonyms and common names to hierarchy entries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `synonyms`
--

LOCK TABLES `synonyms` WRITE;
/*!40000 ALTER TABLE `synonyms` DISABLE KEYS */;
INSERT INTO `synonyms` VALUES (23,2,1,5,2,1,5,2,1,NULL,NULL,NULL,NULL),(24,3,2,1,2,1,5,2,1,NULL,NULL,NULL,NULL),(25,4,1,5,3,1,5,2,1,NULL,NULL,NULL,NULL),(26,5,2,1,3,1,5,2,1,NULL,NULL,NULL,NULL),(27,6,1,5,4,1,5,2,1,NULL,NULL,NULL,NULL),(28,7,2,1,4,1,5,2,1,NULL,NULL,NULL,NULL),(29,8,1,5,5,1,5,2,1,NULL,NULL,NULL,NULL),(30,9,2,1,5,1,5,2,1,NULL,NULL,NULL,NULL),(31,10,1,5,6,1,5,2,1,NULL,NULL,NULL,NULL),(32,11,2,1,6,1,5,2,1,NULL,NULL,NULL,NULL),(33,12,1,5,7,1,5,2,1,NULL,NULL,NULL,NULL),(34,13,2,1,7,1,5,2,1,NULL,NULL,NULL,NULL),(35,14,1,5,8,1,5,2,1,NULL,NULL,NULL,NULL),(36,15,2,1,8,1,5,2,1,NULL,NULL,NULL,NULL),(37,16,2,1,8,0,5,2,1,NULL,NULL,NULL,NULL),(38,17,2,1,8,0,5,2,1,NULL,NULL,NULL,NULL),(39,18,2,1,8,0,5,2,1,NULL,NULL,NULL,NULL),(40,19,2,1,8,0,5,2,1,NULL,NULL,NULL,NULL),(41,20,2,1,8,0,5,2,1,NULL,NULL,NULL,NULL),(42,21,1,5,9,1,5,2,1,NULL,NULL,NULL,NULL),(43,11,2,1,9,1,5,2,1,NULL,NULL,NULL,NULL),(44,22,1,5,10,1,5,2,1,NULL,NULL,NULL,NULL),(45,23,1,5,11,1,5,2,1,NULL,NULL,NULL,NULL),(46,24,2,1,11,1,5,2,1,NULL,NULL,NULL,NULL),(47,26,2,1,12,1,5,2,1,NULL,NULL,NULL,NULL),(48,25,1,5,12,1,5,2,1,NULL,NULL,NULL,NULL),(49,27,1,5,13,1,5,2,1,NULL,NULL,NULL,NULL),(50,31,2,1,17,1,5,2,1,NULL,NULL,NULL,NULL),(51,32,2,1,17,0,5,2,1,NULL,NULL,NULL,NULL),(52,33,2,1,17,0,5,2,1,NULL,NULL,NULL,NULL),(53,30,1,5,17,1,5,2,1,NULL,NULL,NULL,NULL),(54,35,2,1,24,1,5,2,1,NULL,NULL,NULL,NULL),(55,34,1,5,24,1,5,2,1,NULL,NULL,NULL,NULL),(56,39,2,1,26,1,5,2,1,NULL,NULL,NULL,NULL),(57,38,1,5,26,1,5,2,1,NULL,NULL,NULL,NULL),(58,41,2,1,27,1,5,2,1,NULL,NULL,NULL,NULL),(59,40,1,5,27,1,5,2,1,NULL,NULL,NULL,NULL),(60,43,2,1,28,1,5,2,1,NULL,NULL,NULL,NULL),(61,42,1,5,28,1,5,2,1,NULL,NULL,NULL,NULL),(62,45,2,1,29,1,5,2,1,NULL,NULL,NULL,NULL),(63,44,1,5,29,1,5,2,1,NULL,NULL,NULL,NULL),(64,47,2,1,30,1,5,2,1,NULL,NULL,NULL,NULL),(65,46,1,5,30,1,5,2,1,NULL,NULL,NULL,NULL),(66,49,2,1,31,1,5,2,1,NULL,NULL,NULL,NULL),(67,48,1,5,31,1,5,2,1,NULL,NULL,NULL,NULL),(68,51,2,1,32,1,5,2,1,NULL,NULL,NULL,NULL),(69,50,1,5,32,1,5,2,1,NULL,NULL,NULL,NULL),(70,53,2,1,33,1,5,2,1,NULL,NULL,NULL,NULL),(71,52,1,5,33,1,5,2,1,NULL,NULL,NULL,NULL),(72,54,1,5,34,1,5,2,1,NULL,NULL,NULL,NULL),(73,56,2,1,34,1,5,2,1,NULL,NULL,NULL,NULL),(74,57,2,1,34,0,5,2,1,NULL,NULL,NULL,NULL),(75,58,2,1,34,0,5,2,1,NULL,NULL,NULL,NULL),(76,60,2,7,34,1,5,2,1,NULL,NULL,NULL,NULL),(77,61,2,7,34,0,5,2,1,NULL,NULL,NULL,NULL),(78,63,2,2,34,1,5,2,1,NULL,NULL,NULL,NULL),(79,64,2,2,34,0,5,2,1,NULL,NULL,NULL,NULL),(80,65,1,5,34,0,5,2,1,NULL,NULL,NULL,NULL),(81,67,2,1,35,1,5,2,1,NULL,NULL,NULL,NULL),(82,66,1,5,35,1,5,2,1,NULL,NULL,NULL,NULL),(83,69,2,1,36,1,5,2,1,NULL,NULL,NULL,NULL),(84,68,1,5,36,1,5,2,1,NULL,NULL,NULL,NULL),(85,71,2,1,37,1,5,2,1,NULL,NULL,NULL,NULL),(86,70,1,5,37,1,5,2,1,NULL,NULL,NULL,NULL),(87,73,2,1,38,1,5,2,1,NULL,NULL,NULL,NULL),(88,72,1,5,38,1,5,2,1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `synonyms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_of_contents`
--

DROP TABLE IF EXISTS `table_of_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_of_contents` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) unsigned NOT NULL COMMENT 'refers to the parent taxon_of_contents id. Our table of content is only two levels deep',
  `view_order` smallint(5) unsigned DEFAULT '0' COMMENT 'used to organize the view of the table of contents on the species page in order of priority, not alphabetically',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_of_contents`
--

LOCK TABLES `table_of_contents` WRITE;
/*!40000 ALTER TABLE `table_of_contents` DISABLE KEYS */;
INSERT INTO `table_of_contents` VALUES (1,0,1,NULL,NULL),(2,1,2,NULL,NULL),(3,5,39,NULL,NULL),(4,0,3,NULL,NULL),(5,0,4,NULL,NULL),(6,5,5,NULL,NULL),(7,0,6,NULL,NULL),(8,7,7,NULL,NULL),(9,0,8,NULL,NULL),(10,5,9,NULL,NULL),(11,0,50,NULL,NULL),(12,11,51,NULL,NULL),(13,11,52,NULL,NULL),(14,11,53,NULL,NULL),(15,0,57,NULL,NULL),(16,15,58,NULL,NULL),(17,0,61,NULL,NULL),(18,0,62,NULL,NULL),(19,0,70,NULL,NULL),(20,19,71,NULL,NULL),(21,0,58,NULL,NULL),(22,18,65,NULL,NULL),(23,18,66,NULL,NULL),(24,18,67,NULL,NULL),(25,0,68,NULL,NULL),(26,25,69,NULL,NULL),(27,25,70,NULL,NULL),(28,5,41,NULL,NULL),(29,0,77,NULL,NULL),(30,0,78,NULL,NULL),(31,0,57,NULL,NULL),(32,0,80,NULL,NULL),(33,5,43,NULL,NULL),(34,0,56,NULL,NULL),(35,0,83,NULL,NULL),(36,0,84,NULL,NULL),(37,0,85,NULL,NULL),(38,0,59,NULL,NULL),(39,5,40,NULL,NULL),(40,5,42,NULL,NULL),(41,5,44,NULL,NULL),(42,5,45,NULL,NULL),(43,5,46,NULL,NULL),(44,5,47,NULL,NULL),(45,5,48,NULL,NULL),(46,5,49,NULL,NULL),(47,5,50,NULL,NULL),(48,5,51,NULL,NULL),(49,5,52,NULL,NULL),(50,5,53,NULL,NULL),(51,0,55,NULL,NULL),(52,38,60,NULL,NULL),(53,38,61,NULL,NULL),(54,38,62,NULL,NULL),(55,38,63,NULL,NULL),(56,38,64,NULL,NULL),(57,38,65,NULL,NULL),(58,38,66,NULL,NULL),(59,0,65,NULL,NULL);
/*!40000 ALTER TABLE `table_of_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_classifications_locks`
--

DROP TABLE IF EXISTS `taxon_classifications_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_classifications_locks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taxon_concept_id` (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_classifications_locks`
--

LOCK TABLES `taxon_classifications_locks` WRITE;
/*!40000 ALTER TABLE `taxon_classifications_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_classifications_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_content`
--

DROP TABLE IF EXISTS `taxon_concept_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_content` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `text` tinyint(3) unsigned NOT NULL,
  `text_unpublished` tinyint(3) unsigned NOT NULL,
  `image` tinyint(3) unsigned NOT NULL,
  `image_unpublished` tinyint(3) unsigned NOT NULL,
  `child_image` tinyint(3) unsigned NOT NULL,
  `child_image_unpublished` tinyint(3) unsigned NOT NULL,
  `flash` tinyint(3) unsigned NOT NULL,
  `youtube` tinyint(3) unsigned NOT NULL,
  `map` tinyint(3) unsigned NOT NULL,
  `content_level` tinyint(3) unsigned NOT NULL,
  `image_object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_content`
--

LOCK TABLES `taxon_concept_content` WRITE;
/*!40000 ALTER TABLE `taxon_concept_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_concept_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_exemplar_articles`
--

DROP TABLE IF EXISTS `taxon_concept_exemplar_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_exemplar_articles` (
  `taxon_concept_id` int(11) NOT NULL AUTO_INCREMENT,
  `data_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_exemplar_articles`
--

LOCK TABLES `taxon_concept_exemplar_articles` WRITE;
/*!40000 ALTER TABLE `taxon_concept_exemplar_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_concept_exemplar_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_exemplar_images`
--

DROP TABLE IF EXISTS `taxon_concept_exemplar_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_exemplar_images` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_exemplar_images`
--

LOCK TABLES `taxon_concept_exemplar_images` WRITE;
/*!40000 ALTER TABLE `taxon_concept_exemplar_images` DISABLE KEYS */;
INSERT INTO `taxon_concept_exemplar_images` VALUES (7,2),(8,11),(9,20),(10,29),(11,38),(12,47),(16,66),(18,92),(20,101),(21,110),(22,119),(23,128),(24,137),(25,146),(26,155),(27,164),(28,173),(29,182),(30,191),(31,200),(32,209),(33,218),(34,227);
/*!40000 ALTER TABLE `taxon_concept_exemplar_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_metrics`
--

DROP TABLE IF EXISTS `taxon_concept_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_metrics` (
  `taxon_concept_id` int(11) NOT NULL DEFAULT '0',
  `image_total` mediumint(9) DEFAULT NULL,
  `image_trusted` mediumint(9) DEFAULT NULL,
  `image_untrusted` mediumint(9) DEFAULT NULL,
  `image_unreviewed` mediumint(9) DEFAULT NULL,
  `image_total_words` mediumint(9) DEFAULT NULL,
  `image_trusted_words` mediumint(9) DEFAULT NULL,
  `image_untrusted_words` mediumint(9) DEFAULT NULL,
  `image_unreviewed_words` mediumint(9) DEFAULT NULL,
  `text_total` mediumint(9) DEFAULT NULL,
  `text_trusted` mediumint(9) DEFAULT NULL,
  `text_untrusted` mediumint(9) DEFAULT NULL,
  `text_unreviewed` mediumint(9) DEFAULT NULL,
  `text_total_words` mediumint(9) DEFAULT NULL,
  `text_trusted_words` mediumint(9) DEFAULT NULL,
  `text_untrusted_words` mediumint(9) DEFAULT NULL,
  `text_unreviewed_words` mediumint(9) DEFAULT NULL,
  `video_total` mediumint(9) DEFAULT NULL,
  `video_trusted` mediumint(9) DEFAULT NULL,
  `video_untrusted` mediumint(9) DEFAULT NULL,
  `video_unreviewed` mediumint(9) DEFAULT NULL,
  `video_total_words` mediumint(9) DEFAULT NULL,
  `video_trusted_words` mediumint(9) DEFAULT NULL,
  `video_untrusted_words` mediumint(9) DEFAULT NULL,
  `video_unreviewed_words` mediumint(9) DEFAULT NULL,
  `sound_total` mediumint(9) DEFAULT NULL,
  `sound_trusted` mediumint(9) DEFAULT NULL,
  `sound_untrusted` mediumint(9) DEFAULT NULL,
  `sound_unreviewed` mediumint(9) DEFAULT NULL,
  `sound_total_words` mediumint(9) DEFAULT NULL,
  `sound_trusted_words` mediumint(9) DEFAULT NULL,
  `sound_untrusted_words` mediumint(9) DEFAULT NULL,
  `sound_unreviewed_words` mediumint(9) DEFAULT NULL,
  `flash_total` mediumint(9) DEFAULT NULL,
  `flash_trusted` mediumint(9) DEFAULT NULL,
  `flash_untrusted` mediumint(9) DEFAULT NULL,
  `flash_unreviewed` mediumint(9) DEFAULT NULL,
  `flash_total_words` mediumint(9) DEFAULT NULL,
  `flash_trusted_words` mediumint(9) DEFAULT NULL,
  `flash_untrusted_words` mediumint(9) DEFAULT NULL,
  `flash_unreviewed_words` mediumint(9) DEFAULT NULL,
  `youtube_total` mediumint(9) DEFAULT NULL,
  `youtube_trusted` mediumint(9) DEFAULT NULL,
  `youtube_untrusted` mediumint(9) DEFAULT NULL,
  `youtube_unreviewed` mediumint(9) DEFAULT NULL,
  `youtube_total_words` mediumint(9) DEFAULT NULL,
  `youtube_trusted_words` mediumint(9) DEFAULT NULL,
  `youtube_untrusted_words` mediumint(9) DEFAULT NULL,
  `youtube_unreviewed_words` mediumint(9) DEFAULT NULL,
  `iucn_total` tinyint(3) DEFAULT NULL,
  `iucn_trusted` tinyint(3) DEFAULT NULL,
  `iucn_untrusted` tinyint(3) DEFAULT NULL,
  `iucn_unreviewed` tinyint(3) DEFAULT NULL,
  `iucn_total_words` tinyint(3) DEFAULT NULL,
  `iucn_trusted_words` tinyint(3) DEFAULT NULL,
  `iucn_untrusted_words` tinyint(3) DEFAULT NULL,
  `iucn_unreviewed_words` tinyint(3) DEFAULT NULL,
  `data_object_references` smallint(6) DEFAULT NULL,
  `info_items` smallint(6) DEFAULT NULL,
  `BHL_publications` smallint(6) DEFAULT NULL,
  `content_partners` smallint(6) DEFAULT NULL,
  `outlinks` smallint(6) DEFAULT NULL,
  `has_GBIF_map` tinyint(1) DEFAULT NULL,
  `has_biomedical_terms` tinyint(1) DEFAULT NULL,
  `user_submitted_text` smallint(6) DEFAULT NULL,
  `submitted_text_providers` smallint(6) DEFAULT NULL,
  `common_names` smallint(6) DEFAULT NULL,
  `common_name_providers` smallint(6) DEFAULT NULL,
  `synonyms` smallint(6) DEFAULT NULL,
  `synonym_providers` smallint(6) DEFAULT NULL,
  `page_views` mediumint(9) DEFAULT NULL,
  `unique_page_views` mediumint(9) DEFAULT NULL,
  `richness_score` float DEFAULT NULL,
  `map_total` mediumint(9) DEFAULT NULL,
  `map_trusted` mediumint(9) DEFAULT NULL,
  `map_untrusted` mediumint(9) DEFAULT NULL,
  `map_unreviewed` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_metrics`
--

LOCK TABLES `taxon_concept_metrics` WRITE;
/*!40000 ALTER TABLE `taxon_concept_metrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_concept_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_names`
--

DROP TABLE IF EXISTS `taxon_concept_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_names` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `name_id` int(10) unsigned NOT NULL,
  `source_hierarchy_entry_id` int(10) unsigned NOT NULL COMMENT 'recommended; if the name came from a certain hierarchy entry or its associated synonyms, the id of the entry will be listed here. This can be used to track down the source or attribution for a given name',
  `language_id` int(10) unsigned NOT NULL,
  `vern` tinyint(3) unsigned NOT NULL COMMENT 'boolean; if this is a common name, set this field to 1',
  `preferred` tinyint(3) unsigned NOT NULL,
  `synonym_id` int(11) NOT NULL DEFAULT '0',
  `vetted_id` int(11) DEFAULT '0',
  `last_change` datetime DEFAULT NULL,
  PRIMARY KEY (`taxon_concept_id`,`name_id`,`source_hierarchy_entry_id`,`language_id`,`synonym_id`),
  KEY `vern` (`vern`),
  KEY `name_id` (`name_id`),
  KEY `source_hierarchy_entry_id` (`source_hierarchy_entry_id`),
  KEY `index_taxon_concept_names_on_synonym_id` (`synonym_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_names`
--

LOCK TABLES `taxon_concept_names` WRITE;
/*!40000 ALTER TABLE `taxon_concept_names` DISABLE KEYS */;
INSERT INTO `taxon_concept_names` VALUES (7,2,2,5,0,1,23,2,NULL),(7,3,2,1,1,1,24,2,NULL),(7,36,25,5,0,1,0,1,NULL),(7,37,25,1,1,1,0,1,NULL),(8,4,3,5,0,1,25,2,NULL),(8,5,3,1,1,1,26,2,NULL),(9,6,4,5,0,1,27,2,NULL),(9,7,4,1,1,1,28,2,NULL),(10,8,5,5,0,1,29,2,NULL),(10,9,5,1,1,1,30,2,NULL),(11,10,6,5,0,1,31,2,NULL),(11,11,6,1,1,1,32,2,NULL),(12,12,7,5,0,1,33,2,NULL),(12,13,7,1,1,1,34,2,NULL),(13,14,8,5,0,1,35,2,NULL),(13,15,8,1,1,1,36,2,NULL),(13,16,8,1,1,0,37,2,NULL),(13,17,8,1,1,0,38,2,NULL),(13,18,8,1,1,0,39,2,NULL),(13,19,8,1,1,0,40,2,NULL),(13,20,8,1,1,0,41,2,NULL),(14,11,9,1,1,1,43,2,NULL),(14,21,9,5,0,1,42,2,NULL),(15,22,10,5,0,1,44,2,NULL),(16,23,11,5,0,1,45,2,NULL),(16,24,11,1,1,1,46,2,NULL),(17,25,12,5,0,1,48,2,NULL),(17,26,12,1,1,1,47,2,NULL),(18,27,13,5,0,1,49,2,NULL),(20,30,17,5,0,1,53,2,NULL),(20,31,17,1,1,1,50,2,NULL),(20,32,17,1,1,0,51,2,NULL),(20,33,17,1,1,0,52,2,NULL),(21,34,24,5,0,1,55,2,NULL),(21,35,24,1,1,1,54,2,NULL),(22,38,26,5,0,1,57,2,NULL),(22,39,26,1,1,1,56,2,NULL),(23,40,27,5,0,1,59,2,NULL),(23,41,27,1,1,1,58,2,NULL),(24,42,28,5,0,1,61,2,NULL),(24,43,28,1,1,1,60,2,NULL),(25,44,29,5,0,1,63,2,NULL),(25,45,29,1,1,1,62,2,NULL),(26,46,30,5,0,1,65,2,NULL),(26,47,30,1,1,1,64,2,NULL),(27,48,31,5,0,1,67,2,NULL),(27,49,31,1,1,1,66,2,NULL),(28,50,32,5,0,1,69,2,NULL),(28,51,32,1,1,1,68,2,NULL),(29,52,33,5,0,1,71,2,NULL),(29,53,33,1,1,1,70,2,NULL),(30,54,34,5,0,1,72,2,NULL),(30,56,34,1,1,1,73,2,NULL),(30,57,34,1,1,0,74,2,NULL),(30,58,34,1,1,0,75,2,NULL),(30,60,34,7,1,1,76,2,NULL),(30,61,34,7,1,0,77,2,NULL),(30,63,34,2,1,1,78,2,NULL),(30,64,34,2,1,0,79,2,NULL),(30,65,34,5,0,0,80,2,NULL),(31,66,35,5,0,1,82,2,NULL),(31,67,35,1,1,1,81,2,NULL),(32,68,36,5,0,1,84,2,NULL),(32,69,36,1,1,1,83,2,NULL),(33,70,37,5,0,1,86,2,NULL),(33,71,37,1,1,1,85,2,NULL),(34,72,38,5,0,1,88,2,NULL),(34,73,38,1,1,1,87,2,NULL);
/*!40000 ALTER TABLE `taxon_concept_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_preferred_entries`
--

DROP TABLE IF EXISTS `taxon_concept_preferred_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_preferred_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taxon_concept_id` (`taxon_concept_id`)
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_preferred_entries`
--

LOCK TABLES `taxon_concept_preferred_entries` WRITE;
/*!40000 ALTER TABLE `taxon_concept_preferred_entries` DISABLE KEYS */;
INSERT INTO `taxon_concept_preferred_entries` VALUES (77,7,2,'2014-06-24 07:37:21'),(78,8,3,'2014-06-24 07:37:21'),(79,9,4,'2014-06-24 07:37:21'),(80,10,5,'2014-06-24 07:37:21'),(81,11,6,'2014-06-24 07:37:21'),(74,12,7,'2014-06-24 07:37:16'),(7,13,8,'2014-04-09 11:34:06'),(8,14,9,'2014-04-09 11:34:08'),(9,15,10,'2014-04-09 11:34:09'),(75,16,11,'2014-06-24 07:37:16'),(76,17,12,'2014-06-24 07:37:16'),(63,18,13,'2014-06-24 07:37:03'),(65,20,17,'2014-06-24 07:37:03'),(64,21,24,'2014-06-24 07:37:03'),(67,22,26,'2014-06-24 07:37:03'),(70,23,27,'2014-06-24 07:37:04'),(66,24,28,'2014-06-24 07:37:03'),(73,25,29,'2014-06-24 07:37:04'),(71,26,30,'2014-06-24 07:37:04'),(72,27,31,'2014-06-24 07:37:04'),(69,28,32,'2014-06-24 07:37:04'),(62,29,33,'2014-06-24 07:37:03'),(68,30,34,'2014-06-24 07:37:04'),(82,31,35,'2014-06-24 07:38:06'),(83,32,36,'2014-06-24 07:39:46'),(84,33,37,'2014-06-24 07:42:16'),(27,34,38,'2014-04-09 11:35:19');
/*!40000 ALTER TABLE `taxon_concept_preferred_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concept_stats`
--

DROP TABLE IF EXISTS `taxon_concept_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concept_stats` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `text_trusted` mediumint(8) unsigned NOT NULL,
  `text_untrusted` mediumint(8) unsigned NOT NULL,
  `image_trusted` mediumint(8) unsigned NOT NULL,
  `image_untrusted` mediumint(8) unsigned NOT NULL,
  `bhl` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concept_stats`
--

LOCK TABLES `taxon_concept_stats` WRITE;
/*!40000 ALTER TABLE `taxon_concept_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_concept_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concepts`
--

DROP TABLE IF EXISTS `taxon_concepts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concepts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `supercedure_id` int(10) unsigned NOT NULL COMMENT 'if concepts are at first thought to be distinct, there will be two concepts with two different ids. When they are confirmed to be the same one will be superceded by the other, and that replacement is kept track of so that older URLs can be redirected to the proper ids',
  `split_from` int(10) unsigned NOT NULL,
  `vetted_id` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'some concepts come from untrusted resources and are left untrusted until the resources become trusted',
  `published` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'some concepts come from resource left unpublished until the resource becomes published',
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `supercedure_id` (`supercedure_id`),
  KEY `published` (`published`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='This table is poorly named. Used to group similar hierarchy entries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concepts`
--

LOCK TABLES `taxon_concepts` WRITE;
/*!40000 ALTER TABLE `taxon_concepts` DISABLE KEYS */;
INSERT INTO `taxon_concepts` VALUES (1,0,0,0,1,NULL,1),(7,0,0,1,1,NULL,1),(8,0,0,1,1,NULL,1),(9,0,0,1,1,NULL,1),(10,0,0,1,1,NULL,1),(11,0,0,1,1,NULL,1),(12,0,0,1,1,NULL,1),(13,0,0,3,1,NULL,1),(14,0,0,2,1,NULL,1),(15,0,0,1,1,NULL,1),(16,0,0,1,1,NULL,1),(17,0,0,1,1,NULL,1),(18,0,0,1,1,NULL,1),(19,0,0,0,1,NULL,1),(20,0,0,1,1,NULL,1),(21,0,0,1,1,NULL,1),(22,0,0,1,1,NULL,1),(23,0,0,1,1,NULL,1),(24,0,0,1,1,NULL,1),(25,0,0,1,1,NULL,1),(26,0,0,1,1,NULL,1),(27,0,0,1,1,NULL,1),(28,0,0,1,1,NULL,1),(29,0,0,1,1,NULL,1),(30,0,0,1,1,NULL,1),(31,0,0,1,1,NULL,1),(32,0,0,1,1,NULL,1),(33,0,0,1,1,NULL,1),(34,0,0,1,1,NULL,1);
/*!40000 ALTER TABLE `taxon_concepts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_concepts_flattened`
--

DROP TABLE IF EXISTS `taxon_concepts_flattened`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_concepts_flattened` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `ancestor_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`,`ancestor_id`),
  KEY `ancestor_id` (`ancestor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_concepts_flattened`
--

LOCK TABLES `taxon_concepts_flattened` WRITE;
/*!40000 ALTER TABLE `taxon_concepts_flattened` DISABLE KEYS */;
INSERT INTO `taxon_concepts_flattened` VALUES (7,21),(8,7),(9,7),(9,8),(10,7),(10,8),(10,9),(11,7),(11,8),(11,9),(11,10),(12,7),(12,8),(12,9),(12,10),(12,11),(13,7),(13,8),(13,9),(13,10),(13,11),(14,7),(14,8),(14,9),(14,10),(14,11),(15,7),(15,8),(15,9),(15,10),(15,11),(16,7),(16,8),(16,9),(16,10),(16,11),(17,7),(17,8),(17,9),(17,10),(17,11),(22,7),(22,21),(23,7),(23,21),(24,7),(24,21),(24,23),(25,7),(25,21),(25,23),(26,7),(26,21),(26,23),(26,25),(27,7),(27,21),(27,23),(27,25),(28,7),(28,21),(28,23),(28,25),(28,27),(29,7),(29,21),(29,23),(29,25),(29,27),(31,30),(32,30),(32,31),(33,30),(33,31),(33,32),(34,30),(34,31),(34,32),(34,33);
/*!40000 ALTER TABLE `taxon_concepts_flattened` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxon_data_exemplars`
--

DROP TABLE IF EXISTS `taxon_data_exemplars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxon_data_exemplars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_concept_id` int(11) DEFAULT NULL,
  `data_point_uri_id` int(11) DEFAULT NULL,
  `exclude` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_taxon_data_exemplars_on_taxon_concept_id` (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxon_data_exemplars`
--

LOCK TABLES `taxon_data_exemplars` WRITE;
/*!40000 ALTER TABLE `taxon_data_exemplars` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxon_data_exemplars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `title_items`
--

DROP TABLE IF EXISTS `title_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `title_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `publication_title_id` int(10) unsigned NOT NULL,
  `bar_code` varchar(50) NOT NULL,
  `marc_item_id` varchar(50) NOT NULL,
  `call_number` varchar(100) NOT NULL,
  `volume_info` varchar(100) NOT NULL,
  `url` varchar(255) CHARACTER SET ascii NOT NULL COMMENT 'url for the description page for this item',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 COMMENT='Used for BHL. Publications can have different volumes, versions, etc.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `title_items`
--

LOCK TABLES `title_items` WRITE;
/*!40000 ALTER TABLE `title_items` DISABLE KEYS */;
INSERT INTO `title_items` VALUES (22,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(23,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(24,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(25,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(26,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(27,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(28,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(29,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(30,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(31,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(32,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(33,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(34,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(35,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(36,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(37,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(38,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(39,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(40,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(41,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(42,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(43,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(44,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(45,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(46,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(47,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(48,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(49,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(50,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(51,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(52,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(53,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(54,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(55,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(56,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(57,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(58,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(59,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(60,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(61,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(62,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(63,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(64,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(65,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(66,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(67,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(68,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(69,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(70,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(71,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(72,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(73,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(74,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(75,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(76,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(77,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(78,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(79,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(80,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(81,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(82,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(83,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(84,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(85,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(86,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(87,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(88,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(89,3,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting'),(90,4,'73577357735742','i11604463','QK1 .H38','1864 v. 3','http://www.biodiversitylibrary.org/item/ThisWontWork.OnlyTesting');
/*!40000 ALTER TABLE `title_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_concept_images`
--

DROP TABLE IF EXISTS `top_concept_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_concept_images` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `view_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_concept_images`
--

LOCK TABLES `top_concept_images` WRITE;
/*!40000 ALTER TABLE `top_concept_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_concept_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_images`
--

DROP TABLE IF EXISTS `top_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_images` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL COMMENT 'data object id of the image',
  `view_order` smallint(5) unsigned NOT NULL COMMENT 'order in which to show the images, lower values shown first',
  PRIMARY KEY (`hierarchy_entry_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='caches the top 300 or so best images for a particular hierarchy entry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_images`
--

LOCK TABLES `top_images` WRITE;
/*!40000 ALTER TABLE `top_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_species_images`
--

DROP TABLE IF EXISTS `top_species_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_species_images` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL COMMENT 'data object id of the image',
  `view_order` smallint(5) unsigned NOT NULL COMMENT 'order in which to show the images, lower values shown first',
  PRIMARY KEY (`hierarchy_entry_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='caches the top 300 or so best images for a particular hierarchy entry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_species_images`
--

LOCK TABLES `top_species_images` WRITE;
/*!40000 ALTER TABLE `top_species_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_species_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_unpublished_concept_images`
--

DROP TABLE IF EXISTS `top_unpublished_concept_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_unpublished_concept_images` (
  `taxon_concept_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `view_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`taxon_concept_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_unpublished_concept_images`
--

LOCK TABLES `top_unpublished_concept_images` WRITE;
/*!40000 ALTER TABLE `top_unpublished_concept_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_unpublished_concept_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_unpublished_images`
--

DROP TABLE IF EXISTS `top_unpublished_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_unpublished_images` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `view_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='cache the top 300 or so images which are unpublished - for curators and content partners';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_unpublished_images`
--

LOCK TABLES `top_unpublished_images` WRITE;
/*!40000 ALTER TABLE `top_unpublished_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_unpublished_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_unpublished_species_images`
--

DROP TABLE IF EXISTS `top_unpublished_species_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_unpublished_species_images` (
  `hierarchy_entry_id` int(10) unsigned NOT NULL,
  `data_object_id` int(10) unsigned NOT NULL,
  `view_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`hierarchy_entry_id`,`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='cache the top 300 or so images which are unpublished - for curators and content partners';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_unpublished_species_images`
--

LOCK TABLES `top_unpublished_species_images` WRITE;
/*!40000 ALTER TABLE `top_unpublished_species_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_unpublished_species_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_agent_roles`
--

DROP TABLE IF EXISTS `translated_agent_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_agent_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_role_id` tinyint(3) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent_role_id` (`agent_role_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_agent_roles`
--

LOCK TABLES `translated_agent_roles` WRITE;
/*!40000 ALTER TABLE `translated_agent_roles` DISABLE KEYS */;
INSERT INTO `translated_agent_roles` VALUES (1,1,1,'Author',NULL),(2,2,1,'Source',NULL),(3,3,1,'Source Database',NULL),(4,4,1,'Contributor',NULL),(5,5,1,'Photographer',NULL),(6,6,1,'Editor',NULL),(7,7,1,'provider',NULL),(8,8,1,'Animator',NULL),(9,9,1,'Compiler',NULL),(10,10,1,'Composer',NULL),(11,11,1,'Creator',NULL),(12,12,1,'Director',NULL),(13,13,1,'Illustrator',NULL),(14,14,1,'Project',NULL),(15,15,1,'Publisher',NULL),(16,16,1,'Recorder',NULL),(17,17,1,'Contact Person',NULL),(18,18,1,'writer',NULL);
/*!40000 ALTER TABLE `translated_agent_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_audiences`
--

DROP TABLE IF EXISTS `translated_audiences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_audiences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `audience_id` tinyint(3) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `audience_id` (`audience_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_audiences`
--

LOCK TABLES `translated_audiences` WRITE;
/*!40000 ALTER TABLE `translated_audiences` DISABLE KEYS */;
INSERT INTO `translated_audiences` VALUES (1,1,1,'Children',NULL),(2,2,1,'Expert users',NULL),(3,3,1,'General public',NULL);
/*!40000 ALTER TABLE `translated_audiences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_collection_types`
--

DROP TABLE IF EXISTS `translated_collection_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_collection_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_type_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collection_type_id` (`collection_type_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_collection_types`
--

LOCK TABLES `translated_collection_types` WRITE;
/*!40000 ALTER TABLE `translated_collection_types` DISABLE KEYS */;
INSERT INTO `translated_collection_types` VALUES (1,1,1,'Links',NULL),(2,2,1,'Literature',NULL),(3,3,1,'Images',NULL),(4,4,1,'Specimen',NULL),(5,5,1,'Natural',NULL),(6,6,1,'Species Pages',NULL),(7,7,1,'Molecular',NULL),(8,8,1,'Novice',NULL),(9,9,1,'Expert',NULL),(10,10,1,'Marine',NULL),(11,11,1,'Bugs',NULL);
/*!40000 ALTER TABLE `translated_collection_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_contact_roles`
--

DROP TABLE IF EXISTS `translated_contact_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_contact_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_role_id` tinyint(3) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(255) NOT NULL,
  `phonetic_label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent_contact_role_id` (`contact_role_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_contact_roles`
--

LOCK TABLES `translated_contact_roles` WRITE;
/*!40000 ALTER TABLE `translated_contact_roles` DISABLE KEYS */;
INSERT INTO `translated_contact_roles` VALUES (1,1,1,'Primary Contact',NULL),(2,2,1,'Administrative Contact',NULL),(3,3,1,'Technical Contact',NULL);
/*!40000 ALTER TABLE `translated_contact_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_contact_subjects`
--

DROP TABLE IF EXISTS `translated_contact_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_contact_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_subject_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `phonetic_action_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contact_subject_id` (`contact_subject_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_contact_subjects`
--

LOCK TABLES `translated_contact_subjects` WRITE;
/*!40000 ALTER TABLE `translated_contact_subjects` DISABLE KEYS */;
INSERT INTO `translated_contact_subjects` VALUES (1,1,1,'Membership and registration',NULL),(2,2,1,'Terms of use and licensing',NULL),(3,3,1,'Learning and education',NULL),(4,4,1,'Become a content partner',NULL),(5,5,1,'Content partner support',NULL),(6,6,1,'Curator support',NULL),(7,7,1,'Make a correction (spelling and grammar, images, information)',NULL),(8,8,1,'Contribute images, videos or sounds',NULL),(9,9,1,'Media requests (interviews, press inquiries, logo requests)',NULL),(10,10,1,'Make a financial donation',NULL),(11,11,1,'Technical questions (problems with search, website functionality)',NULL),(12,12,1,'General feedback',NULL);
/*!40000 ALTER TABLE `translated_contact_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_content_page_archives`
--

DROP TABLE IF EXISTS `translated_content_page_archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_content_page_archives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `translated_content_page_id` int(11) DEFAULT NULL,
  `content_page_id` int(11) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `left_content` text,
  `main_content` text,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `original_creation_date` date DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_content_page_archives`
--

LOCK TABLES `translated_content_page_archives` WRITE;
/*!40000 ALTER TABLE `translated_content_page_archives` DISABLE KEYS */;
INSERT INTO `translated_content_page_archives` VALUES (1,21,21,1,'test_translation','','<p>test_translation</p>\r\n','','','2014-04-30','2014-04-30','2014-04-30'),(2,14,14,1,'test page','','<p>hello world</p>\r\n','','','2014-04-27','2014-04-30','2014-04-30'),(3,20,20,1,'testlanguage','','<p>Hello</p>\r\n','','','2014-04-27','2014-04-30','2014-04-30'),(4,23,23,1,'test_create_delete','','<p>test_create_delete</p>\r\n','','','2014-04-30','2014-04-30','2014-04-30'),(5,18,18,1,'test6','','<p>hello6</p>\r\n','','','2014-04-27','2014-04-30','2014-04-30'),(6,19,19,1,'testadmin1','','<p>Hello World</p>\r\n','','','2014-04-27','2014-04-30','2014-04-30');
/*!40000 ALTER TABLE `translated_content_page_archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_content_pages`
--

DROP TABLE IF EXISTS `translated_content_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_content_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_page_id` int(11) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `left_content` text,
  `main_content` text,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active_translation` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `content_page_id` (`content_page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_content_pages`
--

LOCK TABLES `translated_content_pages` WRITE;
/*!40000 ALTER TABLE `translated_content_pages` DISABLE KEYS */;
INSERT INTO `translated_content_pages` VALUES (1,1,1,'Home','<h3>This is Left Content in a Home</h3>','<h1>Main Content for Home ROCKS!</h1>','keywords for Home','description for Home','2014-04-09 13:33:10','2014-04-09 13:33:10',1),(2,2,1,'Who We Are','<h3>This is Left Content in a Who We Are</h3>','<h1>Main Content for Who We Are ROCKS!</h1>','keywords for Who We Are','description for Who We Are','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(3,3,1,'Working Groups','<h3>This is Left Content in a Working Groups</h3>','<h1>Main Content for Working Groups ROCKS!</h1>','keywords for Working Groups','description for Working Groups','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(4,4,1,'Working Group A','<h3>This is Left Content in a Working Group A</h3>','<h1>Main Content for Working Group A ROCKS!</h1>','keywords for Working Group A','description for Working Group A','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(5,5,1,'Working Group B','<h3>This is Left Content in a Working Group B</h3>','<h1>Main Content for Working Group B ROCKS!</h1>','keywords for Working Group B','description for Working Group B','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(6,6,1,'Working Group C','<h3>This is Left Content in a Working Group C</h3>','<h1>Main Content for Working Group C ROCKS!</h1>','keywords for Working Group C','description for Working Group C','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(7,7,1,'Working Group D','<h3>This is Left Content in a Working Group D</h3>','<h1>Main Content for Working Group D ROCKS!</h1>','keywords for Working Group D','description for Working Group D','2014-04-09 13:33:11','2014-04-09 13:33:11',1),(8,8,1,'Working Group E','<h3>This is Left Content in a Working Group E</h3>','<h1>Main Content for Working Group E ROCKS!</h1>','keywords for Working Group E','description for Working Group E','2014-04-09 13:33:12','2014-04-09 13:33:12',1),(9,9,1,'Contact Us','<h3>This is Left Content in a Contact Us</h3>','<h1>Main Content for Contact Us ROCKS!</h1>','keywords for Contact Us','description for Contact Us','2014-04-09 13:33:12','2014-04-09 13:33:12',1),(10,10,1,'Screencasts','<h3>This is Left Content in a Screencasts</h3>','<h1>Main Content for Screencasts ROCKS!</h1>','keywords for Screencasts','description for Screencasts','2014-04-09 13:33:13','2014-04-09 13:33:13',1),(11,11,1,'Press Releases','<h3>This is Left Content in a Press Releases</h3>','<h1>Main Content for Press Releases ROCKS!</h1>','keywords for Press Releases','description for Press Releases','2014-04-09 13:33:13','2014-04-09 13:33:13',1),(12,12,1,'Terms of Use','<h3>This is Left Content in a Terms of Use</h3>','<h1>Main Content for Terms of Use ROCKS!</h1>','keywords for Terms of Use','description for Terms of Use','2014-04-09 13:33:13','2014-04-09 13:33:13',1),(13,13,1,'Curator central','','<h1>Main Content for Curator central ROCKS!</h1>','keywords for Curator central','description for Curator central','2014-04-09 13:34:32','2014-04-09 13:34:32',1),(15,15,1,'test2','','<p>hello2</p>\r\n','','','2014-04-27 12:18:39','2014-04-27 12:18:39',1),(16,16,1,'test3','','<p>hello3</p>\r\n','','','2014-04-27 12:23:01','2014-04-27 12:23:01',1),(17,17,1,'test4','','<p>hello4</p>\r\n','','','2014-04-27 12:24:05','2014-04-27 12:24:05',1),(22,22,1,'test_delete','','<p>test_delete</p>\r\n','','','2014-04-30 12:16:58','2014-04-30 12:16:58',1),(24,24,1,'test_created_at','','<p>test_created_at</p>\r\n','','','2014-07-01 11:17:45','2014-07-01 11:17:45',1),(25,25,1,'eol_development','','<p>eol_development</p>\r\n','','','2014-07-01 11:29:07','2014-07-01 11:29:07',1),(26,26,1,'test_created_at','','<p>test_created_at</p>\r\n','','','2014-07-01 11:38:31','2014-07-01 11:38:31',1),(27,27,1,'test_created_at','','<p>test_created_at</p>\r\n','','','2014-07-01 11:40:25','2014-07-01 11:40:25',1);
/*!40000 ALTER TABLE `translated_content_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_content_partner_statuses`
--

DROP TABLE IF EXISTS `translated_content_partner_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_content_partner_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_partner_status_id` tinyint(3) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent_status_id` (`content_partner_status_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_content_partner_statuses`
--

LOCK TABLES `translated_content_partner_statuses` WRITE;
/*!40000 ALTER TABLE `translated_content_partner_statuses` DISABLE KEYS */;
INSERT INTO `translated_content_partner_statuses` VALUES (1,1,1,'Active',NULL),(2,2,1,'Inactive',NULL),(3,3,1,'Archived',NULL),(4,4,1,'Pending',NULL);
/*!40000 ALTER TABLE `translated_content_partner_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_content_tables`
--

DROP TABLE IF EXISTS `translated_content_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_content_tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_table_id` int(11) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `phonetic_label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_content_tables`
--

LOCK TABLES `translated_content_tables` WRITE;
/*!40000 ALTER TABLE `translated_content_tables` DISABLE KEYS */;
INSERT INTO `translated_content_tables` VALUES (1,1,1,'Details',''),(2,2,1,'Details','');
/*!40000 ALTER TABLE `translated_content_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_data_types`
--

DROP TABLE IF EXISTS `translated_data_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_data_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_type_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_type_id` (`data_type_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_data_types`
--

LOCK TABLES `translated_data_types` WRITE;
/*!40000 ALTER TABLE `translated_data_types` DISABLE KEYS */;
INSERT INTO `translated_data_types` VALUES (1,1,1,'Text',NULL),(2,2,1,'Image',NULL),(3,3,1,'Sound',NULL),(4,4,1,'Video',NULL),(5,5,1,'GBIF Image',NULL),(6,6,1,'YouTube',NULL),(7,7,1,'Flash',NULL),(8,8,1,'IUCN',NULL),(9,9,1,'Map',NULL),(10,10,1,'Link',NULL);
/*!40000 ALTER TABLE `translated_data_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_info_items`
--

DROP TABLE IF EXISTS `translated_info_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_info_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `info_item_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `info_item_id` (`info_item_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_info_items`
--

LOCK TABLES `translated_info_items` WRITE;
/*!40000 ALTER TABLE `translated_info_items` DISABLE KEYS */;
INSERT INTO `translated_info_items` VALUES (1,1,1,'TaxonBiology',NULL),(2,2,1,'GeneralDescription',NULL),(3,3,1,'Distribution',NULL),(4,4,1,'Habitat',NULL),(5,5,1,'Morphology',NULL),(6,6,1,'Conservation',NULL),(7,7,1,'Uses',NULL),(8,8,1,'Education',NULL),(9,9,1,'Education Resources',NULL),(10,10,1,'IdentificationResources',NULL),(11,11,1,'Wikipedia',NULL),(12,12,1,'Diagnostic Description',NULL),(13,13,1,'Taxonomy',NULL),(14,14,1,'Associations',NULL),(15,15,1,'Behaviour',NULL),(16,16,1,'ConservationStatus',NULL),(17,17,1,'Cyclicity',NULL),(18,18,1,'Cytology',NULL),(19,19,1,'DiagnosticDescription',NULL),(20,20,1,'Diseases',NULL),(21,21,1,'Dispersal',NULL),(22,22,1,'Evolution',NULL),(23,23,1,'Genetics',NULL),(24,24,1,'Growth',NULL),(25,25,1,'Legislation',NULL),(26,26,1,'LifeCycle',NULL),(27,27,1,'LifeExpectancy',NULL),(28,28,1,'LookAlikes',NULL),(29,29,1,'Management',NULL),(30,30,1,'Migration',NULL),(31,31,1,'MolecularBiology',NULL),(32,32,1,'Physiology',NULL),(33,33,1,'PopulationBiology',NULL),(34,34,1,'Procedures',NULL),(35,35,1,'Reproduction',NULL),(36,36,1,'RiskStatement',NULL),(37,37,1,'Size',NULL),(38,38,1,'Threats',NULL),(39,39,1,'Trends',NULL),(40,40,1,'TrophicStrategy',NULL);
/*!40000 ALTER TABLE `translated_info_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_known_uris`
--

DROP TABLE IF EXISTS `translated_known_uris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_known_uris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `known_uri_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `definition` text,
  `comment` text,
  `attribution` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_language` (`known_uri_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_known_uris`
--

LOCK TABLES `translated_known_uris` WRITE;
/*!40000 ALTER TABLE `translated_known_uris` DISABLE KEYS */;
INSERT INTO `translated_known_uris` VALUES (1,1,1,'Unit of Measure',NULL,NULL,NULL),(2,2,1,'milligrams',NULL,NULL,NULL),(3,3,1,'grams',NULL,NULL,NULL),(4,4,1,'kilograms',NULL,NULL,NULL),(5,5,1,'millimeters',NULL,NULL,NULL),(6,6,1,'centimeters',NULL,NULL,NULL),(7,7,1,'meters',NULL,NULL,NULL),(8,8,1,'kelvin',NULL,NULL,NULL),(9,9,1,'degrees Celsius',NULL,NULL,NULL),(10,10,1,'days',NULL,NULL,NULL),(11,11,1,'years',NULL,NULL,NULL),(12,12,1,'0.1°C',NULL,NULL,NULL),(13,13,1,'Log10 grams',NULL,NULL,NULL),(14,14,1,'Sex',NULL,NULL,NULL),(15,15,1,'male',NULL,NULL,NULL),(16,16,1,'female',NULL,NULL,NULL),(17,17,1,'Source',NULL,NULL,NULL),(18,18,1,'License',NULL,NULL,NULL),(19,19,1,'Reference',NULL,NULL,NULL);
/*!40000 ALTER TABLE `translated_known_uris` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_languages`
--

DROP TABLE IF EXISTS `translated_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `original_language_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `original_language_id` (`original_language_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_languages`
--

LOCK TABLES `translated_languages` WRITE;
/*!40000 ALTER TABLE `translated_languages` DISABLE KEYS */;
INSERT INTO `translated_languages` VALUES (1,1,1,'English',NULL),(2,2,1,'French',NULL),(3,3,1,'Spanish',NULL),(4,4,1,'Arabic',NULL),(5,5,1,'Scientific Name',NULL),(6,6,1,'Unknown',NULL),(7,7,1,'German',NULL);
/*!40000 ALTER TABLE `translated_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_licenses`
--

DROP TABLE IF EXISTS `translated_licenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `description` varchar(400) NOT NULL,
  `phonetic_description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_id` (`license_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_licenses`
--

LOCK TABLES `translated_licenses` WRITE;
/*!40000 ALTER TABLE `translated_licenses` DISABLE KEYS */;
INSERT INTO `translated_licenses` VALUES (1,1,1,'No rights reserved',NULL),(2,2,1,'&#169; All rights reserved',NULL),(3,3,1,'Some rights reserved',NULL),(4,4,1,'Some rights reserved',NULL),(5,5,1,'Some rights reserved',NULL),(6,6,1,'Some rights reserved',NULL),(7,7,1,'Public Domain',NULL),(8,8,1,'No known copyright restrictions',NULL),(9,9,1,'License not applicable',NULL);
/*!40000 ALTER TABLE `translated_licenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_link_types`
--

DROP TABLE IF EXISTS `translated_link_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_link_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link_type_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `label` varchar(255) NOT NULL,
  `phonetic_label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `link_type_id` (`link_type_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_link_types`
--

LOCK TABLES `translated_link_types` WRITE;
/*!40000 ALTER TABLE `translated_link_types` DISABLE KEYS */;
INSERT INTO `translated_link_types` VALUES (1,1,1,'Blog',NULL),(2,2,1,'News',NULL),(3,3,1,'Organization',NULL),(4,4,1,'Paper',NULL),(5,5,1,'Multimedia',NULL),(6,6,1,'Citizen Science',NULL);
/*!40000 ALTER TABLE `translated_link_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_mime_types`
--

DROP TABLE IF EXISTS `translated_mime_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_mime_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mime_type_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mime_type_id` (`mime_type_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_mime_types`
--

LOCK TABLES `translated_mime_types` WRITE;
/*!40000 ALTER TABLE `translated_mime_types` DISABLE KEYS */;
INSERT INTO `translated_mime_types` VALUES (1,1,1,'image/jpeg',NULL),(2,2,1,'audio/mpeg',NULL),(3,3,1,'text/html',NULL),(4,4,1,'text/plain',NULL),(5,5,1,'video/x-flv',NULL),(6,6,1,'video/quicktime',NULL),(7,7,1,'audio/x-wav',NULL),(8,8,1,'video/mp4',NULL),(9,9,1,'video/mpeg',NULL),(10,10,1,'audio/x-ms-wma',NULL),(11,11,1,'audio/x-pn-realaudio',NULL),(12,12,1,'audio/x-realaudio',NULL),(13,13,1,'image/bmp',NULL),(14,14,1,'image/gif',NULL),(15,15,1,'image/png',NULL),(16,16,1,'image/svg+xml',NULL),(17,17,1,'image/tiff',NULL),(18,18,1,'text/richtext',NULL),(19,19,1,'text/rtf',NULL),(20,20,1,'text/xml',NULL),(21,21,1,'video/x-ms-wmv',NULL);
/*!40000 ALTER TABLE `translated_mime_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_news_items`
--

DROP TABLE IF EXISTS `translated_news_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_news_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_item_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `body` text NOT NULL,
  `title` varchar(255) DEFAULT '',
  `active_translation` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `news_item_id` (`news_item_id`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_news_items`
--

LOCK TABLES `translated_news_items` WRITE;
/*!40000 ALTER TABLE `translated_news_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `translated_news_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_permissions`
--

DROP TABLE IF EXISTS `translated_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `language_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_translated_permissions_on_permission_id_and_language_id` (`permission_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_permissions`
--

LOCK TABLES `translated_permissions` WRITE;
/*!40000 ALTER TABLE `translated_permissions` DISABLE KEYS */;
INSERT INTO `translated_permissions` VALUES (1,'edit permissions',1,1),(2,'beta test',1,2),(3,'see data',1,3),(4,'edit cms',1,4);
/*!40000 ALTER TABLE `translated_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_ranks`
--

DROP TABLE IF EXISTS `translated_ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rank_id` (`rank_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_ranks`
--

LOCK TABLES `translated_ranks` WRITE;
/*!40000 ALTER TABLE `translated_ranks` DISABLE KEYS */;
INSERT INTO `translated_ranks` VALUES (1,1,1,'kingdom',NULL),(2,2,1,'phylum',NULL),(3,3,1,'order',NULL),(4,4,1,'class',NULL),(5,5,1,'family',NULL),(6,6,1,'genus',NULL),(7,7,1,'species',NULL),(8,8,1,'subspecies',NULL),(9,9,1,'infraspecies',NULL),(10,10,1,'variety',NULL),(11,11,1,'form',NULL),(12,20,1,'superkingdom',NULL);
/*!40000 ALTER TABLE `translated_ranks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_resource_statuses`
--

DROP TABLE IF EXISTS `translated_resource_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_resource_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_status_id` int(11) NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_status_id` (`resource_status_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_resource_statuses`
--

LOCK TABLES `translated_resource_statuses` WRITE;
/*!40000 ALTER TABLE `translated_resource_statuses` DISABLE KEYS */;
INSERT INTO `translated_resource_statuses` VALUES (1,1,1,'Uploading',NULL),(2,2,1,'Uploaded',NULL),(3,3,1,'Upload Failed',NULL),(4,4,1,'Moved to Content Server',NULL),(5,5,1,'Validated',NULL),(6,6,1,'Validation Failed',NULL),(7,7,1,'Being Processed',NULL),(8,8,1,'Processed',NULL),(9,9,1,'Processing Failed',NULL),(10,10,1,'Force Harvest',NULL),(11,11,1,'Published',NULL);
/*!40000 ALTER TABLE `translated_resource_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_service_types`
--

DROP TABLE IF EXISTS `translated_service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_type_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_type_id` (`service_type_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_service_types`
--

LOCK TABLES `translated_service_types` WRITE;
/*!40000 ALTER TABLE `translated_service_types` DISABLE KEYS */;
INSERT INTO `translated_service_types` VALUES (1,1,1,'EOL Transfer Schema',NULL);
/*!40000 ALTER TABLE `translated_service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_sort_styles`
--

DROP TABLE IF EXISTS `translated_sort_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_sort_styles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `language_id` int(11) NOT NULL,
  `sort_style_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_sort_styles`
--

LOCK TABLES `translated_sort_styles` WRITE;
/*!40000 ALTER TABLE `translated_sort_styles` DISABLE KEYS */;
INSERT INTO `translated_sort_styles` VALUES (1,'Recently Added',1,1),(2,'Oldest',1,2),(3,'Alphabetical',1,3),(4,'Reverse Alphabetical',1,4),(5,'Richness',1,5),(6,'Rating',1,6),(7,'Sort Field',1,7),(8,'Reverse Sort Field',1,8);
/*!40000 ALTER TABLE `translated_sort_styles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_statuses`
--

DROP TABLE IF EXISTS `translated_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `status_id` (`status_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_statuses`
--

LOCK TABLES `translated_statuses` WRITE;
/*!40000 ALTER TABLE `translated_statuses` DISABLE KEYS */;
INSERT INTO `translated_statuses` VALUES (1,1,1,'Inserted',NULL),(2,2,1,'Unchanged',NULL),(3,3,1,'Updated',NULL);
/*!40000 ALTER TABLE `translated_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_synonym_relations`
--

DROP TABLE IF EXISTS `translated_synonym_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_synonym_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `synonym_relation_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `synonym_relation_id` (`synonym_relation_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_synonym_relations`
--

LOCK TABLES `translated_synonym_relations` WRITE;
/*!40000 ALTER TABLE `translated_synonym_relations` DISABLE KEYS */;
INSERT INTO `translated_synonym_relations` VALUES (1,1,1,'synonym',NULL),(2,2,1,'common name',NULL),(3,3,1,'genbank common name',NULL),(4,4,1,'acronym',NULL),(5,5,1,'anamorph',NULL),(6,6,1,'blast name',NULL),(7,7,1,'equivalent name',NULL),(8,8,1,'genbank acronym',NULL),(9,9,1,'genbank anamorph',NULL),(10,10,1,'genbank synonym',NULL),(11,11,1,'in-part',NULL),(12,12,1,'includes',NULL),(13,13,1,'misnomer',NULL),(14,14,1,'misspelling',NULL),(15,15,1,'teleomorph',NULL),(16,16,1,'ambiguous synonym',NULL),(17,17,1,'misapplied name',NULL),(18,18,1,'provisionally accepted name',NULL),(19,19,1,'accepted name',NULL),(20,20,1,'database artifact',NULL),(21,21,1,'other, see comments',NULL),(22,22,1,'orthographic variant (misspelling)',NULL),(23,23,1,'misapplied',NULL),(24,24,1,'rejected name',NULL),(25,25,1,'homonym (illegitimate)',NULL),(26,26,1,'pro parte',NULL),(27,27,1,'superfluous renaming (illegitimate)',NULL),(28,28,1,'nomen oblitum',NULL),(29,29,1,'junior synonym',NULL),(30,30,1,'unavailable, database artifact',NULL),(31,31,1,'unnecessary replacement',NULL),(32,32,1,'subsequent name/combination',NULL),(33,33,1,'unavailable, literature misspelling',NULL),(34,34,1,'original name/combination',NULL),(35,35,1,'unavailable, incorrect orig. spelling',NULL),(36,36,1,'junior homonym',NULL),(37,37,1,'homonym & junior synonym',NULL),(38,38,1,'unavailable, suppressed by ruling',NULL),(39,39,1,'unjustified emendation',NULL),(40,40,1,'unavailable, other',NULL),(41,41,1,'unavailable, nomen nudum',NULL),(42,42,1,'nomen dubium',NULL),(43,43,1,'invalidly published, other',NULL),(44,44,1,'invalidly published, nomen nudum',NULL),(45,45,1,'basionym',NULL),(46,46,1,'heterotypic synonym',NULL),(47,47,1,'homotypic synonym',NULL),(48,48,1,'unavailable name',NULL),(49,49,1,'valid name',NULL);
/*!40000 ALTER TABLE `translated_synonym_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_table_of_contents`
--

DROP TABLE IF EXISTS `translated_table_of_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_table_of_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_of_contents_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_of_contents_id` (`table_of_contents_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_table_of_contents`
--

LOCK TABLES `translated_table_of_contents` WRITE;
/*!40000 ALTER TABLE `translated_table_of_contents` DISABLE KEYS */;
INSERT INTO `translated_table_of_contents` VALUES (1,1,1,'Overview',NULL),(2,2,1,'Brief Summary',NULL),(3,3,1,'Brief Description',NULL),(4,4,1,'Comprehensive Description',NULL),(5,5,1,'Description',NULL),(6,6,1,'Nucleotide Sequences',NULL),(7,7,1,'Ecology and Distribution',NULL),(8,8,1,'Distribution',NULL),(9,9,1,'Wikipedia',NULL),(10,10,1,'Identification Resources',NULL),(11,11,1,'Names and Taxonomy',NULL),(12,12,1,'Related Names',NULL),(13,13,1,'Synonyms',NULL),(14,14,1,'Common Names',NULL),(15,15,1,'Page Statistics',NULL),(16,16,1,'Content Summary',NULL),(17,17,1,'Biodiversity Heritage Library',NULL),(18,18,1,'References and More Information',NULL),(19,19,1,'Citizen Science',NULL),(20,20,1,'Citizen Science Links',NULL),(21,21,1,'Literature References',NULL),(22,22,1,'Content Partners',NULL),(23,23,1,'Biomedical Terms',NULL),(24,24,1,'Search the Web',NULL),(25,25,1,'Education',NULL),(26,26,1,'Education Links',NULL),(27,27,1,'Education Resources',NULL),(28,28,1,'Physical Description',NULL),(29,29,1,'Ecology',NULL),(30,30,1,'Life History and Behavior',NULL),(31,31,1,'Evolution and Systematics',NULL),(32,32,1,'Physiology and Cell Biology',NULL),(33,33,1,'Molecular Biology and Genetics',NULL),(34,34,1,'Conservation',NULL),(35,35,1,'Relevance to Humans and Ecosystems',NULL),(36,36,1,'Notes',NULL),(37,37,1,'Database and Repository Coverage',NULL),(38,38,1,'Relevance',NULL),(39,39,1,'Diagnosis of genus and species',NULL),(40,40,1,'Formal Description',NULL),(41,41,1,'Phenology',NULL),(42,42,1,'Life History',NULL),(43,43,1,'Geographical Distribution',NULL),(44,44,1,'Etymology',NULL),(45,45,1,'Adult Characteristics',NULL),(46,46,1,'Comparison with Similar Species',NULL),(47,47,1,'Host, Oviposition, and Larval Feeding Habits',NULL),(48,48,1,'Type',NULL),(49,49,1,'Characteristics',NULL),(50,50,1,'General Description',NULL),(51,51,1,'Reproductive Behavior',NULL),(52,52,1,'Harmful Blooms',NULL),(53,53,1,'Relation to Humans',NULL),(54,54,1,'Toxicity, Symptoms and Treatment',NULL),(55,55,1,'Cultivation',NULL),(56,56,1,'Culture',NULL),(57,57,1,'Ethnobotany',NULL),(58,58,1,'Suppliers',NULL);
/*!40000 ALTER TABLE `translated_table_of_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_untrust_reasons`
--

DROP TABLE IF EXISTS `translated_untrust_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_untrust_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `untrust_reason_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `untrust_reason_id` (`untrust_reason_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_untrust_reasons`
--

LOCK TABLES `translated_untrust_reasons` WRITE;
/*!40000 ALTER TABLE `translated_untrust_reasons` DISABLE KEYS */;
INSERT INTO `translated_untrust_reasons` VALUES (1,1,1,'misidentified',NULL),(2,2,1,'incorrect/misleading',NULL),(3,3,1,'low quality',NULL),(4,4,1,'duplicate',NULL);
/*!40000 ALTER TABLE `translated_untrust_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_uri_types`
--

DROP TABLE IF EXISTS `translated_uri_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_uri_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `uri_type_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_uri_types`
--

LOCK TABLES `translated_uri_types` WRITE;
/*!40000 ALTER TABLE `translated_uri_types` DISABLE KEYS */;
INSERT INTO `translated_uri_types` VALUES (1,'measurement',1,1),(2,'association',2,1),(3,'value',3,1),(4,'metadata',4,1),(5,'Unit of Measure',5,1);
/*!40000 ALTER TABLE `translated_uri_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_user_identities`
--

DROP TABLE IF EXISTS `translated_user_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_user_identities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_identity_id` smallint(5) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_identity_id` (`user_identity_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_user_identities`
--

LOCK TABLES `translated_user_identities` WRITE;
/*!40000 ALTER TABLE `translated_user_identities` DISABLE KEYS */;
INSERT INTO `translated_user_identities` VALUES (1,1,1,'an enthusiast'),(2,2,1,'a student'),(3,3,1,'an educator'),(4,4,1,'a citizen scientist'),(5,5,1,'a professional scientist');
/*!40000 ALTER TABLE `translated_user_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_vetted`
--

DROP TABLE IF EXISTS `translated_vetted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_vetted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vetted_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vetted_id` (`vetted_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_vetted`
--

LOCK TABLES `translated_vetted` WRITE;
/*!40000 ALTER TABLE `translated_vetted` DISABLE KEYS */;
INSERT INTO `translated_vetted` VALUES (1,1,1,'Trusted',NULL),(2,2,1,'Unknown',NULL),(3,3,1,'Untrusted',NULL),(4,4,1,'Inappropriate',NULL);
/*!40000 ALTER TABLE `translated_vetted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_view_styles`
--

DROP TABLE IF EXISTS `translated_view_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_view_styles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `language_id` int(11) NOT NULL,
  `view_style_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_view_styles`
--

LOCK TABLES `translated_view_styles` WRITE;
/*!40000 ALTER TABLE `translated_view_styles` DISABLE KEYS */;
INSERT INTO `translated_view_styles` VALUES (1,'List',1,1),(2,'Gallery',1,2),(3,'Annotated',1,3);
/*!40000 ALTER TABLE `translated_view_styles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translated_visibilities`
--

DROP TABLE IF EXISTS `translated_visibilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translated_visibilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visibility_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `label` varchar(300) NOT NULL,
  `phonetic_label` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `visibility_id` (`visibility_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translated_visibilities`
--

LOCK TABLES `translated_visibilities` WRITE;
/*!40000 ALTER TABLE `translated_visibilities` DISABLE KEYS */;
INSERT INTO `translated_visibilities` VALUES (1,1,1,'Invisible',NULL),(2,2,1,'Visible',NULL),(3,3,1,'Preview',NULL);
/*!40000 ALTER TABLE `translated_visibilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unique_visitors`
--

DROP TABLE IF EXISTS `unique_visitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unique_visitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unique_visitors`
--

LOCK TABLES `unique_visitors` WRITE;
/*!40000 ALTER TABLE `unique_visitors` DISABLE KEYS */;
/*!40000 ALTER TABLE `unique_visitors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `untrust_reasons`
--

DROP TABLE IF EXISTS `untrust_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `untrust_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `class_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `untrust_reasons`
--

LOCK TABLES `untrust_reasons` WRITE;
/*!40000 ALTER TABLE `untrust_reasons` DISABLE KEYS */;
INSERT INTO `untrust_reasons` VALUES (1,'2014-04-09 13:32:58','2014-04-09 13:33:25','misidentified'),(2,'2014-04-09 13:32:58','2014-04-09 13:33:25','incorrect'),(3,'2014-04-09 13:32:58','2014-04-09 13:33:25','poor'),(4,'2014-04-09 13:32:58','2014-04-09 13:33:25','duplicate');
/*!40000 ALTER TABLE `untrust_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uri_types`
--

DROP TABLE IF EXISTS `uri_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uri_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uri_types`
--

LOCK TABLES `uri_types` WRITE;
/*!40000 ALTER TABLE `uri_types` DISABLE KEYS */;
INSERT INTO `uri_types` VALUES (1),(2),(3),(4),(5);
/*!40000 ALTER TABLE `uri_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_added_data`
--

DROP TABLE IF EXISTS `user_added_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_added_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `predicate` varchar(255) NOT NULL,
  `object` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `vetted_id` int(11) DEFAULT '1',
  `visibility_id` int(11) DEFAULT '2',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_added_data`
--

LOCK TABLES `user_added_data` WRITE;
/*!40000 ALTER TABLE `user_added_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_added_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_added_data_metadata`
--

DROP TABLE IF EXISTS `user_added_data_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_added_data_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_added_data_id` int(11) NOT NULL,
  `predicate` varchar(255) NOT NULL,
  `object` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_added_data_id` (`user_added_data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_added_data_metadata`
--

LOCK TABLES `user_added_data_metadata` WRITE;
/*!40000 ALTER TABLE `user_added_data_metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_added_data_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_identities`
--

DROP TABLE IF EXISTS `user_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_identities` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `sort_order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_identities`
--

LOCK TABLES `user_identities` WRITE;
/*!40000 ALTER TABLE `user_identities` DISABLE KEYS */;
INSERT INTO `user_identities` VALUES (1,1),(2,2),(3,3),(4,4),(5,5);
/*!40000 ALTER TABLE `user_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_infos`
--

DROP TABLE IF EXISTS `user_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `areas_of_interest` varchar(255) DEFAULT NULL,
  `heard_of_eol` varchar(128) DEFAULT NULL,
  `interested_in_contributing` tinyint(1) DEFAULT NULL,
  `interested_in_curating` tinyint(1) DEFAULT NULL,
  `interested_in_advisory_forum` tinyint(1) DEFAULT NULL,
  `show_information` tinyint(1) DEFAULT NULL,
  `age_range` varchar(16) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_primary_role_id` int(11) DEFAULT NULL,
  `interested_in_development` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_infos`
--

LOCK TABLES `user_infos` WRITE;
/*!40000 ALTER TABLE `user_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_primary_roles`
--

DROP TABLE IF EXISTS `user_primary_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_primary_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_primary_roles`
--

LOCK TABLES `user_primary_roles` WRITE;
/*!40000 ALTER TABLE `user_primary_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_primary_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `remote_ip` varchar(24) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `given_name` varchar(255) DEFAULT NULL,
  `family_name` varchar(255) DEFAULT NULL,
  `identity_url` varchar(255) DEFAULT NULL,
  `username` varchar(32) DEFAULT NULL,
  `hashed_password` varchar(32) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `notes` text,
  `curator_approved` tinyint(1) NOT NULL DEFAULT '0',
  `curator_verdict_by_id` int(11) DEFAULT NULL,
  `curator_verdict_at` datetime DEFAULT NULL,
  `credentials` text NOT NULL,
  `validation_code` varchar(255) DEFAULT '',
  `failed_login_attempts` int(11) DEFAULT '0',
  `curator_scope` text NOT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `recover_account_token` char(40) DEFAULT NULL,
  `recover_account_token_expires_at` datetime DEFAULT NULL,
  `agent_id` int(10) unsigned DEFAULT NULL,
  `email_reports_frequency_hours` int(11) DEFAULT '24',
  `last_report_email` datetime DEFAULT NULL,
  `api_key` char(40) DEFAULT NULL,
  `logo_url` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `logo_cache_url` bigint(20) unsigned DEFAULT NULL,
  `logo_file_name` varchar(255) DEFAULT NULL,
  `logo_content_type` varchar(255) DEFAULT NULL,
  `logo_file_size` int(10) unsigned DEFAULT '0',
  `tag_line` varchar(255) DEFAULT NULL,
  `agreed_with_terms` tinyint(1) DEFAULT NULL,
  `bio` text,
  `curator_level_id` int(11) DEFAULT NULL,
  `requested_curator_level_id` int(11) DEFAULT NULL,
  `requested_curator_at` datetime DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(4) DEFAULT '0',
  `last_notification_at` datetime DEFAULT '2014-04-02 11:00:58',
  `last_message_at` datetime DEFAULT '2014-04-02 11:00:58',
  `disable_email_notifications` tinyint(1) DEFAULT '0',
  `news_in_preferred_language` tinyint(1) DEFAULT '0',
  `number_of_forum_posts` int(11) DEFAULT NULL,
  `origin_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_agent_id` (`agent_id`),
  UNIQUE KEY `unique_username` (`username`),
  KEY `index_users_on_created_at` (`created_at`),
  KEY `index_users_on_api_key` (`api_key`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'123.45.67.13','bob1@smith.com','IUCN','Reinger',NULL,'i_reinger','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:17','2014-04-09 13:33:17',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,1,24,NULL,NULL,NULL,201210030069362,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(2,'123.45.67.17','bob2@smith.com','Janie','Jacobs',NULL,'j_jacobs','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:17','2014-04-09 13:33:17',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,2,24,NULL,NULL,NULL,201204220191542,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(3,'123.45.67.10','bob3@smith.com','Helmer','Crona',NULL,'h_crona','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:17','2014-04-09 13:33:17',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,4,24,NULL,NULL,NULL,318700,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(4,'123.45.67.19','bob4@smith.com','Ahmad','Murphy',NULL,'we_loaded_foundation','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:32','2014-04-09 13:33:32',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,9,24,NULL,NULL,NULL,201202040069888,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(5,'123.45.67.17','bob5@smith.com','Roxane','Connelly',NULL,'r_connelly','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:37','2014-04-09 13:33:37',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,10,24,NULL,NULL,NULL,201111020692069,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(6,'123.45.67.19','bob6@smith.com','Mariana','Runolfsson',NULL,'m_runolfsson','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:38','2014-04-09 13:33:38',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,12,24,NULL,NULL,NULL,201207302359794,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(7,'123.45.67.15','bob7@smith.com','Joshuah','Ernser',NULL,'j_ernser','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:38','2014-04-09 13:33:39',NULL,1,6,'2014-04-07 13:33:38','Curator','',0,'scope',NULL,NULL,NULL,NULL,13,24,NULL,NULL,NULL,201301170225666,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,7,1),(8,'123.45.67.13','bob8@smith.com','Antonia','Nolan',NULL,'a_nolan','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:44','2014-04-09 13:33:44',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,14,24,NULL,NULL,NULL,201202110214753,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(9,'123.45.67.15','bob9@smith.com','Eugene','Mosciski',NULL,'e_mosciski','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:44','2014-04-09 13:33:44',NULL,1,8,'2014-04-07 13:33:44','Curator','',0,'scope',NULL,NULL,NULL,NULL,15,24,NULL,NULL,NULL,201201080155483,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,9,1),(10,'123.45.67.17','bob10@smith.com','Kaitlin','Larkin',NULL,'k_larkin','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,16,24,NULL,NULL,NULL,201111021252396,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(11,'123.45.67.16','bob11@smith.com','Otho','Willms',NULL,'o_willms','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:48','2014-04-09 13:33:48',NULL,1,10,'2014-04-07 13:33:48','Curator','',0,'scope',NULL,NULL,NULL,NULL,17,24,NULL,NULL,NULL,201112090080634,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,11,1),(12,'123.45.67.19','bob12@smith.com','Camila','Deckow',NULL,'c_deckow','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:51','2014-04-09 13:33:51',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,18,24,NULL,NULL,NULL,201111021244952,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(13,'123.45.67.19','bob13@smith.com','Colt','Stracke',NULL,'c_stracke','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:51','2014-04-09 13:33:51',NULL,1,12,'2014-04-07 13:33:51','Curator','',0,'scope',NULL,NULL,NULL,NULL,19,24,NULL,NULL,NULL,201204250072439,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,13,1),(14,'123.45.67.17','bob14@smith.com','Mathew','Deckow',NULL,'m_deckow','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:54','2014-04-09 13:33:54',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,20,24,NULL,NULL,NULL,201111021075853,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(15,'123.45.67.15','bob15@smith.com','Electa','Na',NULL,'e_na','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:54','2014-04-09 13:33:55',NULL,1,14,'2014-04-07 13:33:54','Curator','',0,'scope',NULL,NULL,NULL,NULL,21,24,NULL,NULL,NULL,201111011563090,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,15,1),(16,'123.45.67.18','bob16@smith.com','Damaris','Torphy',NULL,'d_torphy','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:58','2014-04-09 13:33:58',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,22,24,NULL,NULL,NULL,201202160129393,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(17,'123.45.67.11','bob17@smith.com','Aidan','Mills',NULL,'a_mills','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:33:58','2014-04-09 13:33:59',NULL,1,16,'2014-04-07 13:33:58','Curator','',0,'scope',NULL,NULL,NULL,NULL,23,24,NULL,NULL,NULL,201206220152592,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,17,1),(18,'123.45.67.17','bob17@smith.com','Dora','Pollich',NULL,'d_pollich','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:04','2014-04-09 13:34:04',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,24,24,NULL,NULL,NULL,201112270143930,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(19,'123.45.67.10','bob18@smith.com','Emmanuelle','Beatty',NULL,'e_beatty','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:06','2014-04-09 13:34:06',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,25,24,NULL,NULL,NULL,201111012383579,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(20,'123.45.67.14','bob19@smith.com','Sam','Hettinger',NULL,'s_hettinger','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:06','2014-04-09 13:34:07',NULL,1,19,'2014-04-07 13:34:06','Curator','',0,'scope',NULL,NULL,NULL,NULL,26,24,NULL,NULL,NULL,201207260783649,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,20,1),(21,'123.45.67.16','bob20@smith.com','Betty','Okuneva',NULL,'b_okuneva','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:08','2014-04-09 13:34:08',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,27,24,NULL,NULL,NULL,201111012169032,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(22,'123.45.67.11','bob21@smith.com','Reuben','Olson',NULL,'r_olson','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:08','2014-04-09 13:34:08',NULL,1,21,'2014-04-07 13:34:08','Curator','',0,'scope',NULL,NULL,NULL,NULL,28,24,NULL,NULL,NULL,201111011158648,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,22,1),(23,'123.45.67.16','bob22@smith.com','Ashley','West',NULL,'a_west','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:09','2014-04-09 13:34:09',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,29,24,NULL,NULL,NULL,201111020612441,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(24,'123.45.67.10','bob23@smith.com','Vicente','Schowalter',NULL,'v_schowalter','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:09','2014-04-09 13:34:09',NULL,1,23,'2014-04-07 13:34:09','Curator','',0,'scope',NULL,NULL,NULL,NULL,30,24,NULL,NULL,NULL,201211270043984,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,24,1),(25,'123.45.67.19','bob24@smith.com','Heber','Hill',NULL,'h_hill','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:10','2014-04-09 13:34:10',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,31,24,NULL,NULL,NULL,201111021029613,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(26,'123.45.67.13','bob25@smith.com','Maybell','Schneider',NULL,'m_schneider','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:10','2014-04-09 13:34:10',NULL,1,25,'2014-04-07 13:34:10','Curator','',0,'scope',NULL,NULL,NULL,NULL,32,24,NULL,NULL,NULL,201209022352216,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,26,1),(27,'123.45.67.16','bob26@smith.com','Okey','McCullough',NULL,'o_mccullough','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:16','2014-04-09 13:34:16',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,33,24,NULL,NULL,NULL,201111011344479,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(28,'123.45.67.13','bob27@smith.com','Leonardo','Schamberger',NULL,'l_schamberge','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:16','2014-04-09 13:34:16',NULL,1,27,'2014-04-07 13:34:16','Curator','',0,'scope',NULL,NULL,NULL,NULL,34,24,NULL,NULL,NULL,201111011679845,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,28,1),(29,'123.45.67.16','bob28@smith.com','Gerhard','Bode',NULL,'g_bode','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:18','2014-04-09 13:34:18',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,35,24,NULL,NULL,NULL,201111300968085,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(30,'123.45.67.17','bob29@smith.com','Cicero','Stehr',NULL,'curator_for_tc','5f4dcc3b5aa765d61d8327deb882cf99',1,1,'2014-04-09 13:34:18','2014-04-09 13:34:19',NULL,1,29,'2014-04-07 13:34:18','Curator','',0,'scope',NULL,NULL,NULL,NULL,36,24,NULL,NULL,NULL,201205100347094,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,30,1),(31,'123.45.67.12','bob30@smith.com','Maritza','Kuhic',NULL,'m_kuhic','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:21','2014-04-09 13:34:21',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,37,24,NULL,NULL,NULL,201209112315713,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(32,'123.45.67.16','bob31@smith.com','Wyatt','Hansen',NULL,'w_hansen','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:21','2014-04-09 13:34:21',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,39,24,NULL,NULL,NULL,201203120007511,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(33,'123.45.67.16','bob32@smith.com','Ming','Spencer',NULL,'m_spencer','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:21','2014-04-09 13:34:22',NULL,1,32,'2014-04-07 13:34:21','Curator','',0,'scope',NULL,NULL,NULL,NULL,40,24,NULL,NULL,NULL,201207070051807,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,33,1),(34,'123.45.67.13','bob33@smith.com','Ralph','Wiggum',NULL,'testcp','f5ec1938b346bf01dc3be259aa270dfa',1,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,41,24,NULL,NULL,NULL,201211040848246,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(35,'123.45.67.17','bob34@smith.com','Benton','Corwin',NULL,'test_cp','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,42,24,NULL,NULL,NULL,201203290044598,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(36,'123.45.67.18','bob35@smith.com','Rosalia','Toy',NULL,'r_toy','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:26','2014-04-09 13:34:26',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,45,24,NULL,NULL,NULL,201211280051661,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(37,'123.45.67.11','bob36@smith.com','Admin','User',NULL,'admin','21232f297a57a5a743894a0e4a801fc3',1,1,'2014-04-09 13:34:26','2014-04-09 13:34:27',NULL,1,36,'2014-04-07 13:34:26','Curator','',0,'scope',NULL,NULL,NULL,NULL,46,24,NULL,NULL,NULL,201111020821391,NULL,NULL,0,NULL,1,NULL,1,NULL,NULL,1,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,37,1),(38,'123.45.67.10','bob37@smith.com','Christie','Ankunding',NULL,'c_ankunding','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:28','2014-04-09 13:34:28',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,47,24,NULL,NULL,NULL,201111012194996,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(39,'123.45.67.16','bob38@smith.com','Madelynn','Beatty',NULL,'m_beatty','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:28','2014-04-09 13:34:29',NULL,1,38,'2014-04-07 13:34:28','Curator','',0,'scope',NULL,NULL,NULL,NULL,48,24,NULL,NULL,NULL,201202260041221,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,39,1),(40,'123.45.67.10','bob39@smith.com','Jeramie','Botsford',NULL,'j_botsford','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:31','2014-04-09 13:34:31',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,49,24,NULL,NULL,NULL,201207170007419,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(41,'123.45.67.14','bob40@smith.com','test','curator',NULL,'test_curator','5f4dcc3b5aa765d61d8327deb882cf99',1,1,'2014-04-09 13:34:31','2014-04-09 13:34:32',NULL,1,40,'2014-04-07 13:34:31','Curator','',0,'scope',NULL,NULL,NULL,NULL,50,24,NULL,NULL,NULL,201211040827144,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,41,1),(42,'123.45.67.10','bob41@smith.com','Duane','Leuschke',NULL,'d_leuschke','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:32','2014-04-09 13:34:32',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,3,24,NULL,NULL,NULL,201201250295337,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(43,'123.45.67.15','bob42@smith.com','Herbert','Senger',NULL,'h_senger','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:33','2014-04-09 13:34:33',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,53,24,NULL,NULL,NULL,201112300194339,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(44,'123.45.67.14','bob43@smith.com','Rolfe','Luettgen',NULL,'r_luettgen','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:33','2014-04-09 13:34:33',NULL,1,43,'2014-04-07 13:34:33','Curator','',0,'scope',NULL,NULL,NULL,NULL,54,24,NULL,NULL,NULL,201204200147552,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,44,1),(45,'123.45.67.15','bob44@smith.com','Kali','Lubowitz',NULL,'k_lubowitz','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:36','2014-04-09 13:34:36',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,55,24,NULL,NULL,NULL,201206210040082,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(46,'123.45.67.15','bob45@smith.com','Jacky','Welch',NULL,'j_welch','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:36','2014-04-09 13:34:37',NULL,1,45,'2014-04-07 13:34:36','Curator','',0,'scope',NULL,NULL,NULL,NULL,56,24,NULL,NULL,NULL,201111012185408,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,46,1),(47,'123.45.67.10','bob46@smith.com','Marilie','Harvey',NULL,'m_harvey','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,57,24,NULL,NULL,NULL,201301040017859,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(48,'123.45.67.12','bob47@smith.com','Jon','Schultz',NULL,'j_schultz','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:40','2014-04-09 13:34:40',NULL,1,47,'2014-04-07 13:34:40','Curator','',0,'scope',NULL,NULL,NULL,NULL,58,24,NULL,NULL,NULL,201111011984102,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,48,1),(49,'123.45.67.13','bob48@smith.com','Rachel','Keebler',NULL,'r_keebler','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,59,24,NULL,NULL,NULL,201111021286828,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(50,'123.45.67.15','bob49@smith.com','Scot','Hudson',NULL,'s_hudson','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:44','2014-04-09 13:34:44',NULL,1,49,'2014-04-07 13:34:44','Curator','',0,'scope',NULL,NULL,NULL,NULL,60,24,NULL,NULL,NULL,201201250380510,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,50,1),(51,'123.45.67.11','bob50@smith.com','Rhea','Leffler',NULL,'r_leffler','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:47','2014-04-09 13:34:47',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,61,24,NULL,NULL,NULL,201209252381279,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(52,'123.45.67.19','bob51@smith.com','Greta','Gleason',NULL,'g_gleason','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:47','2014-04-09 13:34:47',NULL,1,51,'2014-04-07 13:34:47','Curator','',0,'scope',NULL,NULL,NULL,NULL,62,24,NULL,NULL,NULL,201205310077602,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,52,1),(53,'123.45.67.11','bob52@smith.com','Dameon','Schmidt',NULL,'d_schmidt','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,63,24,NULL,NULL,NULL,201111012233905,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(54,'123.45.67.11','bob53@smith.com','Rasheed','Skiles',NULL,'r_skiles','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:51','2014-04-09 13:34:51',NULL,1,53,'2014-04-07 13:34:51','Curator','',0,'scope',NULL,NULL,NULL,NULL,64,24,NULL,NULL,NULL,201111011892631,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,54,1),(55,'123.45.67.14','bob54@smith.com','Bertrand','Gleason',NULL,'b_gleason','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:54','2014-04-09 13:34:54',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,65,24,NULL,NULL,NULL,201203290090064,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(56,'123.45.67.13','bob55@smith.com','Seao','Cummerata',NULL,'s_cummerata','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:54','2014-04-09 13:34:54',NULL,1,55,'2014-04-07 13:34:54','Curator','',0,'scope',NULL,NULL,NULL,NULL,66,24,NULL,NULL,NULL,201209172384084,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,56,1),(57,'123.45.67.10','bob56@smith.com','Janif','Stamm',NULL,'j_stamm','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,67,24,NULL,NULL,NULL,201204150016376,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(58,'123.45.67.11','bob57@smith.com','Helmes','Beier',NULL,'h_beier','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:34:58','2014-04-09 13:34:58',NULL,1,57,'2014-04-07 13:34:58','Curator','',0,'scope',NULL,NULL,NULL,NULL,68,24,NULL,NULL,NULL,201202260034012,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,58,1),(59,'123.45.67.17','bob58@smith.com','Fionb','Dickens',NULL,'f_dickens','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:01','2014-04-09 13:35:01',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,69,24,NULL,NULL,NULL,201111012266993,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(60,'123.45.67.13','bob59@smith.com','Spences','Kulas',NULL,'s_kulas','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:01','2014-04-09 13:35:02',NULL,1,59,'2014-04-07 13:35:01','Curator','',0,'scope',NULL,NULL,NULL,NULL,70,24,NULL,NULL,NULL,201112220171145,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,60,1),(61,'123.45.67.12','bob60@smith.com','Camreo','Franecki',NULL,'c_franecki','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,71,24,NULL,NULL,NULL,201111011632931,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(62,'123.45.67.18','bob61@smith.com','Ahmae','Kuhic',NULL,'a_kuhic','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:05','2014-04-09 13:35:05',NULL,1,61,'2014-04-07 13:35:05','Curator','',0,'scope',NULL,NULL,NULL,NULL,72,24,NULL,NULL,NULL,201203270131349,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,62,1),(63,'123.45.67.18','bob62@smith.com','Roxanf','Padberg',NULL,'r_padberg','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,73,24,NULL,NULL,NULL,201111020255217,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(64,'123.45.67.11','bob63@smith.com','Marianb','Haley',NULL,'m_haley','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:09','2014-04-09 13:35:09',NULL,1,63,'2014-04-07 13:35:09','Curator','',0,'scope',NULL,NULL,NULL,NULL,74,24,NULL,NULL,NULL,201205050025674,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,64,1),(65,'123.45.67.16','bob64@smith.com','Joshuai','Gorczany',NULL,'j_gorczany','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,75,24,NULL,NULL,NULL,201111020299829,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(66,'123.45.67.12','bob65@smith.com','Antonib','Hoeger',NULL,'a_hoeger','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:13','2014-04-09 13:35:13',NULL,1,65,'2014-04-07 13:35:13','Curator','',0,'scope',NULL,NULL,NULL,NULL,76,24,NULL,NULL,NULL,201302041061045,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,66,1),(67,'123.45.67.17','bob66@smith.com','Eugenf','Cronio',NULL,'e_cronio','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:16','2014-04-09 13:35:16',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,77,24,NULL,NULL,NULL,201111020073931,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(68,'123.45.67.16','bob67@smith.com','Kaitlio','Reinges',NULL,'k_reinges','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:16','2014-04-09 13:35:16',NULL,1,67,'2014-04-07 13:35:16','Curator','',0,'scope',NULL,NULL,NULL,NULL,78,24,NULL,NULL,NULL,201111020541857,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,68,1),(69,'123.45.67.18','bob68@smith.com','Othp','Jacobt',NULL,'o_jacobt','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:19','2014-04-09 13:35:19',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,79,24,NULL,NULL,NULL,201111020722713,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(70,'123.45.67.14','bob69@smith.com','Camilb','Cronb',NULL,'c_cronb','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:20','2014-04-09 13:35:20',NULL,1,69,'2014-04-07 13:35:20','Curator','',0,'scope',NULL,NULL,NULL,NULL,80,24,NULL,NULL,NULL,201112090037380,NULL,NULL,0,NULL,1,NULL,2,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,70,1),(71,'123.45.67.14','bob70@smith.com','Colu','Parisiao',NULL,'c_parisiao','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:30','2014-04-09 13:35:30',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,81,24,NULL,NULL,NULL,201111011130833,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(72,'123.45.67.16','bob71@smith.com','Mathex','Bergstron',NULL,'datamama','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:52','2014-04-09 13:35:52',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,82,24,NULL,NULL,NULL,201205310020621,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(73,'123.45.67.15','bob72@smith.com','Electb','Rhyt',NULL,'we_loaded_bootstrap','2aaa8335fd030e054a98e3b2c5852b34',1,1,'2014-04-09 13:35:54','2014-04-09 13:35:54',NULL,0,NULL,NULL,'','',0,'',NULL,NULL,NULL,NULL,83,24,NULL,NULL,NULL,201201050110344,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,NULL,NULL),(78,'127.0.0.1','user1@example.com','',NULL,NULL,'user1','24c9e15e52afc47c225b757e7bee1f9d',1,1,'2014-04-10 09:50:38','2014-04-10 09:50:39',NULL,0,NULL,NULL,'',NULL,0,'',NULL,NULL,NULL,NULL,88,24,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,1,0,'2014-04-27 10:58:59','2014-04-02 11:00:58',0,0,NULL,78,1),(79,'127.0.0.1','admin1@admin1.com',NULL,NULL,NULL,'admin1','e00cf25ad42683b3df678c61f42c6bda',1,1,'2014-04-27 13:04:15','2014-04-27 13:04:17',NULL,0,NULL,NULL,'',NULL,0,'',NULL,NULL,NULL,NULL,89,24,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,1,0,'2014-04-02 11:00:58','2014-04-02 11:00:58',0,0,NULL,79,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_data_objects`
--

DROP TABLE IF EXISTS `users_data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_data_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `data_object_id` int(11) DEFAULT NULL,
  `taxon_concept_id` int(11) DEFAULT NULL,
  `vetted_id` int(11) NOT NULL,
  `visibility_id` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_users_data_objects_on_data_object_id` (`data_object_id`),
  KEY `index_users_data_objects_on_taxon_concept_id` (`taxon_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_data_objects`
--

LOCK TABLES `users_data_objects` WRITE;
/*!40000 ALTER TABLE `users_data_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_data_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_data_objects_ratings`
--

DROP TABLE IF EXISTS `users_data_objects_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_data_objects_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `data_object_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `data_object_guid` varchar(32) CHARACTER SET ascii NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `weight` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_data_objects_ratings_1` (`data_object_guid`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_data_objects_ratings`
--

LOCK TABLES `users_data_objects_ratings` WRITE;
/*!40000 ALTER TABLE `users_data_objects_ratings` DISABLE KEYS */;
INSERT INTO `users_data_objects_ratings` VALUES (1,30,NULL,1,'337539d3a50d4f718e2a18a356c6a433','2014-04-09 13:34:19','2014-04-09 13:34:19',1),(2,30,NULL,1,'64e398018b82432aa087895c30ae5cae','2014-04-09 13:34:19','2014-04-09 13:34:19',1);
/*!40000 ALTER TABLE `users_data_objects_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_identities`
--

DROP TABLE IF EXISTS `users_user_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_user_identities` (
  `user_id` int(10) unsigned NOT NULL,
  `user_identity_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`user_identity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_identities`
--

LOCK TABLES `users_user_identities` WRITE;
/*!40000 ALTER TABLE `users_user_identities` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vetted`
--

DROP TABLE IF EXISTS `vetted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vetted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `view_order` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Vetted statuses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vetted`
--

LOCK TABLES `vetted` WRITE;
/*!40000 ALTER TABLE `vetted` DISABLE KEYS */;
INSERT INTO `vetted` VALUES (1,'2014-04-09 13:33:25','2014-04-09 13:33:25',1),(2,'2014-04-09 13:33:25','2014-04-09 13:33:25',2),(3,'2014-04-09 13:33:25','2014-04-09 13:33:25',3),(4,'2014-04-09 13:33:25','2014-04-09 13:33:25',4);
/*!40000 ALTER TABLE `vetted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `view_styles`
--

DROP TABLE IF EXISTS `view_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `view_styles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `max_items_per_page` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `view_styles`
--

LOCK TABLES `view_styles` WRITE;
/*!40000 ALTER TABLE `view_styles` DISABLE KEYS */;
INSERT INTO `view_styles` VALUES (1,NULL),(2,NULL),(3,NULL);
/*!40000 ALTER TABLE `view_styles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visibilities`
--

DROP TABLE IF EXISTS `visibilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `visibilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visibilities`
--

LOCK TABLES `visibilities` WRITE;
/*!40000 ALTER TABLE `visibilities` DISABLE KEYS */;
INSERT INTO `visibilities` VALUES (1,'2014-04-09 13:33:26','2014-04-09 13:33:26'),(2,'2014-04-09 13:33:26','2014-04-09 13:33:26'),(3,'2014-04-09 13:33:26','2014-04-09 13:33:26');
/*!40000 ALTER TABLE `visibilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `whats_this`
--

DROP TABLE IF EXISTS `whats_this`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `whats_this` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `url` varchar(128) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `whats_this`
--

LOCK TABLES `whats_this` WRITE;
/*!40000 ALTER TABLE `whats_this` DISABLE KEYS */;
/*!40000 ALTER TABLE `whats_this` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wikipedia_queue`
--

DROP TABLE IF EXISTS `wikipedia_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wikipedia_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `revision_id` int(11) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `harvested_at` timestamp NULL DEFAULT NULL,
  `harvest_succeeded` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wikipedia_queue`
--

LOCK TABLES `wikipedia_queue` WRITE;
/*!40000 ALTER TABLE `wikipedia_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `wikipedia_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worklist_ignored_data_objects`
--

DROP TABLE IF EXISTS `worklist_ignored_data_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worklist_ignored_data_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `data_object_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_worklist_ignored_data_objects_on_data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worklist_ignored_data_objects`
--

LOCK TABLES `worklist_ignored_data_objects` WRITE;
/*!40000 ALTER TABLE `worklist_ignored_data_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `worklist_ignored_data_objects` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-07-01 14:22:07
