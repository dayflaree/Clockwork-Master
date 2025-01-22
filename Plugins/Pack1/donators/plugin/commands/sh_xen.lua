
-----------------------------------------------------

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Xen");
COMMAND.tip = "Communicate with Xenian creatures around you";
COMMAND.text = "<string Message>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		return;
	end;
	
	if (player:GetFaction() != FACTION_ALIENGRUNT) then	
		Clockwork.player:Notify(player, "You are unable to speak any Xenian languages!");
		return;
	end

	local listeners = {};
	
	for k, v in pairs(_player.GetAll()) do
		if (v:GetFaction() != FACTION_ALIENGRUNT and v:GetFaction() != FACTION_VORT) then
			continue;
		end;

		if (v:Name():sub(1, 13):lower() == "'turr'chackt'" or v:GetFaction() == FACTION_ALIENGRUNT) then
			listeners[#listeners + 1] = v;
		end;
	end;

	Clockwork.chatBox:Add(listeners, player, "ic", text);
	player:EmitSound("npc/ichthyosaur/attack_growl1.wav");
end;

COMMAND:Register();
