--[[--
	-- Generic Incomplete Gamemode --

	File: cl_inventory.lua
	Purpose: Provides serverside functions for the inventory.
	Created: 18th August 2010 By: _Undefined
	Modified: 21st August 2010 By: Advert
	Assigned to: Advert
--]]--

return -- not functional
-- This will change a bit due to changes in cl_inventory
function GM:GetItem(id)
	-- Placeholder
	-- This function will return itemdata, or failing that, false.
end

function GM:AddItem(itemdata)
	-- Placeholder
	-- This function will create a new item, storing it in the database, serialized with glon.
end

function GM:UpdateItem(id, itemdata)
	-- Placeholder
	-- This function will update an item in the database, serialized with glon.
end

function GM:SpawnItem(id, itemdata)
	-- Placeholder
	-- This function will spawn an item in the world.
	-- Takes an optional itemdata argument, which can be used to modify the default items data in some way.
end
