
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SilentDewhitelist");
COMMAND.tip = "Silently remove a player from a whitelist.";
COMMAND.text = "<string Name> <string Faction>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 2));
		
		if (factionTable) then
			if (factionTable.whitelist) then
				if (Clockwork.player:IsWhitelisted(target, factionTable.name)) then
					Clockwork.player:SetWhitelisted(target, factionTable.name, false);
					Clockwork.player:SaveCharacter(target);	
				else
					Clockwork.player:Notify(player, target:Name().." is not on the "..factionTable.name.." whitelist!");
				end;
			else
				Clockwork.player:Notify(player, factionTable.name.." does not have a whitelist!");
			end;
		else
			Clockwork.player:Notify(player, factionTable.name.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();