local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlySetArmor");
COMMAND.tip = "Set a player's Armor.";
COMMAND.text = "<string Name> [number Amount]";
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	if target then
		if !arguments[2] then
			arguments[2] = target:GetMaxArmor()
		end

		target:SetArmor(tonumber(arguments[2]))
		
		if (player != target) then
			target:Notify("Your armor has been set to "..tonumber(arguments[2])..".")
			player:Notify("You set "..target:Name().."'s armor to "..tonumber(arguments[2])..".")
		else
			player:Notify("You have set your own armor to "..tonumber(arguments[2])..".")
		end
	else
		player:Notify(arguments[1].." is not a valid player!")
	end
end;

COMMAND:Register();