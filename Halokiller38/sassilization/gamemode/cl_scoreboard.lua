CreateClientConVar( "sa_debug", "0", true, false )

local texAdd = surface.GetTextureID("gui/silkicons/add")
local texOn = surface.GetTextureID("gui/silkicons/check_on")
local texOff = surface.GetTextureID("gui/silkicons/check_off")
local texFriendly = surface.GetTextureID("gui/silkicons/user")
local texAlert = surface.GetTextureID("gui/silkicons/exclamation")

function GM:ScoreboardShow()
	if !menu_on then
		GAMEMODE.ShowScoreboard = true
		gui.EnableScreenClicker(true)
	end
end

function GM:ScoreboardHide()
	if GAMEMODE.ShowScoreboard then
		GAMEMODE.ShowScoreboard = false
		gui.EnableScreenClicker(false)
	end
end

function GM:GetTeamScoreInfo() 
   
 	local TeamInfo = {} 

 	for id,pl in pairs( player.GetAll() ) do 
 	 
 		local _team = pl:Team()
 		local _frags = math.Round(pl:GetNWInt("_gold"))
 		local _deaths = math.Round(pl:GetNWInt("_cities"))
 		local _ping = pl:Ping()
 		 
 		if (not TeamInfo[_team]) then 
 			TeamInfo[_team] = {} 
 			TeamInfo[_team].TeamName = team.GetName( _team ) 
 			TeamInfo[_team].Color = team.GetColor( _team ) 
 			TeamInfo[_team].Players = {} 
 		end		 
 		 
 		local PlayerInfo = {}
 		PlayerInfo.Frags = _frags
 		PlayerInfo.Deaths = _deaths
 		PlayerInfo.Score = _frags
 		PlayerInfo.Ping = _ping
 		PlayerInfo.Name = pl:Nick()
 		PlayerInfo.PlayerObj = pl
		PlayerInfo.py = 0
		if LocalPlayer() == pl then
			PlayerInfo.Allied = true
			PlayerInfo.IsAllied = true
		else
			PlayerInfo.Allied = LocalPlayer():GetNWBool("Ally "..pl:UserID())
			PlayerInfo.IsAllied = pl:GetNWBool("Ally "..LocalPlayer():UserID())
		end
 		
		
 		local insertPos = #TeamInfo[_team].Players + 1
 		for idx,info in pairs(TeamInfo[_team].Players) do
 			if (PlayerInfo.Frags > info.Frags) then
 				insertPos = idx
 				break
 			elseif (PlayerInfo.Frags == info.Frags) then
 				if (PlayerInfo.Deaths < info.Deaths) then
 					insertPos = idx
 					break
 				elseif (PlayerInfo.Deaths == info.Deaths) then
 					if (PlayerInfo.Name < info.Name) then
 						insertPos = idx
 						break
 					end
 				end
 			end
 		end
 		
 		table.insert(TeamInfo[_team].Players, insertPos, PlayerInfo)
 	end
 	
 	return TeamInfo
end

function receiveData( data )
	PLINFOTEXT = {}
	local text = ""
	PlayerProfile.UID = data:ReadShort()
	text = data:ReadLong()
	table.insert( PLINFOTEXT, "Food: "..text )
	text = data:ReadLong()
	table.insert( PLINFOTEXT, "Iron: "..text )
	text = data:ReadLong()
	table.insert( PLINFOTEXT, "Soldiers: "..text )
	text = data:ReadLong()
	table.insert( PLINFOTEXT, "Money: "..text )
end
usermessage.Hook("sendData", receiveData)

PlayerProfile = {}
PlayerProfile.Show = false
PlayerProfile.UID = false
PlayerProfile.text = {}

