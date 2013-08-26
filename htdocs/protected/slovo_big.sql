-- phpMiniAdmin dump 1.8.120510
-- Datetime: 2012-11-21 20:08:10
-- Host: localhost
-- Database: slovo

/*!40030 SET NAMES utf8 */;
/*!40030 SET GLOBAL max_allowed_packet=16777216 */;

DROP TABLE IF EXISTS `tbl_dictionary`;
CREATE TABLE `tbl_dictionary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=47663 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `tbl_dictionary` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_dictionary` ENABLE KEYS */;

DROP TABLE IF EXISTS `tbl_stringbundle`;
CREATE TABLE `tbl_stringbundle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `svalue` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `tbl_stringbundle` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_stringbundle` ENABLE KEYS */;

DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oid` varchar(128) NOT NULL,
  `username` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `score` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `tbl_user` DISABLE KEYS */;
INSERT INTO `tbl_user` VALUES ('1','','123','','','29'),('2','','fgh','','','0'),('3','','02','','','0'),('4','','321','','','397'),('5','','sdfsad','','','0'),('6','','1233','','','0'),('7','','123','','','100'),('8','','frkk','','','0'),('9','','frr','','','206'),('10','','frkk','','','0'),('11','','frkk','','','192');
/*!40000 ALTER TABLE `tbl_user` ENABLE KEYS */;

DROP TABLE IF EXISTS `tbl_userdictionary`;
CREATE TABLE `tbl_userdictionary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date_add` datetime NOT NULL,
  `word` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `tbl_userdictionary` DISABLE KEYS */;
INSERT INTO `tbl_userdictionary` VALUES ('1','1','2011-03-31 09:17:37','свет');
/*!40000 ALTER TABLE `tbl_userdictionary` ENABLE KEYS */;


-- phpMiniAdmin dump end