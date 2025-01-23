local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Soda";
ITEM.category = "Food";
ITEM.model = "models/props_junk/PopCan01a.mdl";

ITEM.cost = 30;

function ITEM:OnUse(player)
	player:SetHealth(math.Clamp(player:Health()+35, 0, 100));
	self:RemoveInventory(player);
	return true;
end;
	
function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("A metalic can filled with a fuzzy liquid.");
	descMeta:NewLine();
	descMeta:Text("Using this item will regenerate your health by "); descMeta:Color(Color(0, 255, 100)); descMeta:Text("35 "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(" points!");
end;

RP.Item:New(ITEM);