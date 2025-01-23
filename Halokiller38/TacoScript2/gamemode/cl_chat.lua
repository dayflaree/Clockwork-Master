-- whytf are we defining that stuff here
NextTimeCanChat = 0;
NextTimeCanChatOOC = 0;
ChatCache = {}

awidth = 0;

function msgSetNextChatTime( msg )

	NextTimeCanChat = CurTime() + msg:ReadFloat();

end
usermessage.Hook( "SNCT", msgSetNextChatTime );


function msgSetNextChatTimeOOC( msg )

	NextTimeCanChatOOC = CurTime() + msg:ReadFloat();

end
usermessage.Hook( "SNCTOOC", msgSetNextChatTimeOOC );

surface.CreateFont( "ChatFont", 14, 800, true, false, "NewChatFont" );
surface.CreateFont( "ChatFont", 32, 1600, true, false, "GiantChatFont" );

if( ChatBox ) then

	ChatBox:Remove();
	ChatBox = nil;

end

if( InnerChatBox ) then

	for k, v in pairs( InnerChatBox ) do
	
		v:Remove();
		InnerChatBox[k] = nil;
		
	end

end

ChatTabs = { }
InnerChatBox = { }

CurrentChatTab = 1;

ChatBoxVisible = false;

function OpenChatBox()

	if( ChatBoxVisible ) then return; end

	ChatBox:SetVisible( true );
	InnerChatBox[CurrentChatTab]:SetVisible( true );
	ChatBoxVisible = true;
	
	gui.EnableScreenClicker( true );
	
	FindVisibleChat( CurrentChatTab );
	
	InnerChatBox[CurrentChatTab].Paint = InnerChatBox[CurrentChatTab].OriginalPaint;
	
	if( InnerChatBox[CurrentChatTab].ScrollUpButton ) then
		InnerChatBox[CurrentChatTab].ScrollUpButton:SetVisible( true );
	end
	
	if( InnerChatBox[CurrentChatTab].ScrollDownButton ) then
		InnerChatBox[CurrentChatTab].ScrollDownButton:SetVisible( true );
	end

	if( InnerChatBox[CurrentChatTab].VScrollBar ) then
		InnerChatBox[CurrentChatTab].VScrollBar:SetVisible( true );
	end
	
	
end

function CloseChatBox()

	if( not ChatBoxVisible ) then return; end
	
	RunConsoleCommand( "eng_isnottyping", "" );
	
	FindVisibleChat( CurrentChatTab );

	ChatBox:SetVisible( false );
	ChatBoxVisible = false;
	
	InnerChatBox[CurrentChatTab].Paint = InnerChatBox[CurrentChatTab].PaintHook;
	
	if( InnerChatBox[CurrentChatTab].ScrollUpButton ) then
		InnerChatBox[CurrentChatTab].ScrollUpButton:SetVisible( false );
	end
	
	if( InnerChatBox[CurrentChatTab].ScrollDownButton ) then
		InnerChatBox[CurrentChatTab].ScrollDownButton:SetVisible( false );
	end

	if( InnerChatBox[CurrentChatTab].VScrollBar ) then
		InnerChatBox[CurrentChatTab].VScrollBar:SetVisible( false );
	end

end

function ToggleChatBox()

	ChatBoxVisible = !ChatBoxVisible;
	
	if( ChatBoxVisible ) then
	
		OpenChatBox();
	
	else
	
		CloseChatBox();
	
	end

end

function OOCDelayChange( msg )

	local name = msg:ReadString();
	local delay = msg:ReadFloat();
	
	AddChat( { 1 }, "", name .. " has set the OOC delay to " .. delay, "NewChatFont", Color( 232, 20, 225, 255 ), Color( 255, 255, 149, 255 ) );
	
end
usermessage.Hook( "ODC", OOCDelayChange );

-----------------------------
---TacoScript 1's Radio Chat
-----------------------------
local ChatLineDelay = 0;

function ShiftChatLinesUp( offset )

	offset = offset or 0;

	for k, v in pairs( TS.ChatLines ) do

		v.y = v.y - 16 - offset;

	end

end

