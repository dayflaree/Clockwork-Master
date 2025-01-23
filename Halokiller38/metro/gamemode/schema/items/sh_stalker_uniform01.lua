--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Stalker Gear";
ITEM.weight = 2;
ITEM.runSound = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
};
ITEM.iconModel = "models/avoxgaming/mrp/jake/stalker.mdl";
ITEM.protection = 0.2;
ITEM.description = "A tactical uniform with a Stalker insignia on the sleeve.";
ITEM.replacement = "models/avoxgaming/mrp/jake/stalker.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.uniqueID = "stalker_uniform01";
ITEM.cost = 1;
ITEM.access = "6";
ITEM.business = true;
ITEM.radProtect = 0.5;

openAura.item:Register(ITEM);