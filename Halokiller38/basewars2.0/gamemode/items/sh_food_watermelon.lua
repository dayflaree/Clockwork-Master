local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Watermelon";
ITEM.category = "Food";
ITEM.model = "models/props_junk/watermelon01.mdl";

ITEM.cost = 50;

function ITEM:OnUse(player)
	player:SetHealth(math.Clamp(player:Health()+100, 0, 100));
	self:RemoveInventory(player);
	return true;
end;
	
function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("A yummy melon!");
	descMeta:NewLine();
	descMeta:Color(Color(150, 150, 150)); descMeta:Text("Protip: Sell to players of african decent for a lot of money $$$)");
	descMeta:Color(Color(255, 255, 255));
	descMeta:NewLine();
	descMeta:Text("Using this item will regenerate your health "); descMeta:Color(Color(100, 255, 100)); descMeta:Text("FULLY!");
end;

RP.Item:New(ITEM);