
surface.CreateFont( "ChatFont", 14, 800, true, false, "NewChatFont" );
surface.CreateFont( "ChatFont", 18, 1600, true, false, "BigChatFont" );
surface.CreateFont( "ChatFont", 32, 1600, true, false, "GiantChatFont" );
surface.CreateFont( "ChatFont", 11, 400, true, false, "SmallChatFont" );

RegChatFont = "NewChatFont";

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
	if( not ChatBox ) then return; end
	if( not ChatBox.SetVisible ) then return; end

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


function RedNotice( msg )

	local text = msg:ReadString();

	AddChat( { 1 }, "", text, "BigChatFont", Color( 200, 200, 200, 255 ), Color( 200, 0, 0, 255 ) );
	

end
usermessage.Hook( "RedNotice", RedNotice );

function PrintGreenPrivateMessage( msg )

	local text = msg:ReadString();

	AddChat( { 1 }, "", text, RegChatFont, Color( 200, 200, 200, 255 ), Color( 160, 255, 160, 255 ) );
	

end
usermessage.Hook( "PrivateMessage", PrintGreenPrivateMessage );

function PrintBlueMessage( msg )

	local text = msg:ReadString();

	AddChat( { 1 }, "", text, RegChatFont, Color( 200, 200, 200, 255 ), Color( 200, 200, 200, 255 ) );

end
usermessage.Hook( "PrintBlueMessage", PrintBlueMessage );

function DoICAction( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1 }, "", name .. text, RegChatFont, Color( 131, 196, 251, 255 ), Color( 131, 196, 251, 255 ) );
	

end
usermessage.Hook( "ICAction", DoICAction );

function YellICChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1 }, name, "[YELL]" .. text, RegChatFont, Color( 91, 166, 221, 255 ), Color( 91, 166, 221, 255 ) );

end
usermessage.Hook( "YellICChat", YellICChat );

function WhisperICChat( msg )

	local name = msg:ReadString();
	local text = msg:ReadString();

	AddChat( { 1 }, name, "[whisper]" .. text, RegChatFont, Color( 91, 166, 221, 255 ), Color( 91, 166, 221, 255 ) );

end
usermessage.Hook( "WhisperICChat", WhisperICChat );

function ConsoleChat( msg )

	local text = msg:ReadString();

	AddChat( { 1 }, "Console", text, RegChatFont, Color( 232, 20, 225, 255 ), Color( 200, 200, 200, 255 ) );

end
usermessage.Hook( "ConsoleChat", ConsoleChat );

function GlobalChat( msg )

	local ply = msg:ReadEntity();
	local name = ply:Nick();
	local nameflags = "";
	
	if( ply:IsSuperAdmin() ) then
	
		nameflags = "s";
	
	elseif( ply:IsAdmin() ) then
	
		nameflags = "a";
	
	end
	
	if( !ply:Alive() ) then
	
		nameflags = nameflags .. "d";
	
	end
	
	local color = team.GetColor( ply:Team() );
	local text = msg:ReadString();

	AddChat( { 1 }, name, text, RegChatFont, color, Color( 200, 200, 200, 255 ), nameflags );

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
	
	AddChat( { 1 }, name, text, "GiantChatFont", Color( 255, 255, 255, 255 ), Color( 232, 20, 20, 255 ) );
		

end
usermessage.Hook( "Ayell", AYell );
 
function PlyDisc( msg )

	local name = msg:ReadString();
	local steamid = msg:ReadString();
	
	AddChat( { 1, 7 }, "", name .. " (ID: " .. steamid .. ") has left the server", RegChatFont, Color( 232, 20, 225, 255 ), Color( 255, 255, 149, 255 ) );
	

end
usermessage.Hook( "PlyDisc", PlyDisc );

function AddChat( rec, name, text, font, namecolor, textcolor, nameflags )

	if( not ChatBox or not InnerChatBox ) then return; end

	rec = { 1 }; --Always global
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
		
		if( string.find( nameflags, "s" ) ) then
			admin = 2;
		elseif( string.find( nameflags, "a" ) ) then
			admin = 1;
		elseif( string.find( nameflags, "d" ) ) then
			dead = true;
		end
		
		--Append stuff to the name before we play with it
		if( admin == 2 ) then
		
			name = "(Supah Admin) " .. name;
			newline.Tag = "(Supah Admin)";
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

	ChatBox = CreateBPanel( nil, 5, ScrH() - 350, 450, 250 );
	
	ChatBox.RequiresMouse = false;
	
	ChatBox:SetBodyColor( Color( 0, 0, 0, 0 ) );
	ChatBox:SetOutline( false );
	ChatBox:CanClose( false );
	
	--Make one.
	for n = 1, 1 do
	
		InnerChatBox[n] = CreateBPanel( nil, 10, ScrH() - 350 + 29, 390, 198 );
		--InnerChatBox[n]:SetParent( ChatBox );
		InnerChatBox[n]:SetBodyColor( Color( 0, 0, 0, 150 ) );
		InnerChatBox[n]:EnableScrolling( true );
		InnerChatBox[n]:SetVisible( false );
		InnerChatBox[n]:CanClose( false );
		InnerChatBox[n]:SetOutline( false );
		InnerChatBox[n].RequiresMouse = false;
		
		InnerChatBox[n].OnScrollBarUpdate = function()
	
			FindVisibleChat( n );
		
		end
		
		InnerChatBox[n].PaintHook = function( self )
		
			for k, v in pairs( VisibleChatLines ) do
			
				if( ChatTabs and ChatTabs[n] and ChatTabs[n].ChatLines and ChatTabs[n].ChatLines[v] ) then

					local line = ChatTabs[n].ChatLines[v];
	
					if( ChatBoxVisible ) then
	
						draw.SimpleTextOutlined( line.Tag, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, line.TagColor, 0, 0, 1, Color( 30, 30, 30, 255 ) );
						draw.SimpleTextOutlined( line.Name, line.Font, line.X + line.TagWidth, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, line.NameColor, 0, 0, 1, Color( 30, 30, 30, 255 ) );
						draw.DrawTextOutlined( line.Text, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.TextColor.r, line.TextColor.g, line.TextColor.b, line.TextColor.a ), 0, 0, 1, Color( 30, 30, 30, 255 ) );

					else
					
						draw.SimpleTextOutlined( line.Tag, line.Font, line.X, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.TagColor.r, line.TagColor.g, line.TagColor.b, line.Alpha ), 0, 0, 1, Color( 30, 30, 30, line.Alpha ) );
						draw.SimpleTextOutlined( line.Name, line.Font, line.X + line.TagWidth, line.Y - InnerChatBox[n].VScrollAmount + ChatTabs[n].Shift, Color( line.NameColor.r, line.NameColor.g, line.NameColor.b, line.Alpha ), 0, 0, 1, Color( 30, 30, 30, line.Alpha ) );
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
		ChatBox.TextEntry:SetPos( 10, ScrH() - 350 + 250 );
		ChatBox.TextEntry:SetSize( 390, 16 );
		ChatBox.TextEntry:SetMouseInputEnabled( true );
		ChatBox.TextEntry:SetKeyboardInputEnabled( true );
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
					
					RunConsoleCommand( "say", ChatBox.TextEntry:GetValue() );
					
				end

				ChatBox.TextEntry:SetText( "" );
				
				HideMouse();
		
				return;
			
			end
		
		end
		
	end
	
	InnerChatBox[1]:SetVisible( true );
	
	ChatBox.Button = { }
	
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
	
	SetToChatBox( 1 );

end

--CreateChatBox();
--ChatBox:SetVisible( false );

