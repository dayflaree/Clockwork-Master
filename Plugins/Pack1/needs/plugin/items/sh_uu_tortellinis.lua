local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Tortellinis";
ITEM.uniqueID = "uu_tortellinis";
ITEM.cost = 60;
ITEM.model = "models/pg_props/pg_food/pg_tortellinis.mdl";
ITEM.weight = 0.5;
ITEM.health = 3;
ITEM.hunger = 30;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A box of Tortellini adorning the UU Brand, that seems incredibly cheaply produced. It falls apart when picked at, and tastes dry and bland. Shut up and eat my tortellinis, bitch!";

ITEM:Register();