surface.CreateFont( "Tahoma", 16, 1000, true, false, "bChatFont" ) 
surface.CreateFont( "Tahoma", 14, 1000, true, false, "bChatTitle" )

RepTex = {}
RepTex["vip"] = surface.GetTextureID("coded/vtag")
RepTex["admin"] = surface.GetTextureID("coded/atag")
RepTex["superadmin"] = surface.GetTextureID("coded/otag")
RepTex["developer"] = surface.GetTextureID("coded/dtag")
RepTex["epic"] = surface.GetTextureID("coded/etag")
RepTex["jaanus"] = surface.GetTextureID("coded/jtag")
RepTex["girl"] = surface.GetTextureID("coded/gtag")
RepTex["valve"] = surface.GetTextureID("coded/stag")

teamchat = false
chaton = false
history = {}

local prefix = "Say: "
local cursorpos = 0
local realtext = ""
local chattext = ""
local maxlines = 10

local COLOR_CHAT = Color( 255, 255, 255, 255 )
local COLOR_CONSOLE = Color( 217, 0, 25, 255 )
local COLOR_WHISPER = Color( 101, 202, 36, 255 )
local COLOR_NOTIFY = Color( 101, 202, 36, 255 )
local COLOR_HINT = Color( 77, 131, 240, 255 )

function ClearHistory()
	
	history = {}
	
end

usermessage.Hook( "chat.WebChat", function( um )
	local rep = um:ReadString()
	local name = um:ReadString()
	local msg = um:ReadString()
	history[#history+1]={
		pl=true,
		title=rep,
		name=name,
		msg="(WEB) "..msg,
		time=os.clock()
	}
end )

function AddHistory( pl, msg, from )
	
	from = tonumber(from) or 0
	
	local col = COLOR_CONSOLE
	if from == 1 then
		col = COLOR_CHAT
	elseif from == 2 then
		col = COLOR_WHISPER
	elseif from == 3 then
		col = COLOR_NOTIFY
	elseif from == 4 then
		col = COLOR_HINT
	end
	if pl == 0 then pl = nil end
	if tonumber(pl) == pl  then
		for k, v in pairs( player.GetAll() ) do
			if v:UserID() == pl then
				pl = v
				break
			end
		end
	end
	if pl and type(pl) == "Player" and pl:IsPlayer() then
		if LocalPlayer():GetNWBool( "muted "..pl:UserID() ) == true then return end
		if pl:GetNWBool( "muted" ) == true then return end
		local r,g,b,a = pl:GetColor()
		local color = Color( r,g,b,255 )
		if (	r == 255	and
			g == 255	and
			b == 255	) ||
		(	r == 0		and
			g == 0		and
			b == 0		) then
			color = team.GetColor( pl:Team() )
		end
		history[ #history+1 ] = {
			pl = pl,
			title = pl:GetTitle(),
			name = pl:Nick(),
			color = color,
			textcolor = col,
			msg = msg,
			from = from or 1,
			time = os.clock()
		}
		if pl:IsAdmin() or pl:IsSuperAdmin() then
			print( "(ADMIN) "..pl:Nick()..": "..msg )
		else
			print( pl:Nick()..": "..msg )
		end
	elseif pl and from==3 then
		local npc = ents.GetByIndex(pl.id)
		pl.wav = pl.wav or "none"
		if ValidEntity( npc ) and pl.wav != "none" then
			npc:EmitSound("lounge/vo/npcs/"..pl.name.."/"..pl.wav..".wav")
		end
		local color = Color( 68,168,32,255 )
		history[ #history+1 ] = {
			pl = pl,
			title = false,
			name = pl.name,
			color = color,
			textcolor = COLOR_CHAT,
			msg = msg,
			from = 3,
			time = os.clock()
		}
		print( pl.name..": "..msg )
	else
		if string.find( string.lower(msg), "dropped" ) == 1 then return end
		if string.find( string.lower(msg), "player" ) == 1 then return end
		history[ #history+1 ] = {
			textcolor = col, msg = msg, time = os.clock()
		}
		print( msg )
	end

