--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Veteran Mercenary - black";
ITEM.weight = 2;
ITEM.runSound = {
	"/avoxgaming/gear/mvt_strong_1.wav",
	"/avoxgaming/gear/mvt_strong_2.wav",
	"/avoxgaming/gear/mvt_strong_3.wav",
	"/avoxgaming/gear/mvt_strong_4.wav",
	"/avoxgaming/gear/mvt_strong_5.wav",
	"/avoxgaming/gear/mvt_strong_6.wav"
};
ITEM.iconModel = "models/stalkertnb/banditboss1.mdl";
ITEM.protection = 0.5;
ITEM.description = "A tactical uniform.";
ITEM.replacement = "models/stalkertnb/banditboss1.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.cost = 90;
ITEM.access = "U";
ITEM.business = true;
ITEM.radProtect = 0.9;

openAura.item:Register(ITEM);