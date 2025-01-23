include ("shared.lua")

SWEP.PrintName = "Command"
SWEP.Slot = 5
SWEP.Slotpos = 1
SWEP.Drawammo = false
SWEP.Drawcrosshair = true

local matScreen = Material( "jaanus/teamcolor" )

local RTTexture = GetRenderTarget( "SassWristColor", 128, 128 )

function SWEP:ViewModelDrawn()
	
	local NewRT = RTTexture
	if !NewRT then return end
	
	matScreen:SetMaterialTexture( "$basetexture", NewRT )
	
	local OldRT = render.GetRenderTarget();
	
	render.SetRenderTarget( NewRT )
	render.SetViewPort( 0, 0, 128, 128 )
	cam.Start2D()
	
	local r,g,b,a = LocalPlayer():GetColor()
	draw.RoundedBox( 0, 0, 0, 128, 128, Color( r*0.5, g*0.5, b*0.5, 100 ) )
	
	cam.End2D()
	render.SetRenderTarget( OldRT )
	
end
