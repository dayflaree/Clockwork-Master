local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Water Bottle";
ITEM.category = "Food";
ITEM.model = "models/props/cs_office/Water_bottle.mdl";

ITEM.cost = 25;

function ITEM:OnUse(player)
	player:SetHealth(math.Clamp(player:Health()+25, 0, 100));
	self:RemoveInventory(player);
	return true;
end;
	
function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("A plastic bottle filled with a clear liquid.");
	descMeta:NewLine();
	descMeta:Text("Using this item will regenerate your health by "); descMeta:Color(Color(0, 255, 100)); descMeta:Text("25 "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(" points!");
end;

RP.Item:New(ITEM);