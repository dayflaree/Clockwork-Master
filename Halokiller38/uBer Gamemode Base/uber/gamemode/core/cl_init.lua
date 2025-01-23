--[[
		uBer
File: cl_init.lua
--]]

function HideStandard(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end;
	end;
end;
hook.Add("HUDShouldDraw", "lib_hud_HideStandard", HideStandard);