-- CHANGE THE BUILD NUMBER --
local build = "1.2"
/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()
        GAMEMODE.ShowScoreboard = true
end
/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()
        GAMEMODE.ShowScoreboard = false
end


--local baselogo = surface.GetTextureID("LmaoLlama/basewars/scoreboard/llama");
local basename = surface.GetTextureID("LmaoLlama/basewars/scoreboard/name");
local basesplit = surface.GetTextureID("LmaoLlama/basewars/scoreboard/split");
local basemid = surface.GetTextureID("LmaoLlama/basewars/scoreboard/mid");
local teamboxmid = surface.GetTextureID("LmaoLlama/basewars/scoreboard/teamboxmid");
local teamboxend = surface.GetTextureID("LmaoLlama/basewars/scoreboard/teamboxedge");
local teamboxendr = surface.GetTextureID("LmaoLlama/basewars/scoreboard/teamboxend");
local footl = surface.GetTextureID("LmaoLlama/basewars/scoreboard/footl");
local footm = surface.GetTextureID("LmaoLlama/basewars/scoreboard/footm");
local footr = surface.GetTextureID("LmaoLlama/basewars/scoreboard/footr");
local side = surface.GetTextureID("LmaoLlama/basewars/scoreboard/side");
local sider = surface.GetTextureID("LmaoLlama/basewars/scoreboard/sider");
local headl = surface.GetTextureID("LmaoLlama/basewars/scoreboard/headl");
local headr = surface.GetTextureID("LmaoLlama/basewars/scoreboard/headr");

function GM:GetTeamScoreInfo()

        local TeamInfo = {}

        
                for id,pl in pairs( player.GetAll() ) do
                
        
                local _tag = string.sub(pl:GetNWString("currtag"), 1, -5)
                local _team = pl:Team()
                local _frags = pl:Frags()
                local _deaths = pl:Deaths() --getMoney(pl) --pl:Deaths()
                local _ping = pl:Ping()
                
                if (not TeamInfo[_team]) then 
                        TeamInfo[_team] = {}
                        TeamInfo[_team].TeamName = team.GetName( _team )
                        TeamInfo[_team].Color = team.GetColor( _team )
                        TeamInfo[_team].Players = {}
                end             
                
                local PlayerInfo = {}


        

                PlayerInfo.Tag = _tag
                PlayerInfo.Frags = _frags
                PlayerInfo.Deaths = _deaths
                PlayerInfo.Score = _frags - _deaths
                PlayerInfo.Ping = _ping
                PlayerInfo.Name = pl:Nick()
                PlayerInfo.Money = _money
                PlayerInfo.SteamID = pl:SteamID()
                PlayerInfo.PlayerObj = pl
                
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

function GM:HUDDrawScoreBoard()

        if (!GAMEMODE.ShowScoreboard) then return end
        
        if (GAMEMODE.ScoreDesign == nil) then
        
                GAMEMODE.ScoreDesign = {}
                GAMEMODE.ScoreDesign.HeaderY = 0
                GAMEMODE.ScoreDesign.Height = ScrH() / 2
        
        end
