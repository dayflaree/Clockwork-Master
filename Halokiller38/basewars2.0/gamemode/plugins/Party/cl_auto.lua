--================
--	Party System
--================
RP.party.curParty = {};
RP.party.invites = {};

surface.CreateFont("Arial", 24, 600, true, false, "party_title", false, false, 0);
surface.CreateFont("Arial", 16, 600, true, false, "party_main", false, false, 0);

function RP.party:InParty(ply)
	return table.HasValue(self.curParty, ply);
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:InParty()
	return RP.party:InParty(self);
end;

RP:DataHook("createParty", function(data)
	table.insert(RP.party.curParty, LocalPlayer());
end);

RP:DataHook("endParty", function(data)
	RP.party.curParty = {};
	
	LocalPlayer():Notify("The party has been ended by the leader.");
	
	if (RP.party.managerPanel) then
		RP.party.managerPanel:Rebuild();
	end;
end);

RP:DataHook("playerLeaveParty", function(data)
	local ply = data[1];
	local message = data[2];
	
	if (ply == LocalPlayer()) then
		RP.party.curParty = {};
		
		if (RP.party.managerPanel) then
			RP.party.managerPanel:Rebuild();
		end;
		
		return;
	end;
	
	for k,v in ipairs(RP.party.curParty) do
		if (v == ply) then
			table.remove(RP.party.curParty, k);
			
			break;
		end;
	end;
	
	LocalPlayer():Notify(message);
	
	if (RP.party.managerPanel) then
		RP.party.managerPanel:Rebuild();
	end;
end);

RP:DataHook("partyInvite", function(data)
	local id = data[1];
	local name = data[2];
	
	table.insert(RP.party.invites, {host = name, id = id, startTime = CurTime(), timeout = CurTime() + 30});
	
	LocalPlayer():Notify("You have been invited to "..name.."'s party.");
	-- boop sound?
	
	if (!RP.party.invitePanel or !RP.party.invitePanel:IsValid()) then
		RP.party.invitePanel = vgui.Create("RP_party_invites");
	else
		RP.party.invitePanel:Rebuild();
	end;
end);

RP:DataHook("removeInvite", function(data)
	local id = data[1];
	
	for k,v in ipairs(RP.party.invites) do
		if (v.id == id) then
			table.remove(RP.party.invites, k);
		end;
	end;
	
	if (RP.party.invitePanel:IsValid()) then
		RP.party.invitePanel:Rebuild();
	end;
end);

RP:DataHook("clearAllInvites", function(data)
	RP.party.invites = {};
	
	if (RP.party.invitePanel:IsValid()) then
		RP.party.invitePanel:Remove();
		RP.party.invitePanel = nil;
	end;
end);

RP:DataHook("joinParty", function(data)
	local ply = data[1];
	
	table.insert(RP.party.curParty, ply);
end);

RP:DataHook("newPartyLeader", function(data)
	local ply = data[1];
	
	local curKey = table.KeyFromValue(RP.party.curParty, ply);
	local oldLeader = RP.party.curParty[1];
	
	RP.party.curParty[1] = ply;
	RP.party.curParty[curKey] = oldLeader;
	
	LocalPlayer():Notify(ply:GetName().." has been made the party leader.");
	
	if (RP.party.managerPanel:IsValid()) then
		RP.party.managerPanel:Rebuild();
	end;
end);

PLUGIN.leaderIcon = surface.GetTextureID("gui/silkicons/star");

function PLUGIN:HUDPaint()
	if (#RP.party.curParty > 0) then
		local x = 10;
		local y = ScrH() / 2;
		y = RP.menu:DrawSimpleText("Party", "party_title", x, y, Color(255, 255, 255, 255), 0, 0, false);
		surface.SetDrawColor(20, 20, 20, 255);
		surface.DrawLine(x, y, x + 100, y);
		surface.SetDrawColor(200, 200, 200, 255);
		surface.DrawLine(x, y + 1, x + 100, y + 1);
		
		y = y + 4;
		
		for k,v in ipairs(RP.party.curParty) do
			if (ValidEntity(v)) then
				local r = 255 - 255 * math.TimeFraction(0, 100, v:Health());
				local g = 255 * math.TimeFraction(0, 100, v:Health());
				local colour = Color(r, g, 0, 255);
				
				if (!v:Alive()) then
					colour = Color(50, 50, 50, 255);
				end;
				
				if (k == 1) then
					surface.SetDrawColor(255, 255, 255, 255);
					surface.SetTexture(self.leaderIcon);
					surface.DrawTexturedRect(x, y, 16, 16);
					x = x + 20;
				end;
				
				if (v:Health() <= 10 and v:Alive()) then
					local a = 255 * math.sin(UnPredictedCurTime() * 5);
					RP.menu:DrawSimpleText(v:GetName(), "party_main", x, y, colour, 0, 0, false);
					y = RP.menu:DrawSimpleText(v:GetName(), "party_main", x, y, Color(255, 255, 255, a), 0, 0, true);
				else
					y = RP.menu:DrawSimpleText(v:GetName(), "party_main", x, y, colour, 0, 0, false);
				end;
				
				if (k == 1) then
					x = x - 20;
				end;
			else
				table.remove(RP.party.curParty, k);
			end;
		end;
		
		surface.DrawLine(x, y, x + 100, y);
		surface.SetDrawColor(20, 20, 20, 255);
		surface.DrawLine(x, y + 1, x + 100, y + 1);
	end;
end;

function PLUGIN:Tick()
	local curTime = CurTime();
	for k,v in ipairs(RP.party.invites) do
		if (curTime >= v.timeout) then
			RP:DataStream("partyDecline", {v.id});
			RP.party.invites[k] = nil;
		end;
	end;
end;
