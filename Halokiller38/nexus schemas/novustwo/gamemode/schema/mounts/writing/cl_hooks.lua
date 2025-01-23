--[[
Name: "cl_hooks.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

-- Called when an entity's menu options are needed.
function MOUNT:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "nx_paper") then
		if ( entity:GetSharedVar("sh_Note") ) then
			options["Read"] = "nx_paperOption";
		else
			options["Write"] = "nx_paperOption";
		end;
	end;
end;