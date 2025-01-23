--[[
	Free Clockwork!
--]]

Clockwork:HookDataStream("MapScene", function(data)
	Clockwork.plugin:FindByID("Map Scenes").mapScene = data;
end);