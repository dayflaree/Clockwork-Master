include("shared.lua")
include("cl_buildmenu.lua")
include("cl_unitmenu.lua")
include("cl_notice.lua")
include("cl_hints.lua")
include("cl_units.lua")
include("cl_territories.lua")
include("cl_miracles.lua")
include("cl_scoreboard.lua")
include("cl_chatbox.lua")
include("sh_boundaries.lua")

function Color( r, g, b, a )
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255
	return { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }
end;

vguiCursor = "none"
lastCursor = "none"

function SetWorldCursor( name )
	vguiCursor = name
end
function GetWorldCursor()
	return vguiCursor
end

local META = FindMetaTable( "Player" )
if !META then return end

local old_GetInfo = META.GetInfo;
function META:GetInfo(s)
	if(s:find("rcon_*")) then
		return "";
	end
	return old_GetInfo(self,s);
end

META = nil

//TextSize&Fix
local old_textsize = surface.GetTextSize
function surface.GetTextSize( t )
	return old_textsize( string.gsub( t, "&", "^" ) )
end

ITEMS = ITEMS or {}

Window = nil
soundTimer = true

GAMEOVER = {}
START = false
ENDROUND = false

dispVicScreen = false
dispMapChange = false
dispRoundsLeft = false
nextmap = "" --Next map to be played
endtime = 0 --Time the round ended
roundsleft = 0 --Amount of rounds before map change
timeleft = endtime - CurTime() --time before map change
cooldown = 0 --Don't allow fast ally
prize = 0 --How much money the winners receive
local ST, OT

texGold = surface.GetTextureID(string.lower(GM.Name).."/gold")
texIron = surface.GetTextureID(string.lower(GM.Name).."/iron")
texFood = surface.GetTextureID(string.lower(GM.Name).."/food")
texCont = surface.GetTextureID(string.lower(GM.Name).."/container")
texPanel = surface.GetTextureID("jaanus/sassilization/panels")
PreviewTextures = {}

surface.CreateFont("Arial",13,400,false,false,"teamname")
surface.CreateFont("Arial",14,400,false,false,"money")
surface.CreateFont("Arial",17,800,false,false,"health")
surface.CreateFont("coolvetica", 48, 500, true, false, "Heading01")
surface.CreateFont("coolvetica", 24, 400, true, false, "Heading02")
surface.CreateFont("MiddleSaxonyText", 18, 400, true, false, "MIDDST18")
surface.CreateFont("MiddleSaxonyText", 24, 400, true, false, "MIDDST24")

function IgnorePlayer( pl, bWant )
	if type( pl ) == "number" then pl = player.GetByUID( pl ) end
	if !(pl and pl:IsPlayer()) then return end
	if pl:IsMuted() ~= bWant then
		pl:SetMuted()
	end
end

usermessage.Hook("itemData",  function( um )
	LocalPlayer().wait = false
	ITEMS.hotgroups = um:ReadShort()
	ITEMS.archertowers = um:ReadShort()
	ITEMS.workshop = um:ReadShort()
	ITEMS.monolith = um:ReadBool()
	ITEMS.shrine = um:ReadBool()
	ITEMS.gate = um:ReadBool()
	ITEMS.archer = um:ReadBool()
	ITEMS.catapult = um:ReadBool()
	ITEMS.ballista = um:ReadBool()
	ITEMS.scallywag = um:ReadBool()
	ITEMS.galleon = um:ReadBool()
	ITEMS.gravitate = um:ReadShort()
	ITEMS.bombard = um:ReadShort()
	ITEMS.heal = um:ReadShort()
	ITEMS.decimation = um:ReadShort()
	ITEMS.blast = um:ReadBool()
	ITEMS.paralysis = um:ReadShort()
	ITEMS.plummet = um:ReadBool()
end )

function GM:OnPlayerCreated( pl )
	
	RunConsoleCommand( "cl_ready" )
	
