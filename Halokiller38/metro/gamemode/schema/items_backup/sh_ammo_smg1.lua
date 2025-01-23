--[[
Name: "sh_ammo_smg1.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 3;
ITEM.base = "ammo_base";
ITEM.name = "5.56x45mm Rounds";
ITEM.model = "models/items/boxmrounds.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_smg1";
ITEM.ammoClass = "smg1";
ITEM.ammoAmount = 60;
ITEM.description = "A large green container with 5.56x45mm on the side.";
ITEM.cost = 1;
ITEM.access = "A";
ITEM.business = true;

openAura.item:Register(ITEM);