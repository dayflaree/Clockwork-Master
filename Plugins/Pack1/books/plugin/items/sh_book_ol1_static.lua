
local ITEM = Clockwork.item:New("book_base");
ITEM.name = "Outlands 2020 - Photo 1";
ITEM.model = "models/props_lab/frame002a.mdl";
ITEM.uniqueID = "book_ol1_static";
ITEM.description = "A photo of three very familiar-looking faces...";
ITEM.bookInformation = [[
	<img src = "http://i.imgur.com/GTZp3fH.png" alt = "[A photo with a bunch of resistance members on it]."/>
]];

function ITEM:CanPickup(player, bQuickUse, entity)
	return false;
end;

ITEM:Register();