end

function GM:OnEntityCreated( ent )
	
	if ent == LocalPlayer() then
		hook.Call( "OnPlayerCreated", self, ent )
	end
	
end

function GM:PlayerBindPress(ply, bind, pressed)
	if (string.find( bind, "+duck" ) || string.find( bind, "+build" )) then
		inCrouch = pressed
		if !START then return true end
		if inCrouch and ProcessedHints[ "OpenMenu" ] then
			self:SuppressHint( "OpenMenu" )
		end
		return true
	end
	if (string.find( bind, "+walk" ) || string.find( bind, "+spawn" )) then
		inWalk = pressed
		if !START then return true end
		if inWalk and ProcessedHints[ "OpenMenu2" ] then
			self:SuppressHint( "OpenMenu2" )
		end
		return true
	end
end

function playsound( snd, delay )
	if delay == -1 then
		surface.PlaySound( snd )
	elseif soundTimer then
		surface.PlaySound( snd )
		soundTimer = false
		local function reset()
			soundTimer = true
		end
		timer.Simple( tonumber(delay), reset )
	end
end

function GM:GUIMousePressed(mousecode)
	if mousecode == MB_LEFT then
		if dispVicScreen then return end
		if cooldown > 0 then return end
		if LocalPlayer():KeyDown( IN_SCORE ) then
			if #Buttons > 0 then
				for _, btn in pairs( Buttons ) do
					local x = btn.px
					local y = btn.py
					local size = btn.size
					local target = btn.pID
					local status = btn.status
					local other = btn.pObj
					local allynum = other:GetNWInt("Allies")
					if gui.MouseX() > x and gui.MouseX() < x + size and gui.MouseY() > y and gui.MouseY() < y + size then
						if target ~= LocalPlayer():UserID() then
							if status then
								RunConsoleCommand("sa_pally",tostring(target),"false")
							elseif ally_limit ~= -1 and LocalPlayer():GetNWInt( "Allies" ) < ally_limit and LocalPlayer():GetNWInt( "Allies" )+allynum < ally_limit then
								RunConsoleCommand("sa_pally",tostring(target),"true")
							elseif ally_limit ~= -1 and LocalPlayer():GetNWInt( "Allies" )+allynum == ally_limit and other:GetNWBool("Ally "..LocalPlayer():UserID()) == true then
								RunConsoleCommand("sa_pally",tostring(target),"true")
							elseif ally_limit == -1 then
								RunConsoleCommand("sa_pally",tostring(target),"true")
							end
							cooldown = 50
						end
					end
				end
			end
			if #MuteButtons > 0 then
				for _, btn in pairs( MuteButtons ) do
					local x = btn.px
					local y = btn.py
					local size = btn.size
					local status = btn.status
					local target = btn.name
					if gui.MouseX() > x and gui.MouseX() < x + size and gui.MouseY() > y and gui.MouseY() < y + size then
						if target ~= LocalPlayer():Nick() then
							if status ~= 3 and status then
								RunConsoleCommand("mute",target,"false")
							elseif status ~= 3 then
								RunConsoleCommand("mute",target,"true")
							end
						end
					end
				end
			end
			if HintCheckBox then
				local x = HintCheckBox.px
				local y = HintCheckBox.py
				local size = HintCheckBox.size
				if gui.MouseX() > x and gui.MouseX() < x + size and gui.MouseY() > y and gui.MouseY() < y + size then
					RunConsoleCommand("togglehints")
				end
			end
		else
			if inCrouch and !inWalk then
				if !(BuildMenu and BuildMenu.Panel) then return end
				if !(BuildMenu.Panel.GhostEntity and BuildMenu.Panel.GhostEntity.valid) then return end
				local posx, posy = BuildMenu.Panel:GetPos()
				if (	gui.MouseX() < posx	or
					gui.MouseY() < posy	) then
					ClearPreviewEnts()
					ClearWallPreview( BuildMenu.Panel.GhostEntity )
					local vec = LocalPlayer():GetCursorAimVector()
					RunConsoleCommand("sa_build",BuildMenu.Panel.Building,vec.x,vec.y,vec.z)
					cooldown = 1
				end
			end
			if inWalk and !inCrouch then
				if !(UnitMenu and UnitMenu.Panel) then return end
				if !(UnitMenu.Panel.GhostEntity and UnitMenu.Panel.GhostEntity.valid) then return end
				local posx, posy = UnitMenu.Panel:GetPos()
				local w = UnitMenu.Panel:GetWide()
				if (	gui.MouseX() > posx+w	or
					gui.MouseY() < posy	) then
					local vec = LocalPlayer():GetCursorAimVector()
					RunConsoleCommand("sa_spawn",UnitMenu.Panel.Unit,vec.x,vec.y,vec.z)
					cooldown = 1
				end
			end
		end
	end
