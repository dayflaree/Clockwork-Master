--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "::The fourth protocol::";
ITEM.model = "models/maver1k_XVII/metro_book_darwin.mdl";
ITEM.cost = 8;
ITEM.uniqueID = "book_tfp";
ITEM.description = "A book about the Reich.";
ITEM.bookInformation = [[
*You see an old note on the back of the book*
"The truth behind the war lies within these pages, thou I will probably not be alive when you find it-- make sure this story is heard!"
]];

openAura.item:Register(ITEM);