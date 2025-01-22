--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Consul Speech Cassette No. 3";
ITEM.uniqueID = "consul_speech3";
ITEM.cost = 25;
ITEM.model = "models/devcon/mrp/props/casette.mdl";
ITEM.weight = .05;
ITEM.access = "V";
ITEM.category = "Music";
ITEM.business = true;
ITEM.description = "It's a cassette, with a label that reads: Consul Speech No. 3";
ITEM.isCassette = true;
ITEM.key = t_cassette.Register("Consul3", {
		{
			name = "Consul Part 3",
			length = 26,
			url = "https://dl.dropboxusercontent.com/u/73289868/casettes/consulspeech3.mp3"
		}
	})

function ITEM:OnDrop(player, position)
end;

ITEM:Register();