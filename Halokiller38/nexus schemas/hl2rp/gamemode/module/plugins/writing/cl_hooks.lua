--[[
Name: "cl_hooks.lua".
Product: "Kyron".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "roleplay_paper") then
		if ( entity:GetSharedVar("sh_Note") ) then
			options["Read"] = "roleplay_paperOption";
		else
			options["Write"] = "roleplay_paperOption";
		end;
	end;
end;