--[[
Name: "sh_ceda_uniform.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Metro suit4";
ITEM.weight = 2;
ITEM.runSound = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
};
ITEM.iconModel = "models/stalkertnb/bandit4.mdl";
ITEM.protection = 0.2;
ITEM.description = "Pro0.2 - Rad0.2";
ITEM.replacement = "models/stalkertnb/bandit4.mdl";
ITEM.pocketSpace = 2;
ITEM.batch = 1;
ITEM.cost = 25;
ITEM.access = "U";
ITEM.business = true;
ITEM.radProtect = 0.2;

openAura.item:Register(ITEM);