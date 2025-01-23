-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

LocalPlayer( ).MyModel = "";

surface.CreateFont( "ChatFont", 22, 100, true, false, "PlInfoFont" );
surface.CreateFont( "ChatFont", 32, 500, true, false, "AmmoFont" );
surface.CreateFont( "TargetID", 14, 500, true, false, "AmmoNameFont" );
surface.CreateFont( "ChatFont", 24, 500, true, false, "HUDFont" );
surface.CreateFont( "csd", 46, 500, true, false, "CSSsmall" )
surface.CreateFont( "csd", 54, 500, true, false, "CSSmed" )
surface.CreateFont( "halflife2frp", 40, 500, true, false, "AMMOnormal3" )
surface.CreateFont( "halflife2frp", 36, 500, true, false, "AMMOnormal4" )
surface.CreateFont( "halflife2frp", 22, 500, true, false, "AMMOsmaller" )
surface.CreateFont( "halflife2frp", 26, 500, true, false, "AMMOsmaller2" )
surface.CreateFont( "halflife2frp", 24, 500, true, false, "AMMOsmaller3" )
surface.CreateFont( "csd", 68, 500, true, false, "CSSlarge" )
surface.CreateFont( "csd", 72, 500, true, false, "CSShuge2" )
surface.CreateFont( "csd", 92, 500, true, false, "CSSepic" )
surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, false, "CSSepic2" )
surface.CreateFont( "digital-7", 24, 500, true, false, "LED" )
surface.CreateFont( "digital-7", 21, 500, true, false, "LEDmed" )
surface.CreateFont( "digital-7", 18, 500, true, false, "LEDsmall" )
surface.CreateFont( "Patagonia", 18, 500, true, false, "Patabold" )
surface.CreateFont( "Patagonia", 8, 500, true, false, "Patatiny" )
surface.CreateFont( "Patagonia", 14, 500, true, false, "Patamed" )
surface.CreateFont( "coolvetica", 48, 500, true, false, "MelonLarge" )
surface.CreateFont( "coolvetica", 26, 500, true, false, "MelonMedium" )
surface.CreateFont( "akbar", 54, 500, true, false, "akbar" )
surface.CreateFont( "akbar", 38, 500, true, false, "akbarsmall" )
surface.CreateFont( "JOURNAL", 36, 500, true, false, "script" )

--Player Stats



--Screen Width and Height

local scrwidth = ScrW()
local scrheight = ScrH()

--COLARZ

local White = Color( 255, 255, 255, 255 )
local Black = Color( 0, 0, 0, 255 )
local Green = Color( 0, 255, 0, 255 )
local LightGreen = Color( 30, 255, 30, 255 )
local Red = Color( 255, 0, 0, 255 )
local LightOrange = Color( 255, 146, 109 )

--Textures

local topscreen = surface.GetTextureID( "VGUI/hud/HUD_TOP_SCREEN" )
-- local topbar = surface.GetTextureID( "VGUI/hud/top_hud_bar" )
-- local bottombar = surface.GetTextureID( "VGUI/hud/Bottom_hud_bar" )
local bottomscreen = surface.GetTextureID( "VGUI/hud/pipboy_screen" )

--Weapons

UnknownWeps = 
{
	"hands",
	"weapon_physcannon",
	"weapon_physgun",
	"keys",
	"gmod_tool",
	"gmod_camera",
	"nil",
	"NULL"
}

FSWeps =
{
	"gun_fs_deagle",
	"gun_fs_colt",
	"gun_fs_citykiller"
}
	


