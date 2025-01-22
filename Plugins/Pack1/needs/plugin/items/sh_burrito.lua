local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Packaged Burrito";
ITEM.uniqueID = "burrito";
ITEM.cost = 75;
ITEM.model = "models/pg_props/pg_food/pg_burrito_pack.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.hunger = 40;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A tortilla wrap, encompassing meat and traditional Mexican spices and beans. Instructions read 'open one end of package, microwave for 2 minutes or until warm'.";
 
-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;
 
ITEM:Register();