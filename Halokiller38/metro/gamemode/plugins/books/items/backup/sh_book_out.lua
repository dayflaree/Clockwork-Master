--[[
Name: "sh_book_out.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Old photo, 2010";
ITEM.model = "models/props_lab/frame002a.mdl";
ITEM.cost = 5;
ITEM.uniqueID = "book_out";
ITEM.description = "A photo with a bunch of people on it.";
ITEM.bookInformation = [[
	<img src = "http://img31.imageshack.us/img31/2064/resistancet.jpg" alt = "[A photo with a bunch of people on it]."/>
]];

openAura.item:Register(ITEM);