-- function DrawAmmoInfo( )
	
	-- local pri = 0;
	-- local ammo = nil;

	-- if( LocalPlayer():GetActiveWeapon():IsValid() ) then
		-- ammo = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType();
	-- end

	-- if( LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() > 0 ) then
		-- pri = LocalPlayer():GetActiveWeapon():Clip1();
	-- end
	
	--going to change this later
	-- if( LocalPlayer():GetActiveWeapon():IsValid() and (LocalPlayer():GetActiveWeapon():GetClass() == "weapon_hands" or LocalPlayer():GetActiveWeapon():GetClass() == "weapon_fs_crowbar" or LocalPlayer():GetActiveWeapon():GetClass() == "weapon_fs_knife")) then
	
	-- pri = 0;
	
	-- end
	
	-- surface.SetFont( "AmmoFont" );
	-- local w, h = surface.GetTextSize( pri );
	-- local prisize = w;

    -- if(pri == 0) then return; end

		-- raw.RoundedBox( 4, ScrW() - 35 - 15, ScrH() - 63, 50, 38, Color( 0, 0, 0, 200 ) );
		-- raw.DrawText( pri, "AmmoFont", ScrW() - 10  - 5, ScrH() - 63, Color( 255, 255, 255, 255 ), 2 );

-- end





-- function DrawTargetInfo( )
	
	-- local tr = LocalPlayer( ):GetEyeTrace( )
	
	-- if( !tr.HitNonWorld ) then return; end
	
	-- if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 ) then

		-- local screenpos = tr.Entity:GetPos( ):ToScreen( )
		-- draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		-- draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		-- draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
		-- draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );

	-- end
	
-- end
		
function GM:HUDShouldDraw( name )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 or LocalPlayer( ):GetNWInt( "charactercreate" ) == nil ) then return false; end
	
	local nodraw = 
	{ 
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
	
	 }
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end

	return true;

end

local pnlBlackVGUI = vgui.RegisterFile( "vgui_blackscene.lua" )
local BlackVGUI = vgui.CreateFromTable( pnlBlackVGUI )

function DrawDeathHUD( )

	BlackVGUI:SetWinner( " ", 15 )
	BlackVGUI:Show()
	
	timer.Simple( 14, function() 
	BlackVGUI:Hide(); 
	ShowingDeathMode = 0 
	end )
	
end


function TargetName( entity )



if entity:IsPlayer() and entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 then
	draw.DrawText( "TARGET: ".. entity:Nick(), "LED", scrwidth / 2, 5, White, 1 )
elseif entity:GetClass( ) == "item_prop" and entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 then
	draw.DrawText( "TARGET: ".. entity:GetNWString( "Name" ), "LED", scrwidth / 2, 5, White, 1 )
else
	draw.DrawText( "TARGET: UNKNOWN", "LED", scrwidth / 2, 5, White, 1 )
end
end


function TargetUnknown( )
	draw.DrawText( "TARGET: UNKNOWN", "LED", scrwidth / 2, 5, White, 1 )
end
	
function DrawBottomBar( )


	-- bottombar0 = {}
	-- bottombar0.texture = bottombar
	-- bottombar0.x = -193
	-- bottombar0.y = scrheight - 64
	-- bottombar0.w = 2048
	-- bottombar0.h = 128
	-- bottombar0.Color = White
	-- draw.TexturedQuad( bottombar0 )
	
	-- draw.RoundedBox( 0, ScrW() - 500, ScrH() - 23, LocalPlayer():GetNWInt( "AP" ), 15, LightGreen ) -- AP BAR
	-- draw.DrawText( "AP", "LED", ScrW() - 520, ScrH() - 25, LightGreen, 0 )
	

-- tweentime = .5  
  
-- lastap = lastap or LocalPlayer():GetNWInt( "lastap" )
-- targetap = targetap or 280

-- delta = math.abs( targetap - lastap )  
  
-- if lastap <= targetap then  
  -- lastap = math.Clamp( lastap + delta * FrameTime( ) / tweentime, 0, targetap )  
-- else  
-- lastap = math.Clamp( lastap - delta * FrameTime( ) / tweentime, targetap, lastap )  
-- end  
  
