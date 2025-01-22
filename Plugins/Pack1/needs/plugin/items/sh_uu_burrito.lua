local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Burrito";
ITEM.uniqueID = "uu_burrito";
ITEM.cost = 75;
ITEM.model = "models/pg_props/pg_food/pg_burrito_pack.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.hunger = 40;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A pre-packaged riceflour wrap, encompassing soy lecithin meat substitute, and pieces of arrowroot gel, creating a would-be burrito. It is largely unappetising, and has clearly only been made at the request of a CAB member.";
 
ITEM:Register();