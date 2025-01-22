
-----------------------------------------------------

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Ant");
COMMAND.tip = "Talk to Antlion's near you.";
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
	
	if (player:GetFaction() != FACTION_ANTLION) then	
		Clockwork.player:Notify(player, "You are not an Antlion!");
		return;
	end

	local listeners = {};
	
	for k, v in pairs(_player.GetAll()) do
		if (v:GetFaction() != FACTION_ANTLION) then
			continue;
		end;

		listeners[#listeners + 1] = v;
	end;

	Clockwork.chatBox:Add(listeners, player, "ic", text);
	player:EmitSound("npc/antlion/idle2.wav");
end;

COMMAND:Register();