-- frac = math.Clamp( lastap / LocalPlayer( ):GetNWInt( "AP" ), 0, 1 )  

	draw.RoundedBox( 0, ScrW() - ScrW(), ScrH() - 30, ScrW() + 100, 200, Color( 0, 0, 0, 255 ) ) -- Bottom Black Bar
	-- draw.RoundedBox( 0, ScrW() - 300, ScrH() - 23, LocalPlayer():GetNWInt( "AP" ), 15, Color( 30, 255, 30, 255 ) ) -- AP BAR
	-- draw.DrawText( "AP", "LED", ScrW() - 330, ScrH() - 25, Color( 30,255,30,255 ), 0 )
	-- draw.DrawText( "PIPBOY 3000", "LED", 5, ScrH() - 30, Color( 30,255,30,255 ), 0 )
	-- draw.DrawText( "RADIO CHANNEL: ".. LocalPlayer():GetNWInt( "pradiostation" ), "LED", 250, ScrH() - 30, Color( 30,255,30,255 ), 0 )
	-- draw.DrawText( "HP ".. LocalPlayer():Health(), "akbar", ScrW() / 2 - 300, ScrH() - 70, Color( 30,255,30,255 ), 0 )
	-- draw.DrawText( "ARMOR ".. LocalPlayer():Armor(), "akbar", ScrW() / 2 - 123, ScrH() - 70, Color( 30,255,30,255 ), 0 )
	--draw.DrawText( "AMMO ".. LocalPlayer():Health(), "akbar", ScrW() / 2 - 250, ScrH() - 55, Color( 30,255,30,255 ), 0 )
	-- local pri = 0;
	-- local ammo = nil;
	draw.RoundedBox( 0, 900, scrheight - 20, math.ceil(LocalPlayer():GetNWInt( "rads" ) / 5.3), 12, LightOrange ) -- AP BAR
	draw.DrawText( "RADS", "LED", 850, scrheight - 25, LightGreen, 0 )
	draw.RoundedBox( 0, 670, scrheight - 20, math.ceil(LocalPlayer():GetNWInt( "AP" ) / 1.6), 12, LightGreen ) -- AP BAR
	draw.DrawText( "AP", "LED", 640, scrheight - 25, LightGreen, 0 )
	-- if( LocalPlayer():GetActiveWeapon():IsValid() ) then
		-- ammo = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType();
	-- end

	-- if( LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() > 0 ) then
		-- pri = LocalPlayer():GetActiveWeapon():Clip1();
	-- end
	
	--going to change this later
	-- if( LocalPlayer():GetActiveWeapon():IsValid() and (LocalPlayer():GetActiveWeapon():GetClass() == "hands" or LocalPlayer():GetActiveWeapon():GetClass() == "melee_fs_crowbar")) then
	
	-- pri = 0;
	
	-- end

    --if(pri == 0) then return; end

	--draw.RoundedBox( 4, ScrW() - 35 - 15, ScrH() - 63, 50, 38, Color( 0, 0, 0, 200 ) ); Old Ammo box
	--draw.DrawText( "AMMO ".. pri, "akbar", ScrW() / 2 + 85, ScrH() - 70, Color( 30, 255, 30, 255 ), 0 );
end

function DrawInfoBox( )

	draw.RoundedBox( 8, scrwidth / 2 - 300, scrheight - 75, 600, 150, Color( 0, 0, 0, 255 ) )

	
end
	
