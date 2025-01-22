--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "cw_uenotepad") then
		if (entity:GetDTBool(1)) then
			options["Read Unconfirmed Text"] = "cw_notepadReadUnconfirmedOption";
			if (Clockwork.Client:GetFaction() == FACTION_MPF or Clockwork.Client:GetFaction() == FACTION_CWU) then
				options["Confirm Text"] = "cw_notepadConfirmOption";
			end;
		end;

		if (entity:GetDTBool(0)) then
			options["Read Text"] = "cw_notepadReadOption";
			options["Edit"] = "cw_notepadEditOption";
		else
			options["Write"] = "cw_notepadWriteOption";
		end;
	end;
end;