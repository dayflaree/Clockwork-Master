--[[
Name: "cl_hooks.lua".
Product: "Kyron".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "roleplay_book") then
		options["View"] = "roleplay_bookView";
		options["Take"] = "roleplay_bookTake";
	end;
end;