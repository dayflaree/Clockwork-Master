local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Cactus";
ITEM.category = "Food";
ITEM.model = "models/props_lab/cactus.mdl";

ITEM.cost = 50;

function ITEM:OnUse(player)
	player:SetHealth(math.Clamp(player:Health()-25, 0, 100));
	self:RemoveInventory(player);
	return true;
end;
	
function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("A dry cactus... inside there may be some water?");
	descMeta:NewLine();
	descMeta:Text("Who knows what attempting to eat this will do to you. You gotta be pretty stupid to do that.");
end;

RP.Item:New(ITEM);