
local PLUGIN = PLUGIN;
local NAME_CASH = Clockwork.option:GetKey("name_cash");

local COMMAND = Clockwork.command:New("Claim"..string.gsub(NAME_CASH, "%s", ""));
COMMAND.tip = "Claim your monthly Gold Member "..Clockwork.kernel:Pluralize(string.lower(NAME_CASH))..".";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player.cwDonation and player.cwLastDonation) then
		local iLastClaimTokens = player:GetData("LastClaimTokens");

		if (!iLastClaimTokens or iLastClaimTokens < player.cwLastDonation) then
			player:SetData("LastClaimTokens", player.cwLastDonation);

			Clockwork.player:GiveCash(
				player, 3000, "claiming gold member "..Clockwork.kernel:Pluralize(string.lower(NAME_CASH))
			);

			Clockwork.player:Notify(player, "You have successfully claimed your "..Clockwork.kernel:Pluralize(string.lower(NAME_CASH))..".");
		else
			Clockwork.player:Notify(player, "You cannot claim your "..Clockwork.kernel:Pluralize(string.lower(NAME_CASH)).." yet!");
		end;
	else
		Clockwork.player:Notify(player, "You must have an active Gold Membership!");
	end;
end;

COMMAND:Register();
