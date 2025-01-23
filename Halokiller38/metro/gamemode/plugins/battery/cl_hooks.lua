--[[
	Name: cl_hooks.lua.
	Author: TJjokerR.
--]]

local PLUGIN = PLUGIN;

-- Called when the bars are needed.
function PLUGIN:GetBars(bars)
	local battery = openAura.Client:GetSharedVar("sh_Battery");
	
	if(battery)then
		if (!self.battery) then
			self.battery = battery;
		else
			self.battery = math.Approach(self.battery, battery, 1);
		end;
		
		bars:Add("BATTERY", Color(182, 255, 0, 255), "Battery", self.battery, 100, self.battery < 10);
	end;
end;