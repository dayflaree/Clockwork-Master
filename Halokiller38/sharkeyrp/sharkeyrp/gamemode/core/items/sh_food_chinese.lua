local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Chinese Food";
ITEM.category = "Food";
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";

ITEM.cost = 50;

function ITEM:OnUse(player)
	player:SetHealth(math.Clamp(player:Health()+75, 0, 100));
	self:RemoveInventory(player);
	return true;
end;
	
function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("A soggy box that reeks of a smell similar to body odor. Inside is a nutritious meal!");
	descMeta:NewLine();
	descMeta:Text("Using this item will regenerate your health by "); descMeta:Color(Color(0, 255, 100)); descMeta:Text("75 "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(" points!");
end;

RP.item:New(ITEM);