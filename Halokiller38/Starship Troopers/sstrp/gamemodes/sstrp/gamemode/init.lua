--[[
Name: "init.lua".
Product: "Starship Troopers".
--]]


-- Store the current gamemode table here so that nexus can access it internally.
NEXUS = GM;

-- We want clients to download the client initialisation file.
AddCSLuaFile("cl_init.lua");

-- Derive the gamemode from nexus.
DeriveGamemode("nexus");