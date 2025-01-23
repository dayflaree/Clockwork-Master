--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

RP.Cash = {};

local PLUGIN = PLUGIN;

PLUGIN.name = "Cash";

local COMMAND = {};
COMMAND.description = "Drops cash";
COMMAND.arguments = {{"Number", "Amount"}};
function COMMAND:OnRun(player, args)
	local trace = player:GetEyeTrace();
	if (player:CanAfford(args["Amount"])) then
		player:TakeCash(args["Amount"]);
		RP.Cash:CreateCash(trace.HitPos, Angle(0, 0, 0), args["Amount"]);
	else
		player:Notify("You can not afford that amount!");
	end;
end;

RP.Command:New("DropShards", COMMAND);
