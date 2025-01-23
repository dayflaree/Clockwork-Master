--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "weapon_base";
ITEM.name = "Old Flashlight";
ITEM.model = "models/raviool/flashlight.mdl";
ITEM.weight = 0.8;
ITEM.category = "Reusables";
ITEM.uniqueID = "aura_flashlight";
ITEM.fakeWeapon = true;
ITEM.meleeWeapon = true;
ITEM.description = "A old flashlight with Maglite printed on the side.";
ITEM.batch = 1;
ITEM.cost = 6;
ITEM.access = "U3AHLM";
ITEM.business = true;

openAura.item:Register(ITEM);