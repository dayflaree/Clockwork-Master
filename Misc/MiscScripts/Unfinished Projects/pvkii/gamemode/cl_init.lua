// Include gamemode files
include( "shared.lua" )
include( "vgui/hud.lua" )

function GM:InitPostEntity()
	if ( !self.HUD ) then
		self.HUD = vgui.Create( "PVK_HUD" )
	end
end

function GM:HUDShouldDraw( name )
	if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudDeathNotice" ) then
		return false
	else
		return true
	end
end