--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Acoustic Guitar Cassette";
ITEM.uniqueID = "cassette_guitar";
ITEM.cost = 25;
ITEM.model = "models/devcon/mrp/props/casette.mdl";
ITEM.weight = .05;
ITEM.access = "V";
ITEM.category = "Music";
ITEM.business = true;
ITEM.description = "It's a cassette, with a label that reads: Acoustic Guitar";
ITEM.isCassette = true;
ITEM.key = t_cassette.Register("Acoustic - Guitar", {
		{
			name = "Ain't No Sunshine",
			length = 143,
			url = "https://dl.dropboxusercontent.com/u/73289868/aintnosunshine.mp3"
		},
		{
			name = "I See Fire",
			length = 289,
			url = "https://dl.dropboxusercontent.com/u/73289868/iseefire.mp3"
		},
		{
			name = "See You Again",
			length = 222,
			url = "https://dl.dropboxusercontent.com/u/73289868/seeuagain.mp3"
		},
		{
			name = "Hey There Delilah",
			length = 231,
			url = "https://dl.dropboxusercontent.com/u/73289868/delilah.mp3"
		}
	})

function ITEM:OnDrop(player, position)
end;

ITEM:Register();