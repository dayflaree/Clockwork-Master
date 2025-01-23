--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Ranger Uniform";
ITEM.weight = 2;
ITEM.runSound = {
	"avoxgaming/mvt_strong_1.wav",
	"avoxgaming/mvt_strong_2.wav",
	"avoxgaming/mvt_strong_3.wav",
	"avoxgaming/mvt_strong_4.wav",
	"avoxgaming/mvt_strong_5.wav",
	"avoxgaming/mvt_strong_6.wav"
};
ITEM.iconModel = "models/avoxgaming/mrp/jake/ranger.mdl";
ITEM.protection = 0.9;
ITEM.description = "A tactical Ranger uniform that is heavy protected.";
ITEM.replacement = "models/avoxgaming/mrp/jake/ranger.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.uniqueID = "ranger_uniform";
ITEM.cost = 1;
ITEM.access = "7";
ITEM.business = true;
ITEM.radProtect = 0.4;

openAura.item:Register(ITEM);