function AddChatLine(name, str)

	ChatLineDelay = math.Clamp( ChatLineDelay - .1, 0, 1000 );

	local newline = { }
	
	newline.x = 39;
	
	newline.r = 255;
	newline.g = 255;
	newline.b = 255;
	newline.a = 255;
	
	local n;
	
	if name then
		str = name .. ': ' .. str
	end
	
	newline.text, n = FormatLine(str, "ChatFont", ScrW() / 2 - 55, '     ');
	newline.start = CurTime();
	
	_, newline.height = surface.GetTextSize( newline.text );
	
	local offset = ( n * 16 );
	
	newline.height = newline.height - 6;
	
	newline.y = ScrH() / 2 - 150 - offset;
	
	ShiftChatLinesUp( offset );
	
	table.insert( TS.ChatLines, newline );
end

--Tabs, for reference
--1 - Global
--2 - OOC
--3 - IC
--4 - Admin
--5 - PM
--6 - Radio
-- inofficial 7: TSC LOOC

function AddChat( rec, name, text, font, namecolor, textcolor )

	if( not ChatBox or not InnerChatBox ) then return; end

	local origname = name;

	for k, v in pairs( rec ) do
	
		if( not ChatTabs[v] ) then
		
			ChatTabs[v] = { }
			ChatTabs[v].ChatLines = { }
			ChatTabs[v].CurrentY = 195;
			ChatTabs[v].Shift = 0;
			
		end
	
		local newline = { }
		
		surface.SetFont( font );
		
		
		
		--Figure out how tall this piece of name/text is
		local _, textheight = surface.GetTextSize( text );
		local _, nameheight = surface.GetTextSize( name );
		
		if( name ~= nil and name ~= "" ) then
			name = name .. ": ";
		end
		
		newline.Name = name;
		newline.NameColor = namecolor;
		newline.TextColor = textcolor;
		newline.Font = font;
		
		local spacesize = surface.GetTextSize( " " );
		
		--We indent the text so that it doesn't overlap the name, 
		--because the name and text are two different strings
		local namewidth = surface.GetTextSize( name );
		local numspaces = math.ceil( namewidth / spacesize );
		
		newline.Text = "";
		
		for n = 1, numspaces do
		
			newline.Text = newline.Text .. " ";
		
		end
		
		newline.Text = newline.Text .. text;
		
		newline.Text = FormatLine( newline.Text, font, awidth - 35, '     ' );
		_, textheight = surface.GetTextSize( newline.Text );
		
		--Position the text
		newline.X = 2;
		newline.Y = ChatTabs[v].CurrentY;
		
		newline.Time = CurTime();
		newline.Alpha = 255;
		
		local numlines = 1;
		
		--Which one takes up more space, the name or the text?  
		--We need to know this so we know how far down to place the next chat line
		if( textheight < nameheight ) then
		
			newline.Height = nameheight;
			numlines = math.ceil( newline.Height / nameheight );
			ChatTabs[v].CurrentY = ChatTabs[v].CurrentY + nameheight;
		
		else
		
			newline.Height = textheight;
			numlines = math.ceil( newline.Height / textheight );
			ChatTabs[v].CurrentY = ChatTabs[v].CurrentY + textheight;			
		
		end
		
		--The code here at the bottom deals with the scroll bar
		local movebar = false;
		
		local olddist = InnerChatBox[v].VScrollDistance;

		InnerChatBox[v].VScrollDistance = InnerChatBox[v].VScrollDistance + newline.Height;
		
		if( InnerChatBox[v].VScrollBar ) then
		
			local _, y = InnerChatBox[v].VScrollBar:GetPos();
			local ymax = y + InnerChatBox[v].VScrollBar:GetTall();
			local _, y2 = InnerChatBox[v].ScrollDownButton:GetPos();
			
			if( ymax - y2 == 0 ) then
			
				movebar = true;
			
			end
			
		end
		
		InnerChatBox[v]:CalculateScrollBar();
		
		if( olddist == 0 and InnerChatBox[v].VScrollDistance > 0 ) then
		
			movebar = true;
		
		end
		
		if( movebar ) then
		
			local x, y = InnerChatBox[v].VScrollBar:GetPos();
			local _, y2 = InnerChatBox[v].ScrollDownButton:GetPos();
			y2 = y2 - InnerChatBox[v].VScrollBar:GetTall();
		
			InnerChatBox[v].VScrollBar:SetPos( x, y2 );	
			InnerChatBox[v].VScrollBar:CalculateScrollAmount();

		end

		table.insert( ChatTabs[v].ChatLines, newline );
		
		name = origname;
		
		if( not ChatBoxVisible ) then
		
			if( InnerChatBox[CurrentChatTab].ScrollUpButton ) then
				InnerChatBox[CurrentChatTab].ScrollUpButton:SetVisible( false );
			end
			
			if( InnerChatBox[CurrentChatTab].ScrollDownButton ) then
				InnerChatBox[CurrentChatTab].ScrollDownButton:SetVisible( false );
			end
		
			if( InnerChatBox[CurrentChatTab].VScrollBar ) then
				InnerChatBox[CurrentChatTab].VScrollBar:SetVisible( false );
			end
		
		end
		
		if( v ~= CurrentChatTab and ChatBox.Button[v] ) then
			
			ChatBox.Button[v].HighlightRed = true;
			ChatBox.Button[v].AlwaysHighlight = true;
		
		end
		
	end
	
	--Finally we decide which piece of the chat we want to render into the chatbox
	--To do this we have to make a table of what chat to display by looping through
	--all current chat lines and determining which is visible
	FindVisibleChat( CurrentChatTab );

