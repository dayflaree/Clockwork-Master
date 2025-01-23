--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Clean Water";
ITEM.model = "models/props_junk/glassbottle01a.mdl";
ITEM.weight = 0.8;
ITEM.useText = "Drink";
ITEM.category = "Consumables"
ITEM.description = "A glass bottle full of clean water, the radiation has been filtered out.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 3, 0, 100) );
	
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);