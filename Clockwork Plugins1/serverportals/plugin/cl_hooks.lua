
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local CurTime = CurTime;
local Derma_Query = Derma_Query

PLUGIN.nextCheckAreaPortals = 0;

local portalEsp = Clockwork.kernel:CreateClientConVar("cwServerPortalEsp", 0, true, false)

Clockwork.setting:AddCheckBox("Framework", "Enable the server portal ESP.", "cwServerPortalEsp", "Whether or not to show the server portal admin ESP.", function()
	return Clockwork.Client:IsSuperAdmin();
end);

function PLUGIN:Tick()
	if (CurTime() > self.nextCheckAreaPortals) then
		self.nextCheckAreaPortals = CurTime() + 1;
		if (IsValid(Clockwork.Client) and Clockwork.Client:HasInitialized() and
			(!Clockwork.Client:IsNoClipping()) and Clockwork.Client:Alive()
			and (!self.DermaQueryOpen)) then

			local pos = Clockwork.Client:EyePos();
			local portalFound = false;
			local portal = nil;
			for k, v in pairs(self.areaPortals) do
				if (self:IsInBox(pos, v.min, v.max)) then
					portalFound = true;
					if (self.currentAreaPortal != k) then
						portal = k;

						break;
					end;
				end;
			end;

			if (portalFound) then
				if (portal) then
					self.currentAreaPortal = portal;
					self.DermaQueryOpen = true;
					Derma_Query("You are about to leave to "..self.areaPortals[portal].destination..". Are you sure you want to switch server?", "Leaving Area",
						"Leave", function()
							Clockwork.datastream:Start("UseAreaPortal", {portal})
							timer.Simple(2, function() self.DermaQueryOpen = false end)
						end,
						"Stay", function()
							self.DermaQueryOpen = false
						end
					);
				end;
			else
				self.currentAreaPortal = nil;
			end;
		end;
	end;
end;

function PLUGIN:HUDPaintForeground()
	if (!Clockwork.Client:IsSuperAdmin() or portalEsp:GetInt() == 0) then
		return;
	end;
	
	if (self.areaPortals and Clockwork.plugin:Call("PlayerCanSeeAdminESP")) then
		for k, portal in pairs(self.areaPortals) do
			local min = portal.min;
			local max = portal.max;

			local corner1 = min:ToScreen();
			local corner2 = Vector(min.x, max.y, min.z):ToScreen();
			local corner3 = Vector(max.x, max.y, min.z):ToScreen();
			local corner4 = Vector(max.x, min.y, min.z):ToScreen();
			local corner5 = Vector(min.x, min.y, max.z):ToScreen();
			local corner6 = Vector(min.x, max.y, max.z):ToScreen();
			local corner7 = max:ToScreen();
			local corner8 = Vector(max.x, min.y, max.z):ToScreen();

			surface.SetDrawColor(255, 255, 255, 255);
			if (corner1.visible and corner2.visible) then
				surface.DrawLine(corner1.x, corner1.y, corner2.x, corner2.y);
			end;
			if (corner2.visible and corner3.visible) then
				surface.DrawLine(corner2.x, corner2.y, corner3.x, corner3.y);
			end;
			if (corner3.visible and corner4.visible) then
				surface.DrawLine(corner3.x, corner3.y, corner4.x, corner4.y);
			end;
			if (corner4.visible and corner1.visible) then
				surface.DrawLine(corner4.x, corner4.y, corner1.x, corner1.y);
			end;

			if (corner1.visible and corner5.visible) then
				surface.DrawLine(corner1.x, corner1.y, corner5.x, corner5.y);
			end;
			if (corner2.visible and corner6.visible) then
				surface.DrawLine(corner2.x, corner2.y, corner6.x, corner6.y);
			end;
			if (corner3.visible and corner7.visible) then
				surface.DrawLine(corner3.x, corner3.y, corner7.x, corner7.y);
			end;
			if (corner4.visible and corner8.visible) then
				surface.DrawLine(corner4.x, corner4.y, corner8.x, corner8.y);
			end;

			if (corner5.visible and corner6.visible) then
				surface.DrawLine(corner5.x, corner5.y, corner6.x, corner6.y);
			end;
			if (corner6.visible and corner7.visible) then
				surface.DrawLine(corner6.x, corner6.y, corner7.x, corner7.y);
			end;
			if (corner7.visible and corner8.visible) then
				surface.DrawLine(corner7.x, corner7.y, corner8.x, corner8.y);
			end;
			if (corner8.visible and corner5.visible) then
				surface.DrawLine(corner8.x, corner8.y, corner5.x, corner5.y);
			end;
		end;
	end;
end;

function PLUGIN:GetAdminESPInfo(info)
	if (!Clockwork.Client:IsSuperAdmin() or portalEsp:GetInt() == 0) then
		return;
	end;
	
	if (self.areaPortals) then
		for k, portal in pairs(self.areaPortals) do
			local text = "Portal "..k..": "..portal.destination.." ("..portal.ip.."; "..portal.serverWhitelist..")"
			if (portal.spawnPoint) then
				text = "Portal "..k..": "..portal.destination.." ("..portal.ip.."; "..portal.serverWhitelist.."; "..portal.spawnPoint..")";
			end;

			info[#info + 1] = {
				position = (portal.min + portal.max) / 2,
				text = text
			};
		end;
	end;

	if (self.portalSpawns) then
		for k, spawns in pairs(self.portalSpawns) do
			for k2, spawn in pairs(spawns) do
				info[#info + 1] = {
					position = spawn + Vector(0, 0, 30),
					text = "Spawn "..k.." #"..k2
				};
			end;
		end;
	end;
end;

-- Called when a player's scoreboard options are needed.
function PLUGIN:GetPlayerScoreboardOptions(player, options, menu)
	if (Clockwork.command:FindByID("PlyAddServerWhitelist")
	or Clockwork.command:FindByID("PlyRemoveServerWhitelist")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("PlyAddServerWhitelist").access)) then
			options["Server Whitelist"] = {};
			
			if (Clockwork.command:FindByID("PlyAddServerWhitelist")) then
				options["Server Whitelist"]["Add"] = function()
					Derma_StringRequest(player:Name(), "What server whitelist would you like to add them to?", "", function(text)
						Clockwork.kernel:RunCommand("PlyAddServerWhitelist", player:Name(), text);
					end);
				end;
			end;
			
			if (Clockwork.command:FindByID("PlyRemoveServerWhitelist")) then
				options["Server Whitelist"]["Remove"] = function()
					Derma_StringRequest(player:Name(), "What server whitelist would you like to remove them from?", "", function(text)
						Clockwork.kernel:RunCommand("PlyRemoveServerWhitelist", player:Name(), text);
					end);
				end;
			end;
		end;
	end;
end;