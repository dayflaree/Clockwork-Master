
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local CurTime = CurTime;
local Derma_Query = Derma_Query

local gasEsp = Clockwork.kernel:CreateClientConVar("cwGasZoneEsp", 0, true, false)

Clockwork.setting:AddCheckBox("Framework", "Enable the gas zone ESP.", "cwGasZoneEsp", "Whether or not to show the gas zone admin ESP.", function()
	return Clockwork.Client:IsSuperAdmin();
end);

function PLUGIN:HUDPaintForeground()
	if (!Clockwork.Client:IsSuperAdmin() or gasEsp:GetInt() == 0) then
		return;
	end;
	
	if (self.gasZones and Clockwork.plugin:Call("PlayerCanSeeAdminESP")) then
		for k, gas in pairs(self.gasZones) do
			local min = gas.min;
			local max = gas.max;

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
	if (!Clockwork.Client:IsSuperAdmin() or gasEsp:GetInt() == 0) then
		return;
	end;
	
	if (self.gasZones) then
		for k, gas in pairs(self.gasZones) do
			local text = "Gas Zone"

			info[#info + 1] = {
				position = (gas.min + gas.max) / 2,
				text = text
			};
		end;
	end;
end;