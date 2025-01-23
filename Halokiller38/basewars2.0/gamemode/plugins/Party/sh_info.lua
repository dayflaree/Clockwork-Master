--================
--	Party System
--================
local PLUGIN = PLUGIN;

RP.party = {};
RP.party.max = 5;

RP:IncludeFile("cl_derma.lua");

PLUGIN.name = "Party";

local COMMAND = {};
COMMAND.description = "Invites a player to your party";
COMMAND.arguments = {{"String", "Name"}};
function COMMAND:OnRun(ply, args)
	local playerID = args["Name"];
	local target = RP.player:FindPlayer(playerID);
	
	if (target) then
		if (!ply:GetParty() or #ply:GetParty() <= RP.party.max) then
			local success, err = RP.party:InvitePlayer(ply, target);
			
			if (success) then				
				for k,v in ipairs(ply:GetParty()) do
					v:Notify(target:Name().." has been invited to the party.");
					v:PlaySound("buttons/button3.wav");
				end;
				target:PlaySound("buttons/button3.wav");
			else
				ply:Notify(err);
			end;
		else
			ply:Notify("Your party is full!");
		end;
	else
		ply:Notify(playerID.." is not a valid player!");
	end;
end;

RP.Command:New("invite", COMMAND);

local COMMAND = {};
COMMAND.description = "Use party chat";
COMMAND.arguments = {{"String", "Text"}};
function COMMAND:OnRun(ply, args)
	local text = args["Text"];
	local players = ply:GetParty();
	
	if (players) then
		local icon = "gui/silkicons/group";
		if (ply:IsPartyLeader()) then icon = "gui/silkicons/star"; end;
		
		for k,v in ipairs(players) do			
			RP.chat:Add(v, Format("[Party] %s: %s", ply:GetName(), text), icon);
		end;
	else
		ply:Notify("You are not in a party!");
	end;
end;

RP.Command:New("party", COMMAND);

local COMMAND = {};
COMMAND.description = "Kick a player from your party";
COMMAND.arguments = {{"String", "Name"}};
function COMMAND:OnRun(ply, args)
	if (ply:GetParty()) then
		local playerID = args["Name"];
		local target = RP.player:FindPlayer(playerID);
		
		if (target) then
			if (target != ply) then
				if (ply:IsPartyLeader()) then
					RP.party:RemovePlayer(ply, target, Format("%s has been kicked by the party leader!", target:GetName()));
				else
					ply:Notify("You need to be the party leader to do that!");
				end;
			else
				ply:Notify("You cannot kick yourself!");
			end;
		else
			ply:Notify(playerID.." is not a valid player!");
		end;
	else
		ply:Notify("You are not in a party.");
	end;
end;

RP.Command:New("partyKick", COMMAND);

local COMMAND = {};
COMMAND.description = "Leave/end your current party";
COMMAND.arguments = {};
function COMMAND:OnRun(ply, args)
	local party = ply:GetParty();
	
	if (party) then
		if (ply:IsPartyLeader()) then
			RP.party:EndParty(ply);
		else
			RP.party:RemovePlayer(party[1], ply);
		end;
	else
		ply:Notify("You are not in a party.");
	end;
end;

RP.Command:New("partyLeave", COMMAND);

local COMMAND = {};
COMMAND.description = "Make another player the leader of your party";
COMMAND.arguments = {{"String", "Name"}};
function COMMAND:OnRun(ply, args)
	local playerID = args["Name"];
	local target = RP.player:FindPlayer(playerID);
	
	if (target) then
		local party = ply:GetParty();
		
		if (party) then
			if (target:InParty(ply)) then
				if (ply:IsPartyLeader()) then
					RP.party:MakeLeader(target);
				else
					ply:Notify("You must be the party leader to do that!");
				end;
			else
				ply:Notify(target:GetName().." is not in your party!");
			end;
		else
			ply:Notify("You are not in a party!");
		end;
	else
		ply:Notify(playerID.." is not a valid player!");
	end;
end;

RP.Command:New("partyLeader", COMMAND);
