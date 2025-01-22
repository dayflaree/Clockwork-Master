local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Figgy Pudding";
ITEM.uniqueID = "pudding";
ITEM.cost = 30;
ITEM.health = 5;
ITEM.hunger = 40;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.2;
ITEM.description = "A classic pudding, consisting mainly of figs. Add some alcohol to the top, to light on fire, and you've got a classic christmas treat.";

function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/pack2/bluelight");
end;

ITEM:Register();