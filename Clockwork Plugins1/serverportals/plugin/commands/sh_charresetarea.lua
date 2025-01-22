
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharResetArea");
COMMAND.tip = "Reset a character's area so they can use it on the main server again. Needs exact character name, not case sensitive.";
COMMAND.text = "<string CharName>"
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local charName = string.lower(arguments[1]);
	for k, v in pairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (string.lower(v:Name()) == charName) then
				Clockwork.player:Notify(v, player:Name().." has reset your area.");
				Clockwork.player:Notify(player, "You have reset "..v:Name().."'s area.");
				v:SetCharacterData("CurrentServer", "");
				
				return;
			else
				for k2, v2 in pairs(v:GetCharacters()) do
					if (string.lower(v2.name) == charName) then
						Clockwork.player:Notify(v, player:Name().." has reset "..v2.name.."'s area.");
						Clockwork.player:Notify(player, "You have reset "..v2.name.."'s area.");
						v2.data["CurrentServer"] = "";
						
						return;
					end;
				end;
			end;
		end;
	end;
end;

COMMAND:Register();