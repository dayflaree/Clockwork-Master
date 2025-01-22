--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local PLUGIN = PLUGIN;

-- A function to load the monitors.
function PLUGIN:LoadConFields()
	local confields = Clockwork.kernel:RestoreSchemaData("plugins/confiscationfield/"..game.GetMap());
	
	for k, v in pairs(confields) do
		local entity = ents.Create("cw_confield");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetAngles(v.angles);
		end;
	end;
end;

-- A function to save the monitors.
function PLUGIN:SaveConFields()
	local confields = {};
	
	for k, v in pairs(ents.FindByClass("cw_confield")) do
		confields[#confields + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/confiscationfield/"..game.GetMap(), confields);
end;