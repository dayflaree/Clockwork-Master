ENT.Type       		= "anim"
ENT.Base       		= "base_anim"
ENT.PrintName      	= "Fridge V2"
ENT.Author    		= "_Undefined"
ENT.Contact  		= "admin@equinox.cc"
ENT.Purpose  		= "Fridge!"
ENT.Instructions    = "Press E to get some!"
ENT.Spawnable      	= true
ENT.AdminSpawnable  = true

Items = {}

function RegisterItem(ITEM)
	Items[ITEM.Name] = ITEM
end

local items = file.FindInLua("entities/sent_fridge/items/*.lua")
for _, filename in pairs(items) do
	if SERVER then
		AddCSLuaFile("entities/sent_fridge/items/"..filename)
	end
	include("entities/sent_fridge/items/"..filename)
end

function Restock()
	for k, ITEM in pairs(Items) do
		ITEM.StockLevel = ITEM.DefaultStockLevel
	end
end
