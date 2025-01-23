DROP TABLE IF EXISTS `sstrp`.`characters`;
CREATE TABLE  `sstrp`.`characters` (
  `_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
  `_Data` text NOT NULL,
  `_Name` varchar(150) NOT NULL,
  `_Ammo` text NOT NULL,
  `_Cash` varchar(150) NOT NULL,
  `_Model` varchar(250) NOT NULL,
  `_Flags` text NOT NULL,
  `_Schema` text NOT NULL,
  `_Gender` varchar(50) NOT NULL,
  `_Faction` varchar(50) NOT NULL,
  `_SteamID` varchar(60) NOT NULL,
  `_SteamName` varchar(150) NOT NULL,
  `_Inventory` text NOT NULL,
  `_OnNextLoad` text NOT NULL,
  `_Attributes` text NOT NULL,
  `_LastPlayed` varchar(50) NOT NULL,
  `_TimeCreated` varchar(50) NOT NULL,
  `_CharacterID` varchar(50) NOT NULL,
  `_RecognisedNames` text NOT NULL,
  PRIMARY KEY (`_Key`)
) ENGINE=MyISAM AUTO_INCREMENT=1861 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `sstrp`.`players`;
CREATE TABLE  `sstrp`.`players` (
  `_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
  `_Data` text NOT NULL,
  `_Schema` text NOT NULL,
  `_SteamID` varchar(60) NOT NULL,
  `_IPAddress` varchar(50) NOT NULL,
  `_SteamName` varchar(150) NOT NULL,
  `_OnNextPlay` text NOT NULL,
  `_LastPlayed` varchar(50) NOT NULL,
  `_TimeJoined` varchar(50) NOT NULL,
  PRIMARY KEY (`_Key`)
) ENGINE=MyISAM AUTO_INCREMENT=786 DEFAULT CHARSET=latin1;