-- function DrawPipBoy( )

	-- local Pippip = surface.GetTextureID( "VGUI/hud/Status_HUD" )
	--surface.SetTexture( Pippip )
	-- setpip = {}
	-- setpip.texture = Pippip
	-- setpip.x = -100
	-- setpip.y = ScrH() / 1.46
	-- setpip.w = 512
	-- setpip.h = 512
	-- setpip.color = Color( 255,255,255,255 )
	-- draw.TexturedQuad( setpip )--20, ScrH() - 180 -100, ScrH() / 1.5, 512, 512
	-- local hp = LocalPlayer():Health()
	-- setpipboy = {}
	-- if LocalPlayer():Alive() then
		-- if (hp >= 90 or hp >= 100) then
			-- local pipstatus = surface.GetTextureID( "VGUI/hud/status_100" )
			-- setpipboy.texture = pipstatus
			-- setpipboy.x = -145
			-- setpipboy.y = ScrH() / 1.47
		-- elseif(hp >= 80 and hp < 90)then
			-- local pipstatus = surface.GetTextureID( "VGUI/hud/status_90" )
			-- setpipboy.texture = pipstatus
			-- setpipboy.x = -158
			-- setpipboy.y = ScrH() / 1.47 
		-- elseif(hp >= 60 and hp < 80)then
			-- local pipstatus = surface.GetTextureID( "VGUI/hud/status_80" )
			-- setpipboy.texture = pipstatus
			-- setpipboy.x = -160
			-- setpipboy.y = ScrH() / 1.46 + 5
		-- elseif(hp >= 30 and hp < 60)then
			-- local pipstatus = surface.GetTextureID( "VGUI/hud/status_60" )
			-- setpipboy.texture = pipstatus
			-- setpipboy.x = -170
			-- setpipboy.y = ScrH() / 1.46 - 20
		-- elseif(hp >= 1 and hp < 30)then
			-- local pipstatus = surface.GetTextureID( "VGUI/hud/status_30" )
			-- setpipboy.texture = pipstatus
			-- setpipboy.x = -160
			-- setpipboy.y = ScrH() / 1.47
		-- end
	
	-- setpipboy.w = 512
	-- setpipboy.h = 512
	-- setpipboy.color = Color( 255,255,255,255 )
	-- draw.TexturedQuad( setpipboy )
	-- draw.DrawText( "Radiation", "LEDsmall", 200, ScrH() / 1.15, Color( 0, 255, 0, 255 ), 0 )
	-- RADS = LocalPlayer():GetNWString( "RADS" )
	-- draw.RoundedBox( 0, 200, ScrH() / 1.13, RADS, 20, Color( 255, 215, 0, 255 ) )
	-- end
-- end

-- function DrawIDCard( )
-- graphic = true
-- if graphic == true then
	--local IDCardTexture = surface.GetTextureID( "VGUI/hud/ID_HUD" )
	-- surface.SetDrawColor( 255, 255, 255, 255 )
	-- surface.SetTexture( IDCardTexture )
	-- surface.DrawTexturedRect( -180, ScrH() - ScrH() + -90, 512, 512 )
-- else
	-- return
-- end
-- if LocalPlayer():Alive() then
	-- drawidcard = {}
	-- drawidcard.texture = IDCardTexture
	-- drawidcard.x = -180
	-- drawidcard.y = ScrH() - ScrH() + -90
	-- drawidcard.w = 512
	-- drawidcard.h = 512
	-- drawidcard.Color = Color( 255, 255, 255, 128 )
	-- draw.TexturedQuad( drawidcard )
	-- name = true
	-- if name == false then
		-- return
	-- else
	-- surface.SetFont( "Pata" )
	-- surface.SetTextPos( 60, 100 )
	-- surface.SetTextColor( 0, 0, 0, 255 )

	-- draw.DrawText( string.upper(LocalPlayer():Nick()), "Pata", 100, 100, Color( 0, 0, 0, 255 ), 1 )
	-- draw.DrawText( string.upper(LocalPlayer():GetNWString("title")), "Pata", 100, 225, Color( 0, 0, 0, 255 ), 1 )
-- end
	-- surface.DrawText( string.upper( LocalPlayer():Nick() ) )
	-- end
-- end

-- hook.Add("HUDPaint", "DrawIDCard", DrawIDCard)

function DrawTime( )

	--draw.RoundedBox( 20, ScrW() - 200, ScrH() - 25, 220, 300, Color( 0, 0, 0, 175 ) ) 
	draw.DrawText( "TIME ".. GetGlobalString( "time" ), "LED", 5, 5, Green, 0 );
	
end

