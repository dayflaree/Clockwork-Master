--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = ":: Power of the Reich ::";
ITEM.model = "models/maver1k_XVII/metro_book_darwin.mdl";
ITEM.cost = 11;
ITEM.uniqueID = "book_potr";
ITEM.description = "A book about facism.";
ITEM.bookInformation = [[
WIP
]];

openAura.item:Register(ITEM);