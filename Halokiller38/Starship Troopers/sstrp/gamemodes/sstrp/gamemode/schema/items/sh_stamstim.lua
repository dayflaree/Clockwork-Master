--[[
Name: "sh_chinese_takeout.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your items.
--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.name = "Stamina Stimulant"; -- The name of the item, obviously.
ITEM.cost = 10; -- How much does this item cost for people with business access to it?
ITEM.model = "models/Items/battery.mdl"; -- What model does the item use.
ITEM.weight = 0.5; -- How much does it weigh in kg?
ITEM.access = "b"; -- What flags do you need to have access to this item in your business menu (you only need one of them)?
ITEM.useText = "Use"; -- What does the text say instead of Use, remove this line to keep it as Use.
ITEM.category = "Medical Supplies"; -- What category does the item belong in?
ITEM.business = true; -- Is this item available on the business menu (if the player has access to it)?
ITEM.description = "Designed to give a quick burst of energy, simular in chemical makeup to adrenaline."; -- Give a small description of the item.

--[[
	Called when a player uses the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnUse(player, itemEntity)
player:SetCharacterData( "stamina", 100) -- LOLOLOLOL ONLY HAS TWO ARGUMENTS LOLOLOLOLOLOOOLOLOLOLOLOLOLOLOLOLOLOLOLOLOL
end;

--[[
	Called when a player drops the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDrop(player, position)
	-- If the item doesn't have this function, it cannot be dropped.
end;

--[[
	Called when a player destroys the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDestroy(player)
	-- If the item doesn't have this function, it cannot be destroyed.
end;

-- Register the item to the nexus framework.
nexus.item.Register(ITEM);