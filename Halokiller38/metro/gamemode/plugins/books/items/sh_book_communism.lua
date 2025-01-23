--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Communism.";
ITEM.model = "models/maver1k_XVII/metro_book_darwin.mdl";
ITEM.cost = 11;
ITEM.uniqueID = "book_communism";
ITEM.description = "A blood about communism.";
ITEM.bookInformation = [[


]];

openAura.item:Register(ITEM);