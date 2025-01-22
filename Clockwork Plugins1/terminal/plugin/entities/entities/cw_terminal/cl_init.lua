include("shared.lua");

surface.CreateFont( "panel_font", {
	
	[ "font" ] = "verdana",
	[ "size" ] = 12,
	[ "weight" ] = 128,
	[ "antialias" ] = true
	
} )

local sublimeMessages = {
	
	"He is watching",
	"Don't question the combine",
	"The combine is here to help",
	"4626"
	
}

local panel
local receiveTime
local urlOpened
local html
local keys = { KEY_4, KEY_6, KEY_2, KEY_6 }
local validKeysCount = 1
local secretScreen
local keyDown
local nextPress = CurTime();
local num = math.random(1,999)

local function ExitScreen()
	
	panel = nil
	receiveTime = nil
	urlOpened = nil
	keyDown = nil
	secretScreen = nil
	validKeysCount = 1
	
	if IsValid( html ) then html:Remove() end
	
end

local function CreateHTML()
	
	if IsValid( html ) then html:Remove() end
	
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "<:: CRITICAL ERROR ::>" )
	frame:SetSize( ScrW() - 256, ScrH() - 256 )
	frame:SetPos( 128, 128 )
	frame:MakePopup()
	frame:ShowCloseButton( true )
	
	local html = vgui.Create( "HTML", frame )
	html:SetSize( frame:GetWide() - 10, frame:GetTall() - 31 )
	html:SetPos( 5, 26 )
	html:OpenURL( "http://art642.com/wp-content/uploads/2016/04/Static.gif" )
	
	html = frame
	
end

local function CreateHTMLP()
	
	if IsValid( html ) then html:Remove() end
	
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "Applications" )
	frame:SetSize( ScrW() - 256, ScrH() - 256 )
	frame:SetPos( 128, 128 )
	frame:MakePopup()
	frame:ShowCloseButton( true )
	
	local html = vgui.Create( "HTML", frame )
	html:SetSize( frame:GetWide() - 10, frame:GetTall() - 31 )
	html:SetPos( 5, 26 )
	html:OpenURL( "http://precinct.one/applications/" )
	
	html = frame
	
end

