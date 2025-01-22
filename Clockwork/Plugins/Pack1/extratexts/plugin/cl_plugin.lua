--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]
local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("SurfaceTexts", function(data)
	PLUGIN.storedList = data;
end);

Clockwork.datastream:Hook("SurfaceTextAdd", function(data)
	PLUGIN.storedList[#PLUGIN.storedList + 1] = data;
end);

Clockwork.datastream:Hook("SurfaceTextRemove", function(data)
	for k, v in pairs(PLUGIN.storedList) do
		if (v.position == data) then
			PLUGIN.storedList[k] = nil;
		end;
	end;
end);