function DrawTopScreen( )

	topscreen0 = {} --Draw the screen graphic here.
	topscreen0.texture = topscreen
	topscreen0.x = scrwidth - 405
	topscreen0.y = -160
	topscreen0.w = 512
	topscreen0.h = 512
	topscreen0.Color = White
	draw.TexturedQuad( topscreen0 )
	
	--Note that the player icon is in cl_playermenu.lua
	
	--Draw their RP name and Title
	draw.DrawText( string.upper(LocalPlayer():Nick()), "Patamed", scrwidth - 123, 35, White, 1 )
	draw.DrawText( string.upper(LocalPlayer():GetNWString("title")), "Patamed", scrwidth - 123, 140, White, 1 )

	
end

function DrawTopBar( )

	-- topbar0 = {}
	-- topbar0.texture = topbar
	-- topbar0.x = ScrW() - 1857
	-- topbar0.y = -64
	-- topbar0.w = 2048
	-- topbar0.h = 128
	-- topbar0.Color = White
	-- draw.TexturedQuad( topbar0 )
	draw.RoundedBox( 0, ScrW() - ScrW(), -30, ScrW() + 100, 60, Color( 0, 0, 0, 255 ) ) 
	draw.DrawText( "CAPS:".. LocalPlayer():GetNWString("money"), "LED", scrwidth - 450, 5, Green, 0 )

end

-- function DrawPipBoy3000( )

-- if LocalPlayer():GetNWBool( "KOed" ) then return end
	-- if LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_citykiller" then
	-- LocalPlayer():SetNWString( "k" )
	-- elseif LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_colt" then
	-- LocalPlayer():SetNWString( "u" )
	-- elseif LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_deagle" then
	-- LocalPlayer():SetNWString( "f" )
	-- end

-- end

function DrawBottomScreen( )

	bottomscreen0 = {}
	bottomscreen0.texture = bottomscreen
	bottomscreen0.x = -166
	bottomscreen0.y = ScrH() - 312
	bottomscreen0.w = 1024
	bottomscreen0.h = 512
	bottomscreen0.Color = White
	draw.TexturedQuad( bottomscreen0 )
	local hp = LocalPlayer():Health()
	setpipboy = {}
	if LocalPlayer():Alive() then
		if (hp >= 90 or hp >= 100) then
			local pipstatus = surface.GetTextureID( "VGUI/hud/status_100" )
			setpipboy.texture = pipstatus
			setpipboy.x = -110
			setpipboy.y = scrheight - 266
		elseif(hp >= 80 and hp < 90)then
			local pipstatus = surface.GetTextureID( "VGUI/hud/status_90" )
			setpipboy.texture = pipstatus
			setpipboy.x = -117
			setpipboy.y = scrheight - 266
		elseif(hp >= 60 and hp < 80)then
			local pipstatus = surface.GetTextureID( "VGUI/hud/status_80" )
			setpipboy.texture = pipstatus
			setpipboy.x = -127
			setpipboy.y = scrheight - 256
		elseif(hp >= 30 and hp < 60)then
			local pipstatus = surface.GetTextureID( "VGUI/hud/status_60" )
			setpipboy.texture = pipstatus
			setpipboy.x = -133
			setpipboy.y = scrheight - 280
		elseif(hp >= 1 and hp < 30)then
			local pipstatus = surface.GetTextureID( "VGUI/hud/status_30" )
			setpipboy.texture = pipstatus
			setpipboy.x = -123
			setpipboy.y = scrheight - 270
		end
	
	setpipboy.w = 384
	setpipboy.h = 384
	setpipboy.color = White
	draw.TexturedQuad( setpipboy )
	
	if LocalPlayer():GetNWBool( "KOed" ) then return; end
	if LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_citykiller" then
	wepicon = "k" 
	wepiconx = 340
	wepicony = scrheight - 74
	wepfont = "CSSepic"
	weptext = LocalPlayer():GetActiveWeapon():GetPrintName()
	wepammofont = "AMMOsmaller3"
	wepammo = "ssssssssssssssssssssssssssssssssssssssssssssss" --LUL HACKY STRING MATH
	wepammoy = 81
	wepammox = 400
	elseif LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_colt" then
	wepicon = "u" 
	wepiconx = 330
	wepicony = scrheight - 75
	wepfont = "CSSepic"
	weptext = LocalPlayer():GetActiveWeapon():GetPrintName()
	wepammofont = "AMMOnormal4"
	wepammo = "ppppppppppppppppppppppppppppppppppppppp" --LUL HACKY STRING MATH
	wepammoy = 86
	wepammox = 365
	elseif LocalPlayer():GetActiveWeapon():GetClass() == "gun_fs_deagle" then
	wepicon = "f" 
	wepiconx = 330
	wepicony = scrheight - 75
	wepfont = "CSSlarge"
	weptext = LocalPlayer():GetActiveWeapon():GetPrintName()
	wepammofont = "AMMOnormal4"
	wepammo = "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq" --LUL HACKY STRING MATH
	wepammoy = 86
	wepammox = 365
	end

	for j, l in pairs( FSWeps ) do
			
		if( not l == LocalPlayer():GetActiveWeapon():GetClass() ) then
			draw.DrawText( "*Unknown Weapon*", "LEDsmall", 450, scrheight - 90, Green, 1 )
			return
		end
		
	end
	
	for j, l in pairs( FSWeps ) do
		if( l == LocalPlayer():GetActiveWeapon():GetClass() ) then
			draw.DrawText( wepicon, wepfont, wepiconx, wepicony, Green, 1 )
			draw.DrawText( weptext, "LEDsmall", 500, scrheight - 60, Green, 1 )
			draw.DrawText( string.sub(wepammo, 0, LocalPlayer():GetActiveWeapon():Clip1()), wepammofont, wepammox, scrheight - wepammoy, Green, 0 )
		end
			
	end
	end
