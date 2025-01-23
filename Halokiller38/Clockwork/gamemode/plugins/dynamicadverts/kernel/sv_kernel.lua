--[[
	Free Clockwork!
--]]

-- A function to load the dynamic adverts.
function PLUGIN:LoadDynamicAdverts()
	self.dynamicAdverts = Clockwork:RestoreSchemaData("plugins/adverts/"..game.GetMap());
end;

-- A function to save the dynamic adverts.
function PLUGIN:SaveDynamicAdverts()
	Clockwork:SaveSchemaData("plugins/adverts/"..game.GetMap(), self.dynamicAdverts);
end;