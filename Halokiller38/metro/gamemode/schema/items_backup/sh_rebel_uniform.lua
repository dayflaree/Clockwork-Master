--[[
Name: "sh_resistance_uniform.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "clothes_base";
ITEM.name = "Rebel Uniform";
ITEM.group = "group03";
ITEM.weight = 3;
ITEM.access = "y";
ITEM.business = true;
ITEM.protection = 0.1;
ITEM.description = "A uniform with a yellow symbol on the sleeve.";
ITEM.cost = 3;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (string.lower( player:GetModel() ) == "models/humans/group01/jasona.mdl") then
		return "models/humans/group03/male_02.mdl";
	end;
end;

openAura.item:Register(ITEM);