--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;
--[[
-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	local itemTable = entity:GetItemTable();
	
	if (class == "cw_item" and itemTable.isBook) then
		options["Read"] = "cw_bookView";
	end;
end;
]]