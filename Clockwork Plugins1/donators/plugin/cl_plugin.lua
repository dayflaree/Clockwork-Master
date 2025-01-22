
-----------------------------------------------------

local PLUGIN = PLUGIN;

function PLUGIN:ChatBoxAdjustInfo(info)
	if (IsValid(info.speaker)) then
		if (Clockwork.player:HasFlags(info.speaker, "D")) then
			if (!info.speaker:IsAdmin() and !info.speaker:IsUserGroup("operator")) then
				info.icon = "icon16/heart.png";
			end;
		end;
	end;
end;
