--[[
Name: "cl_hooks.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "bp_paper") then
		if ( entity:GetSharedVar("sh_Note") ) then
			options["Read"] = "bp_paperOption";
		else
			options["Write"] = "bp_paperOption";
		end;
	end;
end;