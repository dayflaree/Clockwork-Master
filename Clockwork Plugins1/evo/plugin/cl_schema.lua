--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.

SPAGHETTI CODE
]]

CreateClientConVar( "evo_names", 1, true, false )
CreateClientConVar( "evo_hud", 1, true, false )
CreateClientConVar( "evo_outlines", 1, true, false )
CreateClientConVar( "evo_crosshair", 0, true, false )
CreateClientConVar( "evo_outline_distance", 295, true, false )
CreateClientConVar( "evo_hud_distance", 175, true, false )

-- Get rid of them nasty display lines.
Schema.randomDisplayLines = {
	"CONNECTED TO OVERWATCH UPLINK...!"
};


local people = {}
local combine = {}

for k,v in pairs(player.GetAll()) do
	if ( v:IsPlayer() and v != LocalPlayer() and !v:IsNoClipping() and v:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_hud_distance") and !Schema:PlayerIsCombine(v)) then
		table.insert(people, v)
	elseif ( v:IsPlayer() and v != LocalPlayer() and !v:IsNoClipping() and v:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_hud_distance") and Schema:PlayerIsCombine(v)) then
		table.insert(combine, v)
	end
end

hook.Add("PreDrawHalos", "Outlines", function()
	if (Schema:PlayerIsCombine(LocalPlayer())) then
		for k,v in pairs(people) do
			halo.Add( v, Color(248,248,255,255), 0, 0, 1, true, false )
		end
		for k,v in pairs(combine) do
			halo.Add( v, Color(0,0,255,255), 0, 0, 1, true, false )
		end
	end
end)


-- Colours
colormal = Color(255, 10, 0, 255)
--[[coloryel = Color(255, 215, 0, 255)
colorgre = Color(50, 205, 50, 255)]]
coloryel = Color(255, 255, 255, 255)
colorgre = Color(255, 255, 255, 255)
color = Color(0, 128, 255, 255)
colorcitizen = Color(255, 250, 250, 255)

-- Fonts
surface.CreateFont( "HUDFont", {
	font = "BudgetLabel",
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "NameFont", {
	font = "BudgetLabel",
	size = 17,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = true,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )



-- Crosshair
hook.Add("HUDPaint", "Crosshair", function()
	if (ConVarExists( "evo_crosshair" ) and GetConVar("evo_crosshair"):GetInt() == 1) then
		if (Schema:PlayerIsCombine(LocalPlayer())) then
	local x = ScrW() / 2
	local y = ScrH() / 2
	surface.SetDrawColor(0, 128, 255, 255)
	local gap = 5
	local length = gap + 15
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
			end;
		end;
	end)



-- Settings Derma
concommand.Add("evo_settings", function()
        local frame = vgui.Create("DFrame")
		local PropertySheet = vgui.Create( "DPropertySheet" )
		PropertySheet:SetParent( frame )
		PropertySheet:SetPos( 0, 25 )
		PropertySheet:SetSize( 600, 215 )
        frame:SetPos((surface.ScreenWidth()/2) - 350,(surface.ScreenHeight()/2) - 350)
        frame:SetSize(600, 245)
        frame:SetTitle("Enhanced Visual Overlay - Menu")
        frame:SetBackgroundBlur( true )
        frame:SetDraggable( true )
        frame:MakePopup()

		local SheetItemOne = vgui.Create( "DPanel" )
		SheetItemOne:SetPos( 25, 50 )
		SheetItemOne:SetSize( 350, 230 )
		SheetItemOne.Paint = function() -- 
		surface.SetDrawColor( 50, 50, 50, 255 ) -- 
		surface.DrawRect( 0, 0, SheetItemOne:GetWide(), SheetItemOne:GetTall() )
		end

		local NamesBox = vgui.Create( "DCheckBoxLabel", SheetItemOne )
		NamesBox:SetPos( 15, 15 )
		NamesBox:SetText( "Enable Friendly Names" )
		NamesBox:SetConVar( "evo_names" )
		NamesBox:SizeToContents()

		local HudBox = vgui.Create( "DCheckBoxLabel", SheetItemOne )
		HudBox:SetPos( 15, 30 )
		HudBox:SetText( "Enable the EVO HUD" )
		HudBox:SetConVar( "evo_hud" )
		HudBox:SizeToContents()	

		local OutBox = vgui.Create( "DCheckBoxLabel", SheetItemOne )
		OutBox:SetPos( 15,45 )
		OutBox:SetText( "Enable Detection" )
		OutBox:SetConVar( "evo_outlines" )
		OutBox:SizeToContents()

		local CrossBox = vgui.Create( "DCheckBoxLabel", SheetItemOne )
		CrossBox:SetPos( 15,60 )
		CrossBox:SetText( "Enable the Crosshair" )
		CrossBox:SetConVar( "evo_crosshair" )
		CrossBox:SizeToContents()

		local HUDDistanceMod = vgui.Create( "DNumSlider", SheetItemOne )
		HUDDistanceMod:SetPos( 15,90 )
		HUDDistanceMod:SetSize( 450, 50 )
		HUDDistanceMod:SetText( "HUD Distance Modifier" )
		HUDDistanceMod:SetMin( 260 )
		HUDDistanceMod:SetMax( 3000 )
		HUDDistanceMod:SetDecimals( 0 )
		HUDDistanceMod:SetConVar( "evo_hud_distance" )		

		local OutlineDistanceMOD = vgui.Create( "DNumSlider", SheetItemOne )
		OutlineDistanceMOD:SetPos( 15,105 )
		OutlineDistanceMOD:SetSize( 550, 50 )
		OutlineDistanceMOD:SetText( "Detection Distance Modifier" )
		OutlineDistanceMOD:SetMin( 5 )
		OutlineDistanceMOD:SetMax( 295 )
		OutlineDistanceMOD:SetDecimals( 0 )
		OutlineDistanceMOD:SetConVar( "evo_outline_distance" )														

		PropertySheet:AddSheet( "Settings", SheetItemOne, "icon16/wrench.png", false, false, "Configure the settings for your visual overlay." )        		
end)



-- General Interface
hook.Add("HUDPaint", "General Interface", function()
	if (Schema:PlayerIsCombine(LocalPlayer())) then
	for k,e in pairs ( player.GetAll() ) do
		if ( e:IsPlayer() and e != LocalPlayer() and !e:IsNoClipping() and e:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_hud_distance")) then
		local Position = ( e:GetPos() + Vector( 0,0,80 ) ):ToScreen()
		local font = "HUDFont"

			if (ConVarExists( "evo_names" ) and GetConVar("evo_names"):GetInt() == 1 and Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: #"..string.sub(e:Name(), -2).." ::>", "NameFont", Position.x, Position.y + 15, color, 1 )
			elseif (ConVarExists( "evo_names" ) and GetConVar("evo_names"):GetInt() == 1) then
					--draw.DrawText( ":V:", "NameFont", Position.x, Position.y + 15, coloryel, 1 )
			end;

		if (ConVarExists( "evo_hud" ) and GetConVar("evo_hud"):GetInt() == 1) then	
			local model = e:GetModel()
			if (e:Health() <= 0 and Schema:PlayerIsCombine(e)) then
				draw.DrawText( "<:: UNIT DESERVICED. ASSESS AND RESPOND. ::>", font, Position.x, Position.y + 81, colormal, 1 )
			elseif(e:Health()<= 0) then
				draw.DrawText( "<:: NO LIFE SIGNS. ASSESS AND RESPOND. ::>", font, Position.x, Position.y + 81, colormal, 1 )
			elseif (e:Health() <= 10) then
				draw.DrawText( "<:: MAMED. ASSESS AND RESPOND. ::>", font, Position.x, Position.y + 31, coloryel, 1 )
			elseif (e:Health() <= 96) then
				draw.DrawText( "<:: SUBJECT INJURED. MONITOR. ::>", font, Position.x, Position.y + 31, coloryel, 1 )
			end;

			if (e:IsRagdolled() and e:Alive()) then
				draw.DrawText( "<:: SUBJECT UNCONSCIOUS. INQUIRE. ::>", font, Position.x, Position.y + 81, colormal, 1 )
			elseif (e:GetSharedVar("tied") != 0 and !Schema:PlayerIsCombine(e)) then
				draw.DrawText( "<:: RESTRAINED. INQUIRE AND RESPOND. ::>", font, Position.x, Position.y + 44, colorgre, 1 )
			elseif (e:GetSharedVar("tied") != 0 and Schema:PlayerIsCombine(e)) then
				draw.DrawText( "<:: RESTRAINED UNIT. INQUIRE AND ASSIST. ::>", font, Position.x, Position.y + 44, coloryel, 1 )
			end;

			if (e:FlashlightIsOn()) then
					draw.DrawText( "<:: FLASHLIGHT ACTIVE.", font, Position.x, Position.y + 57, colorgre, 1 )
			end;

				if (e:IsOnFire()) then
					draw.DrawText( "<:: ON FIRE. ASSESS. ::>", font, Position.x, Position.y + 57, colormal, 1 )
				elseif (e:InVehicle() and !Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: ILLEGAL VEHICULAR USAGE. ASSESS AND RESPOND. ::>", font, Position.x, Position.y + 57, colormal, 1 )
				elseif (e:IsRunning() or e:IsJogging()) then
					if (!Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: MOBILE VIOLATION. PROSECUTE. ::>", font, Position.x, Position.y + 57, coloryel, 1 )
					end;
				elseif (e:Crouching() and !Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: SUBJECT IN STEALTH/HIDING. INQUIRE. ::>", font, Position.x, Position.y + 57, coloryel, 1 )
				elseif (e:Crouching() and Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: OPERATING COVERTLY. ASSIST. ::>", font, Position.x, Position.y + 57, colorgre, 1 )
					end;
			
			
				end;
			end;
		end;	

	end;
end)



--[[hook.Add("HUDPaint", "Flying Words", function()
if (ConVarExists( "evo_outlines" ) and GetConVar( "evo_outlines" ):GetInt() == 1 and Schema:PlayerIsCombine(LocalPlayer())) then
	for k,ent in pairs (ents.FindByClass("cw_item")) do
		if LocalPlayer():Alive() and (Clockwork.entity:HasFetchedItemData(ent)) then
		local Table = ent:GetItemTable()
		local ita =  Table("category")	
		local Position = ( ent:GetPos() + Vector( 0,0,0 ) ):ToScreen()
		local distance = ent:GetPos():Distance(LocalPlayer():GetPos()); 
	if (ita == "Weapons") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: INVESTIGATE LEGALITY ::>", "HUDFont", Position.x, Position.y - 10, Color(255, 255, 255, 255), 1 )
		draw.DrawText( "<:: WARNING: "..Table("name"), "HUDFont", Position.x, Position.y, Color(255, 0, 10, 255), 1 )
		draw.DrawText( "<:: PROXIMITY: " .. math.floor(distance), "HUDFont", Position.x, Position.y + 10, Color(255, 0, 10, 255), 1 )
		end;
	elseif (ita == "Ammunition") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: INVESTIGATE LEGALITY ::>", "HUDFont", Position.x, Position.y - 10, Color(255, 255, 255, 255), 1 )
		draw.DrawText( "<:: ATTENTION: "..Table("name"), "HUDFont", Position.x, Position.y, Color(10, 80, 255, 255), 1 )
		draw.DrawText( "<:: PROXIMITY: " .. math.floor(distance), "HUDFont", Position.x, Position.y + 10, Color(10, 80, 255, 255), 1 )
		end;
	elseif (ita == "Medical" and ita != "Weapons" and ita != "Ammunition") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: "..Table("name"), "HUDFont", Position.x, Position.y, Color(0, 255, 10, 255), 1 )
		draw.DrawText( "<:: PROXIMITY: " .. math.floor(distance), "HUDFont", Position.x, Position.y + 10, Color(0, 255, 10, 255), 1 )
		end;
	end;
				end;
			end;

		end;	
end)]]

-- A function that modifies the Combine Display lines.
function Schema:AddCombineDisplayLine(text, color)
	if (self:PlayerIsCombine(Clockwork.Client)) then
		if (!self.combineDisplayLines) then
			self.combineDisplayLines = {};
		end;
		
		table.insert(self.combineDisplayLines, {"!<:: "..text.." ::>", CurTime() + 25, 5, color});
	end;
end;
