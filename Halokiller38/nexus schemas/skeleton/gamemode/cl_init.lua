--[[
Name: "cl_init.lua".
Product: "Skeleton".
--]]

--[[
	Store the current gamemode table here so that
	resistance can access it internally.
-]]
RESISTANCE = GM;

-- Derive the gamemode from resistance.
DeriveGamemode("resistance");