function GM:HUDDrawScoreBoard()
	
	local MySelf = LocalPlayer()
	
	Buttons = {}
	MuteButtons = {}
	
 	if (!GAMEMODE.ShowScoreboard) then return end
 	
 	if (GAMEMODE.ScoreDesign == nil) then
 	
 		GAMEMODE.ScoreDesign = {}
 		GAMEMODE.ScoreDesign.HeaderY = 0
 		GAMEMODE.ScoreDesign.Height = ScrH() / 2
 	
 	end
 	
 	local alpha = 255
	
 	ScoreboardInfo = self:GetTeamScoreInfo()
 	
 	local xOffset = ScrW() / 10
 	local yOffset = 32
 	local scrWidth = ScrW()
	local scrHeight = ScrH() - 64
	local boardWidth = scrWidth - (2* xOffset)
	local boardHeight = scrHeight
	local colWidth = 50
	local padding = 24
	
	boardWidth = math.Clamp( boardWidth, 400, 600 )
	boardHeight = GAMEMODE.ScoreDesign.Height
	
	xOffset = math.Round((ScrW() - boardWidth) * 0.5)
	yOffset = (ScrH() - boardHeight) * 0.5
	yOffset = yOffset - ScrH() * 0.25
	yOffset = math.Round(math.Clamp( yOffset, 142, ScrH() ))
	 
	// Background 
	surface.SetDrawColor( 0, 0, 0, 255 ) 
	surface.DrawRect( xOffset, yOffset, boardWidth, GAMEMODE.ScoreDesign.HeaderY) 
	 
	surface.SetDrawColor( 80, 80, 80, 200 ) 
	surface.DrawRect( xOffset, yOffset+GAMEMODE.ScoreDesign.HeaderY, boardWidth, boardHeight-GAMEMODE.ScoreDesign.HeaderY) 
	 
	local hostname = GetGlobalString( "ServerName" ) 
	local gamemodeName = GAMEMODE.Name .. " - " .. GAMEMODE.Author 
	 
	surface.SetTextColor( 255, 255, 255, 255 ) 
	
	local txWidth, txHeight = 256, 64
	local y = yOffset + 15

	/*
	local logo = surface.GetTextureID("darkland/logofinal")
	surface.SetTexture(logo)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(xOffset + (boardWidth * 0.5) - ( txWidth * 0.5 ),y,txWidth, txHeight)
	*/
	
	/*
	surface.SetTextPos(xOffset + (boardWidth * 0.5) - (txWidth * 0.5), y)
	surface.DrawText( hostname )
	*/
	
	y = y + txHeight + 2
	
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetFont( "ScoreboardSub" )
	local txWidth, txHeight = surface.GetTextSize( gamemodeName ) 
	surface.SetTextPos(xOffset + (boardWidth / 2) - (txWidth/2), y) 
	surface.DrawText( gamemodeName ) 

	y = y + txHeight + 4
	GAMEMODE.ScoreDesign.HeaderY = y - yOffset

	local obw = boardWidth
	local oxo = xOffset
	local oy = y

 	boardWidth = boardWidth - ( 2 * padding )
 	
	xOffset = math.Round((scrWidth - boardWidth) * 0.5)


 	surface.SetDrawColor( 0, 0, 0, 100 ) 
 	surface.DrawRect( xOffset, y-1, boardWidth, 1)

 	surface.SetDrawColor( 255, 255, 255, 20 )
 	surface.DrawRect( xOffset, y, colWidth, boardHeight-y+yOffset )

 	surface.SetDrawColor( 255, 255, 255, 20 ) 
 	surface.DrawRect( xOffset + boardWidth - (colWidth*2), y, colWidth, boardHeight-y+yOffset )

 	surface.SetDrawColor( 255, 255, 255, 20 ) 
 	surface.DrawRect( xOffset + boardWidth - (colWidth*4), y, colWidth, boardHeight-y+yOffset )


 	surface.SetFont( "ScoreboardText" ) 
 	local txWidth, txHeight = surface.GetTextSize( "W" )

 	surface.SetDrawColor( 0, 0, 0, 100 ) 
 	surface.DrawRect( xOffset, y, boardWidth, txHeight + 6 )

 	y = y + 2

 	surface.SetTextPos( xOffset + 6, y )					surface.DrawText("Allied")
 	surface.SetTextPos( xOffset + colWidth + 12, y )			surface.DrawText("Name")
 	surface.SetTextPos( xOffset + boardWidth - (colWidth*4) + 8, y )	surface.DrawText("Gold")
 	surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8, y )	surface.DrawText("Cities")
 	surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8, y )	surface.DrawText("Ping")
 	surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 8, y )	surface.DrawText("Mute")

 	y = y + txHeight + 4
	
	//First we get every player's position.
 	local yPosition = y 
 	for team,info in pairs(ScoreboardInfo) do 
 		yPosition = yPosition + txHeight + 6 
		for index,plinfo in pairs(info.Players) do
			local py = yPosition
			plinfo.py = py
			yPosition = yPosition + txHeight + 3 
		end
	end

	//Then we draw their shit.

	Alliances = {}
	Alliances.px = xOffset + (colWidth) - 16

 	yPosition = y

	local onPlayer = false
 	

 	for team,info in pairs(ScoreboardInfo) do 
 		 
 		local teamText = info.TeamName .. "  (" .. #info.Players .. " Players)" 
 		 
 		surface.SetFont( "ScoreboardText" ) 
 		surface.SetTextColor( 0, 0, 0, 255 ) 
 		
 		txWidth, txHeight = surface.GetTextSize( teamText ) 
 		surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 255 ) 
 		surface.DrawRect( xOffset, yPosition, boardWidth, txHeight + 4) 
 		yPosition = yPosition + 2 
 		surface.SetTextPos( xOffset + boardWidth/2 - txWidth/2, yPosition ) 
 		surface.DrawText( teamText )
		if info.TeamName == "Players" then
			txWidth, txHeight = surface.GetTextSize( "Show Hints" ) 
			surface.SetTextPos( xOffset + boardWidth - txWidth - 24, yPosition ) 
 			surface.DrawText( "Show Hints" )
			DrawCheckBox( xOffset + boardWidth - 20, yPosition + 1, 14, shadowcolor, textcolor, LocalPlayer():GetNWInt("showhelp") )
			HintCheckBox = {px = xOffset + boardWidth - 20,py = yPosition + 1,size = 14}
		end
 		yPosition = yPosition + 2

 		yPosition = yPosition + txHeight + 2 

 		for index, plinfo in pairs(info.Players) do 

 			surface.SetFont( "ScoreboardText" ) 
 			surface.SetTextColor( info.Color.r, info.Color.g, info.Color.b, 200 ) 
 			surface.SetTextPos( xOffset + 16, yPosition ) 
 			txWidth, txHeight = surface.GetTextSize( plinfo.Name )

 			if (plinfo.PlayerObj == LocalPlayer()) then 
 				surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 50 ) 
 				surface.DrawRect( xOffset, yPosition, boardWidth, txHeight + 2) 
 				surface.SetTextColor( info.Color.r, info.Color.g, info.Color.b, 255 ) 
 			end

 			local px, py = xOffset + 6, yPosition
 			local textcolor = Color( info.Color.r, info.Color.g, info.Color.b, alpha ) 
 			local shadowcolor = Color( 0, 0, 0, alpha * 0.8 )
			local debugcolor = textcolor
			local ply = plinfo.PlayerObj

			local mx, my = gui.MouseX(), gui.MouseY()
			if mx > xOffset and mx < xOffset+boardWidth and my > py and my < py + txHeight + 3 then

				onPlayer = true
				if !prevPlayer || prevPlayer ~= ply:UserID() then
					canLoad = CurTime() + 1
					prevPlayer = ply:UserID()
				end

 				surface.SetDrawColor( 255, 255, 255, 20 ) 
 				surface.DrawRect( xOffset, py, boardWidth, txHeight + 3 )

				if ply ~= MySelf and ply:Team() == TEAM_PLAYERS then

					PlayerProfile.Show = true
					PlayerProfile.bordercolor = ply:GetColor()
					PlayerProfile.textcolor = textcolor
					PlayerProfile.px = mx
					PlayerProfile.py = my
					
					if ply:UserID() == PlayerProfile.UID then
						PlayerProfile.text = PLINFOTEXT
					else
						local timer = ""
						if canLoad and CurTime() < canLoad then
							wait = canLoad - CurTime()
							wait = 3 - math.Round(wait * 3)
						end
						if wait == 1 then timer = "." end
						if wait == 2 then timer = ".." end
						if wait == 3 then timer = "..." end
						PlayerProfile.text = {"Opening"..timer}
					end
					if !canLoad || CurTime() > canLoad then
						canLoad = CurTime() + 1
						LocalPlayer():ConCommand("sa_getstats "..ply:UserID().."\n")
					end

				else

					PlayerProfile.Show = false

				end

			elseif !onPlayer then
				PlayerProfile.Show = false
			end

			if info.TeamName == "Players" then

				if ply ~= MySelf and !ply:IsAdmin() and !ply:IsSuperAdmin() then
					local status = false
					if ply:GetNWBool("muted") == true then
						status = 3
					elseif MySelf:GetNWBool("muted "..ply:UserID()) == true then
						status = 2
					end
					DrawCheckBox( xOffset + boardWidth - colWidth*0.5 - 7, py + ((txHeight + 2)*0.5) - 7, 14, shadowcolor, textcolor, status )
					MuteButtons[index] = {}
					MuteButtons[index].px = xOffset + boardWidth - colWidth*0.5 - 7
					MuteButtons[index].py = py + ((txHeight + 2)*0.5) - 7
					MuteButtons[index].size = 14
					MuteButtons[index].status = status
					MuteButtons[index].name = ply:Nick()
					MuteButtons[index].pID = ply:UserID()
				end
				
				if ALLIANCES then
					
					DrawAllyBox( MySelf, ply, px + (colWidth) - 22, py + ((txHeight + 2)*0.5) - 7, 14, plinfo.Allied, plinfo.IsAllied, shadowcolor, textcolor, LocalPlayer():GetNWInt( "Allies" ), plinfo.PlayerObj:GetNWInt( "Allies" ) )
					Buttons[index] = {}
					Buttons[index].px = px + (colWidth) - 22
					Buttons[index].py = py + ((txHeight + 2)*0.5) - 7
					Buttons[index].size = 14
					Buttons[index].pID = ply:UserID()
					Buttons[index].status = plinfo.Allied
					Buttons[index].pObj = ply
						
					myAlliances = {}
					myAlliances[1] = plinfo.py
					local allies = {}
					local ShouldDraw = false
					
					if ply:GetNWInt("Allies")>0 then
						ShouldDraw = true
						debugcolor = Color(0,0,255,255)
						local Group = {}
						for k,v in pairs( info.Players ) do
							if v.PlayerObj:GetNWBool( "Ally "..ply:UserID() ) and ply:GetNWBool( "Ally "..v.PlayerObj:UserID() ) and ply ~= v.PlayerObj then
								if #Group > 0 then
									local CanAdd = true
									for i=1, #Group do
										if !(v.PlayerObj:GetNWBool( "Ally "..Group[i]:UserID() ) and Group[i]:GetNWBool( "Ally "..v.PlayerObj:UserID() )) then
											CanAdd = false
											break
										end
									end
									if CanAdd then
										table.insert( myAlliances, v.py )
										table.insert( Group, v.PlayerObj )
									else
										ShouldDraw = false
										debugcolor = Color(255,0,0,255)
										break
									end
								else
									table.insert( myAlliances, v.py )
									table.insert( Group, v.PlayerObj )
								end
							end
						end
						if #Group == 0 then ShouldDraw = false end
					end
					if ShouldDraw then
						
						table.sort(myAlliances, function (a, b) return a < b end)
						
						for i=1, #myAlliances do
							if myAlliances[i+1] then
								allies[i] = {}
								allies[i].posy = myAlliances[i]
								allies[i].length = myAlliances[i+1] - myAlliances[i]
							end
						end
						
						if #Alliances > 0 then
							//Check if there is already an equal alliance shown.
							local foundMatch = false
							for i=1, #Alliances do
								local isMatch = true
								for k=1, #allies do
									if !Alliances[i].info[k] then
										isMatch = false
									elseif allies[k].posy ~= Alliances[i].info[k].posy then
										isMatch = false
									elseif allies[k].length ~= Alliances[i].info[k].length then
										isMatch = false
									end
								end
								if isMatch then
									foundMatch = true
									break
								end
							end
							if !foundMatch then
								Alliances[#Alliances+1] = {}
								Alliances[#Alliances].info = allies
								local r,g,b,a = ply:GetColor()
								Alliances[#Alliances].col = Color( r,g,b,a )
								debugcolor = Color(255,100,50,255)
							end
						elseif #allies > 0 then
							Alliances[1] = {}
							Alliances[1].info = allies
							local r,g,b,a = ply:GetColor()
							Alliances[1].col = Color( r,g,b,a )
							debugcolor = Color(0,255,0,255)
						end
					end
				end
				
			end
			
			local show = GetConVarNumber( "sa_debug" )
			if (show == 0) then debugcolor = textcolor end

			px = xOffset + colWidth + 12
 			draw.SimpleText( plinfo.Name, "ScoreboardText", px+1, py+1, shadowcolor )
 			draw.SimpleText( plinfo.Name, "ScoreboardText", px, py, debugcolor )

 			px = xOffset + boardWidth - (colWidth*4) + 8			 
 			draw.SimpleText( plinfo.Frags, "ScoreboardText", px+1, py+1, shadowcolor ) 
 			draw.SimpleText( plinfo.Frags, "ScoreboardText", px, py, textcolor )

 			px = xOffset + boardWidth - (colWidth*3) + 8			 
 			draw.SimpleText( plinfo.Deaths, "ScoreboardText", px+1, py+1, shadowcolor ) 
 			draw.SimpleText( plinfo.Deaths, "ScoreboardText", px, py, textcolor )

 			px = xOffset + boardWidth - (colWidth*2) + 8			 
 			draw.SimpleText( plinfo.Ping, "ScoreboardText", px+1, py+1, shadowcolor ) 
 			draw.SimpleText( plinfo.Ping, "ScoreboardText", px, py, textcolor )

 			yPosition = yPosition + txHeight + 3
 		end
 	end


 	surface.SetDrawColor( 0, 0, 0, 255 ) 
 	surface.DrawRect( oxo, oy-1, padding, boardHeight-oy+yOffset+1)

 	surface.SetDrawColor( 0, 0, 0, 255 ) 
 	surface.DrawRect( oxo + obw - padding, oy-1, padding, boardHeight-oy+yOffset+1)

 	surface.SetDrawColor( 0, 0, 0, 255 )
 	surface.DrawRect( oxo, yOffset+boardHeight-padding*0.5, obw, padding*0.5 )

	draw.Border( oxo, yOffset, obw+1, boardHeight )
	draw.Border( xOffset, oy, boardWidth, yOffset+boardHeight-padding*0.5-oy )

 	yPosition = yPosition + padding * 0.5

 	GAMEMODE.ScoreDesign.Height = (GAMEMODE.ScoreDesign.Height * 2) + (yPosition-yOffset)
 	GAMEMODE.ScoreDesign.Height = GAMEMODE.ScoreDesign.Height / 3
	
	if ALLIANCES then DrawAllianceBridges() end
	DrawPlayerProfile()
	
end

function DrawAllyBox( ply, plyr, px, py, size, status, status2, sc, tc, allies, allynum )
	draw.RoundedBox(0, px, py, size, size, Color(255,220,220,100))
	draw.RoundedBox(0, px+1, py+1, size-2, size-2, Color(0,0,0,255))
	if gui.MouseX() > px and gui.MouseX() < px + size and gui.MouseY() > py and gui.MouseY() < py + size then
		PlayerProfile.Show = false
		if ally_limit == -1 then
			draw.RoundedBox(0, px, py, size, size, Color(255,255,255,50))
		elseif allies < ally_limit and allies + allynum < ally_limit then
			draw.RoundedBox(0, px, py, size, size, Color(255,255,255,50))
		elseif ply:GetNWBool( "Ally "..plyr:UserID() ) and allies == ally_limit  then
			draw.RoundedBox(0, px, py, size, size, Color(255,255,255,50))
		elseif ply:GetNWBool( "Ally "..plyr:UserID() ) and allies + allynum == ally_limit then
			draw.RoundedBox(0, px, py, size, size, Color(255,255,255,50))
		end
	end
	surface.SetDrawColor( 255, 255, 255, 255 )
	if status2 and status then
		surface.SetTexture( texFriendly )
		surface.DrawTexturedRect( px, py, 14, 14 )
		--draw.RoundedBox(4, px+3, py+3, size-6, size-6, Color(150,255,50,200))
	elseif status then
		surface.SetTexture( texOn )
		surface.DrawTexturedRect( px, py, 14, 14 )
		--draw.RoundedBox(4, px+3, py+3, size-6, size-6, Color(250,250,75,180))
	elseif status2 then
		surface.SetTexture( texAdd )
		surface.DrawTexturedRect( px, py, 14, 14 )
		--draw.RoundedBox(4, px+3, py+3, size-6, size-6, Color(150,150,255,180))
	end
	if ally_limit == -1 then return end
	if allies == ally_limit || allies + allynum >= ally_limit then
		draw.RoundedBox(0, px, py, size, size, Color(0,0,0,36))
	end
end

function DrawAllianceBridges()
	local px = Alliances.px - 1
	local col = Color(200,255,100,255)
	local sha = Color(0,0,0,255)
	local offset = 8
	for i=#Alliances, 1, -1 do
		offset = 8 - (#Alliances*0.5) + (#Alliances-i)
		local info = Alliances[i].info
		col = Alliances[i].col
		for _, alliance in pairs( info ) do
			draw.RoundedBox(0, px - ( i * 4 ) + 1, offset + alliance.posy + 1, 3 * i, 2, sha)
			draw.RoundedBox(0, px - ( i * 4 ) + 1, offset + alliance.posy + alliance.length + 1, 3 * i, 2, sha)
			draw.RoundedBox(0, px - ( i * 4 ) + 1, offset + alliance.posy + 2, 1, alliance.length, sha)
			draw.RoundedBox(0, px - ( i * 4 ), offset + alliance.posy, 3 * i, 2, col)
			draw.RoundedBox(0, px - ( i * 4 ), offset + alliance.posy + alliance.length, 3 * i, 2, col)
			draw.RoundedBox(0, px - ( i * 4 ), offset + alliance.posy + 1, 1, alliance.length, col)
		end
	end
end

function DrawCheckBox( px, py, size, sc, tc, status )
	draw.RoundedBox(0, px, py, size, size, Color(255,220,220,100))
	draw.RoundedBox(0, px+1, py+1, size-2, size-2, Color(0,0,0,255))
	if gui.MouseX() > px and gui.MouseX() < px + size and gui.MouseY() > py and gui.MouseY() < py + size then
		PlayerProfile.Show = false
		draw.RoundedBox(0, px, py, size, size, Color(255,255,255,50))
	end
	surface.SetDrawColor( 255, 255, 255, 255 )
	if status == 3 then
		surface.SetTexture( texAlert )
		surface.DrawTexturedRect( px, py, 14, 14 )
	elseif status == 2 then
		surface.SetTexture( texOff )
		surface.DrawTexturedRect( px+1, py, 14, 14 )
	elseif status == 1 then
		surface.SetTexture( texOn )
		surface.DrawTexturedRect( px, py, 14, 14 )
	elseif status == 0 then
		surface.SetTexture( texOff )
		surface.DrawTexturedRect( px+1, py, 14, 14 )
	elseif status then
	else
	end
end

function DrawPlayerProfile()
	if !PlayerProfile.Show then return end
	local px = PlayerProfile.px
	local py = PlayerProfile.py
	local offset = 12
	local padding = 5
	local textcolor = PlayerProfile.textcolor
 	local shadowcolor = Color( 0, 0, 0, 204 )
	local txWidth, txHeight = surface.GetTextSize( "sample" )
	local count = #PlayerProfile.text
	count = txHeight*count

	surface.SetDrawColor( 20, 20, 20, 220 )
 	surface.DrawRect( px, py - count - (2*padding), 156, count+(2*padding) )
	draw.Border( px, py - count - (2*padding), 156, count+(2*padding) )

	for i, txt in pairs( PlayerProfile.text ) do
		draw.SimpleText( txt, "ScoreboardText", px+offset+1, py-offset-padding*0.5+txHeight*i-count-txHeight*0.5+1, shadowcolor ) 
 		draw.SimpleText( txt, "ScoreboardText", px+offset, py-offset-padding*0.5+txHeight*i-count-txHeight*0.5, textcolor )
	end
end