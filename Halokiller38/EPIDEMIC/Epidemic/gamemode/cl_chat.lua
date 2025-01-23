
surface.CreateFont( "ChatFont", 14, 800, true, false, "NewChatFont" );
surface.CreateFont( "ChatFont", 16, 800, true, false, "BigChatFont" );
surface.CreateFont( "ChatFont", 24, 1600, true, false, "GiantChatFont" );
surface.CreateFont( "ChatFont", 20, 1600, true, false, "EvChatFont" );
surface.CreateFont( "ChatFont", 12, 800, true, false, "SmallChatFont" );

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

OOCDELAY = 0;

function SetOOCDelay( um )
	
	local t = um:ReadShort();
	OOCDELAY = t;
	
end
usermessage.Hook( "SetOOCDelay", SetOOCDelay );

function OpenChatBox()

	if( BlackScreenOn ) then
	
		return;
	
	end

	if( ChatBoxVisible ) then return; end
	if( not ChatBox ) then return; end
	if( not ChatBox.SetVisible ) then return; end

	ChatBox:SetVisible( true );
	InnerChatBox[CurrentChatTab]:SetVisible( true );
	ChatBoxVisible = true;
	
	gui.EnableScreenClicker( true );
	
	FindVisibleChat( CurrentChatTab );
	
	if( RadioMenu and RadioMenu:IsValid() ) then

		RadioMenu:SetVisible( true );
		FillRadioChatMenu();
		
	end
	
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

	FindVisibleChat( CurrentChatTab );

	ChatBox:SetVisible( false );
	ChatBoxVisible = false;
	
	if( RadioMenu and RadioMenu:IsValid() ) then
	
		RadioMenu:SetVisible( false );
	
	end
	
	if( CurrentChatTab == 8 ) then

		InnerChatBox[CurrentChatTab]:SetVisible( false );
	
	end
	
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
	
	RunConsoleCommand( "eng_nt" );

end

function ToggleChatBox()

	ChatBoxVisible = !ChatBoxVisible;
	
	if( ChatBoxVisible ) then
	
		OpenChatBox();
	
	else
	
		CloseChatBox();
	
	end

end


function RedNotice( msg )

	local text = msg:ReadString();

	AddChat( { 1 }, "", text, "BigChatFont", Color( 200, 200, 200, 255 ), Color( 200, 0, 0, 255 ) );
	

end
usermessage.Hook( "RedNotice", RedNotice );

function PrintGreenPrivateMessage( msg )

	local text = msg:ReadString();

	AddChat( { 1, 5 }, "", text, RegChatFont, Color( 200, 200, 200, 255 ), Color( 160, 255, 160, 255 ) );
	

end
usermessage.Hook( "PMM", PrintGreenPrivateMessage );

function PrintBlueMessage( msg )

	local text = msg:ReadString();

	AddChat( { 1, 2, 3, 4, 5, 6, 7 }, "", text, RegChatFont, Color( 200, 200, 200, 255 ), Color( 200, 200, 200, 255 ) );

end
usermessage.Hook( "PBM", PrintBlueMessage );

function PrintMaintMessage( msg )

	local text = msg:ReadString();

	AddChat( { 1, 2, 3, 4, 5, 6, 7 }, "", text, RegChatFont, Color( 255, 0, 0, 255 ), Color( 255, 0, 0, 255 ) );

end
usermessage.Hook( "PMaM", PrintMaintMessage );

function SayICChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	local enti = msg:ReadEntity();

	if( enti and enti:IsValid() and enti == LocalPlayer() ) then
		
		AddChat( { 1, 3 }, name, "\"" .. text .. "\"", "NewChatFont", Color( 32, 225, 246, 255 ), Color( 32, 225, 246, 255 ), nil, true );
		
	else
		
		AddChat( { 1, 3 }, name, "\"" .. text .. "\"", "NewChatFont", Color( 91, 166, 221, 255 ), Color( 91, 166, 221, 255 ), nil, true );
		
	end

end
usermessage.Hook( "ic", SayICChat );

function SayAdminChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1, 4 }, "[TO ADMINS]" .. name, text, "NewChatFont", Color( 250, 100, 100, 255 ), Color( 250, 100, 100, 255 ) );

end
usermessage.Hook( "ac", SayAdminChat );

