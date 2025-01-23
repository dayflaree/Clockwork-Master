--[[
	Free Clockwork!
--]]

ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Agility";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "agt";
	ATTRIBUTE.description = "Affects your overall speed, e.g: how fast you run.";
	ATTRIBUTE.characterScreen = true;
ATB_AGILITY = Clockwork.attribute:Register(ATTRIBUTE);