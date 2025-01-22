local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharKnockOut");
COMMAND.tip = "Knockout a character.";
COMMAND.text = "<string Name> [number Seconds] [boolean Force Knockout]";
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])

	if target then
		if target:IsFrozen() then
			player:Notify(target:Name().." is frozen. Ragdolling them will result in unfreezing them: unfreeze them first.")
			return;
		end

		if !arguments[2] then
			arguments[2] = Clockwork.config:Get("knockout_time"):Get()
		end
		
		Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, tonumber(arguments[2]))
		
		if (target != player) then
			target:Notify("Your have been knocked out for "..tonumber(arguments[2]).." seconds.")
			player:Notify("You knocked "..target:Name().." out for "..tonumber(arguments[2]).." seconds.")
		else
			player:Notify("You have knocked yourself out for "..tonumber(arguments[2]).." seconds.")
		end
	else
		player:Notify(arguments[1].." is not a valid player!")
	end
end;

COMMAND:Register();