function SayRadio( msg )

	if( Radios[SelectedRadioFreq] ) then

		local name = msg:ReadString();
		local text = msg:ReadString();
	
		AddChat( { 1, 3, 6 }, "@" .. Radios[SelectedRadioFreq].Freq .. "." .. Radios[SelectedRadioFreq].DFreq .. " " .. name, "\"" .. text .. "\"", "NewChatFont", Color( 230, 230, 230, 255 ), Color( 230, 230, 230, 255 ), nil, true );
	
	end

end
usermessage.Hook( "r", SayRadio );

function SayBroadcastRadio( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1, 3, 6 }, "[Broadcast Radio] " .. name, "\"" .. text .. "\"", "NewChatFont", Color( 230, 230, 230, 255 ), Color( 230, 230, 230, 255 ), nil, true );
	
end
usermessage.Hook( "br", SayBroadcastRadio );

function SayLocalOOCChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1, 3 }, name, text, "NewChatFont", Color( 220, 220, 220, 255 ), Color( 220, 220, 220, 255 ) );

end
usermessage.Hook( "looc", SayLocalOOCChat );

function SayICAction( msg )

	local text = msg:ReadString();

	AddChat( { 1, 3 }, "", text, "NewChatFont", Color( 131, 206, 251, 255 ), Color( 131, 196, 251, 255 ) );
	

end
usermessage.Hook( "it", SayICAction );

function SayICActionLoud( msg )

	local text = msg:ReadString();

	AddChat( { 1, 3 }, "", text, "BigChatFont", Color( 131, 206, 251, 255 ), Color( 131, 196, 251, 255 ) );
	

end
usermessage.Hook( "lit", SayICActionLoud );