--                                                              VARIABLES
        local alpha = 255

        local ScoreboardInfo = self:GetTeamScoreInfo()
        
        local xOffset = ScrW() / 10
        local yOffset = 32
        local scrWidth = ScrW()
        local scrHeight = ScrH() - 64
        local boardx1 = ScrW()/4
        local boardx2 = ScrW() - boardx1
        local boardy1 = ScrH()/7
        local boardWidth = ScrW()/2
        local boardHeight = scrHeight
        local colWidth = 75
        local y = yOffset + 15
        local bot = 32

        
                boardHeight = GAMEMODE.ScoreDesign.Height
        
        xOffset = (ScrW() - boardWidth) / 2.0
        yOffset = (ScrH() - boardHeight) / 2.0
        yOffset = yOffset - ScrH() / 4.0
        yOffset = math.Clamp( yOffset, 32, ScrH() )
        

        
        local hostname = GetHostName()
        local gamemodeName = GAMEMODE.Name .. " - " .. GAMEMODE.Author

        
        -- Draw the White Brackground
        surface.SetDrawColor( 220, 220, 220, 255 )
        surface.DrawRect( boardx1, boardy1+92, boardWidth, boardHeight-y+yOffset )
        
        -- Reset the color
        surface.SetDrawColor( 255, 255, 255, 255 )
                
        
        -- Draw the Head Background

        surface.SetTexture( basesplit );
        surface.DrawTexturedRect( boardx1+20, boardy1, boardWidth-25, 64);
        surface.SetTexture( headl );
        surface.DrawTexturedRect( boardx1-4, boardy1, 32, 64);
        surface.SetTexture( headr );
        surface.DrawTexturedRect( boardx2-29, boardy1, 32, 64);
        
        -- Draw the Mid thingw
                
        surface.SetTexture( basemid );
        surface.DrawTexturedRect( boardx1, boardy1+64, boardWidth, 32);
        
        -- Draw the header

        surface.CreateFont ("Espionage", 24, 400, true, false, "EspionageLarge") --unscaled
        surface.CreateFont ("Espionage", 64, 400, true, false, "EspionageSmall") --unscaled
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetFont( "EspionageLarge" );
        surface.SetTextPos( boardx1+19, boardy1+5 );
        surface.DrawText( "Slidefuse Basewars");
        
        --surface.SetTexture( basename );
        --surface.DrawTexturedRect( boardx1+3, boardy1, 512, 64);

        -- Draw the logo
                
        --surface.SetTexture( baselogo );
        --surface.DrawTexturedRect( boardx2-64, boardy1, 64, 64);
        
        -- Draw the Footer
        
        surface.SetTexture( footm );
        surface.DrawTexturedRect( boardx1+16, boardy1+boardHeight-y+yOffset+76, boardWidth-31, 32);     
        surface.SetTexture( footl );
        surface.DrawTexturedRect( boardx1-2, boardy1+boardHeight-y+yOffset+76, 18, 32); 
        surface.SetTexture( footr );
        surface.DrawTexturedRect( boardx2-17, boardy1+boardHeight-y+yOffset+76, 18, 32);        

        -- Draw the sides
        
        surface.SetTexture( side );
        surface.DrawTexturedRect( boardx1-2, boardy1+58, 2, boardHeight-y+yOffset+19);
        surface.SetTexture( sider );
        surface.DrawTexturedRect( boardx2-1, boardy1+58, 2, boardHeight-y+yOffset+19);
        
        -- Draw the Build Number
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetFont( "BudgetLabel" );
    surface.SetTextPos( boardx2-100, boardy1+boardHeight-y+yOffset+82 );
        surface.DrawText( "Build:" .. build );
        
        
        
        ----------------------  
        surface.SetFont( "ScoreboardText" )
        local txWidth, txHeight = surface.GetTextSize( "W" )
        

        
        
        
        
        surface.SetTextColor( 0, 0, 0, 255 )
        surface.SetTextPos( xOffset + 16,                                                               boardy1+72)     surface.DrawText("#Name")
        surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8,    boardy1+72)     surface.DrawText("Frags")
        surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8,    boardy1+72)     surface.DrawText("Deaths")
        surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 10,   boardy1+72)     surface.DrawText("#Ping")
        
        local y = y + txHeight + 4

        local yPosition = y
        for team,info in pairs(ScoreboardInfo) do
                
                local teamText = info.TeamName .. "  (" .. #info.Players .. " Players)"
                surface.SetFont( "ScoreboardText" )

                local teamer = surface.GetTextSize( teamText )
                surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 255 )
                surface.SetTexture( teamboxmid );
                surface.DrawTexturedRect( boardx1+31, boardy1+yPosition+36, boardWidth-63, txHeight + 4)
                surface.SetTexture( teamboxend );
                surface.DrawTexturedRect( boardx1+16, boardy1+yPosition+36, 16, txHeight + 4)
                surface.SetTexture( teamboxendr );
                surface.DrawTexturedRect( boardx2-40, boardy1+yPosition+36, 16, txHeight + 4)
                
                yPosition = yPosition + 2
                surface.SetFont( "ScoreboardText" )
                surface.SetTextPos( boardx1+(boardWidth/2)-(teamer/2), boardy1+yPosition+36 )
                surface.DrawText( teamText )
                yPosition = yPosition + 2
                                                

                
                yPosition = yPosition + txHeight + 2
                
                for index,plinfo in pairs(info.Players) do
                
                --      surface.SetFont( "ScoreboardText" )
                        surface.SetTextColor( info.Color.r, info.Color.g, info.Color.b, 200 )
                        surface.SetTextPos( xOffset + 16, yPosition )
                        txWidth, txHeight = surface.GetTextSize( plinfo.Name )
                        
                        if (plinfo.PlayerObj == LocalPlayer()) then
                                surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 50 )
