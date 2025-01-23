local meta = FindMetaTable( "Player" );

function GM:ToggleHolsterThink()
	
	if( !self.ToggleHolsterPressed ) then self.ToggleHolsterPressed = false; end
	
	if( vgui.CursorVisible() ) then self.ToggleHolsterPressed = false; return end
	
	if( input.IsKeyDown( KEY_B ) and !self.ToggleHolsterPressed ) then
		
		self.ToggleHolsterPressed = true;
		
		if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" or
				LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then
				
				return false;
				
			end
			
		end
		
		net.Start( "nToggleHolster" );
		net.SendToServer();
		
		if( LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon().Holsterable ) then
				
				LocalPlayer():SetHolstered( !LocalPlayer():Holstered() );
				
			else
				
				LocalPlayer():SetHolstered( false );
				
			end
			
		end
		
	elseif( !input.IsKeyDown( KEY_B ) and self.ToggleHolsterPressed ) then
		
		self.ToggleHolsterPressed = false;
		
	end
	
end

function GM:GetWeaponSlot()
	
	if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return 1 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_inf_hands" ) then return 1 end
	if( LocalPlayer():GetActiveWeapon().PrimaryWep ) then return 2 end
	if( LocalPlayer():GetActiveWeapon().SecondaryWep ) then return 3 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" ) then return 4 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then return 5 end
	
	return 1;
	
end

function GM:GetWeaponBySlot( i )
	
	if( i == 1 ) then return "weapon_inf_hands" end
	if( i == 4 ) then return "weapon_physgun" end
	if( i == 5 ) then return "gmod_tool" end
	
	for _, v in pairs( LocalPlayer():GetWeapons() ) do
		
		if( i == 2 and v:GetTable().PrimaryWep ) then return v:GetClass() end
		if( i == 3 and v:GetTable().SecondaryWep ) then return v:GetClass() end
		
	end
	
	return "";
	
end

