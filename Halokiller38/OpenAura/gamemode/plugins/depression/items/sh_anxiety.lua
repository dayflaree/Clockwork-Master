--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Anxiety Tablets";
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Swallow";
ITEM.category = "Medical";
ITEM.description = "A tin of tablets, it'll calm you down.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
		player:SetCharacterData("depression", 0);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);