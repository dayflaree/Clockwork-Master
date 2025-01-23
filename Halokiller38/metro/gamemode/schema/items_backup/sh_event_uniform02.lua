--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Volunteer suit";
ITEM.weight = 2;
ITEM.runSound = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
};
ITEM.iconModel = "models/avoxgaming/mrp/jake/volunteer.mdl";
ITEM.protection = 0.5;
ITEM.description = "A tactical uniform.";
ITEM.replacement = "models/avoxgaming/mrp/jake/volunteer.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.cost = 14;
ITEM.access = "2";
ITEM.business = true;
ITEM.radProtect = 0.4;

openAura.item:Register(ITEM);