end

-- function GetWeaponIcons( data )

	-- local weaponicondata = {}
	-- weaponicondata.Icon = data:ReadString()
	
-- end



function DrawOOCInfo( )
for k, v in pairs( player.GetAll( ) ) do	
		if( v != LocalPlayer( ) ) then

		    local tr = LocalPlayer( ):GetEyeTrace( )
			local position = v:GetPos( )
			local position = Vector( position.x, position.y, position.z + 75 )
			local screenpos = position:ToScreen( )

				if( v:GetNWInt( "faggot" ) == 1 ) then
				
				draw.DrawText( "WARNING - FAGGOT", "MelonLarge", screenpos.x, screenpos.y - 80, Color( 255, 0, 228, 255 ), 1 )

				end
				
				if( v:GetNWInt( "rave" ) == 1 ) then
				
				draw.DrawText( "RAVE", "MelonLarge", screenpos.x, screenpos.y - 80, Color( 0, 0, 255, 255 ), 1 )
				
				end
				
				if ( LocalPlayer():GetNWInt( "seeall" ) == 1 ) then
				
				draw.DrawText( ""..v:Nick().."", "LEDsmall", screenpos.x, screenpos.y - 80, Red, 1 )
				
				end
				
		end

end

end

--[[
function DrawPlayerInfo( )

	for k, v in pairs( player.GetAll( ) ) do
		
		if( v != LocalPlayer( ) ) then
			
			if( v:Alive( ) ) then

				local alpha = 0
				local position = v:GetPos( )
				local position = Vector( position.x, position.y, position.z + 75 )
				local screenpos = position:ToScreen( )
				local dist = position:Distance( LocalPlayer( ):GetPos( ) )
				local dist = dist / 2
				local dist = math.floor( dist )
				
				if( dist > 50 ) then
				
					alpha = 255 - ( dist - 50 )
				
				else
				
					alpha = 255
				
				end
				
				if( alpha > 255 ) then
					
					alpha = 255
					
				elseif( alpha < 0 ) then
				
					alpha = 0
					
				end
				
				-- New Things START
				local trace = { }
				trace.start = LocalPlayer():EyePos();
				trace.endpos = trace.start + LocalPlayer():GetAimVector() * 300; -- LET US SEE WHAT HAPPENS WHEN I UNCOMMENT THIS LINE LOL
				--trace.endpos = v:GetPos() + Vector(0,0,40)
				trace.filter = LocalPlayer();
				
				local trv = util.TraceLine( trace );
				
				if trv.HitWorld then return; end
				-- New Things END
				
				draw.DrawText( v:Nick(), "TargetID", screenpos.x, screenpos.y - 30, Color( 0, 255, 0, alpha ), 1 )
				draw.DrawText( team.GetName( v:Team( ) ), "TargetID", screenpos.x, screenpos.y - 15, Color( 0, 255, 0, alpha ), 1 )
				draw.DrawText( v:GetNWString( "title" ), "TargetID", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
				
				if( v:GetNWInt( "chatopen" ) == 1 ) then
				
					draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, alpha ), 1 )
				
				end
				
				if( v:GetNWInt( "tiedup" ) == 1 ) then
				
					draw.DrawText( "Tied Up", "ChatFont", screenpos.x, screenpos.y - 60, Color( 255, 0, 0, alpha ), 1 )
				
				end
				
			end
			
		end
		
	end
	
end
]]--

