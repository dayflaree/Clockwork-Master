--[[
Name: "sh_ammo_pistol.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire resistance framework
	for cool little tricks and variables you can use with your items.
--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.base = "ammo_base"; -- The base of the item, in this case use the ammo base (see the resistance framework).
ITEM.name = "9mm Pistol Bullets"; -- The name of the item, obviously.
ITEM.cost = 20; -- How much does this item cost for people with business access to it?
ITEM.model = "models/items/boxsrounds.mdl"; -- What model does the item use.
ITEM.weight = 1; -- How much does it weigh in kg?
--[[
	Instead of going by flags, we're gonna go by faction. Make it so the Citizen faction has access
	to this item in their business menu.
--]]
ITEM.factions = {FACTION_CITIZEN};
ITEM.uniqueID = "ammo_pistol";  -- Optionally, you can manually set a unique ID for an item, but usually you don't need to.
ITEM.business = true;  -- Is this item available on the business menu (if the player has access to it)?
ITEM.ammoClass = "pistol"; -- What class of ammo does this item give you?
ITEM.ammoAmount = 20; -- How much ammo does this item give you?
ITEM.description = "A container filled with bullets and 9mm printed on the side.";  -- Give a small description of the item.

-- Register the item to the resistance framework.
resistance.item.Register(ITEM);