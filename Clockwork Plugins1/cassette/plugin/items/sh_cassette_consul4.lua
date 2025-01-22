--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Consul Speech Cassette No. 4";
ITEM.uniqueID = "consul_speech4";
ITEM.cost = 25;
ITEM.model = "models/devcon/mrp/props/casette.mdl";
ITEM.weight = .05;
ITEM.access = "V";
ITEM.category = "Music";
ITEM.business = true;
ITEM.description = "It's a cassette, with a label that reads: Consul Speech No. 4";
ITEM.isCassette = true;
ITEM.key = t_cassette.Register("Consul4", {
		{
			name = "Consul Part 4",
			length = 196,
			url = "https://dl.dropboxusercontent.com/u/73289868/casettes/consulspeech4.mp3"
		}
	})

function ITEM:OnDrop(player, position)
end;

ITEM:Register();