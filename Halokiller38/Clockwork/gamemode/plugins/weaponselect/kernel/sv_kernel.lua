--[[
	Free Clockwork!
--]]

Clockwork.config:Add("weapon_selection_multi", false);

Clockwork:HookDataStream("SelectWeapon", function(player, data)
	if (type(data) == "string") then
		if (player:HasWeapon(data)) then
			player:SelectWeapon(data);
		end;
	end;
end);