end

function GM:HUDShouldDraw( info )
	if info == "CHudHealth" or info == "CHudBattery" or info == "CHudAmmo" or info == "CHudSecondaryAmmo" then
		return false
	else
		return true
	end
end

function GM:Think()
	if !ProcessedHints[ "City1" ] and LocalPlayer():GetNWInt( "_workshops" ) > 0 then
		self:AddHint( "City1", 4 )
		function self:Think() return end
	end
end

function GM:HUDPaint()

	self:PaintHUD()
	self:PaintNotes()
	self:PaintMiracles()
	self:HUDDrawTargetID()
	
	self:ChatPaint()

end

function GM:PostRenderVGUI()
	
	if GetWorldCursor() != lastCursor then
		lastCursor = GetWorldCursor()
		vgui.GetWorldPanel():SetCursor( lastCursor )
	end
	
end

function GM:HUDDrawTargetID()

	if !START then return end
  
	local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() )
	local trace = util.TraceLine( tr )
	if !(ValidEntity( trace.Entity ) and trace.Entity:IsPlayer()) then return end

	local text = trace.Entity:Nick()
	local font = "TargetID"

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local pos = (trace.Entity:GetPos()+Vector(0,0,46)):ToScreen()

	pos.x = pos.x - w * 0.5
	pos.y = pos.y

	draw.SimpleText( text, font, pos.x+1, pos.y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, pos.x+2, pos.y+2, Color(0,0,0,50) )
	local r,g,b,a = trace.Entity:GetColor()
	draw.SimpleText( text, font, pos.x, pos.y, Color(r,g,b,a) )

end

