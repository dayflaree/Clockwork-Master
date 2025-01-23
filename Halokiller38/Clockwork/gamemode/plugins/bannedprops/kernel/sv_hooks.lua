--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when a player attempts to spawn a prop.
function PLUGIN:PlayerSpawnProp(player, model)
	model = Clockwork:Replace(model, "\\", "/");
	model = Clockwork:Replace(model, "//", "/");
	model = string.lower(model);
	
	if (!player.nextSpawnProp or CurTime() > player.nextSpawnProp) then
	
		if (!Clockwork.player:IsAdmin(player)) then
			if (string.find(model, "propane")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				
				return false;
			end;
			
			
			if (string.find(model, "props_phx/")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			if (string.find(model, "hunter/")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			if (string.find(model, "XQM/")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			if (string.find(model, "xeon133")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			if (string.find(string.lower(model), "mechanics/")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			if (string.find(model, "weapons/")) then
				Clockwork.player:Notify(player, "You cannot spawn banned props!");
				return false;
			end;
			
			for k, v in pairs(self.bannedProps) do
				if (string.lower(v) == model) then
					Clockwork.player:Notify(player, "You cannot spawn banned props!");
					
					return false;
				end;
			end;
		end;
		player.nextSpawnProp = CurTime() + 4;
	else
		Clockwork.player:Notify(player, "You must wait a few moments before spawning another prop!");
		return false;
	end;
end;