--                              surface.DrawRect( xOffset+1, yPosition, boardWidth - 2, txHeight + 2)
                                surface.SetTextColor( info.Color.r, info.Color.g, info.Color.b, 255 )
                        end
                        
                        
                        local px, py = xOffset + 16, yPosition
                        local textcolor = Color( info.Color.r, info.Color.g, info.Color.b, alpha )
                        local shadowcolor = Color( 0, 0, 0, alpha * 0.8 )


                        -------------------------------
                        bot = py
                        draw.SimpleText( plinfo.Name, "ScoreboardText", px+1+35, boardy1+py+37, shadowcolor )
                        draw.SimpleText( plinfo.Name, "ScoreboardText", px+35, boardy1+py+36, textcolor )

                        if not plinfo.Tag == nil then
                        print("This is not nil..")
                                local QuadTable = {} 
                                QuadTable.texture = surface.GetTextureID( plinfo.Tag )
                                QuadTable.x = px-3
                                QuadTable.y = py+1
                                QuadTable.w = 32 
                                QuadTable.h = 16
                                draw.TexturedQuad( QuadTable )
                        end             
        
                        px = xOffset + boardWidth - (colWidth*3) + 8                    
                        draw.SimpleText( plinfo.Frags, "ScoreboardText", px+1, boardy1+py+37, shadowcolor )
                        draw.SimpleText( plinfo.Frags, "ScoreboardText", px, boardy1+py+36, textcolor )
                                
                        px = xOffset + boardWidth - (colWidth*2) + 8                    
                        draw.SimpleText( plinfo.Deaths, "ScoreboardText", px+1, boardy1+py+37, shadowcolor )
                        draw.SimpleText( plinfo.Deaths, "ScoreboardText", px, boardy1+py+36, textcolor )
                        
                        local pingcolor = Color( plinfo.Ping/2, 255 - (plinfo.Ping/2), 0, 255 )

                        
                        px = xOffset + boardWidth - (colWidth*1) + 8            
                        if plinfo.Ping>510 then
                                plinfo.Ping = 510
                        end
                        draw.RoundedBox( 0, px+1, boardy1+py+37+14, 4, 4, Color( plinfo.Ping/2, 255 - (plinfo.Ping/2), 0, 255 ) )
                        if plinfo.Ping < 300 then
                        draw.RoundedBox( 0, px+6, boardy1+py+37+9, 4, 9, Color( plinfo.Ping/2, 255 - (plinfo.Ping/2), 0, 255 ) )                        
                        else
                                draw.RoundedBox( 0, px+6, boardy1+py+37+9, 4, 9, Color( 0, 0, 0, 255 ) )                        
                        end
                        if plinfo.Ping < 200 then
                                draw.RoundedBox( 0, px+11, boardy1+py+37+4, 4, 14, Color( plinfo.Ping/2, 255 - (plinfo.Ping/2), 0, 255 ) )                      
                        else
                                draw.RoundedBox( 0, px+11, boardy1+py+37+4, 4, 14, Color( 0, 0, 0, 255 ) )                      
                        end
                        if plinfo.Ping < 100 then
                                draw.RoundedBox( 0, px+16, boardy1+py+37, 4, 18, Color( plinfo.Ping/2, 255 - (plinfo.Ping/2), 0, 255 ) )                        
                        else
                                draw.RoundedBox( 0, px+16, boardy1+py+37, 4, 18, Color( 0, 0, 0, 255 ) )                        
                        end                     
                        draw.SimpleText( plinfo.Ping, "ScoreboardText", px+31, boardy1+py+37, shadowcolor )
                        draw.SimpleText( plinfo.Ping, "ScoreboardText", px+30, boardy1+py+36, textcolor )
                        
                        
                        //surface.DrawText( plinfo.Name )
                        //surface.SetTextPos( xOffset + 16 + 2, yPosition + 2 )
                        //surface.SetTextColor( 0, 0, 0, 200 )
                        //surface.DrawText( plinfo.Name )
                        
                        //surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8, yPosition )
                        //surface.DrawText( plinfo.Frags )

                        //surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8, yPosition )
                        //surface.DrawText( plinfo.Deaths )

                        //surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 8, yPosition )
                        //surface.DrawText( plinfo.Ping )

                        yPosition = yPosition + txHeight + 3
                end
        end
        
        yPosition = yPosition + 8
        
        GAMEMODE.ScoreDesign.Height = (GAMEMODE.ScoreDesign.Height * 2) + (yPosition-yOffset)
        GAMEMODE.ScoreDesign.Height = GAMEMODE.ScoreDesign.Height / 3
        
end

function GM:HUDDrawTargetID()

        local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() )
        local trace = util.TraceLine( tr )
        if (!trace.Hit) then return end
        if (!trace.HitNonWorld) then return end
        
        local text = "ERROR"
        local font = "TargetID"
        
        if (trace.Entity:IsPlayer() and (LocalPlayer():GetObserverTarget()==nil or trace.Entity!=LocalPlayer():GetObserverTarget())) then
                text = trace.Entity:Nick()
        else
                return
                //text = trace.Entity:GetClass()
        end
        
        --surface.SetFont( font )
        local w, h = surface.GetTextSize( text )
        
        local MouseX, MouseY = gui.MousePos()
        
        if ( MouseX == 0 && MouseY == 0 ) then
        
                MouseX = ScrW() / 2
                MouseY = ScrH() / 2
        
        end
        
        local x = MouseX
        local y = MouseY
        
--      local QuadTable = {} 
--      QuadTable.texture = surface.GetTextureID( string.sub(trace.Entity:GetNWString("currtag"), 1, -5) )
--      QuadTable.x = x-16
--      QuadTable.y = y+10
--      QuadTable.w = 32
--      QuadTable.h = 16
--      draw.TexturedQuad( QuadTable )
        
        x = x - w / 2
        y = y + 30
        
        // The fonts internal drop shadow looks lousy with AA on
        draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
        draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
        draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
        
        y = y + h + 5
        
        local text = trace.Entity:Health() .. "%"
        local font = "TargetIDSmall"
        
        --surface.SetFont( font )
        local w, h = surface.GetTextSize( text )
        local x =  MouseX  - w / 2
        
        draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
        draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
        draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

end