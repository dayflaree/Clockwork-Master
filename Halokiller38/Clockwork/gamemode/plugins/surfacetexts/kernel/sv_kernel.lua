--[[
	Free Clockwork!
--]]

-- A function to load the surface texts.
function PLUGIN:LoadSurfaceTexts()
	self.surfaceTexts = Clockwork:RestoreSchemaData("plugins/texts/"..game.GetMap());
end;

-- A function to save the surface texts.
function PLUGIN:SaveSurfaceTexts()
	Clockwork:SaveSchemaData("plugins/texts/"..game.GetMap(), self.surfaceTexts);
end;