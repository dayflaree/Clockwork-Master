--[[
Name: "init.lua".
Product: "Skeleton".
--]]

--[[
	Store the current gamemode table here so that
	resistance can access it internally.
-]]
RESISTANCE = GM;

-- We want clients to download the client initialisation file.
AddCSLuaFile("cl_init.lua");

-- Derive the gamemode from resistance.
DeriveGamemode("resistance");