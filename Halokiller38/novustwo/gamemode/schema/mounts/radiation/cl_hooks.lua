--[[
Name: "cl_hooks.lua".
Product: "eXperim3nt".
--]]

local MOUNT = MOUNT;

-- Called when the bars are needed.
function MOUNT:GetBars(bars)
	local radiation = g_LocalPlayer:GetSharedVar("sh_Radiation");
	
	if (!self.radiation) then
		self.radiation = radiation;
	else
		self.radiation = math.Approach(self.radiation, radiation, 1);
	end;
	
	if (self.radiation > 1) then
		bars:Add("RADIATION", Color(179, 46, 49, 255), "", self.radiation, 1000, self.radiation < 10, 2);
	end;
end;