function ENT:Draw()
	
	self:DrawModel()
	
	local ang = self:GetAngles()
	local pos = self:GetPos() + ang:Up() * 61.5 + ang:Right() * -8.2 + ang:Forward() * -10.75
	ang:RotateAroundAxis(ang:Right(), 105)
	ang:RotateAroundAxis(ang:Up(), -90)
	
	cam.Start3D2D( pos, ang, 0.1 )
	
	local width, height = 155, 130
	
	surface.SetDrawColor( Color( 16, 16, 16, 140 ) )
	surface.DrawRect( 0, 0, width, height )
	
	surface.SetDrawColor( Color( 255, 255, 255, 16 ) )
	surface.DrawRect( 0, height / 2 + math.sin( CurTime() * 4 ) * height / 2, width, 1 )
	
	local alpha = 191 + 64 * math.sin( CurTime() * 4 )
	local deltaTime = CurTime() - ( receiveTime or 0 )
	
	if not receiveTime or deltaTime < 0.5 then
		
		draw.SimpleText( "UU Terminal Uplink", "panel_font", width / 2, 25, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER )
		draw.SimpleText( "Insert your CID...", "panel_font", width / 2, height - 16, Color( 255, 255, 180, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
	elseif receiveTime then
		
		if not secretScreen then
		
			draw.SimpleText( string.format( "Session ID #"..num.." (%s)", string.rep( ".", math.Clamp( math.floor( ( deltaTime - 0.5 ) * 3 ), 0, 6 ) ) ), "panel_font", 5, 5, Color( 255, 255, 255, alpha ) )
			draw.SimpleText( "Log off ('E')", "panel_font", 5, height - 16, Color( 255, 255, 255, alpha ) )
		
			if deltaTime > 3 then
				draw.SimpleText( "'ENTER': Download News", "panel_font", 5, 36, Color( 255, 255, 255, alpha ) )
				draw.SimpleText( "'M': Submit Applications", "panel_font", 5, 46, Color( 255, 255, 255, alpha ) )
				draw.SimpleText( "'SPACE': View Civil Scoring", "panel_font", 5, 56, Color( 255, 255, 255, alpha ) )
			end
			
			if deltaTime < 0.6 then 
				
				surface.SetDrawColor( Color( 200, 200, 200 ) )
				surface.DrawRect( 0, 0, width, height )
				
				draw.SimpleText( sublimeMessages[ math.random( #sublimeMessages ) ], "panel_font", width / 2, height / 2, Color( 190, 190, 190, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
		
		else
			
			surface.SetFont( "panel_font" )
			local str = "GMan"
			local strWidth, strHeight = surface.GetTextSize( str )
			
			for i = 0, 5 do
				
				draw.SimpleText( string.rep( str, math.floor( width / strWidth ) ), "panel_font", 5, 5 + strHeight * i, Color( 190, 190, 190, alpha ) )
				
			end
			
		end
		
	end
	
	cam.End3D2D()
	
end

local function PanelThink()
	
	if receiveTime then
	
		local deltaTime = CurTime() - receiveTime
		if deltaTime > 2 and input.IsKeyDown( KEY_E ) then
		
			ExitScreen()
			RunConsoleCommand( "wp_eject" )
			
		else
			
			local keyEnum = keys[ validKeysCount ]
			if keyEnum then
				
				if input.IsKeyDown( keyEnum ) then
					
					if not keyDown then
					
						keyDown = true
						validKeysCount = validKeysCount + 1
					
					end
					
				elseif keyDown then
			
					keyDown = false
					
				end
				
			else
				
				surface.PlaySound( "ambient/machines/thumper_hit.wav" )
				
				secretScreen = true
				urlOpened = true
				
			end

			if nextPress < CurTime() and (input.IsKeyDown( KEY_ENTER ) or input.IsKeyDown( KEY_SPACE ) or input.IsKeyDown( KEY_M )) then
				if deltaTime > 3 and input.IsKeyDown( KEY_ENTER ) then
					CreateHTML()
					//gui.OpenURL( "http://phasecommunity.com/forum/index.php" )
					surface.PlaySound( "ambient/machines/keyboard7_clicks_enter.wav" )
					
					urlOpened = true
					
    			elseif nextPress < CurTime() and (input.IsKeyDown( KEY_M ) or input.IsKeyDown( KEY_ENTER ) or input.IsKeyDown( KEY_SPACE )) then
				if deltaTime > 3 and input.IsKeyDown( KEY_M ) then
					CreateHTMLP()
					//gui.OpenURL( "http://precinct.one/applications/" )
					surface.PlaySound( "ambient/machines/keyboard7_clicks_enter.wav" )
					
					urlOpened = true
					
				elseif deltaTime > 3 and input.IsKeyDown( KEY_SPACE ) then
					local vPoints = "N/A";
					local lPoints = "N/A";

					if (Clockwork.Client:GetSharedVar("vPoints") != "") then vPoints = Clockwork.Client:GetSharedVar("vPoints"); end;
					if (Clockwork.Client:GetSharedVar("lPoints") != "") then lPoints = Clockwork.Client:GetSharedVar("lPoints"); end;

					chat.AddText(Color(255,255,0),[[ Terminal Data ]],Color(255,255,255), "Verdict Points: "..vPoints.." | Loyalty Points: "..lPoints);
					surface.PlaySound( "ambient/machines/keyboard7_clicks_enter.wav" )
					
					urlOpened = true
				end
			nextPress = CurTime()+3
			end
			
	end
end
	
	if not LocalPlayer():Alive() and IsValid( panel ) then
		ExitScreen()
	end
	
end
end
hook.Add( "Think", "wp_think", PanelThink )

local function ReceiveUse( msg )
	
	local inUse = msg:ReadBool()
	if inUse then
	
		panel = msg:ReadEntity()
		local ang = panel:GetAngles()
		
		wantedViewPos = panel:GetPos() + ang:Up() * 52 + ang:Right() * 4 + ang:Forward() * -2
		viewPos = nil
		receiveTime = CurTime()
		
	
	else
	
		ExitScreen()
		
	end
	
end
usermessage.Hook( "wp_screen", ReceiveUse );