end

function GM:ChatText(playerindex, playername, text, filter)

	if(tonumber(playerindex) == 0) then
		AddHistory(nil, text, 0)
	end
	return true
	
end

function GM:OnPlayerChat(ply, text, bTeamOnly, bPlayerIsDead)
	
	if(ValidEntity(ply)) then
		AddHistory(ply, text, 1)
	else
		AddHistory(nil, text, 0)
	end
	return false
	
end


function GM:ChatPaint()
	
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetFont( "bChatFont" )
	
	local x, y = 80, math.Round(ScrH()-125)
	
	local num = 0
	local total = 0
	for k, v in pairs( history ) do
		
		if (v.time + 10 > os.clock() or chaton) and k > #history - maxlines then
			total = total + 1
		end
		
	end
	for k, v in pairs( history ) do
		
		if (v.time + 10 > os.clock() or chaton) and k > #history - maxlines then
			
			local textcolor = v.textcolor or Color( 255, 255, 255, 255 )
			
			if v.pl then
				
				-- Player say
				
				local title = v.title
				local pl = v.pl
				local from = v.from or 1
				local name = string.Trim(v.name)
				local color = v.color or Color(20, 120, 120, 255)
				
				local tex
				local w, h = 0, 0
				local ww, hh = 4, 0
				
				if !nextfade or CurTime() > nextfade + 1 then
					nextfade = CurTime() + 1
				end
				local perc = (nextfade - CurTime())
				if CurTime() > nextfade then
					perc = (CurTime() - nextfade)
				end
				if perc > 1 then perc = 1 end
				
				if title and title != "none" then
					tex = RepTex[title]
					w, h = 32, 16
					surface.SetTexture(tex)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(x - w + 1, y - total*15 + num*15 + 1, w, h)
				end
				
				text = name..": "
				
				surface.SetTextPos( x + ww + 1, y - total*15 + num*15 + 1 )
				surface.SetTextColor( 0, 0, 0, 255 )
				surface.DrawText( text )
				surface.SetTextPos( x + ww, y - total*15 + num*15 )
				surface.SetTextColor( color.r, color.g, color.b, 255 )
				surface.DrawText( text )
				
				w, h = surface.GetTextSize( text )
				w = w+ww
				h = h+hh
				
				surface.SetTextPos( x + w + 1, y - total*15 + num*15 + 1 )
				surface.SetTextColor( 0, 0, 0, 255 )
				surface.DrawText( v.msg )
				surface.SetTextPos( x + w, y - total*15 + num*15 )
				surface.SetTextColor( textcolor.r, textcolor.g, textcolor.b, 255 )
				surface.DrawText( v.msg )
				
			else
				
				-- Console say
				
				surface.SetTextColor( 0, 0, 0, 255 )
				surface.SetTextPos( x + 1, y - total*15 + num*15 + 1 )
				surface.DrawText( v.msg )
				surface.SetTextColor( textcolor.r, textcolor.g, textcolor.b, 255 )
				surface.SetTextPos( x, y - total*15 + num*15 )
				surface.DrawText( v.msg )

			end
			
			num = num + 1
		end
	end
	
	-- Draw text input
	if chaton then
		
		local w, h = surface.GetTextSize( prefix )
		
		draw.RoundedBox( 4, x-5, y+5, w+14, h, Color( 0, 0, 0, 200 ) )
		
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( x+2, y+4 )
		surface.DrawText( prefix )
		
	end

end

function GM:StartChat()
	return true
end

local PANEL = {}

