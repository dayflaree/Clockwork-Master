local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyFreeze");
COMMAND.tip = "Freeze/Unfreeze a player.";
COMMAND.text = "<string Name>";
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	if target then
		echo = Clockwork.config:Get("admin_echoes"):Get()
		if !target:IsFrozen() then
			if target:GetRagdollState() != RAGDOLL_NONE then
				Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
				player:Notify("Unragdolled the target.")
			end
			target:Freeze(true)
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have frozen "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has frozen you.")
				else
					Clockwork.player:Notify(player, "You have frozen yourself.")
				end
			end
			player:Notify("Remember that if the player gets ragdolled, you may need to re-freeze them.")
		else
			target:Freeze(false)
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have unfrozen "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has unfrozen you.")
				else
					Clockwork.player:Notify(player, "You have unfrozen yourself.")
				end
			end
		end
	else
		player:Notify(arguments[2].." is not a valid player!")
	end
end;

COMMAND:Register();