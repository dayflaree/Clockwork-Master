local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Bread";
ITEM.uniqueID = "uu_bread";
ITEM.cost = 60;
ITEM.model = "models/bioshockinfinite/dread_loaf.mdl";
ITEM.weight = 0.7;
ITEM.health = 2;
ITEM.hunger = 30;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A delicious smelling loaf of bread. It's oddly porous, but still tasty. A Universal Union logo is toasted onto the top.";
 
ITEM:Register();