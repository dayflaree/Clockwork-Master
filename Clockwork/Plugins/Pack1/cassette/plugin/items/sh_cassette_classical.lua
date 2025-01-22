--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Classical Cassette";
ITEM.uniqueID = "cassette_classical";
ITEM.cost = 25;
ITEM.model = "models/devcon/mrp/props/casette.mdl";
ITEM.weight = .05;
ITEM.access = "V";
ITEM.category = "Music";
ITEM.business = true;
ITEM.description = "It's a cassette, with a label that reads: Classical";
ITEM.isCassette = true;
ITEM.key = t_cassette.Register("Classical", {
		{
			name = "Moonlight Sonata",
			length = 900,
			url = "https://dl.dropboxusercontent.com/u/73289868/moonlight.mp3"
		},
		{
			name = "Requiem",
			length = 533,
			url = "https://dl.dropboxusercontent.com/u/73289868/requiem.mp3"
		},
		{
			name = "1812 Overture",
			length = 908,
			url = "https://dl.dropboxusercontent.com/u/73289868/1812.mp3"
		},
		{
			name = "Ave Maria",
			length = 376,
			url = "https://dl.dropboxusercontent.com/u/73289868/ave.mp3"
		},
		{
			name = "The Marriage of Figaro Duettino",
			length = 214,
			url = "https://dl.dropboxusercontent.com/u/73289868/shawshank.mp3"
		}
	})

function ITEM:OnDrop(player, position)
end;

ITEM:Register();