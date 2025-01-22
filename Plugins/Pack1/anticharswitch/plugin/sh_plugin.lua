
-----------------------------------------------------
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

if (CLIENT) then
	Clockwork.config:AddToSystem("Anti Char Switch", "anti_charswitch", "Whether or not the switching of chars should be prohibited.");

	return;
end;

Clockwork.config:Add("anti_charswitch", false);

function PLUGIN:PlayerCanSwitchCharacter(player, character)
	if (Clockwork.config:Get("anti_charswitch"):Get()) then
		return "You cannot switch characters when the anti char switch is active!";
    end
end