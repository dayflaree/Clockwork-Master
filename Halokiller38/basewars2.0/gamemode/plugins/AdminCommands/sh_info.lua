--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "HUD";

local COMMAND = {};
COMMAND.description = "Gives a player some cash";
COMMAND.arguments = {{"Player", "Target"}, {"Number", "Amount"}};
COMMAND.access = "a";
function COMMAND:OnRun(player, args)
	PrintTable(args);
	local target = args["Target"];
	target:GiveCash(args["Amount"]);
	player:Notify("You have given "..target:Name().." $"..args["Amount"]);
end;

RP.Command:New("GiveCash", COMMAND);

local COMMAND = {};
COMMAND.description = "Sets a player's cash value";
COMMAND.arguments = {{"Player", "Target"}, {"Number", "Amount"}};
COMMAND.access = "a";
function COMMAND:OnRun(player, args)
	local target = args["Target"];
	target:SetCash(args["Amount"]);
	player:Notify("You have set "..target:Name().."'s cash to $"..args["Amount"]);
end;

RP.Command:New("SetCash", COMMAND);

local COMMAND = {};
COMMAND.description = "Take cash from a player";
COMMAND.arguments = {{"Player", "Target"}, {"Number", "Amount"}};
COMMAND.access = "a";
function COMMAND:OnRun(player, args)
	local target = args["Target"];
	target:TakeCash(args["Amount"]);
	player:Notify("You have taken $"..args["Amount"].." from "..target:Name());
end;

RP.Command:New("TakeCash", COMMAND);

local COMMAND = {};
COMMAND.description = "Gives a player an item";
COMMAND.arguments = {{"Player", "Target"}, {"String", "Item Name"}};
COMMAND.access = "a";
function COMMAND:OnRun(player, args)
	local target = args["Target"];
	RP.Inventory:GiveItem(player, RP.Item:CreateID(args["Item Name"]));
end;

RP.Command:New("GiveItem", COMMAND);

local COMMAND = {};
COMMAND.description = "Gives a permission";
COMMAND.arguments = {{"Player", "Target"}, {"String", "Permission"}};
COMMAND.access = "a";
function COMMAND:OnRun(player, args)
	if (args["Target"]:IsValid()) then
		player:GiveFlag(args["Permission"]);
	end;
end;

RP.Command:New("GiveFlag", COMMAND);