end

VisibleChatLines = { }

function FindVisibleChat( num )

	if( not ChatTabs[num] or not ChatTabs[num].ChatLines ) then return; end

	VisibleChatLines = { }

	for k, v in pairs( ChatTabs[num].ChatLines ) do

		local y = v.Y - InnerChatBox[num].VScrollAmount + ChatTabs[num].Shift;
		local ymax = y + v.Height;
		
		if( ( y >= -5 or ymax >= -5 ) and y <= InnerChatBox[num]:GetTall() ) then
			
			--This text is visible
			table.insert( VisibleChatLines, k );
		
		end
	
	end

end

function CreateChatBox()

	awidth = math.Clamp(ScrW()/2 - 40, 470, ScrW());
	 
	ChatBox = CreateBPanel( nil, 15, ScrH() - 350, awidth, 250 );
	ChatBox.RequiresMouse = false;
	
	ChatBox.CloseButton = ChatBox:AddButton( "X", awidth - 23, 5, function()
	
		ChatBox.TextEntry:SetText( "" );
		
		CloseChatBox();
		HideMouse();

	end );
	
	ChatBox.CloseButton.Outline = 1;
	ChatBox.CloseButton.HighlightRed = true;
	ChatBox.CloseButton.AlwaysHighlight = true;
	
	for n = 1, 8 do
	
		InnerChatBox[n] = CreateBPanel( nil, 20, ScrH() - 350 + 29, awidth - 10, 198 );
		InnerChatBox[n]:SetBodyColor( Color( 50, 50, 50, 10 ) );
		InnerChatBox[n]:EnableScrolling( true );
		InnerChatBox[n]:SetVisible( false );
		InnerChatBox[n].RequiresMouse = false;
		InnerChatBox[n].OnScrollBarUpdate = function()
	
			FindVisibleChat( n );
		
		end
		
		InnerChatBox[n].PaintHook = function( self )
		
			if( not ChatBox:IsVisible() and PlayerMenuVisible ) then
			
				return;
			
			end
		
			for k, v in pairs( VisibleChatLines ) do
			
				if( ChatTabs and ChatTabs[n] and ChatTabs[n].ChatLines and ChatTabs[n].ChatLines[v] ) then

					local line = ChatTabs[n].ChatLines[v];
	
					if( ChatBoxVisible ) then
	
						draw.SimpleTextOutlined( line.Name, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, line.NameColor, 0, 0, 1, Color( 30, 30, 30, 255 ) );
						draw.DrawTextOutlined( line.Text, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.TextColor.r, line.TextColor.g, line.TextColor.b, line.TextColor.a ), 0, 0, 1, Color( 30, 30, 30, 255 ) );

					else
					
						draw.SimpleTextOutlined( line.Name, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.NameColor.r, line.NameColor.g, line.NameColor.b, line.Alpha ), 0, 0, 1, Color( 30, 30, 30, line.Alpha ) );
						draw.DrawTextOutlined( line.Text, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.TextColor.r, line.TextColor.g, line.TextColor.b, line.Alpha ), 0, 0, 1, Color( 30, 30, 30, line.Alpha ) );

						if( line.Time + 5 < CurTime() ) then
						
							line.Alpha = math.Clamp( line.Alpha - 200 * FrameTime(), 0, 255 );
						
						end 

					end
					
				end
				
			end	
		
		end
		
		InnerChatBox[n].OriginalPaint = InnerChatBox[n].Paint;
		InnerChatBox[n].Paint = InnerChatBox[n].PaintHook;
		
		ChatBox.TextEntry = vgui.Create( "DTextEntry", ChatBox );
		ChatBox.TextEntry:SetPos( 20, ScrH() - 101 );
		ChatBox.TextEntry:SetSize( awidth - 10, 16 );
		ChatBox.TextEntry:SetMouseInputEnabled( true );
		ChatBox.TextEntry:SetKeyboardInputEnabled( true );
		ChatBox.TextEntry:SetAllowNonAsciiCharacters( true );
		ChatBox.TextEntry:SetFGColor( 0, 0, 0, 255 );
		ChatBox.TextEntry:MakePopup();
		
		ChatBox.TextEntry.OnKeyCodeTyped = function( self, key )
			
			if( key == 70 ) then
			
				CloseChatBox();
				RunConsoleCommand( "cancelselect", "" );
				
				HideMouse();
				
				return;
			
			end
			
			if( key == KEY_ENTER ) then
			
				CloseChatBox();
			
				if( string.gsub( ChatBox.TextEntry:GetValue(), " ", "" ) ~= "" ) then
					
					SendOverlongMessage(ChatBox.TextEntry:GetValue())
					
				end

				ChatBox.TextEntry:SetText( "" );
				HideMouse();
				
				return;
			
			end
		
		end
		
	end
	
	InnerChatBox[1]:SetVisible( true );
	
	ChatBox.Button = { }
	
	ChatBox.Button[1] = ChatBox:AddButton( "Global", 5, 5 );
	ChatBox.Button[1].Outline = 1;
	
	local function SetToChatBox( n )
	
		if( CurrentChatTab == n ) then return; end

		ChatBox.Button[CurrentChatTab].AlwaysHighlight = false;
		ChatBox.Button[n].AlwaysHighlight = true;
		ChatBox.Button[n].HighlightRed = false;
		InnerChatBox[CurrentChatTab]:SetVisible( false );
		InnerChatBox[n]:SetVisible( true );
		InnerChatBox[n].Paint = InnerChatBox[n].OriginalPaint;
		
		CurrentChatTab = n;
		
		FindVisibleChat( n );		
	
	end
	
	ChatBox.Button[1].Action = function()
	
		SetToChatBox( 1 );
	
	end
	ChatBox.Button[1].Action();
	
	ChatBox.Button[1].AlwaysHighlight = true;
	
	ChatBox.Button[2] = ChatBox:AddButton( "OOC", 60, 5 );
	ChatBox.Button[2].Outline = 1;
	
	ChatBox.Button[2].Action = function()
	
		SetToChatBox( 2 );
	
	end
	
	ChatBox.Button[3] = ChatBox:AddButton( "IC", 105, 5 );
	ChatBox.Button[3].Outline = 1;
	
	ChatBox.Button[3].Action = function()
	
		SetToChatBox( 3 );
	
	end
	
	ChatBox.Button[4] = ChatBox:AddButton( "Admin", 133, 5 );
	ChatBox.Button[4].Outline = 1;
	
	ChatBox.Button[4].Action = function()
	
		SetToChatBox( 4 );
	
	end
	
	ChatBox.Button[5] = ChatBox:AddButton( "PM", 187, 5 );
	ChatBox.Button[5].Outline = 1;
	
	ChatBox.Button[5].Action = function()
	
		SetToChatBox( 5 );
		
	end
		
	ChatBox.Button[6] = ChatBox:AddButton( "Radio", 222, 5 );
	ChatBox.Button[6].Outline = 1;
	
	ChatBox.Button[6].Action = function()
	
		SetToChatBox( 6 );
	
	end
	