//Thanks Foszor and Chad for this method of overriding clientside chat.
function PANEL:Init()
	
	self:SetZPos( -1000 )
	
	self.TextEntry = vgui.Create( "DTextEntry", self )
	self.TextEntry:SetDrawBackground( true )
	self.TextEntry:SetDrawBorder( true )
	self.TextEntry.Wide = ScrW()*0.4
	self.TextEntry:SetText( "" )
	self.TextEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.TextEntry.OnTextChanged = function( entry )
		
		local text = entry:GetValue()
		
		if entry.command then
			prefix = "Command: "
		elseif !entry.command and text:sub( 1, 1 ) == "/" then
			entry:SetText( text:sub( 2 ) )
			entry.command = true
			prefix = "Command: "
		elseif teamchat then
			prefix = "Team: "
		else
			prefix = "Say: "
		end
		
		if prefix != self.prefix then
			self.prefix = prefix
			surface.SetFont( "bChatFont" )
			local w, h = surface.GetTextSize( prefix )
			entry:SetPos( 80 + w, ScrH()-122 )
			entry:SetWide( entry.Wide - w - 80 )
		end
		
	end
	self.TextEntry.onLoseFocus = function( entry )
		
		self:Hide()
		return true
		
	end
	self.TextEntry.OnKeyCodeTyped = function( entry, code )
		
		if ( code == KEY_ESCAPE ) then
			self:Hide()
			return true
		end
		
		local keycode = code
		if ( input.IsKeyDown( KEY_RSHIFT ) || input.IsKeyDown( KEY_LSHIFT ) ) then
			
			keycode = keycode + 500
			
		end
		
		local text = entry:GetValue()
		
		if ( code == KEY_BACKSPACE ) then
			
			if entry.command and entry:GetCaretPos() == 0 then
				
				entry.command = false
				entry:OnTextChanged()
				
			end
			
		end
		
		if ( code == KEY_TAB ) then
			
			/* This would be nice to add later, but I need foszor's permission
			local newtext, caretmod = unpack( PackageCall( "chat+", "AutoComplete", text, entry:GetCaretPos() ) )
			
			if ( newtext ) then
				
				local cpos = math.min( entry:GetCaretPos() + caretmod, #newtext )
				entry:SetValue( newtext )
				entry:SetCaretPos( cpos )
				
			end
			
			return true
			*/
			
			entry:SetCaretPos( entry:GetCaretPos() )
			
			return true
			
		end
		
		if ( code == KEY_ENTER ) then
			
			local text = entry:GetValue()
			
			if ( text && #text > 0 ) then
				
				RunConsoleCommand( teamchat && "say_team" || "say", entry.command && "/"..text || text )
				
			end
			
			self:Hide()
			
		end
		
	end
	
end

function PANEL:PerformLayout() end

function PANEL:Show()
	
	if chaton then
		self:Hide()
		return
	end
	
	--RunConsoleCommand( "gameui_preventescapetoshow" )
	
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	self:SetKeyboardInputEnabled( true )
	self:SetMouseInputEnabled( true )
	
	self.TextEntry:SetText( "" )
	self.TextEntry:OnTextChanged()
	self.TextEntry:SetVisible( true )
	self:MakePopup()
	
	timer.Simple( 0.01, function(self)
		gui.SetMousePos( self.CursorPos.x, self.CursorPos.y )
	end, self )
	
	self:SetFocusTopLevel( true )
	self.TextEntry:RequestFocus()
	chaton = true
	
end

function PANEL:Hide()
	
	--RunConsoleCommand( "gameui_allowescapetoshow" )
	
	self.TextEntry.command = false
	self.TextEntry:SetText( "" )
	
	self.CursorPos = Vector( gui.MousePos() )
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )
	
	self.TextEntry:SetVisible( false )
	
	chaton = false
	teamchat = false
	
end

function PANEL:Paint() end

vgui.Register( "chat.ChatArea", PANEL, "EditablePanel" )

hook.Add( "OnPlayerCreated", "SetupChatInput", function( pl )
	
	pl.Chat = vgui.Create( "chat.ChatArea" )
	pl.Chat:Hide()
	
end )

hook.Add("PlayerBindPress", "chat.detectChat", function(ply, bind, pressed)
	
	if string.find( bind, "messagemode" ) and pressed then
		if string.find( bind, "messagemode2" ) then
			teamchat = true
		end
		ply.Chat:Show()
		return true
	end
	
end )