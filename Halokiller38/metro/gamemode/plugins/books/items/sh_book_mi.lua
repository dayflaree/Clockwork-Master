--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = ":: Metro Ideology ::";
ITEM.model = "models/avoxgaming/mrp/jake/props/book3.mdl";
ITEM.cost = 8;
ITEM.uniqueID = "book_mi";
ITEM.description = "This was not writen by some crazy red, or fascist pig. Yet simply by a man who has common sense and posseses a sane mind.";
ITEM.bookInformation = [[
WIP
]];

openAura.item:Register(ITEM);