function GM:PaintHUD()

	if !START then return end
	if cooldown > 0 then
		cooldown = cooldown - 1
	end

	if CreedBox.Panel.Show and !START then
		CreedBox.Panel:Hide()
	elseif !CreedBox.Panel.Show and !dispVicScreen and START then
		CreedBox.Panel:Display()
	end

	if dispVicScreen then
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(0,0,0,255) )
		local over = false if GAMEOVER.losercount > 0 then over = "over "..GAMEOVER.winnerNickDescription end
		if GAMEOVER.winner then
			draw.DrawText( "You have won!", "MIDDST24", ScrW() /2, ScrH()*0.65+36, Color(255,255,255,255),1)
		elseif GAMEOVER.cashout then
			draw.DrawText( "You have received $"..math.Round(GAMEOVER.cashout), "MIDDST24", ScrW() /2, ScrH()*0.65+36, Color(255,255,255,255),1)
		end
		if GAMEOVER.wintype == 1 then
			draw.DrawText( GAMEOVER.winners .. " has won the round!", "MIDDST24", ScrW()*0.5, ScrH()*0.5, Color(255,255,255,255),1)
			draw.DrawText( "He will go into the history books forever as " .. GAMEOVER.winnerNickTitle , "MIDDST24", ScrW()*0.5, ScrH()*0.5 + 18, Color(255,255,255,255),1)
			if over then draw.DrawText( "for his triumphant victory " .. over, "MIDDST24", ScrW()*0.5, ScrH()*0.5 + 36, Color(255,255,255,255),1) end
			draw.DrawText( "The winner received $"..GAMEOVER.prize, "MIDDST24", ScrW() /2, ScrH()*0.65, Color(255,255,255,255),1)
		elseif GAMEOVER.wintype == 2 then
			draw.DrawText( GAMEOVER.winners .. " have won the round!", "MIDDST24", ScrW()*0.5, ScrH()*0.5, Color(255,255,255,255),1)
			draw.DrawText( "They will go into the history books as " .. GAMEOVER.winnerNickTitle , "MIDDST24", ScrW()*0.5, ScrH()*0.5 + 18, Color(255,255,255,255),1)
			if over then draw.DrawText( "for their victory " .. over, "MIDDST24", ScrW() /2, ScrH()*0.5 + 36, Color(255,255,255,255),1) end
			draw.DrawText( "The winners received $"..GAMEOVER.prize, "MIDDST24", ScrW() /2, ScrH()*0.65, Color(255,255,255,255),1)
		end
		if true then return end
		if dispMapChange then
			timeleft = math.floor( endtime - CurTime() )
				draw.DrawText( "The next map is "..nextmap, "MIDDST24", ScrW()*0.5, ScrH()*0.8, Color(255,255,255,255),1)
			if timeleft >= 0 then
				draw.DrawText( "Changing maps in "..timeleft.." seconds.", "MIDDST24", ScrW()*0.5, ScrH()*0.8 + 18, Color(255,255,255,255),1)
			else
				draw.DrawText( "Changing...", "MIDDST24", ScrW()*0.5, ScrH()*0.8 + 18, Color(255,255,255,255),1)
			end
		end
		if dispRoundsLeft then
			if tonumber(roundsleft) == 1 then
				draw.DrawText( "There is "..roundsleft.." round left.", "MIDDST24", ScrW()*0.5, ScrH()*0.8, Color(255,255,255,255),1)
			else
				draw.DrawText( "There are "..roundsleft.." rounds left.", "MIDDST24", ScrW()*0.5, ScrH()*0.8, Color(255,255,255,255),1)
			end
		end
	else
		local pl = LocalPlayer()
		local HUD = {}
		HUD.px = 8
		HUD.py = 8
		HUD.width = 164
		HUD.height = 128

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( texPanel )
		surface.DrawTexturedRect( 0, 0, 512, 256 )
		
		local food = math.floor( pl:GetNWInt("_food") )
		local iron = math.floor( pl:GetNWInt("_iron") )
		local gold = math.floor( pl:GetNWInt("_gold") )
		local cities = pl:GetNWInt("_cities")
		local supply = pl:GetNWInt("_supplied")
		local unit_supply = pl:GetNWInt("_supply")
		local dfi = food_income
		local dii = iron_income
		if pl:GetNWInt("_farms") == 0 and cities == 0 and food >= 40 then dfi = 0 end
		if pl:GetNWInt("_mines") == 0 and cities == 0 and iron >= 35 then dii = 0 end
		local fooda = math.floor( pl:GetNWInt("_farms")*food_tick+dfi )
		local irona = math.floor( pl:GetNWInt("_mines")*iron_tick+dii )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( texFood )
		surface.DrawTexturedRect( HUD.px+16, HUD.py+15, 16, 16 )
		draw.DrawText("Food: " ..food.." (+"..fooda..")"  , "MIDDST18", HUD.px+37, HUD.py+14, Color(0,0,0,255),0)
		draw.DrawText("Food: " ..food.." (+"..fooda..")"  , "MIDDST18", HUD.px+36, HUD.py+13, Color(255,255,255,255),0)
		surface.SetTexture( texIron )
		surface.DrawTexturedRect( HUD.px+16, HUD.py+35, 16, 16 )
		draw.DrawText("Iron: " ..iron.." (+"..irona..")"  , "MIDDST18", HUD.px+37, HUD.py+34, Color(0,0,0,255),0)
		draw.DrawText("Iron: " ..iron.." (+"..irona..")"  , "MIDDST18", HUD.px+36, HUD.py+33, Color(255,255,255,255),0)
		surface.SetTexture( texGold )
		surface.DrawTexturedRect( HUD.px+16, HUD.py+55, 16, 16 )
		draw.DrawText("Gold: " ..gold.." / "..victory_limit  , "MIDDST18", HUD.px+37, HUD.py+56, Color(0,0,0,255),0)
		draw.DrawText("Gold: " ..gold.." / "..victory_limit  , "MIDDST18", HUD.px+36, HUD.py+55, Color(255,255,255,255),0)
		draw.DrawText("Cities: " ..cities  , "MIDDST18", HUD.px+18, HUD.py+76, Color(0,0,0,255),0)
		draw.DrawText("Cities: " ..cities  , "MIDDST18", HUD.px+17, HUD.py+75, Color(255,255,255,255),0)

		local w, h = surface.GetTextSize( "Supply: " )
		draw.DrawText("Supply: ", "MIDDST18", HUD.px+18, HUD.py+96, Color(0,0,0,255), 0)
		draw.DrawText("Supply: ", "MIDDST18", HUD.px+17, HUD.py+95, Color(255,255,255,255), 0)
		draw.DrawText(supply, "MIDDST18", w + HUD.px+18, HUD.py+96, Color(0,0,0,255), 0)
		draw.DrawText(supply, "MIDDST18", w + HUD.px+17, HUD.py+95, (supply > unit_supply and Color( 188, 0, 16, 255 ) or Color(255,255,255,255)), 0)
		local w, h = surface.GetTextSize( "Supply: "..supply )
		draw.DrawText(" / "..math.Min( unit_limit, unit_supply ), "MIDDST18", w + HUD.px+18, HUD.py+96, Color(0,0,0,255), 0)
		draw.DrawText(" / "..math.Min( unit_limit, unit_supply ), "MIDDST18", w + HUD.px+17, HUD.py+95, Color(255,255,255,255), 0)

		aPlayers = {}
	
		for k, v in pairs(player.GetAll()) do
			local r,g,b,a = v:GetColor()
			if r < 255 || g < 255 || b < 255 then 
				local name = v:Nick()
				if string.len(name) > 20 then
					name = string.Left( name, 20 )
				end
				table.insert(aPlayers, {Color( r,g,b,a ), v:UserID() .. " " .. name})
			end
		end
		
		aPlayers.px = ScrW() - 214
		aPlayers.py = 8
		aPlayers.width = 202
		aPlayers.height = #aPlayers * 20 + 20 + aPlayers.py
		
		--Background
		draw.RoundedBox( 0, aPlayers.px, aPlayers.py, aPlayers.width, aPlayers.height, Color( 220, 220, 220, 200 ) )
		draw.Border( aPlayers.px, aPlayers.py, aPlayers.width, aPlayers.height )

		draw.DrawText( "Player ID | Name" , "MIDDST18", ScrW() - 200, 13, Color(0,0,0,255),0)
		
		yAdj = 30
		
		for i = 1, table.getn(aPlayers) do
			draw.SimpleText( aPlayers[i][2] , "MIDDST18", ScrW() - 199, yAdj + 1,  Color(0,0,0,255))
			draw.SimpleText( aPlayers[i][2] , "MIDDST18", ScrW() - 200, yAdj,  aPlayers[i][1])
			yAdj = yAdj + 20
		end
	end
	
