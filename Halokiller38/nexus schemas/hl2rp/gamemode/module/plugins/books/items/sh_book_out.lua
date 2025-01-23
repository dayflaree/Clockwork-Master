--[[
Name: "sh_book_out.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "book_base";
ITEM.name = "Outlands 2015";
ITEM.model = "models/props_lab/frame002a.mdl";
ITEM.uniqueID = "book_out";
ITEM.description = "A photo with a bunch of resistance members on it.";
ITEM.bookInformation = [[
	<img src = "http://www.dazzlemods.com/resistance.jpg" alt = "[A photo with a bunch of resistance members on it]."/>
]];

resistance.item.Register(ITEM);