-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: eol_registry_development
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
-- Table structure for table `log_action_parameters`
--

DROP TABLE IF EXISTS `log_action_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_action_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `peer_log_id` int(11) DEFAULT NULL,
  `param_object_type_id` int(11) DEFAULT NULL,
  `param_object_id` int(11) DEFAULT NULL,
  `param_object_site_id` int(11) DEFAULT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_action_parameters`
--

LOCK TABLES `log_action_parameters` WRITE;
/*!40000 ALTER TABLE `log_action_parameters` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_action_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peer_logs`
--

DROP TABLE IF EXISTS `peer_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peer_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_site_id` int(11) DEFAULT NULL,
  `user_site_object_id` int(11) DEFAULT NULL,
  `action_taken_at_time` datetime DEFAULT NULL,
  `sync_object_action_id` int(11) DEFAULT NULL,
  `sync_object_type_id` int(11) DEFAULT NULL,
  `sync_object_id` int(11) DEFAULT NULL,
  `sync_object_site_id` int(11) DEFAULT NULL,
  `push_request_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peer_logs`
--

LOCK TABLES `peer_logs` WRITE;
/*!40000 ALTER TABLE `peer_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `peer_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pull_events`
--

DROP TABLE IF EXISTS `pull_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pull_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `pull_at` datetime DEFAULT NULL,
  `success_at` datetime DEFAULT NULL,
  `state_uuid` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `success` int(11) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_md5_hash` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pull_events`
--

LOCK TABLES `pull_events` WRITE;
/*!40000 ALTER TABLE `pull_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `pull_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `push_requests`
--

DROP TABLE IF EXISTS `push_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `push_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_md5_hash` varchar(255) DEFAULT NULL,
  `received_at` datetime DEFAULT NULL,
  `success_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `failed_reason` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `success` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `push_requests`
--

LOCK TABLES `push_requests` WRITE;
/*!40000 ALTER TABLE `push_requests` DISABLE KEYS */;
INSERT INTO `push_requests` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'dfc9a8e4-0119-11e4-a574-000ffe473f57',1,'2014-07-01 12:18:56','2014-07-01 12:18:56');
/*!40000 ALTER TABLE `push_requests` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20121209084027'),('20121209084637'),('20121209084834'),('20121209085914'),('20121209091349'),('20121209091755'),('20121209094045'),('20121211101824'),('20140210135139'),('20140210140010'),('20140210140049');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
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
  `current_uuid` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `auth_code` varchar(255) DEFAULT NULL,
  `response_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'MBL','dfc9a8e4-0119-11e4-a574-000ffe473f57','http://localhost:3001','cf405938-c08b-11e3-ab74-000ffe473f57','http://localhost:3001/sync_event_update','2014-04-10 08:40:46','2014-07-01 12:18:57'),(2,'BA','dfc9a8e4-0119-11e4-a574-000ffe473f57','http://localhost:3002','5371149c-9250-11e3-a9d6-000ffe473aab','http://localhost:3002/sync_event_update','2014-04-10 08:40:46','2014-07-01 12:18:57');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_object_actions`
--

LOCK TABLES `sync_object_actions` WRITE;
/*!40000 ALTER TABLE `sync_object_actions` DISABLE KEYS */;
INSERT INTO `sync_object_actions` VALUES (1,'create','2014-04-10 09:59:20','2014-04-10 09:59:20'),(2,'activate','2014-04-27 13:06:45','2014-04-27 13:06:45'),(3,'delete','2014-04-30 12:43:35','2014-04-30 12:43:35');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_object_types`
--

LOCK TABLES `sync_object_types` WRITE;
/*!40000 ALTER TABLE `sync_object_types` DISABLE KEYS */;
INSERT INTO `sync_object_types` VALUES (1,'User','2014-04-10 09:59:20','2014-04-10 09:59:20'),(2,'content_page','2014-04-27 12:46:54','2014-04-27 12:46:54');
/*!40000 ALTER TABLE `sync_object_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-07-01 14:22:32
