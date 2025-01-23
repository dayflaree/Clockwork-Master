SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

CREATE TABLE IF NOT EXISTS `ts_characters` (
  `charID` int(20) NOT NULL AUTO_INCREMENT,
  `CID` int(5) NOT NULL DEFAULT '0',
  `userID` int(10) NOT NULL DEFAULT '0',
  `charName` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `charTokens` int(10) NOT NULL DEFAULT '0',
  `charModel` varchar(75) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `charAge` varchar(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `charTitle` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `charJob` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `charBio` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `charRace` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `items` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `statStrength` int(3) NOT NULL DEFAULT '0',
  `statAIM` int(3) NOT NULL DEFAULT '0',
  `statEndurance` int(3) NOT NULL DEFAULT '0',
  `statSprint` int(3) NOT NULL DEFAULT '0',
  `statMedic` int(3) NOT NULL DEFAULT '0',
  `statSpeed` int(3) NOT NULL DEFAULT '0',
  `statSneak` int(3) NOT NULL DEFAULT '0',
  `loanAmount` int(4) NOT NULL DEFAULT '0',
  `loanRemain` int(4) NOT NULL DEFAULT '0',
  `loanCanGet` int(1) NOT NULL DEFAULT '1',
  `BusinessOwn` int(1) NOT NULL DEFAULT '0',
  `BusinessMoney` int(7) NOT NULL DEFAULT '0',
  `BusinessSupplyLicense` int(1) NOT NULL DEFAULT '0',
  `BusinessItems` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `BusinessName` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `SaveVersion` tinyint(2) NOT NULL DEFAULT '0',
  `combineflags` text COLLATE utf8_unicode_ci NOT NULL,
  `playerflags` text COLLATE utf8_unicode_ci NOT NULL,
  `BusinessSupplyLicenseTypes` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`charID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

CREATE TABLE IF NOT EXISTS `ts_donations` (
  `STEAMID` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `MaxRagdolls` tinyint(1) NOT NULL DEFAULT '0',
  `MaxProps` tinyint(2) NOT NULL DEFAULT '0',
  `CustomModel` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `CustomModelCharName` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`STEAMID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `ts_realtimedonations` (
  `STEAMID` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `CharName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Fail` int(1) NOT NULL DEFAULT '0',
  `tokens` int(8) NOT NULL DEFAULT '0',
  `strength` int(3) NOT NULL DEFAULT '0',
  `speed` int(3) NOT NULL DEFAULT '0',
  `sprint` int(3) NOT NULL DEFAULT '0',
  `endurance` int(3) NOT NULL DEFAULT '0',
  `aim` int(3) NOT NULL DEFAULT '0',
  `sneak` int(3) NOT NULL DEFAULT '0',
  `medic` int(3) NOT NULL DEFAULT '0',
  `weapon` varchar(128) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `ts_users` (
  `uID` int(5) NOT NULL AUTO_INCREMENT,
  `STEAMID` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `UserName` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `Password` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `groupID` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;
