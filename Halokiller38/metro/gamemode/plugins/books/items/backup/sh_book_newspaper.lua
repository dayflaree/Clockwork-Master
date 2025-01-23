--[[
Name: "sh_book_out.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Newspaper";
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
ITEM.uniqueID = "book_newspaper";
ITEM.description = "The Newspaper is here!";
ITEM.cost = 5;
ITEM.bookInformation = [[
	I'm still wating for someone to write some damn news, contact  <br>
	me on steam if you would like to write some epic IC news  //Tokiz
]];

openAura.item:Register(ITEM);