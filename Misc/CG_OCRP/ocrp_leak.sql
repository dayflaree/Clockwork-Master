# Dumped by kira.SQL v. c100
# Home page: http://google.com
#
# Host settings:
# MySQL version: (5.0.92-community) running on 74.86.183.204 (www.catalyst-gaming.net)
# Date: 20.05.2011 00:27:31
# DB: "catalyst_ocrp"
#---------------------------------------------------------
DROP TABLE IF EXISTS `achievements`;
CREATE TABLE `achievements` (
  `ID` text NOT NULL,
  `GMod Racer: Record Breaker` int(11) NOT NULL,
  `GMod Racer: Speed Demon` int(11) NOT NULL,
  `GMod Racer: Road Rage` int(11) NOT NULL,
  `GMod Racer: Destruction Derby` int(11) NOT NULL,
  `GMod Racer: Rolling the Rick` int(11) NOT NULL,
  `GMod Racer: Bomber` int(11) NOT NULL,
  `GMod Racer: Black Worshiper` int(11) NOT NULL,
  `Murder: Cold Blood` int(11) NOT NULL,
  `Murder: Framed` int(11) NOT NULL,
  `Murder: No Rest for the Wicked` int(11) NOT NULL,
  `Murder: Short Round` int(11) NOT NULL,
  `Murder: Wanna Be Cop` int(11) NOT NULL,
  `Murder: Ninja` int(11) NOT NULL,
  `Murder: Sharp Shooter` int(11) NOT NULL,
  `Murder: Last Stand` int(11) NOT NULL,
  `GMod Racer: Prestige One` int(11) NOT NULL,
  `GMod Racer: Prestige Two` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
  `ID` text NOT NULL,
  `NAME` text NOT NULL,
  `UNBAN` int(11) NOT NULL default '0',
  `BANNER` text,
  `REASON` text,
  `NOW` int(11) NOT NULL default '0',
  `IP` text,
  `BAN` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`BAN`,`UNBAN`)
) ENGINE=MyISAM AUTO_INCREMENT=4422 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `global_chat`;
CREATE TABLE `global_chat` (
  `server_id` text,
  `user_name` text,
  `message` text,
  `num` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`num`)
) ENGINE=MyISAM AUTO_INCREMENT=19684 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_businesses`;
CREATE TABLE `ocrp_businesses` (
  `ID` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `info` text NOT NULL,
  `permissions` text NOT NULL,
  `owner` text NOT NULL,
  `type` text NOT NULL,
  `balance` int(11) NOT NULL,
  `products` text NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

INSERT INTO `ocrp_businesses`(`ID`, `name`, `info`, `permissions`, `owner`, `type`, `balance`, `products`) VALUES ('14', 'New Business', 'No information', 'manage_user_permissions.false;edit_billboard.false;buy_billboard.false;fund_view.true;manage_wages.false;fund_access.false;buy_vehicles.false;', 'STEAM_0:0:5300193', 'Primary', '0', '');
DROP TABLE IF EXISTS `ocrp_cars`;
CREATE TABLE `ocrp_cars` (
  `car` text,
  `skin` int(11) default NULL,
  `SteamID` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_invs`;
CREATE TABLE `ocrp_invs` (
  `item` text NOT NULL,
  `amount` int(11) NOT NULL,
  `SteamID` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_orgs`;
CREATE TABLE `ocrp_orgs` (
  `org_id` int(10) unsigned NOT NULL auto_increment,
  `org_name` text,
  `org_owner` text,
  `org_notes` text,
  `DefaultRank` int(11) default NULL,
  `0` text,
  `1` text,
  `2` text,
  `3` text,
  `4` text,
  PRIMARY KEY  (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=929 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_s_adverts`;
CREATE TABLE `ocrp_s_adverts` (
  `Name` text,
  `Desc` text,
  `Type` text,
  `OrgID` int(10) default NULL,
  `Start` int(20) default NULL,
  `End` int(20) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_s_messages`;
CREATE TABLE `ocrp_s_messages` (
  `ID` int(10) NOT NULL auto_increment,
  `To` text,
  `Subject` text,
  `Body` text,
  `Sender` text,
  `SenderName` text,
  `Unread` int(11) default '1',
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_s_orgs`;
CREATE TABLE `ocrp_s_orgs` (
  `org_id` int(10) unsigned NOT NULL auto_increment,
  `org_name` text,
  `org_owner` text,
  `org_notes` text,
  `DefaultRank` int(11) default NULL,
  `ranks` text,
  `defaultgroup` text,
  `groups` text,
  `perks` text,
  `storage` text,
  `org_creation` text,
  `org_type` text,
  `balance` int(10) default '0',
  `payneeded` int(10) default '0',
  PRIMARY KEY  (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_s_partys`;
CREATE TABLE `ocrp_s_partys` (
  `ID` int(11) NOT NULL auto_increment,
  `Name` text,
  `Desc` text,
  `Laws` text,
  `Creator` text,
  `Leader` text,
  `Creation` int(30) default '0',
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_s_settings`;
CREATE TABLE `ocrp_s_settings` (
  `Government` text,
  `MayorEvents` text,
  `Laws` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_s_users`;
CREATE TABLE `ocrp_s_users` (
  `nick` text NOT NULL,
  `cars` text,
  `model` text,
  `cur_model` text,
  `org_id` text,
  `org_group` text NOT NULL,
  `STEAM_ID` text NOT NULL,
  `ID` int(11) NOT NULL auto_increment,
  `inv` text,
  `skills` text,
  `wardrobe` text,
  `lastselect` int(11) NOT NULL default '0',
  `storage` text,
  `permissions` text,
  `business` int(11) NOT NULL default '0',
  `bl_medic` text NOT NULL,
  `bl_police` text NOT NULL,
  `key` int(11) NOT NULL default '0',
  `RPName` text,
  `characters` text,
  `money` text,
  `access` text,
  `license` text,
  `cr` text,
  `flags` text,
  `job` text,
  `wallet` int(10) default NULL,
  `bank` int(10) default NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_skills`;
CREATE TABLE `ocrp_skills` (
  `skill` text,
  `level` int(11) default NULL,
  `SteamID` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ocrp_users`;
CREATE TABLE `ocrp_users` (
  `nick` text NOT NULL,
  `wallet` int(11) NOT NULL default '0',
  `bank` int(11) NOT NULL default '2500',
  `cars` text,
  `model` text,
  `cur_model` text,
  `bl_police` text,
  `bl_medic` text,
  `bl_srs` text,
  `org_id` int(11) NOT NULL default '0',
  `org_rank` int(11) NOT NULL default '0',
  `STEAM_ID` text NOT NULL,
  `inv` text,
  `skills` text,
  `wardrobe` text,
  `newold` int(11) NOT NULL default '0',
  `storage` text,
  `permissions` text,
  `business` int(11) NOT NULL default '0',
  `key` int(11) NOT NULL default '0',
  PRIMARY KEY  (`STEAM_ID`(25))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ocrp_wardrobe`;
CREATE TABLE `ocrp_wardrobe` (
  `key` int(11) default NULL,
  `model` text,
  `outfit` text,
  `choice` text,
  `SteamID` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#---------------------------------------------------------------------------------

