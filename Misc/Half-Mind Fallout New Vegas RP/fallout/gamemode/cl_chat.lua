GM.ChatboxOpen = GM.ChatboxOpen or false;
GM.ChatboxFilter = GM.ChatboxFilter or CB_ALL;

GM.ChatWidth = 600;
GM.ChatHeight = 300;

GM.ChatLines = GM.ChatLines or { };

function GM:AddChat( filter, font, color, text, pre, ply )
	
	pre = pre or "";
	
	local str, n = GAMEMODE:FormatLine( text, font, GAMEMODE.ChatWidth - 20 - 16 );
	
	table.insert( self.ChatLines, { CurTime(), filter, font, color, text, ply, str } );
	MsgC( color, pre .. text .. "\n" );
	
	if( #self.ChatLines > 100 ) then
		
		for i = 1, #self.ChatLines - 100 do
			
			table.remove( self.ChatLines, 1 );
			
		end
		
	end
	
	if( !system.HasFocus() and table.HasValue( filter, self.ChatboxFilter ) ) then
		
		system.FlashWindow();
		
	end
	
end

function GM:HUDPaintChat()
	
	if( !self.ChatboxOpen ) then
		
		local y = ScrH() - 200 - 40 - 34;
		
		local tab = { };
		
		for _, v in pairs( self.ChatLines ) do
			
			if( table.HasValue( v[2], self.ChatboxFilter ) and CurTime() - v[1] < 10 ) then
				
				table.insert( tab, v );
				
			end
			
		end
		
		local ty = 0;
		
		for i = #tab, math.max( #tab - 8, 1 ), -1 do
			
			local start = tab[i][1];
			local filter = tab[i][2];
			local font = tab[i][3];
			local color = tab[i][4];
			local text = tab[i][5];
			local ply = tab[i][6];
			local str = tab[i][7];
			
			local amul = 0;
			
			if( CurTime() - start < 9 ) then
				
				amul = 1;
				
			else
				
				amul = 1 - ( CurTime() - start - 9 );
				
			end
			
			surface.SetFont( font );
			local _, h = surface.GetTextSize( text );
			
			local expl = string.Explode( "\n", str );
			
			local cy = 0;
			
			for i = #expl, 1, -1 do
				
				local v = expl[i];
				_, h = surface.GetTextSize( v );
				
				if( y - h < 0 ) then break; end
				
				surface.SetFont( font );
				local tw, th = surface.GetTextSize( string.sub( v, 1, 196 ) );
				surface.SetDrawColor( Color( 0, 0, 0, 225 * amul ) );
				surface.DrawRect( 30, y - h, tw + 2, th );
				draw.DrawTextShadow( string.sub( v, 1, 196 ), font, 30, y - h, Color( color.r, color.g, color.b, color.a * amul ), Color( 0, 0, 0, 255 ), 0 );
				
				y = y - h;
				ty = ty + h;
				
			end
			
		end
		
	end
	
end

function GM:CreateChatbox()
	
	self.ChatboxOpen = true;
	
	self.D.Chat = vgui.Create( "IChatPanel" );
	self.D.Chat:SetSize( self.ChatWidth, self.ChatHeight );
	self.D.Chat:SetPos( 20, ScrH() - 200 - 34 - self.ChatHeight );
	self.D.Chat:MakePopup();
	
	self.D.Chat.Entry = vgui.Create( "DTextEntry", self.D.Chat );
	self.D.Chat.Entry:SetFont( "Infected.ChatNormal" );
	self.D.Chat.Entry:SetPos( 10, self.ChatHeight - 30 );
	self.D.Chat.Entry:SetSize( self.ChatWidth - 20, 20 );
	self.D.Chat.Entry:PerformLayout();
	function self.D.Chat.Entry:OnEnter()
		
		if( string.len( self:GetValue() ) > 0 ) then
			
			if( string.len( self:GetValue() ) > 500 ) then
				
				GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", Color( 200, 0, 0, 255 ), "The maximum chat length is 500 characters. You typed " .. string.len( self:GetValue() ) .. "." );
				GAMEMODE.NextChatText = self:GetValue();
				
			else
				
				net.Start( "nSay" );
					net.WriteString( self:GetValue() );
				net.SendToServer();
				
				GAMEMODE:OnChat( LocalPlayer(), self:GetValue() );
				
			end
			
		else
			
			GAMEMODE.NextChatText = nil;
			
		end
		
		GAMEMODE.ChatboxOpen = false;
		
		net.Start( "nSetTyping" );
			net.WriteFloat( 0 );
		net.SendToServer();
		
		self:GetParent():Remove();
		
		GAMEMODE.D.Chat = nil;
		
	end
	function self.D.Chat.Entry:OnTextChanged()
		
		local cc = GAMEMODE:GetChatCommand( self:GetValue() );
		
		if( string.len( self:GetValue() ) > 0 ) then
			
			if( cc ) then
				
				net.Start( "nSetTyping" );
					net.WriteFloat( 2 );
				net.SendToServer();
				
			else
				
				net.Start( "nSetTyping" );
					net.WriteFloat( 1 );
				net.SendToServer();
				
			end
			
		else
			
			net.Start( "nSetTyping" );
				net.WriteFloat( 0 );
			net.SendToServer();
			
		end
		
		if( cc ) then
			
			self.OverrideColor = cc[2];
			
		else
			
			self.OverrideColor = nil;
			
		end
		
	end
	if( self.NextChatText ) then
		
		self.D.Chat.Entry:SetValue( self.NextChatText );
		self.NextChatText = nil;
		
	end
	self.D.Chat.Entry:RequestFocus();
	self.D.Chat.Entry:SetCaretPos( string.len( self.D.Chat.Entry:GetValue() ) );
	
	self.D.Chat.AllButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.AllButton:SetFont( "Infected.TinyTitle" );
	self.D.Chat.AllButton:SetText( "All" );
	self.D.Chat.AllButton:SetPos( 10, 10 );
	self.D.Chat.AllButton:SetSize( 50, 20 );
	function self.D.Chat.AllButton:DoClick()
		
		GAMEMODE.D.Chat.AllButton:SetDisabled( true );
		GAMEMODE.D.Chat.ICButton:SetDisabled( false );
		GAMEMODE.D.Chat.OOCButton:SetDisabled( false );
		GAMEMODE.D.Chat.RadioButton:SetDisabled( false );
		GAMEMODE.ChatboxFilter = CB_ALL;
		
	end
	
	self.D.Chat.ICButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.ICButton:SetFont( "Infected.TinyTitle" );
	self.D.Chat.ICButton:SetText( "IC" );
	self.D.Chat.ICButton:SetPos( 70, 10 );
	self.D.Chat.ICButton:SetSize( 50, 20 );
	function self.D.Chat.ICButton:DoClick()
		
		GAMEMODE.D.Chat.AllButton:SetDisabled( false );
		GAMEMODE.D.Chat.ICButton:SetDisabled( true );
		GAMEMODE.D.Chat.OOCButton:SetDisabled( false );
		GAMEMODE.D.Chat.RadioButton:SetDisabled( false );
		GAMEMODE.ChatboxFilter = CB_IC;
		
	end
	
	self.D.Chat.OOCButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.OOCButton:SetFont( "Infected.TinyTitle" );
	self.D.Chat.OOCButton:SetText( "OOC" );
	self.D.Chat.OOCButton:SetPos( 130, 10 );
	self.D.Chat.OOCButton:SetSize( 50, 20 );
	function self.D.Chat.OOCButton:DoClick()
		
		GAMEMODE.D.Chat.AllButton:SetDisabled( false );
		GAMEMODE.D.Chat.ICButton:SetDisabled( false );
		GAMEMODE.D.Chat.OOCButton:SetDisabled( true );
		GAMEMODE.D.Chat.RadioButton:SetDisabled( false );
		GAMEMODE.ChatboxFilter = CB_OOC;
		
	end
	
	self.D.Chat.RadioButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.RadioButton:SetFont( "Infected.TinyTitle" );
	self.D.Chat.RadioButton:SetText( "Radio" );
	self.D.Chat.RadioButton:SetPos( 190, 10 );
	self.D.Chat.RadioButton:SetSize( 50, 20 );
	function self.D.Chat.RadioButton:DoClick()
		
		GAMEMODE.D.Chat.AllButton:SetDisabled( false );
		GAMEMODE.D.Chat.ICButton:SetDisabled( false );
		GAMEMODE.D.Chat.OOCButton:SetDisabled( false );
		GAMEMODE.D.Chat.RadioButton:SetDisabled( true );
		GAMEMODE.ChatboxFilter = CB_RADIO;
		
	end
	
	self.D.Chat.PMButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.PMButton:SetFont( "Infected.TinyTitle" );
	self.D.Chat.PMButton:SetText( "PM" );
	self.D.Chat.PMButton:SetPos( 250, 10 );
	self.D.Chat.PMButton:SetSize( 50, 20 );
	function self.D.Chat.PMButton:DoClick()
		
		GAMEMODE.D.Chat.AllButton:SetDisabled( false );
		GAMEMODE.D.Chat.ICButton:SetDisabled( false );
		GAMEMODE.D.Chat.OOCButton:SetDisabled( false );
		GAMEMODE.D.Chat.RadioButton:SetDisabled( false );
		GAMEMODE.D.Chat.PMButton:SetDisabled( true );
		GAMEMODE.ChatboxFilter = CB_PM;
		
	end
	
	if( self.ChatboxFilter == CB_ALL ) then
		
		self.D.Chat.AllButton:SetDisabled( true );
		
	end
	
	if( self.ChatboxFilter == CB_IC ) then
		
		self.D.Chat.ICButton:SetDisabled( true );
		
	end
	
	if( self.ChatboxFilter == CB_OOC ) then
		
		self.D.Chat.OOCButton:SetDisabled( true );
		
	end
	
	if( self.ChatboxFilter == CB_RADIO ) then
		
		self.D.Chat.RadioButton:SetDisabled( true );
		
	end
	
	if( self.ChatboxFilter == CB_PM ) then
		
		self.D.Chat.PMButton:SetDisabled( true );
		
	end
	
	self.D.Chat.CloseButton = vgui.Create( "DButton", self.D.Chat );
	self.D.Chat.CloseButton:SetFont( "marlett" );
	self.D.Chat.CloseButton:SetText( "r" );
	self.D.Chat.CloseButton:SetPos( self.ChatWidth - 20 - 10, 10 );
	self.D.Chat.CloseButton:SetSize( 20, 20 );
	function self.D.Chat.CloseButton:DoClick()
		
		GAMEMODE.ChatboxOpen = false;
		
		net.Start( "nSetTyping" );
			net.WriteFloat( 0 );
		net.SendToServer();
		
		self:GetParent():Remove();
		
		GAMEMODE.D.Chat = nil;
		
	end
	
end

function GM:StartChat()
	
	return true;
	
end

function GM:ChatText( i, name, text, type )

	if( string.find( text, "Console:" ) ) then
		
		self:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", Color(232, 20, 225), text );
		
	end
	
	if( type == "joinleave" and string.find( text, "has joined the game" ) ) then
		
		self:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, text );
		
	end
	
	return true;
	
end

local function nSay( len )
	
	local ply = net.ReadEntity();
	local arg = net.ReadString();
	
	GAMEMODE:OnChat( ply, arg );
	
end
net.Receive( "nSay", nSay );