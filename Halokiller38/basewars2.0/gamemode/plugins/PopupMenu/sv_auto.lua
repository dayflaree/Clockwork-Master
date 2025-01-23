--=============
--	Popup Menu
--=============
local PLUGIN = PLUGIN;

RP.popup.callbacks = {};

-- Create a new popup menu.
function RP.popup:Create(ply, entity, title, options, distance, pos)
	if (!ply) then return false; end;
	if (!pos) then pos = ply:GetEyeTrace().HitPos; end;
	if (!distance) then distance = 256; end;
	
	local sendOptions = {};
	
	for k,v in ipairs(options) do
		local id = util.CRC(tostring(v.callback)..tostring(SysTime()));
		self.callbacks[id] = v.callback;
		
		table.insert(sendOptions, {id = id, text = v.text});
	end;
	
	-- table.insert(sendOptions, {id = util.CRC(tostring({})..tostring(SysTime())), text = "Close"});
	
	RP:DataStream(ply, "newPopup", {entity, title, pos, distance, sendOptions});
end;

RP:DataHook("pressOption", function(ply, data)
	local id = data[1];
	local entity = data[2];
	
	if (RP.popup.callbacks[id]) then
		RP.popup.callbacks[id](ply, entity);
		RP.popup.callbacks[id] = nil;
	end;
end);

/*
local ply = player.GetAll()[1]
local entity = ply:GetEyeTraceNoCursor().Entity
local title = "Test"
local callback = function()
    print("win")
end
local callback2 = function(ply1, entity1)
	print(ply1, entity1)
end;
local options = {
   {text = "test", callback = callback},
   {text = "Print player entity", callback = callback2}
}

RP.popup:Create(ply, entity, title, options)
*/