end

CreateChatBox();
ChatBox:SetVisible( false );

-- Keep this synced with player_chat.lua!
local OLM_BEGINLENGTH = 236
local OLM_DATALENGTH = 240
local OLM_MAXLENGTH = 710

-- OLM. If that doesn't work, blame Zaubermuffin.
-- could be improved a bit to save 5 bytes.
function SendOverlongMessage(text)
	-- Limit the total length to 1 Start, 1 End, 1 Data Packet minus a few bytes
	-- "unfehlbarkeitsbonus".
	-- This is really just for network reasons and ab00sers. It might
	-- be lifted for certain users later and is checked serversided as well.
	-- Whoever is going to write 710 chars in one message has serious problems anyway.
	
	if #text > OLM_MAXLENGTH then
		text = string.sub(text, 0, OLM_MAXLENGTH)
	end
	
	-- get our first packet
	-- because the server stuff stuff in here
	-- (8+8 (16) bytes); we can't fill it completely
	local subtext = string.sub(text, 0, OLM_BEGINLENGTH)
	
	-- cut off text
	text = string.sub(text, #subtext+1)
	-- begin transaction
	RunConsoleCommand("tsb", subtext)
	
	-- We can abort if subtext is less than 236
	if #subtext < OLM_BEGINLENGTH then
		return
	end
	
	-- The limit for a single source 
	while #text >= OLM_DATALENGTH do -- bytes.
		subtext = string.sub(text, 0, OLM_DATALENGTH)
		text = string.sub(text, #subtext+1)
		RunConsoleCommand("tsd", subtext)
		-- Again, we can abort if we got our goal.
	end
	RunConsoleCommand("tsd", text)
end

function msgOLMBegin(msg)
	local index = msg:ReadLong()
	local mt = tonumber(msg:ReadChar()) -- yay chars... No idea what GMod reads it like, I assume C-ish style
	local text = msg:ReadString()
	
	if ChatCache[index] then
		ProcessOLM(index)
	end
	
	ChatCache[index] = {Message = text, MessageType = mt}
	
	if player.GetByID(index) and player.GetByID(index).GetRPName then
		ChatCache[index].SenderName = player.GetByID(index):GetRPName()
		ChatCache[index].SenderTeam = player.GetByID(index):Team()
		ChatCache[index].SenderNick = player.GetByID(index):Nick()
	else
		ChatCache[index].SenderName = 'Consoliaro'
		ChatCache[index].SenderNick = 'Consoliaro Del Monte'
		ChatCache[index].SenderTeam = 0
	end
	
	-- Is it too short already?
	if #text < OLM_BEGINLENGTH then
		ProcessOLM(index)
	end
end
usermessage.Hook("tsb", msgOLMBegin)

function msgOLMData(msg)
	local index = msg:ReadLong()
	local text = msg:ReadString()
	
	ChatCache[index].Message = ChatCache[index].Message .. text
	
	if #text < OLM_DATALENGTH then
		ProcessOLM(index)
	end
end
usermessage.Hook("tsd", msgOLMData)

-- Basically, we take the template and the data we have
-- and make cake out of it
function ProcessOLM(index)
	if not ChatCache[index] then
		return
	end
	
	local msg = ChatCache[index]
	local template = TS.MessageTypes[msg.MessageType]
	
	if not template then
		error("OLM: Unable to find template for message type " .. msg.MessageType)
	end
	
	local text = msg.Message
	local consoletext = text
	local name = msg.SenderName
	local consolename = name
	local namecolor = template.NameColor
	local textcolor = template.TextColor
	
	if not template.ShowName then
		name = ''
	end
	
	if not namecolor then
		namecolor = team.GetColor(msg.SenderTeam)
	end
	
	-- finally, change the message if necessary
	if template.hook then
		-- To make it easy for the hook, wrap all things into a table.
		-- I'm not sure if lua has pass-by-reference
		-- and I'm not that interested in finding out since defining..
		-- 8 parameters? would be a pain anyway.
		
		local t = {
			text = text, -- chat
			name = name, -- chat
			consoletext = consoletext, -- console, logs
			consolename = consolename, -- console, logs
			namecolor = namecolor, -- chat, console
			textcolor = textcolor, -- chat, console
			msg = msg -- just for reference; you should not change this.
		}
		
		-- FIRE IT
		template.hook(t)
		
		-- unpack.
		text, name, consoletext, consolename, namecolor, textcolor = t.text, t.name, t.consoletext, t.consolename, t.namecolor, t.textcolor
	end
	
	AddChat(template.tabs, name, text, template.font, namecolor, textcolor)
	
	if name == '' then
		chat.AddText(textcolor, consoletext)
		if template.ACL then
			AddChatLine(nil, text)
		end		
	else
		chat.AddText(namecolor, consolename, ": ", textcolor, consoletext)

		if template.ACL then
			AddChatLine(name, text)
		end	
		
		text = name .. ': ' .. text
		consoletext = consolename .. ': ' .. consoletext
	end
	
	-- Logging
	if template.AllLog then
		WriteClientAllLog(consoletext)
	end
	
	if template.ICLog then
		WriteClientICLog(consoletext)
	end
	
	-- Erasure. HAHAHAHAHAHAHAHA.
	ChatCache[index] = nil
end

-- rehook a few things
TS.MessageTypes.GOOC.hook = function(t)
	t.text = "[OOC] " .. t.text;
	t.consoletext = t.text
	t.consolename = t.consolename .. " (" .. t.msg.SenderNick .. ")"
end

TS.MessageTypes.LOOC.hook = function(t)
	t.text = "[LOCAL-OOC] " .. t.text
	t.consoletext = t.text
end

TS.MessageTypes.YELL.hook = function(t)
	t.text = "[YELL] " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.WHISPER.hook = function(t)
	t.text = "[WHISPER] " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.ICACTION.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /it");
	t.text = "** " .. t.text .. " **";
	t.consoletext = t.text
end

TS.MessageTypes.EMOTE.hook = function(t)
	t.text = "** " .. t.msg.SenderName .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.RADIO.hook = function(t)
	t.consoletext = "[RADIO] " .. t.text
end

TS.MessageTypes.RADIOYELL.hook = function(t)
	t.text = "[YELL] " .. t.text;
	t.consoletext = "[RADIO] " .. t.text
end

TS.MessageTypes.RADIOWHISPER.hook = function(t)
	t.text = "[WHISPER] " .. t.text
	t.consoletext = "[RADIO] " .. t.text
end

TS.MessageTypes.CONSOLE.hook = function(t)
	t.text = "Console: " .. t.text
	t.consoletext = t.text
end

TS.MessageTypes.DISPATCH.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /dis");
	t.text = "[DISPATCH] " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.BROADCAST.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /br");
	t.text = "[BROADCAST] " .. t.msg.SenderName .. ": " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.ADVERTISMENT.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /adv");
	t.text = "[ADVERTISMENT] " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.EVENT.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /ev");
	t.text = "[EVENT] ** " .. t.text .. " **";
	t.consoletext = t.text
end

TS.MessageTypes.RADIODISPATCH.hook = function(t)
	print(t.msg.SenderName .. " (" .. t.msg.SenderNick .. ") used /rdis");
	t.text = "[DISPATCH] " .. t.text;
	t.consoletext = t.text
end

TS.MessageTypes.ADMIN.hook = function(t)
	t.name = t.name .. " (" .. t.msg.SenderNick .. ")"
	t.consolename = t.name
end

-- Client sided logging
-- CVars
local loggingEnabled = CreateClientConVar("rp_cl_logging", "0", true, false)
local loggingPerChar = CreateClientConVar("rp_cl_logging_per_char", "0", true, false)
local loggingPerDate = CreateClientConVar("rp_cl_logging_per_date", "1", true, false)
local loggingPerDateFormat = CreateClientConVar("rp_cl_logging_per_date_format", "Y-m-d", true, false)

function IsLoggingEnabled()
	return loggingEnabled:GetInt() ~= 0
end

function IsLoggingPerCharacterEnabled()
	return loggingPerChar:GetInt() ~= 0
end

function IsLoggingPerDateEnabled()
	return loggingPerDate:GetInt() ~= 0
end

function LoggingDateFormat()
	if loggingPerDateFormat:GetString() == "" then
		return "%Y-%m-%d"
	end
	local s = string.gsub(string.gsub(loggingPerDateFormat:GetString(), "[aAbBcCdDehHIjklmMnpRsStTuUVwWxXyYz%%]", "%%%1"), "\\", "%%")
	return s
end

function WriteClientAllLog(text)
	WriteClientLog(0, text)
end

function WriteClientICLog(text)
	WriteClientLog(1, text)
end

-- Add configuration stuff here
-- 0 - ALL only
-- 1 - IC
-- Logfileformat:
-- garrysmod/data/TnB/DATE IF rp_cl_logging_per_date FORMATTED AS rp_cl_logging_per_date_format/CHARACTERNAME IF rp_cl_logging_per_char.txt
-- if CHAR is omitted, the filename is the date
-- if CHAR is omitted AND DATE is omitted, the filename is simply "All" or "IC".
function GetLogFilename(val)
	local filename = "TnB/logs/HL2/";
	
	if val == 0 then
		filename = filename .. "All"
	elseif val == 1 then
		filename = filename .. "IC"
	end
	
	if IsLoggingPerDateEnabled() then
		filename = filename .. "/" .. os.date(LoggingDateFormat())
	end
	
	if IsLoggingPerCharacterEnabled() then
		if not LocalPlayer().GetRPName then
			filename = filename .. "/unknown"
		else
			filename = filename .. "/" .. LocalPlayer():GetRPName()
		end
	end
	
	local s = string.gsub(filename, "[.]", "_") .. ".txt"
	return s
end

-- 0 - ALL only
-- 1 - IC
function WriteClientLog( val, text )
	if not IsLoggingEnabled() then
		return
	end
	
	filex.Append(GetLogFilename(val), text .. "\n")
end
