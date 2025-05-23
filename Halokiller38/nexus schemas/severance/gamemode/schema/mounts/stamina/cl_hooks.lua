--[[
Name: "cl_hooks.lua".
Product: "Severance".
--]]

local MOUNT = MOUNT;

-- Called when the bars are needed.
function MOUNT:GetBars(bars)
	local stamina = g_LocalPlayer:GetSharedVar("sh_Stamina");
	
	if (!self.stamina) then
		self.stamina = stamina;
	else
		self.stamina = math.Approach(self.stamina, stamina, 1);
	end;
	
	if (self.stamina < 75) then
		bars:Add("STAMINA", Color(100, 175, 100, 255), "", self.stamina, 100, self.stamina < 10);
	end;
end;