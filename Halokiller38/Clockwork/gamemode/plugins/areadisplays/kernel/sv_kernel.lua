--[[
	Free Clockwork!
--]]

Clockwork:HookDataStream("EnteredArea", function(player, data)
	if (data[1] and data[2] and data[3]) then
		hook.Call("PlayerEnteredArea", Clockwork, player, data[1], data[2], data[3]);
	end;
end);

-- A function to load the area names.
function PLUGIN:LoadAreaDisplays()
	self.areaDisplays = Clockwork:RestoreSchemaData("plugins/areas/"..game.GetMap());
end;

-- A function to save the area names.
function PLUGIN:SaveAreaDisplays()
	Clockwork:SaveSchemaData("plugins/areas/"..game.GetMap(), self.areaDisplays);
end;