--[[
	Free Clockwork!
--]]

Clockwork:HookDataStream("SurfaceTexts", function(data)
	Clockwork.plugin:FindByID("Surface Texts").surfaceTexts = data;
end);

Clockwork:HookDataStream("SurfaceTextAdd", function(data)
	local PLUGIN = Clockwork.plugin:FindByID("Surface Texts");
	
	if (PLUGIN) then
		PLUGIN.surfaceTexts[#PLUGIN.surfaceTexts + 1] = data;
	end;
end);

Clockwork:HookDataStream("SurfaceTextRemove", function(data)
	local PLUGIN = Clockwork.plugin:FindByID("Surface Texts");
	
	for k, v in pairs(PLUGIN.surfaceTexts) do
		if (v.position == data) then
			PLUGIN.surfaceTexts[k] = nil;
		end;
	end;
end);