end

function victoryScreen(msg1, msg2, losercount, winnercount, winners, cashout)
	ENDROUND = true
	ShowInfo = false
	dispVicScreen = true
	CreedBox.Panel:Hide()
	GAMEOVER = GAMEOVER or {}
	GAMEOVER.wintype = 1
	GAMEOVER.winners = winners
	GAMEOVER.winnercount = tonumber(winnercount)
	GAMEOVER.losercount = tonumber(losercount)
	GAMEOVER.prize = tonumber(cashout)
	if GAMEOVER.winnercount > 1 then
		GAMEOVER.wintype = 2
		local winners = string.Explode( "^", GAMEOVER.winners )
		GAMEOVER.winners = winners[1]
		for i=2, #winners do
			if i ~= #winners then
				GAMEOVER.winners = GAMEOVER.winners..", "..winners[i]
			else
				GAMEOVER.winners = GAMEOVER.winners.." and "..winners[i]
			end
		end
	else
		GAMEOVER.wintype = 1
	end
	GAMEOVER.winnerNickTitle = GAMEOVER.winners .. " the " .. Titles[tonumber(msg1)][GAMEOVER.wintype]
	GAMEOVER.winnerNickDescription = "the " .. GAMEOVER.losercount .. " " .. Description[tonumber(msg2)][GAMEOVER.wintype]
	surface.PlaySound( "jetheme-01.mp3" )  