function DrawPlayerInfo( ply )

	local position = ply:GetPos( )
	local position = Vector( position.x, position.y, position.z + 75 )
	local screenpos = position:ToScreen( )

	if( !ply:Alive( ) ) then return; end

	--draw.DrawText( "MY NAME HERE".. ply:Nick(), "LED", ScrW() / 2, 5, Color( 255, 255, 255, 255 ), 1 )
	-- draw.DrawText( team.GetName( ply:Team( ) ), "TargetID", screenpos.x, screenpos.y - 15, Color( 0, 255, 0, 255 ), 1 )
	-- draw.DrawText( ply:GetNWString( "title" ), "TargetID", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
				
	if( ply:GetNWInt( "chatopen" ) == 1 ) then
				
		draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, 255 ), 1 )
				
	end
				
	if( ply:GetNWInt( "tiedup" ) == 1 ) then
				
		draw.DrawText( "Tied Up", "ChatFont", screenpos.x, screenpos.y - 60, Color( 255, 0, 0, 255 ), 1 )
				
	end
	
end

function DrawHudStuff( )

	if( LocalPlayer():Alive() and LocalPlayer():Armor() > 0 ) then

	draw.RoundedBox( 2, 10, ScrH() - 30, 60, 25, Color( 0, 0, 0, 190 ) );
	draw.DrawText( "%"..LocalPlayer():Armor(), "PlInfoFont", 65, ScrH() - 10, Color( 255, 255, 255, 255 ), 2 );
	
	end
	
end

ShowingDeathMode = 0
function GM:HUDPaint( )
	local tr = LocalPlayer():GetEyeTrace();	
	if( LocalPlayer( ):GetNWInt( "deathmode" ) == 1 and ShowingDeathMode == 0) then
	
		DrawDeathHUD( )

		ShowingDeathMode = 1;
		
	end
	
	-- DrawPlayerInfo( );
if LocalPlayer():Alive() then 
    DrawHudStuff( );
	--DrawAmmoInfo( );
	--DrawPipBoy( )
	--DrawInfoBox( )
	--DrawIDCard( )
	DrawTopBar( )
	DrawBottomBar( )
	--DrawPipBoy3000( )
	DrawBottomScreen( )
	DrawOOCInfo( )
	DrawTime( );
	DrawTopScreen( )
	--DrawPlayerInfo( );

	if( !tr.HitNonWorld ) then TargetUnknown() return; end
	
	if( tr.Entity:IsValid() and tr.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 300 ) then
		
		if( tr.Entity:IsPlayer() ) then
				
			DrawPlayerInfo( tr.Entity );

			
		--elseif( tr.Entity:Is
		end
				
	end

	TargetName( tr.Entity )	
	--DrawTargetInfo( );
end	
end
