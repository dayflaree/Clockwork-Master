local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Pineapple";
ITEM.uniqueID = "uu_pineapple";
ITEM.cost = 40;
ITEM.model = "models/bioshockinfinite/hext_pineapple.mdl";
ITEM.weight = 0.2;
ITEM.health = 2;
ITEM.hunger = 20;
ITEM.thirst = 10;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A synthetic odd looking fruit, consisting of a spiky silicone shell, filled with pale yellow gel. It tastes reminiscent of pineapple candy, but saccharin sweet.";

ITEM:Register();