function DoICAction( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	local enti = msg:ReadEntity();
	
	if( enti and enti:IsValid() and enti == LocalPlayer() ) then
		
		AddChat( { 1, 3 }, "", name .. text, RegChatFont, Color( 32, 225, 246, 255 ), Color( 32, 225, 246, 255 ) );
		
	else
		
		AddChat( { 1, 3 }, "", name .. text, RegChatFont, Color( 131, 196, 251, 255 ), Color( 131, 196, 251, 255 ) );
		
	end
	
end
usermessage.Hook( "ica", DoICAction );

function DoICYellAction( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	local enti = msg:ReadEntity();
	
	if( enti and enti:IsValid() and enti == LocalPlayer() ) then
		
		AddChat( { 1, 3 }, "", name .. text, "BigChatFont", Color( 32, 225, 246, 255 ), Color( 32, 225, 246, 255 ) );
		
	else
		
		AddChat( { 1, 3 }, "", name .. text, "BigChatFont", Color( 131, 196, 251, 255 ), Color( 131, 196, 251, 255 ) );
		
	end
	
end
usermessage.Hook( "yica", DoICYellAction );

function DoIDAction( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1, 3 }, "", text, RegChatFont, Color( 50, 225, 50, 255 ), Color( 50, 225, 50, 255 ) );
	

end
usermessage.Hook( "ida", DoIDAction );

function YellICChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	local enti = msg:ReadEntity();
	
	if( enti and enti:IsValid() and enti == LocalPlayer() ) then
		
		AddChat( { 1, 3 }, name, "[Y] \"" .. text .. "\"", "BigChatFont", Color( 32, 225, 246, 255 ), Color( 32, 225, 246, 255 ), nil, true );
		
	else
		
		AddChat( { 1, 3 }, name, "[Y] \"" .. text .. "\"", "BigChatFont", Color( 91, 166, 221, 255 ), Color( 91, 166, 221, 255 ), nil, true );
		
	end

end
usermessage.Hook( "yicc", YellICChat );

function WhisperICChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	local enti = msg:ReadEntity();

	if( enti and enti:IsValid() and enti == LocalPlayer() ) then
		
		AddChat( { 1, 3 }, name, "[w] \"" .. text .. "\"", "SmallChatFont", Color( 32, 225, 246, 255 ), Color( 32, 225, 246, 255 ), nil, true );
		
	else
		
		AddChat( { 1, 3 }, name, "[w] \"" .. text .. "\"", "SmallChatFont", Color( 91, 166, 221, 255 ), Color( 91, 166, 221, 255 ), nil, true );
		
	end

end
usermessage.Hook( "wicc", WhisperICChat );

function GlobalChat( msg )

	local name = msg:ReadString();
	local nameflags = "";
	
	local color = team.GetColor( 1 );
	local text = msg:ReadString();

	AddChat( { 1, 2 }, name, text, RegChatFont, color, Color( 200, 200, 200, 255 ), nameflags );

end
usermessage.Hook( "GC", GlobalChat );

function PlyCon( msg )

	local name = msg:ReadString();
	
	AddChat( { 1 }, "", name .. " has connected", RegChatFont, Color( 232, 20, 225, 255 ), Color( 255, 255, 149, 255 ) );
	

end
usermessage.Hook( "PlyCon", PlyCon );

function MiscCon( msg )

	local text = msg:ReadString();
	
	AddChat( { 1 }, "", text, RegChatFont, Color( 232, 20, 225, 255 ), Color( 255, 255, 149, 255 ) );
		

end
usermessage.Hook( "MiscCon", MiscCon );

function AYell( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();
	
	AddChat( { 1, 4, 7 }, name, text, "GiantChatFont", Color( 255, 255, 255, 255 ), Color( 232, 20, 20, 255 ) );
		

end
usermessage.Hook( "Ayell", AYell );

function ConsoleSay( msg )
	
	local text = msg:ReadString();
	
	AddChat( { 1, 4, 7 }, "", "Console: " .. text, RegChatFont, Color( 232, 20, 20, 255 ), Color( 232, 20, 20, 255 ) );

end
usermessage.Hook( "CSAY", ConsoleSay );

function Aev( msg )

	local text = msg:ReadString();
	
	AddChat( { 1, 4, 7 }, "", text, "EvChatFont", Color( 255, 255, 255, 255 ), Color( 255, 128, 20, 255 ) );

end
usermessage.Hook( "Aev", Aev );
 
function PlyDisc( msg )

	local name = msg:ReadString();
	local steamid = msg:ReadString();
	
	AddChat( { 1, 7 }, "", name .. " (ID: " .. steamid .. ") has left the server", RegChatFont, Color( 232, 20, 225, 255 ), Color( 255, 255, 149, 255 ) );
	

end
usermessage.Hook( "PDSC", PlyDisc );

function Charple() -- fuck off jain
	
	AddChat( { 1, 4, 7 }, "", "NEW UPDATE!", "GiantChatFont", Color( 1, 2, 3, 4 ), Color( 255, 255, 149, 255 ) );

end
usermessage.Hook( "Charple", Charple );

function AddChat( rec, name, text, font, namecolor, textcolor, nameflags, ic )

	if( not ChatBox or not InnerChatBox ) then return; end

	nameflags = nameflags or "";

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
		
		local admin = 0;
		local dead = false;
		
		--Append stuff to the name before we play with it
		if( admin == 2 ) then
		
			name = "(Super Admin) " .. name;
			newline.Tag = "(Super Admin)";
			newline.TagColor = Color( 200, 0, 0, 255 );
		
		elseif( admin == 1 ) then
		
			name = "(Admin) " .. name;
			newline.Tag = "(Admin)";
			newline.TagColor = Color( 255, 255, 255, 200 );
		
		elseif( dead ) then
		
			name = "(Dead) " .. name;
			newline.Tag = "(Dead)";
			newline.TagColor = Color( 70, 70, 70, 200 );
		
		else
			
			newline.Tag = "";
			newline.TagColor = Color( 0, 0, 0, 0 );
			
		end
		
		newline.TagWidth = surface.GetTextSize( newline.Tag );
		
		--Figure out how tall this piece of name/text is
		local _, textheight = surface.GetTextSize( text );
		local _, nameheight = surface.GetTextSize( name );
		
		if( name ~= nil and name ~= "" ) then
			if( ic ) then
				name = name .. " - ";
			else
				name = name .. ": ";
			end
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
		
		newline.Text = FormatLine( newline.Text, font, 385 );
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
		
		--Remove stuff from the name
		if( admin == 2 ) then
		
			newline.Name = string.sub( newline.Name, 14 );
			
		elseif( admin == 1 ) then
		
			newline.Name = string.sub( newline.Name, 8 );
		
		elseif( dead ) then
		
			newline.Name = string.sub( newline.Name, 7 );
		
		end
		
		--ChatTabs[v].Shift = ChatTabs[v].Shift - newline.Height;

		
		--The code here at the bottom deals with the scroll bar in the
		local movebar = false;
		
		local olddist = InnerChatBox[v].VScrollDistance;

		InnerChatBox[v].VScrollDistance = InnerChatBox[v].VScrollDistance + newline.Height;
		
		
		if( InnerChatBox[v].VScrollBar ) then
		
			local _, y = InnerChatBox[v].VScrollBar:GetPos();
			local ymax = y + InnerChatBox[v].VScrollBar:GetTall();
			local _, y2 = InnerChatBox[v].ScrollDownButton:GetPos();
			
			--If the scrollbar is at the bottom, then we move it down when
			--more chat comes in
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

	ChatBox = CreateBPanel( nil, 5, ScrH() - 455, 400, 275 );
	ChatBox.RequiresMouse = false;
	ChatBox:SetOutline( false );
	ChatBox:SetBodyColor( Color( 0, 0, 0, 0 ) );
	ChatBox.Prefix = "";
	
	for n = 1, 8 do
	
		InnerChatBox[n] = CreateBPanel( nil, 10, ScrH() - 455 + 29, 390, 198 );
		--InnerChatBox[n]:SetParent( ChatBox );
		InnerChatBox[n]:SetBodyColor( Color( 0, 0, 0, 0 ) );
		InnerChatBox[n]:SetOutline( false );
		InnerChatBox[n]:EnableScrolling( true );
		InnerChatBox[n]:SetVisible( false );
		InnerChatBox[n].RequiresMouse = false;
		InnerChatBox[n].OnScrollBarUpdate = function()
	
			FindVisibleChat( n );
		
		end
		
		InnerChatBox[n].PaintHook = function( self )
		
			if( BlackScreenOn ) then
			
				return;
			
			end
		
			if( not ChatBox:IsVisible() and PlayerMenuVisible ) then
			
				return;
			
			end
		
			for k, v in pairs( VisibleChatLines ) do
			
				if( ChatTabs and ChatTabs[n] and ChatTabs[n].ChatLines and ChatTabs[n].ChatLines[v] ) then

					local line = ChatTabs[n].ChatLines[v];
					
					if( line.NameColor.r == 1 and line.NameColor.g == 2 and line.NameColor.b == 3 and line.NameColor.a == 4 ) then
						
						if( ChatBoxVisible ) then
							
							draw.DrawTextOutlined( line.Text, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( ( math.random( 1, 2 ) - 1 ) * 255, ( math.random( 1, 2 ) - 1 ) * 255, ( math.random( 1, 2 ) - 1 ) * 255, line.TextColor.a ), 0, 0, 1, Color( 30, 30, 30, 255 ) );

						else
							
							draw.DrawTextOutlined( line.Text, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( ( math.random( 1, 2 ) - 1 ) * 255, ( math.random( 1, 2 ) - 1 ) * 255, ( math.random( 1, 2 ) - 1 ) * 255, line.Alpha ), 0, 0, 1, Color( 30, 30, 30, line.Alpha ) );

							if( line.Time + 5 < CurTime() ) then
							
								line.Alpha = math.Clamp( line.Alpha - 200 * FrameTime(), 0, 255 );
							
							end 

						end
						
					else
		
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
		
		end
		
		InnerChatBox[n].OriginalPaint = InnerChatBox[n].Paint;
		InnerChatBox[n].Paint = InnerChatBox[n].PaintHook;
		
		ChatBox.TextEntry = vgui.Create( "DTextEntry", ChatBox );
		ChatBox.TextEntry:SetPos( 10, ScrH() - 455 + 250 );
		ChatBox.TextEntry:SetSize( 390, 16 );
		ChatBox.TextEntry:SetMouseInputEnabled( true );
		ChatBox.TextEntry:SetKeyboardInputEnabled( true );
		ChatBox.TextEntry:SetFGColor( 0, 0, 0, 255 );
		ChatBox.TextEntry:MakePopup();
		
		ChatBox.TextEntry.OnTextChanged = function( self )
			
			if( string.len( self:GetValue() ) == 0 ) then
				
				RunConsoleCommand( "eng_nt" );
				
			elseif( string.len( self:GetValue() ) == 1 ) then
				
				RunConsoleCommand( "eng_it" );
				
			end
			
			self:SetValue( string.sub( self:GetValue(), 1, 124 ) );
			
		end
		
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
					
					RunConsoleCommand( "say", ChatBox.Prefix .. ChatBox.TextEntry:GetValue() );
					
				end

				ChatBox.TextEntry:SetText( "" );
				HideMouse();
				
				return;
			
			end
		
		end
		
	end
	
	InnerChatBox[1]:SetVisible( true );
	
	ChatBox.Button = { }
	
	ChatBox.Button[1] = ChatBox:AddButton( "Global", 5, 250 );
	ChatBox.Button[1].Outline = 2;
	
	local function SetToChatBox( n )
	
		if( CurrentChatTab == n ) then return; end

		DestroyRadioChatMenu();	

		ChatBox.Prefix = ChatBox.Button[n].ChatPrefix or "";
		ChatBox.Button[CurrentChatTab].AlwaysHighlight = false;
		ChatBox.Button[n].AlwaysHighlight = true;
		ChatBox.Button[n].HighlightRed = false;
		InnerChatBox[CurrentChatTab]:SetVisible( false );
		InnerChatBox[n]:SetVisible( true );
		InnerChatBox[n].Paint = InnerChatBox[n].OriginalPaint;
		
		CurrentChatTab = n;
		
		FindVisibleChat( n );	
	
	end
	
	ChatBox.Button[1].ChatPrefix = "";
	ChatBox.Button[1].Action = function()
	
		SetToChatBox( 1 );
	
	end
	ChatBox.Button[1].Action();
	
	ChatBox.Button[1].AlwaysHighlight = true;
	
	ChatBox.Button[2] = ChatBox:AddButton( "OOC", 60, 250 );
	ChatBox.Button[2].Outline = 2;
	ChatBox.Button[2].ChatPrefix = "/a ";
	
	ChatBox.Button[2].Action = function()
	
		SetToChatBox( 2 );
	
	end
	
	ChatBox.Button[3] = ChatBox:AddButton( "IC", 95, 250 );
	ChatBox.Button[3].Outline = 2;
	ChatBox.Button[3].ChatPrefix = "";
	
	ChatBox.Button[3].Action = function()
	
		SetToChatBox( 3 );
	
	end
	
	ChatBox.Button[4] = ChatBox:AddButton( "Admin", 119, 250 );
	ChatBox.Button[4].Outline = 2;
	ChatBox.Button[4].ChatPrefix = "!a ";
	
	ChatBox.Button[4].Action = function()
	
		SetToChatBox( 4 );
	
	end
	
	ChatBox.Button[5] = ChatBox:AddButton( "PM", 168, 250 );
	ChatBox.Button[5].Outline = 2;
	ChatBox.Button[5].ChatPrefix = "";
	
	ChatBox.Button[5].Action = function()
	
		SetToChatBox( 5 );
	
	end
	
	ChatBox.Button[6] = ChatBox:AddButton( "Radio", 198, 250 );
	ChatBox.Button[6].Outline = 2;	
	ChatBox.Button[6].ChatPrefix = "/r ";
	
	ChatBox.Button[6].Action = function()
	
		SetToChatBox( 6 );
		
		CreateRadioChatMenu();
	
	end
	
	ChatBox.Button[7] = ChatBox:AddButton( "Console", 244, 250 );
	ChatBox.Button[7].Outline = 2;
	
	ChatBox.Button[7].Action = function()
	
		SetToChatBox( 7 );
	
	end
	
	ChatBox.Button[8] = ChatBox:AddButton( "Help", 307, 250 );
	ChatBox.Button[8].Outline = 2;
	
	ChatBox.Button[8].Action = function()
	
		if( CurrentChatTab == 8 ) then return; end

		ChatBox.Button[CurrentChatTab].AlwaysHighlight = false;
		ChatBox.Button[8].AlwaysHighlight = true;
		ChatBox.Button[8].HighlightRed = false;
		InnerChatBox[CurrentChatTab]:SetVisible( false );
		InnerChatBox[8]:SetVisible( true );
		InnerChatBox[8].Paint = InnerChatBox[8].OriginalPaint;
		
		CurrentChatTab = 8;
		
		DestroyRadioChatMenu();	
	
	end
	
	InnerChatBox[8]:EnableScrolling( true );
	
	for k, v in pairs( ChatCmdListing ) do
	
		InnerChatBox[8]:AddLabel( FormatLine( v, "NewChatFont", 370 ), "NewChatFont", 5, 5 + ( k - 1 ) * 40, Color( 255, 255, 255, 255 ) );

	end
	
	InnerChatBox[8].PaintHook = function()
	
		local w, h = InnerChatBox[8]:GetSize();
	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end

end

CreateChatBox();
ChatBox:SetVisible( false );

