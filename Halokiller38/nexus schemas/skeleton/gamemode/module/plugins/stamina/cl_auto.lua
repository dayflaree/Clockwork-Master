--[[
Name: "cl_auto.lua".
Product: "Skeleton".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

-- Called when the bars are needed.
function PLUGIN:GetBars(bars)
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

-- Called when the module small bars should be drawn.
function PLUGIN:ModuleDrawSmallBars(info)
	local stamina = g_LocalPlayer:GetSharedVar("sh_Stamina");
	
	if (!self.stamina) then
		self.stamina = stamina;
	else
		self.stamina = math.Approach(self.stamina, stamina, 1);
	end;
	
	if (self.stamina < 90) then
		info.y = RESISTANCE:DrawBar(info.x, info.y, info.width, info.height, Color(100, 175, 100, 255), "", self.stamina, 100) + 12;
	end;
end;