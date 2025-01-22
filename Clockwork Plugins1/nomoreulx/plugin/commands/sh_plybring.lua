local COMMAND = Clockwork.command:New("PlyBring");
COMMAND.tip = "Brings a player to you.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] );
	
	if (target) then
		Clockwork.player:SetSafePosition( target, player:GetPos() );
		Clockwork.player:Notify(player, target:Name().." has been brought to your location.");
		Clockwork.player:Notify(target, "You have been brought to "..player:Name().."'s location.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register()