--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Uniform 7";
ITEM.weight = 2;
ITEM.iconModel = "models/avoxgaming/mrp/jake/reich_enlisted.mdl";
ITEM.protection = 0.4;
ITEM.runSound = {
	"npc/metropolice/gear1.wav",
	"npc/metropolice/gear2.wav",
	"npc/metropolice/gear3.wav",
	"npc/metropolice/gear4.wav",
	"npc/metropolice/gear5.wav",
	"npc/metropolice/gear6.wav"
};
ITEM.description = "Uniform 7";
ITEM.replacement = "models/avoxgaming/mrp/jake/reich_enlisted.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.cost = 1;
ITEM.access = "9";
ITEM.business = true;
ITEM.radProtect = 0.2;

openAura.item:Register(ITEM);