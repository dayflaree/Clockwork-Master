// Healthbar and armor VGUI

local PANEL = {}

function PANEL:Init()
	self:SetSize( 512, 512 )
	
	self.MatBackground = Material( "HUD/bg" )	
	self.MatHealth = Material( "HUD/healthbar" )
	self.MatArmor = Material( "HUD/armorbar" )
end

function PANEL:Paint()
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetMaterial( self.MatBackground )
	surface.DrawTexturedRect( 0, 0, self:GetSize() )
	
	// Health
	local h = 1 - LocalPlayer():Health() / GAMEMODE:GetClass( LocalPlayer() ).Health
	surface.SetMaterial( self.MatHealth )
	surface.DrawPoly( {
		{ x = 46, y = 179 + h*256, u = 0, v = h },
		{ x = 78, y = 179 + h*256, u = 1, v = h },
		{ x = 78, y = 435, u = 1, v = 1 },
		{ x = 46, y = 435, u = 0, v = 1 }
	} )
	
	// Armor
	local h = 1 - LocalPlayer():Armor() / GAMEMODE:GetClass( LocalPlayer() ).Armor
	surface.SetMaterial( self.MatArmor )
	surface.DrawPoly( {
		{ x = 46 + 66, y = 179 + h*256, u = 0, v = h },
		{ x = 78 + 66, y = 179 + h*256, u = 1, v = h },
		{ x = 78 + 66, y = 435, u = 1, v = 1 },
		{ x = 46 + 66, y = 435, u = 0, v = 1 }
	} )
end

vgui.Register( "PVK_HealthArmor", PANEL, "Panel" )  