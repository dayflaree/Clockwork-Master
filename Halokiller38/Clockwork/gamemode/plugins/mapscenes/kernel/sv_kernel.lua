--[[
	Free Clockwork!
--]]

-- A function to load the map scenes.
function PLUGIN:LoadMapScenes()
	local mapScenes = Clockwork:RestoreSchemaData("plugins/scenes/"..game.GetMap());
	self.mapScenes = {};
	
	for k, v in pairs(mapScenes) do
		self.mapScenes[#self.mapScenes + 1] = v;
	end;
end;

-- A function to save the map scenes.
function PLUGIN:SaveMapScenes()
	local mapScenes = {};
	
	for k, v in pairs(self.mapScenes) do
		mapScenes[#mapScenes + 1] = v;
	end;
	
	Clockwork:SaveSchemaData("plugins/scenes/"..game.GetMap(), mapScenes);
end;