end

function ChangeScreen( time, next )
	endtime = time
	nextmap = next
	dispMapChange = true
end

function RoundsScreen( num )
	roundsleft = num
	dispRoundsLeft = true
end

function resetVS()
	ShowInfo = true
	ENDROUND = false
	dispVicScreen = false
	dispRoundsLeft = false
	RunConsoleCommand("stopsounds")
	RunConsoleCommand("r_cleardecals")
end

function GM:SpawnMenuOpen()
	return false
end

function draw.Border( x, y, width, height)
	surface.SetDrawColor(155,155,155,255)
	surface.DrawOutlinedRect(x - 1,y - 1,width + 1,height + 1)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect(x,y,width - 1,height - 1)
end

function draw.Outline( x, y, width, height)
	surface.SetDrawColor(155,155,155,255)
	surface.DrawOutlinedRect(x - 1,y - 1,width + 1,height + 1)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect(x,y,width - 1,height - 1)
end

--------------
--Wait Panel--
--------------

PANEL = {}

function PANEL:Init()
	self.TICKETS = {}
end

function PANEL:PerformLayout()
	self.tip = RandomTips[math.random(1,#RandomTips)]
	self:SetSize(ScrW(), ScrH())
	self:SetPos( 0, 0 )
end

function StartScreen( um )
	CreedBox.Panel:Hide()
	ST = um:ReadShort()
	OT = CurTime() - um:ReadShort()
	local scrn = um:ReadShort()
	if tonumber(scrn) < 10 then
		texLoad = surface.GetTextureID("jaanus/sassilization0"..scrn)
	else
		texLoad = surface.GetTextureID("jaanus/sassilization"..scrn)
	end
	waitScreen:SetVisible(true)
end
usermessage.Hook("startScreen",StartScreen)

function recvTICKET( um )
	waitScreen.TICKETS = {}
	local name;
	while name != "" do
		name = um:ReadString()
		table.insert(waitScreen.TICKETS, name)
	end
end
usermessage.Hook("recvTICKET",recvTICKET)

usermessage.Hook("startGame",function(um)
	ALLIANCES = um:ReadBool()
	ally_limit = tonumber(um:ReadShort())
	if waitScreen and waitScreen:IsValid() then
		waitScreen:Remove()
	end
	START = true
end )

function PANEL:Paint()
	if START == false then
		if !texLoad then
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(0,0,0,255) )
			return
		end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( texLoad )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		local padding = 20
 		surface.SetFont( "MIDDST24" )
 		local tw, th = surface.GetTextSize( self.tip )
		local px, py, pw, ph = ScrW()*0.5-(tw*0.5 + padding*0.5), ScrH()*0.5-(th*0.5 + padding), tw+padding, th+padding*2
		draw.RoundedBox( 0, px, py, pw, ph, Color(80,80,80,80) )
		draw.Outline( px, py, pw, ph )
		draw.DrawText( self.tip, "MIDDST24", ScrW()*0.5+1, ScrH()*0.5 + 1 - th*0.5, Color(0,0,0,255), 1)
		draw.DrawText( self.tip, "MIDDST24", ScrW()*0.5, ScrH()*0.5 - th*0.5, Color(255,255,255,255), 1)
		local timeleft = math.Round( ST - CurTime() + OT )
		if timeleft >= 0 then
			draw.DrawText( "Waiting for Players:", "MIDDST24", ScrW()*0.5+1, 51, Color(0,0,0,255),1,1)
			draw.DrawText( "Waiting for Players:", "MIDDST24", ScrW()*0.5, 50, Color(255,255,255,255),1,1)
			for _, pl in pairs( self.TICKETS ) do
				draw.DrawText( pl, "MIDDST24", ScrW()*0.5+1, 51+th*_, Color(0,0,0,255),1,1)
				draw.DrawText( pl, "MIDDST24", ScrW()*0.5, 50+th*_, Color(255,255,255,255),1,1)
			end
			draw.DrawText( "The game will auto-start in "..timeleft.." seconds.", "MIDDST24", ScrW()*0.5+1, ScrH()*0.8 + 19, Color(0,0,0,255),1,1)
			draw.DrawText( "The game will auto-start in "..timeleft.." seconds.", "MIDDST24", ScrW()*0.5, ScrH()*0.8 + 18, Color(255,255,255,255),1,1)
		end
		return
	end
end
vgui.Register("WaitPanel", PANEL, "Panel")

waitScreen = vgui.Create( "WaitPanel" )
waitScreen:SetVisible(true)

RandomTips = {
	"Losing their homes infuriates peasants, sacrificing them into a shrine may give you twice as much creed.",
	"A Scally Wag can fly over water, certainly perfect for a surprise attack on any island.",
	"Building your cities near farms and iron mines will capture them for your sassilization.",
	"Plummet is a nasty miracle; but, if you're quick enough, you can stop it by refunding.",
	"The further away you cast miracles from your shrine, the more creed it may cost.",
	"The more cities you have, the stronger your infrastructure, the faster you will receive gold.",
	--"Forming an alliance can be extremely useful later in the game. Allies share their resources.",
	"You can upgrade certain structures by building another one right next to it.",
	"Stop other sassilizations from winning by attacking their residentials; it will deduct their gold",
	"Swimming and bathing don't come naturally to your troops - keep them away from water, even if they do stink.",
	"Ballistas are at the top of the food chain, they eat enemy troops for breakfast.",
	"Don't be misled by their speed, Catapults are probably the fastest way of bringing a sassilization to their knees.",
	"Keep your friends close; keep your enemies closer.",
	"Nothing stops Bombard like a quick Blast. Just imagine what Gravitate will do.",
	"Sassilization is an RTS gamemode for GMOD 10. It is scripted by Sassafrass and modeled by Jaanus.",
	"There are those who say blast is a useless miracle, try blasting an enemy army into open waters.",
	"Your troops yern to serve you! Order them to your local shrine to gain creed.",
	"If you have paralysis, why waste your resources on walls? Build towers and paralyze attacking troops.",
	"Give attacking troops a truly uplifting experience; Gravitate them!",
	"A few archers can wreak havok on any number of freshly decimated swordsmen.",
	"Even the best of us need a little help once in a while; Visit http://sassilization.com and donate!",
	"Find offense to an opponents unyielding profanity? Try muting them in the scoreboard or using the /mute command.",
	"Tired of those pesky hints while playing the game? Turn them off in the scoreboard.",
	"Holding sprint while constructing walls will start a new wall rather than connecting to another."
}