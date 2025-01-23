--[[
Name: "sh_weapon_pistol.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your items.
	
] lua_run_cl local tr = LocalPlayer():GetEyeTrace() print(tr.Entity:GetModel())
models/weapons/w_prototype_3.mdl
] lua_run_cl local tr = LocalPlayer():GetEyeTrace() print(tr.Entity:GetClass())
nx_br2


--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.base = "weapon_base"; -- The base of the item, in this case use the weapon base (see the nexus framework).
ITEM.name = "Battle Rifle Prototype 2"; -- The name of the item, obviously.
ITEM.cost = 2900; -- How much does this item cost for people with business access to it?
ITEM.model = "models/weapons/w_prototype_3.mdl"; -- What model does the item use.
ITEM.weight = 1; -- How much does it weigh in kg?
ITEM.access = "b"; -- What flags do you need to have access to this item in your business menu (you only need one of them)?
ITEM.uniqueID = "nx_br2"; -- Optionally, you can manually set a unique ID for an item, but usually you don't need to.
ITEM.business = true; -- Is this item available on the business menu (if the player has access to it)?
ITEM.description = "A BR2 is a scoped weapon, with an integral silencer, and its main purpose is to aim in medium to long-range target acquisition."; -- Give a small description of the item.
ITEM.loweredOrigin = Vector(3, 0, -4); -- For weapons, you can manually set the lowered (holstered) origin of the view model.
ITEM.loweredAngles = Angle(0, 45, 0); -- For weapons, you can manually set the lowered (holstered) angles of the view model.

-- Register the item to the nexus framework.
nexus.item.Register(ITEM);