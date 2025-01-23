--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Surface suit";
ITEM.weight = 2;
ITEM.runSound = {
	"avoxgaming/mvt_strong_1.wav",
	"avoxgaming/mvt_strong_2.wav",
	"avoxgaming/mvt_strong_3.wav",
	"avoxgaming/mvt_strong_4.wav",
	"avoxgaming/mvt_strong_5.wav",
	"avoxgaming/mvt_strong_6.wav"
};
ITEM.iconModel = "models/stalkertnb/io7a_merc2.mdl";
ITEM.protection = 0.6;
ITEM.description = "Anti-radiation gear.";
ITEM.replacement = "models/stalkertnb/io7a_merc2.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.cost = 47;
ITEM.access = "U";
ITEM.business = true;
ITEM.radProtect = 0.5;

openAura.item:Register(ITEM);