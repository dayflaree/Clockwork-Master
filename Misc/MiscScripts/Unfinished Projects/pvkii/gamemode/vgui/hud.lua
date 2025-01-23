// HUD VGUI manager

// VGUI files
include( "healtharmor.lua" )

local PANEL = {}

function PANEL:Init()
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	self.HealthArmor = vgui.Create( "PVK_HealthArmor", self )
end

vgui.Register( "PVK_HUD", PANEL, "Panel" )  