function GM:PlayerBindPress( ply, b, d )
	
	if( d and b == "gm_showhelp" ) then
		
		self:ShowF1();
		return true;
		
	end
	
	if( d and b == "gm_showteam" ) then
		
		self:ShowF2();
		return true;
		
	end
	
	if( d and b == "gm_showspare1" ) then
		
		self:ShowF3();
		return true;
		
	end
	
 	if( d and b == "gm_showspare2") then
	
		if( LocalPlayer():IsTrader() ) then
	
			self:ShowF4();
			return true;
			
		end
		
	end
	
	if( d and string.find( b, "messagemode" ) and (self.IntroMode != 1) ) then

		self:CreateChatbox();
		return true;
		
	end
	
	if( d and b == "+use" ) then
		
		local tr = ply:GetHandTrace( 400 );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			self:ShowPlayerCard( tr.Entity );
			
			return true;
			
		end
		
	end
	
	if( d and string.find( b, "rp_toggleholster" ) ) then
		
		if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" or
				LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then
				
				return false;
				
			end
			
		end
		
		net.Start( "nToggleHolster" );
		net.SendToServer();
		
		if( LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon().Holsterable ) then
				
				LocalPlayer():SetHolstered( !LocalPlayer():Holstered() );
				
			else
				
				LocalPlayer():SetHolstered( false );
				
			end
			
		end
		
		return true;
		
	end
	
	if( d and string.find( b, "slot" ) ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		local n = string.gsub( b, "slot", "" );
		
		if( tonumber( n ) and tonumber( n ) >= 1 and tonumber( n ) <= 5 ) then
			
			local wep = self:GetWeaponBySlot( tonumber( n ) );
			
			if( LocalPlayer():HasWeapon( wep ) ) then
				
				net.Start( "nSelectWeapon" );
					net.WriteString( wep );
				net.SendToServer();
				
			end
			
		end
		
		return true;
		
	end
	
	if( d and b == "invnext" ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		if( LocalPlayer().isPhysgunning ) then return false end;
		
		if( !self.WeaponSlot ) then self.WeaponSlot = self:GetWeaponSlot(); end
		
		self.WeaponSlot = self.WeaponSlot + 1;
		
		if( self.WeaponSlot > 5 ) then self.WeaponSlot = 1 end
		
		local wep = self:GetWeaponBySlot( self.WeaponSlot );
		
		while( !LocalPlayer():HasWeapon( wep ) ) do
			
			self.WeaponSlot = self.WeaponSlot + 1;
			if( self.WeaponSlot > 5 ) then self.WeaponSlot = 1 end
			wep = self:GetWeaponBySlot( self.WeaponSlot );
			
		end
		
		net.Start( "nSelectWeapon" );
			net.WriteString( wep );
		net.SendToServer();
		
		return true;
		
	end
	
	if( d and b == "invprev" ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		if( LocalPlayer().isPhysgunning ) then return false end;
		
		if( !self.WeaponSlot ) then self.WeaponSlot = self:GetWeaponSlot(); end
		
		self.WeaponSlot = self.WeaponSlot - 1;
		
		if( self.WeaponSlot < 1 ) then self.WeaponSlot = 5 end
		
		local wep = self:GetWeaponBySlot( self.WeaponSlot );
		
		while( !LocalPlayer():HasWeapon( wep ) ) do
			
			self.WeaponSlot = self.WeaponSlot - 1;
			if( self.WeaponSlot < 1 ) then self.WeaponSlot = 5 end
			wep = self:GetWeaponBySlot( self.WeaponSlot );
			
		end
		
		net.Start( "nSelectWeapon" );
			net.WriteString( wep );
		net.SendToServer();
		
		return true;
		
	end
	
	return self.BaseClass:PlayerBindPress( ply, b, d );
	
end

GM.HelpTopics = { };
GM.HelpTopics[1] = { "Commands", [[
/w - Whisper. Has a range of 90 units.

/y, /yell, /shout - Yelling. Has a range of 1000 units.

/me - Used to express character actions. Has a range of 500 units.

/lme - Used to express character actions. Has a range of 1000 units.

/it - Used to express environmental actions. Has a range of 500 units.

/lit - Used to express environmental actions. Has a range of 1000 units.

[[, .//, /looc - Local out of character. Has a range of 500 units.

//, /ooc - Out of character. Global chat.

/a - Admin chat. Use this to contact admins.

/r - Radio. Only usable when you have a radio. Will reach anyone on the same frequency.
]] };
GM.HelpTopics[2] = { "Credits", 
[[
Gonzo - Fallout HUD.
Half-Logic - Gamemode.
Frix - Extra models.
Johnny Guitar - Character/Weapon Models.
]] 
};
GM.HelpTopics[3] = { "Admin 1", [[
rpa_kick
1: Target Name
2: Reason

rpa_ban
1: Target Name
2: Duration
3: Reason

rpa_goto
1: Target Name

rpa_bring
1: Target Name

rpa_setphystrust
1: Target Name
2: Value, 1 or 0

rpa_settooltrust
1: Target Name
2: Value, 1 or 0

rpa_setcharcreateflags
1: Target Name
2: Character, m for Supermutant

rpa_createitem
1: Item classname. Leave blank for list of items

rpa_createmoney
1: Amount
]]
};
GM.HelpTopics[4] = { "Admin 2", [[
rpa_setfactionspawnpos
1: Faction ID, 1 for Survivor, 2 for Supermutant

rpa_setmodel
1: Target Name
2: Model Path

rpa_setadmin
1: Target Name
2: Rank, superadmin or admin.

rpa_takeadmin
1: Target Name

rpa_setpersist
1: True or false. Look at prop and run command. Does not require an argument.
]]
};

function GM:ShowF1()
	
	if( LocalPlayer():CharID() == -1 ) then return end
	if( self.CharCreateMode ) then return end
	
	self.D.F1 = vgui.Create( "DFrame" );
	self.D.F1:SetSize( 500, 700 );
	self.D.F1:Center();
	self.D.F1:SetTitle( "Help" );
	self.D.F1:MakePopup();
	
	for k, v in pairs( self.HelpTopics ) do
	
		if( ( k == 3 or k == 4 ) and !LocalPlayer():IsAdmin() ) then continue end
		
		local b = vgui.Create( "DButton", self.D.F1 );
		b:SetPos( 10, 24 + 10 + 40 * ( k - 1 ) );
		b:SetSize( 128, 30 );
		b:SetFont( "Infected.TinyTitle" );
		b:SetText( v[1] );
		function b:DoClick()
			
			GAMEMODE.D.F1.Text:SetText( v[2] );
			GAMEMODE.D.F1.Text:PerformLayout();
			
		end
		
	end
	
	self.D.F1.Back = vgui.Create( "DScrollPanel", self.D.F1 );
	self.D.F1.Back:SetPos( 148, 34 );
	self.D.F1.Back:SetSize( 500 - 148 - 10, 700 );
	
	self.D.F1.Text = vgui.Create( "DLabel", self.D.F1.Back );
	self.D.F1.Text:SetPos( 0, 0 );
	self.D.F1.Text:SetSize( 500 - 148 - 10, 24 + 10 );
	self.D.F1.Text:SetWrap( true );
	self.D.F1.Text:SetAutoStretchVertical( true );
	self.D.F1.Text:SetFont( "Infected.LabelSmall" );
	self.D.F1.Text:SetText( "" );
	
end

function GM:ShowF2()
	
	if( LocalPlayer():CharID() == -1 ) then return end
	if( self.CharCreateMode ) then return end
	
	self:ShowInventory();
	
end

function GM:ShowF3()
	
	if( LocalPlayer():CharID() == -1 ) then return end
	if( self.CharCreateMode ) then return end
	
	self:ShowPlayerCard( LocalPlayer(), true );
	
end

function GM:ShowF4()
	
	if( LocalPlayer():CharID() == -1 ) then return end
	if( self.CharCreateMode ) then return end
	if( !LocalPlayer():IsTrader() ) then return end;
	
	self:ShowTraderMenu();
	
end

function GM:ShowPlayerCard( ply, me )
	
	self.D.F3 = vgui.Create( "DFrame" );
	self.D.F3:SetSize( 500, 700 );
	self.D.F3:Center();
	if( me ) then
		self.D.F3:SetTitle( "Player Menu" );
	else
		self.D.F3:SetTitle( ply:RPName() );
	end
	self.D.F3:MakePopup();
	
	self.D.F3.P = vgui.Create( "ICharPanel", self.D.F3 );
	self.D.F3.P:SetPos( 10, 34 );
	self.D.F3.P:SetSize( 128, 128 );
	self.D.F3.P:SetModel( ply:GetModel() );
	
	for i = 0, #ply:GetMaterials() - 1 do
		
		self.D.F3.P:SetSubMaterial( i, ply:GetSubMaterial( i ) );
		
	end
	
	self.D.F3.P:SetCamPos( Vector( 50, 20, 63 ) );
	self.D.F3.P:SetLookAtEyes();
	self.D.F3.P:SetFOV( 15 );
	self.D.F3.P:SetupPlayer( ply );
	
	self.D.F3.P.NoMouseWheel = true;
	
	self.D.F3.N = vgui.Create( "DLabel", self.D.F3 );
	self.D.F3.N:SetPos( 148, 34 );
	self.D.F3.N:SetFont( "Infected.SubTitle" );
	self.D.F3.N:SetText( ply:RPName() );
	self.D.F3.N:SizeToContents();
	self.D.F3.N:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.F3.DS = vgui.Create( "DScrollPanel", self.D.F3 );
	self.D.F3.DS:SetPos( 148, 64 );
	self.D.F3.DS:SetSize( 500 - 148 - 10, 700 - 64 - 10 );
	function self.D.F3.DS:Paint( w, h ) end
	
	self.D.F3.D = vgui.Create( "DLabel", self.D.F3.DS );
	self.D.F3.D:SetPos( 0, 0 );
	self.D.F3.D:SetFont( "Infected.LabelSmall" );
	self.D.F3.D:SetText( ply:Desc() );
	self.D.F3.D:SetAutoStretchVertical( true );
	self.D.F3.D:SetWrap( true );
	self.D.F3.D:SetSize( 500 - 148 - 10 - 16, 10 );
	self.D.F3.D:SetTextColor( Color( 255, 255, 255, 255 ) );
	self.D.F3.D:PerformLayout();
	
	if( me ) then
		
		self.D.F3.CN = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CN:SetPos( 10, 24 + 10 + 128 + 10 );
		self.D.F3.CN:SetSize( 128, 30 );
		self.D.F3.CN:SetFont( "Infected.TinyTitle" );
		self.D.F3.CN:SetText( "Change Name" );
		function self.D.F3.CN:DoClick()
			
			GAMEMODE:CreatePopupEntry( "Change Name", LocalPlayer():RPName(), GAMEMODE.MinNameLength, GAMEMODE.MaxNameLength, function( text )
				
				if( GAMEMODE.D.F3.N and GAMEMODE.D.F3.N:IsValid() ) then
					
					GAMEMODE.D.F3.N:SetText( text );
					GAMEMODE.D.F3.N:SizeToContents();
					
				end
				
				net.Start( "nChangeName" );
					net.WriteString( text );
				net.SendToServer();
				
			end );
			
		end
		
		self.D.F3.CD = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CD:SetPos( 10, 24 + 10 + 128 + 10 + 30 + 10 );
		self.D.F3.CD:SetSize( 128, 30 );
		self.D.F3.CD:SetFont( "Infected.TinyTitle" );
		self.D.F3.CD:SetText( "Change Desc" );
		function self.D.F3.CD:DoClick()
			
			GAMEMODE:CreatePopupEntry( "Change Description", LocalPlayer():Desc(), 0, GAMEMODE.MaxDescLength, function( text )
				
				if( GAMEMODE.D.F3.D and GAMEMODE.D.F3.D:IsValid() ) then
					
					GAMEMODE.D.F3.D:SetText( text );
					GAMEMODE.D.F3.D:PerformLayout()
					
				end
				
				net.Start( "nChangeDesc" );
					net.WriteString( text );
				net.SendToServer();
				
			end, true );
			
		end
		
		self.D.F3.CPD = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CPD:SetPos( 10, 24 + 10 + 128 + 10 + 80 );
		self.D.F3.CPD:SetSize( 128, 30 );
		self.D.F3.CPD:SetFont( "Infected.TinyTitle" );
		self.D.F3.CPD:SetText( "Prop Desc" );
		if( LocalPlayer():GetEyeTraceNoCursor().Entity:GetClass() != "prop_physics" ) then
		
			self.D.F3.CPD:SetDisabled( true );
			
		end
		function self.D.F3.CPD:DoClick()
			
			local ent = LocalPlayer():GetEyeTraceNoCursor().Entity;
			
			if( ent:GetClass() != "prop_physics" ) then return end
			
			GAMEMODE:CreatePopupEntry( "Change Prop Description", ent:GetNWString( "desc", "" ), 0, 199, function( text )
				
				net.Start( "nChangePropDesc" );
					net.WriteString( text );
				net.SendToServer();
				
			end, true );
			
		end
		
		self.D.F3.CNC = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CNC:SetPos( 10, 700 - 40 );
		self.D.F3.CNC:SetSize( 128, 30 );
		self.D.F3.CNC:SetFont( "Infected.TinyTitle" );
		self.D.F3.CNC:SetText( "Menu" );
		function self.D.F3.CNC:DoClick()
			
			GAMEMODE.StartFadeIntro = nil;
			GAMEMODE.IntroFadeStart = nil;
			GAMEMODE.MainMenuButtons = nil;
			GAMEMODE.IntroMode = 1;
			
			GAMEMODE.D.F3:Remove();
			
		end
		
	end
	
end

local slotsoccupiedraw = {};
local positions = {};

local function FindSlot(item) -- thank you based razor

	for j = 1, 40 - (item.H - 1)
	do

		for i = 1, 10 - (item.W - 1)
		do

			local usethis = true;

			for iw = 0, item.W - 1
			do

				for ih = 0, item.H - 1
				do

					for k, v in next, slotsoccupiedraw
					do

						if(v.x == (i + iw) and v.y == (j + ih))
						then

							usethis = false;
							break;

						end

					end

					if(not usethis)
					then

						break;

					end

				end

				if(not usethis)
				then

					break;

				end

			end

			if(usethis)
			then

				for w = 0, item.W - 1
				do

					for h = 0, item.H - 1
					do

						slotsoccupiedraw[#slotsoccupiedraw + 1] = {["x"] = (i + w), ["y"] = (j + h)};

					end

				end

				return j, i

			end

		end

	end

end

function GM:ShowTraderMenu()

	x = 8;

	self.category = CATEGORY_PRIMARYWEAPON;

	self.D.F4 = vgui.Create( "DFrame" );
	self.D.F4:SetSize( 1024, 700 );
	self.D.F4:Center();
	self.D.F4:SetTitle( "Trader System" );
	self.D.F4:MakePopup();
	
	self.D.F4.Scroll = vgui.Create( "DScrollPanel", self.D.F4 );
	self.D.F4.Scroll:SetSize( 500, 648 );
	self.D.F4.Scroll:SetPos( 6, 48 );
	
	self.D.F4.InvScroll = vgui.Create( "DScrollPanel", self.D.F4 );
	self.D.F4.InvScroll:SetSize( 500, 320 );
	self.D.F4.InvScroll:SetPos( self.D.F4:GetWide() / 2 + 5, self.D.F4:GetTall() / 2 + 25 );
	
	self.D.F4.T = vgui.Create( "DLabel", self.D.F4 );
	self.D.F4.T:SetPos( 48 * 11, 48 );
	self.D.F4.T:SetFont( "Infected.SubTitle" );
	self.D.F4.T:SetText( "" );
	self.D.F4.T:SizeToContents();
	self.D.F4.T:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.F4.D = vgui.Create( "DLabel", self.D.F4 );
	self.D.F4.D:SetPos( 48 * 11, 76 );
	self.D.F4.D:SetFont( "Infected.LabelSmall" );
	self.D.F4.D:SetText( "" );
	self.D.F4.D:SetAutoStretchVertical( true );
	self.D.F4.D:SetWrap( true );
	self.D.F4.D:SetSize( 800 - 10 - ( 10 + 48 * 10 + 30 ), 48 * 10 - 200 );
	self.D.F4.D:SetTextColor( Color( 255, 255, 255, 255 ) );
	self.D.F4.D:PerformLayout();
	
	self.D.F4.P = vgui.Create( "DLabel", self.D.F4 );
	self.D.F4.P:SetPos( 48 * 18, 48 );
	self.D.F4.P:SetFont( "Infected.SubTitle" );
	self.D.F4.P:SetText( "" );
	self.D.F4.P:SizeToContents();
	self.D.F4.P:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.F4.C1 = vgui.Create( "DButton", self.D.F4 ); -- this kind of sucks, todo: create table with string and doclick func and loop create.
	self.D.F4.C1:SetPos( x, 12 );
	self.D.F4.C1:SetFont( "Infected.FrameTitle" );
	self.D.F4.C1:SetText( "Primary" );
	self.D.F4.C1:SizeToContents();
	self.D.F4.C1.DoClick = function()
	
		GAMEMODE.category = CATEGORY_PRIMARYWEAPON;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C1:GetWide() + 4;
	
	self.D.F4.C2 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C2:SetPos( x, 12 );
	self.D.F4.C2:SetFont( "Infected.FrameTitle" );
	self.D.F4.C2:SetText( "Secondary" );
	self.D.F4.C2:SizeToContents();
	self.D.F4.C2.DoClick = function()
	
		GAMEMODE.category = CATEGORY_SECONDARYWEAPON;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C2:GetWide() + 4;
	
	self.D.F4.C3 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C3:SetPos( x, 12 );
	self.D.F4.C3:SetFont( "Infected.FrameTitle" );
	self.D.F4.C3:SetText( "Ammo" );
	self.D.F4.C3:SizeToContents();
	self.D.F4.C3.DoClick = function()
	
		GAMEMODE.category = CATEGORY_AMMO;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C3:GetWide() + 4;
	
	self.D.F4.C4 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C4:SetPos( x, 12 );
	self.D.F4.C4:SetFont( "Infected.FrameTitle" );
	self.D.F4.C4:SetText( "Clothing" );
	self.D.F4.C4:SizeToContents();
	self.D.F4.C4.DoClick = function()
	
		GAMEMODE.category = CATEGORY_CLOTHING;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C4:GetWide() + 4;
	
	self.D.F4.C5 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C5:SetPos( x, 12 );
	self.D.F4.C5:SetFont( "Infected.FrameTitle" );
	self.D.F4.C5:SetText( "Armor" );
	self.D.F4.C5:SizeToContents();
	self.D.F4.C5.DoClick = function()
	
		GAMEMODE.category = CATEGORY_ARMOR;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C5:GetWide() + 4;
	
	self.D.F4.C7 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C7:SetPos( x, 12 );
	self.D.F4.C7:SetFont( "Infected.FrameTitle" );
	self.D.F4.C7:SetText( "Medical" );
	self.D.F4.C7:SizeToContents();
	self.D.F4.C7.DoClick = function()
	
		GAMEMODE.category = CATEGORY_MEDICAL;
		self:RefreshTrader();
	
	end
	
	x = x + self.D.F4.C7:GetWide() + 4;
	
	self.D.F4.C8 = vgui.Create( "DButton", self.D.F4 );
	self.D.F4.C8:SetPos( x, 12 );
	self.D.F4.C8:SetFont( "Infected.FrameTitle" );
	self.D.F4.C8:SetText( "Misc." );
	self.D.F4.C8:SizeToContents();
	self.D.F4.C8.DoClick = function()
	
		GAMEMODE.category = CATEGORY_MISC;
		self:RefreshTrader();
	
	end
	
	self:RefreshTrader();
	
end

function GM:RefreshTrader()

	if( self.D.F4.Slots ) then
	
		for j = 1, 40 do
		
			for i = 1, 10 do
			
				self.D.F4.Slots[j][i]:Remove();
				self.D.F4.Slots[j][i] = nil;
			
			end
			
		end
		
	end
	
	if( self.BuyItemPanels ) then
	
		for _,v in pairs( self.BuyItemPanels ) do
		
			v:Remove();
			self.BuyItemPanels[_] = nil;
			
		end
		
	end

	if( self.D.F4.InvSlots ) then
	
		for j = 1, 40 do
		
			for i = 1, 10 do
			
				self.D.F4.InvSlots[j][i]:Remove();
				self.D.F4.InvSlots[j][i] = nil;
			
			end
			
		end
		
	end
	
	if( self.TraderItemPanels ) then
	
		for _,v in pairs( self.TraderItemPanels ) do
		
			v:Remove();
			self.TraderItemPanels[_] = nil;
			
		end
		
	end
	
	if( self.D.F4.T ) then
		
		self.D.F4.T:SetText( "" );
		self.D.F4.T:SizeToContents();
		
	end
	
	if( self.D.F4.D ) then
		
		self.D.F4.D:SetText( "" );
		self.D.F4.D:PerformLayout();
	
	end
	
	if( self.D.F4.P ) then
		
		self.D.F4.P:SetText( "" );
		self.D.F4.P:SizeToContents();
		
	end

	local x,y = 1,1;
	slotsoccupiedraw = {};
	buyPositions = {};
	self.BuyItemPanels = { };
	self.D.F4.Slots = { };
	
	for j = 1, 40 do
		
		self.D.F4.Slots[j] = { };
		
		for i = 1, 10 do
			
			self.D.F4.Slots[j][i] = vgui.Create( "IInventorySquare", self.D.F4.Scroll );
			self.D.F4.Slots[j][i]:SetPos( ( i - 1 ) * 48, ( j - 1 ) * 48 );
			self.D.F4.Slots[j][i]:SetSize( 48, 48 );
			self.D.F4.Slots[j][i].OnMousePressed = function()
			
				for k,v in pairs( self.BuyItemPanels ) do
				
					v.Selected = false;
					
				end
				
				for k,v in pairs( self.TraderItemPanels ) do
				
					v.Selected = false;
					
				end
				
				if( self.D.F4.T ) then
					
					self.D.F4.T:SetText( "" );
					self.D.F4.T:SizeToContents();
					
				end
				
				if( self.D.F4.D ) then
					
					self.D.F4.D:SetText( "" );
					self.D.F4.D:PerformLayout();
				
				end
				
				if( self.D.F4.P ) then
					
					self.D.F4.P:SetText( "" );
					self.D.F4.P:SizeToContents();
					
				end
				
				self:RefreshTraderItemButtons();
				
			end
			
			self.D.F4.Slots[j][i].ItemX = i;
			self.D.F4.Slots[j][i].ItemY = j;
		
		end
		
	end
	
 	for class, metaitem in pairs( GAMEMODE.MetaItems ) do
	
		if( table.HasValue( GAMEMODE.TraderMenuBlacklist, class ) ) then continue end;
		if( metaitem.Category != self.category ) then continue end;
		
		local y,x = FindSlot( metaitem );

		buyPositions[class] = { ["x"] = x, ["y"] = y };
		
	end
	
	for k,v in pairs( buyPositions ) do
	
		local item = vgui.Create( "IItem", self.D.F4.Scroll );
		item:SetPos( ( v.x - 1 ) * 48, ( v.y - 1 ) * 48 );
		item:SetSize( GAMEMODE:GetMetaItem( k ).W * 48, GAMEMODE:GetMetaItem( k ).H * 48 );
		item.Item = GAMEMODE:GetMetaItem( k );
		item:SetModel( GAMEMODE:GetMetaItem( k ).Model );
		item.Click = function( itemdata, metaitem )
		
			for k,v in pairs( self.BuyItemPanels ) do
			
				v.Selected = false;
				
			end
			
			for k,v in pairs( self.TraderItemPanels ) do
			
				v.Selected = false;
				
			end
			
			if( self.D.F4.T ) then
				
				self.D.F4.T:SetText( metaitem.Name );
				self.D.F4.T:SizeToContents();
				
			end
			
			if( self.D.F4.D ) then
				
				self.D.F4.D:SetText( metaitem.Desc );
				self.D.F4.D:PerformLayout();
			
			end
			
			if( self.D.F4.P ) then
				
				self.D.F4.P:SetText( Format( "Price: %d", metaitem.BasePrice ) );
				self.D.F4.P:SizeToContents();
				
			end
		
			item.Selected = true;
			
			self:RefreshTraderItemButtons();
		
		end
		if( GAMEMODE:GetMetaItem( k ).DropSkin ) then
		
			item:SetSkin( GAMEMODE:GetMetaItem( k ).DropSkin );
			
		end
		
		self.BuyItemPanels[#self.BuyItemPanels + 1] = item;
		
	end
	
	traderPositions = { };
	slotsoccupiedraw = {};
	self.TraderItemPanels = { };
	self.D.F4.InvSlots = { };
	
	for j = 1, 40 do
		
		self.D.F4.InvSlots[j] = { };
		
		for i = 1, 10 do
			
			self.D.F4.InvSlots[j][i] = vgui.Create( "IInventorySquare", self.D.F4.InvScroll );
			self.D.F4.InvSlots[j][i]:SetPos( ( i - 1 ) * 48, ( j - 1 ) * 48 );
			self.D.F4.InvSlots[j][i]:SetSize( 48, 48 );
			self.D.F4.InvSlots[j][i].OnMousePressed = function()
			
				for k,v in pairs( self.BuyItemPanels ) do
				
					v.Selected = false;
					
				end
				
				for k,v in pairs( self.TraderItemPanels ) do
				
					v.Selected = false;
					
				end
				
				if( self.D.F4.T ) then
					
					self.D.F4.T:SetText( "" );
					self.D.F4.T:SizeToContents();
					
				end
				
				if( self.D.F4.D ) then
					
					self.D.F4.D:SetText( "" );
					self.D.F4.D:PerformLayout();
				
				end
				
				if( self.D.F4.P ) then
					
					self.D.F4.P:SetText( "" );
					self.D.F4.P:SizeToContents();
					
				end
				
				self:RefreshTraderItemButtons();
				
			end
			
			self.D.F4.InvSlots[j][i].ItemX = i;
			self.D.F4.InvSlots[j][i].ItemY = j;
		
		end
		
	end
	
 	for key, item in pairs( LocalPlayer().Inventory ) do
		
		local metaitem = GAMEMODE:GetMetaItem( item.Class );
		local y,x = FindSlot( metaitem );
		
		if( !item.inTraderInv ) then continue end;

		traderPositions[item.Key] = { ["x"] = x, ["y"] = y, ["item"] = item };
		
	end
	
	for k,v in pairs( traderPositions ) do
	
		local item = vgui.Create( "IItem", self.D.F4.InvScroll );
		item:SetPos( ( v.x - 1 ) * 48, ( v.y - 1 ) * 48 );
		item:SetSize( GAMEMODE:GetMetaItem( v.item.Class ).W * 48, GAMEMODE:GetMetaItem( v.item.Class ).H * 48 );
		item.Item = v.item; -- since this is an actual item, we need its individual data
		item:SetModel( GAMEMODE:GetMetaItem( v.item.Class ).Model );
		item.Click = function( itemdata, metaitem )
		
			metaitem = GAMEMODE:GetMetaItem( v.item.Class );
		
			for k,v in pairs( self.BuyItemPanels ) do
			
				v.Selected = false;
				
			end
			
			for k,v in pairs( self.TraderItemPanels ) do
			
				v.Selected = false;
				
			end
			
			if( self.D.F4.T ) then
				
				self.D.F4.T:SetText( metaitem.Name );
				self.D.F4.T:SizeToContents();
				
			end
			
			if( self.D.F4.D ) then
				
				self.D.F4.D:SetText( metaitem.Desc );
				self.D.F4.D:PerformLayout();
			
			end
			
			if( self.D.F4.P ) then
				
				self.D.F4.P:SetText( Format( "Price: %d", metaitem.BasePrice ) );
				self.D.F4.P:SizeToContents();
				
			end
		
			item.Selected = true;
			
			self:RefreshTraderItemButtons();
		
		end
		if( GAMEMODE:GetMetaItem( v.item.Class ).DropSkin ) then
		
			item:SetSkin( GAMEMODE:GetMetaItem( v.item.Class ).DropSkin );
			
		end
		
		self.TraderItemPanels[#self.TraderItemPanels + 1] = item;
		
	end

end

function GM:RefreshTraderItemButtons()

	if( self.D.F4.MoveToInventory ) then
		
		self.D.F4.MoveToInventory:Remove();
		
	end
	
	if ( self.D.F4.Sell ) then
	
		self.D.F4.Sell:Remove();
	
	end
	
	if ( self.D.F4.Buy ) then
	
		self.D.F4.Buy:Remove();
	
	end
	
	local panel = self:GetSelectedTraderItem();

	if( panel ) then
		
		local item = panel.Item;
		local metaitem = self:GetMetaItem( item.Class );
		
		local y = ( 48 * 6 ) + 50;
		
		if( item.inTraderInv ) then
		
			self.D.F4.MoveToInventory = vgui.Create( "DButton", self.D.F4 );
			self.D.F4.MoveToInventory:SetPos( 518, y );
			self.D.F4.MoveToInventory:SetSize( 200, 30 );
			self.D.F4.MoveToInventory:SetFont( "Infected.TinyTitle" );
			self.D.F4.MoveToInventory:SetText( "Move To Inventory" );
			function self.D.F4.MoveToInventory:DoClick()

				net.Start( "nMoveToInventory" );
					net.WriteFloat( item.Key );
				net.SendToServer();
			
			end
			
			y = y - 30;
		
			self.D.F4.Sell = vgui.Create( "DButton", self.D.F4 );
			self.D.F4.Sell:SetPos( 518, y );
			self.D.F4.Sell:SetSize( 200, 30 );
			self.D.F4.Sell:SetFont( "Infected.TinyTitle" );
			self.D.F4.Sell:SetText( "Sell" );
			function self.D.F4.Sell:DoClick()
			
				net.Start( "nSellItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				
				table.remove( LocalPlayer().Inventory, key );
				
				GAMEMODE:RefreshTrader();
				GAMEMODE:RefreshTraderItemButtons();
			
			end
		
			y = y - 30;
			
		end
		
		if( !item.inTraderInv ) then
			
			self.D.F4.Buy = vgui.Create( "DButton", self.D.F4 );
			self.D.F4.Buy:SetPos( 518, y );
			self.D.F4.Buy:SetSize( 200, 30 );
			self.D.F4.Buy:SetFont( "Infected.TinyTitle" );
			self.D.F4.Buy:SetText( "Buy" );
			function self.D.F4.Buy:DoClick()

				net.Start( "nBuyItem" );
					net.WriteString( item.Class );
				net.SendToServer();
				
				GAMEMODE:RefreshTrader();
			
			end
			
		end
		
	end

end

function GM:GetSelectedTraderItem()

	for k,v in pairs( self.TraderItemPanels ) do
	
		if( v.Selected ) then
		
			return v;
			
		end
		
	end
	
	for k,v in pairs( self.BuyItemPanels ) do
	
		if( v.Selected ) then
		
			return v;
			
		end
		
	end
	
end

function GM:KeyPress( ply, key )
	
	if( key == IN_RELOAD and !self.D.ReloadMenu ) then
		
		if( ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon().ItemAmmo ) then
			
			local ammo = ply:GetItemsOfType( ply:GetActiveWeapon().ItemAmmo );
			local wep = ply:GetActiveWeapon();
			
			if( #ammo > 0 ) then
				
				self.D.ReloadMenu = vgui.Create( "IInventoryBack" );
				self.D.ReloadMenu:SetSize( 48, 48 * #ammo );
				self.D.ReloadMenu:SetPos( ScrW() - 58, ScrH() - 200 - ( 48 * #ammo ) );
				self.D.ReloadMenu:MakePopup();
				
				local y = 48 * #ammo - 48;
				
				input.SetCursorPos( ScrW() - 58 + 24, ScrH() - 200 - 48 + 24 );
				
				for _, v in pairs( ammo ) do
					
					local item = ply.Inventory[v];
					local metaitem = self:GetMetaItem( item.Class );
					
					local but = vgui.Create( "IItem", self.D.ReloadMenu );
					but:SetPos( 0, y );
					but:SetSize( metaitem.W * 48, metaitem.H * 48 );
					but.Item = item;
					but.ShowAmmo = true;
					but:SetModel( metaitem.Model );
					function but:Click( item, metaitem )
						
						if( !wep or !wep:IsValid() ) then return end
						
						wep:ReloadItem( item, metaitem );
						
						net.Start( "nReload" );
							net.WriteFloat( item.Key );
						net.SendToServer();
						
						self:GetParent():Remove();
						
					end
					
					y = y - 48;
					
				end
				
			end
			
		end
		
	end
	
end

function GM:KeyRelease( ply, key )
	
	if( key == IN_RELOAD ) then
		
		if( ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon().ItemAmmo ) then
			
			if( self.D.ReloadMenu ) then
				
				self.D.ReloadMenu:Remove();
				self.D.ReloadMenu = nil;
				
			end
			
		end
		
	end
	
end