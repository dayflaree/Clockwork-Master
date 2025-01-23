--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Artifact Base";
ITEM.color = Color(255, 255, 255, 255);
ITEM.category = "Artifacts";
ITEM.isBaseItem = true;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);