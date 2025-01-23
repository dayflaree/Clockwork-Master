surface.CreateFont( "Infected.MainTitle", {
	font = "BebasNeue",
	size = 100,
	weight = 500,
	antialias = true } );

surface.CreateFont( "Infected.MediumTitle", {
	font = "BebasNeue",
	size = 50,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.SubTitle", {
	font = "BebasNeue",
	size = 30,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.TinyTitle", {
	font = "Monofonto",
	size = 20,
	weight = 300,
	antialias = true } );
	
surface.CreateFont( "Infected.FrameTitle", {
	font = "Monofonto",
	size = 24,
	weight = 300,
	antialias = true } );
	
surface.CreateFont( "Infected.BigButton", {
	font = "Monofonto",
	size = 100,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.SmallButton", {
	font = "Monofonto",
	size = 20,
	weight = 500,
	antialias = true } );
	
	surface.CreateFont( "Infected.MainMenuButton", {
	font = "Monofonto",
	size = 30,
	weight = 500,
	shadow = true,
	antialias = true } );

surface.CreateFont( "Infected.LabelLarge", {
	font = "Myriad Pro",
	size = 30,
	weight = 500,
	antialias = true } );

surface.CreateFont( "Infected.LabelSmall", {
	font = "Myriad Pro",
	size = 20,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.LabelSmaller", {
	font = "Myriad Pro",
	size = 16,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.PlayerName", {
	font = "BebasNeue",
	size = 30,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.PlayerNameSmall", {
	font = "BebasNeue",
	size = 20,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.AmmoClip", {
	font = "BebasNeue",
	size = 70,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.AmmoCount", {
	font = "BebasNeue",
	size = 50,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatSmall", {
	font = "Myriad Pro",
	size = 14,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatNormal", {
	font = "Monofonto",
	size = 18,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatNormalI", {
	font = "Monofonto",
	size = 18,
	weight = 500,
	antialias = true,
	italic = true } );
	
surface.CreateFont( "Infected.ChatBig", {
	font = "Myriad Pro",
	size = 26,
	weight = 500,
	antialias = true } );

function GM:HUDShouldDraw( str )
	
	if( str == "CHudWeaponSelection" ) then return false end
	if( str == "CHudAmmo" ) then return false end
	if( str == "CHudAmmoSecondary" ) then return false end
	if( str == "CHudSecondaryAmmo" ) then return false end
	if( str == "CHudHealth" ) then return false end
	if( str == "CHudBattery" ) then return false end
	if( str == "CHudChat" ) then return false end
	if( str == "CHudDamageIndicator" ) then return false end
	--if( str == "CHudMenu" ) then return false end
	
	if( str == "CHudCrosshair" ) then
		
		local wep = LocalPlayer():GetActiveWeapon();
		
		if( wep and wep:IsValid() and wep != NULL ) then
			
			if( wep:GetClass() == "gmod_tool" or wep:GetClass() == "weapon_physgun" or wep:GetClass() == "weapon_physcannon" ) then
				
				return true
				
			end
			
		end
		
		return false;
		
	end
	
	return true
	
end

function GM:AddNotify() end

function GM:CalcView( ply, pos, ang, fov, znear, zfar )
	
	local ct = ( math.sin( CurTime() / 10 ) + 1 ) / 2;
	
	if( self.IntroMode == 1 and self.MainIntroCams ) then
		
		local cp = LerpVector( ct, self.MainIntroCams[1][1], self.MainIntroCams[2][1] );
		local ca = LerpAngle( ct, self.MainIntroCams[1][2], self.MainIntroCams[2][2] );
		
		return { origin = cp, angles = ca, fov = fov };
		
	end
	
	return self.BaseClass:CalcView( ply, pos, ang, fov, znear, zfar );
	
end

function draw.DrawDiagonals( col, x, y, w, h, density )
	
	surface.SetDrawColor( col );
	
	for i = 0, w + h, density do
		
		if( i < h ) then
			
			surface.DrawLine( x + i, y, x, y + i );
			
		elseif( i > w ) then
			
			surface.DrawLine( x + w, y + i - w, x - h + i, y + h );
			
		else
			
			surface.DrawLine( x + i, y, x + i - h, y + h );
			
		end
		
	end
	
end

function draw.DrawProgressBar( perc, x, y, w, h, col )
	
	perc = math.Clamp( perc, 0, 1 );
	
	draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 150 ) );
	draw.RoundedBox( 0, x + 2, y + 2, ( w - 4 ) * perc, h - 4, col );
	draw.DrawDiagonals( Color( col.r * 0.8, col.g * 0.8, col.b * 0.8, col.a ), x + 2, y + 2, w - 4, h - 4, 4 );
	
end

local matBlurScreen = Material( "pp/blurscreen" );

function draw.DrawBackgroundBlur( frac )
	
	if( frac == 0 ) then return end
	
	DisableClipping( true );
	
	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 );
	
	for i = 1, 3 do
		
		matBlurScreen:SetFloat( "$blur", frac * 5 * ( i / 3 ) )
		matBlurScreen:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	DisableClipping( false );

end

function draw.DrawBlur( x, y, w, h, us, vs, ue, ve, frac )
	
	if( frac == 0 ) then return end
	
	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 );
	
	for i = 1, 3 do
		
		matBlurScreen:SetFloat( "$blur", frac * 5 * ( i / 3 ) )
		matBlurScreen:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRectUV( x, y, w, h, us, vs, ue, ve );
		
	end

end

function draw.DrawTextShadow( text, font, x, y, color, color2, mode )
	
	draw.DrawText( text, font, x, y, color2, mode );
	draw.DrawText( text, font, x + 1, y + 1, color, mode );
	
end

GM.LogoBigMat = Material( "fallout/vgui/main_title.png" );
GM.MenuBGMat = Material( "fallout/vgui/main_background.png", "unlitgeneric mips" );

function GM:HUDPaintIntro()
	
	if( !self.IntroMode ) then self.IntroMode = 1 end
	if( !self.StartFadeIntro ) then self.StartFadeIntro = nil; end
	if( !self.IntroFadeStart ) then
		
		self.IntroFadeStart = CurTime();
		self:PlaySong( self.Music.Menus[1] );
		
	end
	
	if( self.IntroMode == 1 ) then
		
		surface.SetMaterial( self.MenuBGMat );
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
		
		DrawToyTown( 3, 0.4 );
		
		local as = math.Clamp( CurTime() - self.IntroFadeStart - 2, 0, 1 );
		
		local w = self.LogoBigMat:Width();
		local h = self.LogoBigMat:Height();
		
		local ratio = h / w;
		
		local lw = ScrW() * 0.55;
		local lh = lw * ratio;
		
		surface.SetMaterial( self.LogoBigMat );
		surface.SetDrawColor( Color( 255, 255, 255, 255 * as ) )
		surface.DrawTexturedRect( ScrW() * 0.3 - lw / 2, ScrH() * 0.525 - lh / 2, lw / 1.5, lh / 1.5 );
		
		if( self.StartFadeIntro ) then
			
			local d = CurTime() - self.StartFadeIntro;
			local a = math.Clamp( d, 0, 1 );
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 * a ) );
			surface.DrawRect( 0, 0, ScrW(), ScrH() );
			
			if( d > 4 ) then
				
				if( cookie.GetNumber( "inf_introlines", 0 ) == 0 ) then
					
					self.IntroMode = 2;
					cookie.Set( "inf_introlines", 1 );
					
				else
					
					self.IntroMode = 3;
					
				end
				
				self.StartFadeIntro = CurTime();
				
			end
			
		end
		
		if (!self.MainMenuButtons and as == 1 and self.charactersRecieved) then
			surface.PlaySound( "fallout/ui/ui_popup_messagewindow.wav" )
			
			self.MainMenuButtons = {}

			self.MainMenuButtons.Continue = vgui.Create( "DButton" )
			self.MainMenuButtons.Continue:SetSize( ScrW() / 4.4, 40 )
			self.MainMenuButtons.Continue:SetPos( ScrW() * 0.75, ScrH() * 0.33 )
			self.MainMenuButtons.Continue:SetFont( "Infected.MainMenuButton" )
			self.MainMenuButtons.Continue:SetText( "Continue" )
			self.MainMenuButtons.Continue:SetContentAlignment( 6 )
			self.MainMenuButtons.Continue:MakePopup( true )
			self.MainMenuButtons.Continue:SetDisabled( true )
			if (LocalPlayer():CharID() > -1) then
				self.MainMenuButtons.Continue:SetDisabled( false )
			end
			self.MainMenuButtons.Continue.DoClick = function()
			
				if (GAMEMODE.CharSelectButtons) then
				
					for _, v in pairs( GAMEMODE.CharSelectButtons ) do
						
						if( v != self ) then
							
							v:Remove();
							
						end
						
					end
					GAMEMODE.CharSelectButtons = nil;
					GAMEMODE.D.CP:Remove();
					GAMEMODE.D.CP = nil;
				end
				
				GAMEMODE.StartFadeIntro = CurTime();
				GAMEMODE.IntroMode = 5;
				
				GAMEMODE.CharCreateMode = nil;
				
				for k,v in pairs(GAMEMODE.MainMenuButtons) do
					v:Remove()
				end
				
				if (GAMEMODE.CurrentSongEnd) then
					GAMEMODE:StopSong(2)
				end
				
				if( GAMEMODE.D.CancelBut ) then
					
					GAMEMODE.D.CancelBut:Remove();
					
				end
			
			end
			
			self.MainMenuButtons.New = vgui.Create( "DButton" )
			self.MainMenuButtons.New:SetSize( ScrW() / 4.4, 40 )
			self.MainMenuButtons.New:SetPos( ScrW() * 0.75, ScrH() * 0.33 + 44 )
			self.MainMenuButtons.New:SetFont( "Infected.MainMenuButton" )
			self.MainMenuButtons.New:SetText( "New" )
			self.MainMenuButtons.New:SetContentAlignment( 6 )
			self.MainMenuButtons.New:MakePopup( true )
			self.MainMenuButtons.New.DoClick = function( panel, w, h )
			
				GAMEMODE.IntroMode = 4;
			
				if( LocalPlayer():CharCreateFlags() == "" ) then
				
					GAMEMODE:CharCreate( CHARCREATE_SURVIVOR );
					
				else
				
					GAMEMODE:CharCreateSelectClass();
					
				end
				
				for k,v in pairs(self.MainMenuButtons) do
				
					v:Remove()
					
				end
				if (GAMEMODE.CharSelectButtons) then
				
					GAMEMODE.D.CP:RemoveAllChildren();
					GAMEMODE.D.CP:Remove();
					GAMEMODE.D.CP = nil;
					for k,v in pairs(GAMEMODE.CharSelectButtons) do
					
						v:Remove()
						
					end
					
					GAMEMODE.CharSelectButtons = nil;
				end
				
			end
			if( #GAMEMODE.CharData[LocalPlayer():SteamID()] >= GAMEMODE.MaxChars ) then
			
				self.MainMenuButtons.New:SetDisabled( true );
			
			end
			
			self.MainMenuButtons.Load = vgui.Create( "DButton" )
			self.MainMenuButtons.Load:SetSize( ScrW() / 4.4, 40 )
			self.MainMenuButtons.Load:SetPos( ScrW() * 0.75, ScrH() * 0.33 + 88 )
			self.MainMenuButtons.Load:SetFont( "Infected.MainMenuButton" )
			self.MainMenuButtons.Load:SetText( "Load" )
			self.MainMenuButtons.Load:SetContentAlignment( 6 )
			self.MainMenuButtons.Load:MakePopup( true )
			self.MainMenuButtons.Load.DoClick = function()
				GAMEMODE:CharCreateSelect()
			end
			if (#(GAMEMODE.CharData[LocalPlayer():SteamID()] or {}) == 0) then
				self.MainMenuButtons.Load:SetDisabled( true )
			end
			
			self.MainMenuButtons.Quit = vgui.Create( "DButton" )
			self.MainMenuButtons.Quit:SetSize( ScrW() / 4.4, 40 )
			self.MainMenuButtons.Quit:SetPos( ScrW() * 0.75, ScrH() * 0.33 + 132 )
			self.MainMenuButtons.Quit:SetFont( "Infected.MainMenuButton" )
			self.MainMenuButtons.Quit:SetText( "Quit" )
			self.MainMenuButtons.Quit:SetContentAlignment( 6 )
			self.MainMenuButtons.Quit:MakePopup( true )
			self.MainMenuButtons.Quit.DoClick = function()
				RunConsoleCommand("disconnect")
			end
			
		end
		
	elseif( self.IntroMode == 2 ) then
		
		self.IntroMode = 1
		
	elseif( self.IntroMode == 3 ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		if( a == 0 ) then
			
			self.IntroMode = 4;
			
		end
		
	elseif( self.IntroMode == 4 ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	elseif( self.IntroMode == 5 ) then
		
		local d = CurTime() - self.StartFadeIntro;
		local a = 1 - math.Clamp( d, 0, 1 );
		local ba = 1 - math.Clamp( d, 0, 3 ) / 3;
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 * a ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		draw.DrawBackgroundBlur( ba );
		
		if( ba == 0 ) then
			
			self.IntroMode = 6;
			
		end
		
	end
	
end

function GM:HUDPaintCharCreate()
	
	if( self.CharCreateMode == CHARCREATE_SELECT ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
		surface.DrawRect( ScrW() / 2.6, 0, ScrW() / 3.2, ScrH() );
		
	elseif( self.CharCreateMode == CHARCREATE_DELETE ) then
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who's finished?" );
		
	elseif( self.CharCreateMode == CHARCREATE_SELECTCLASS ) then
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "What are you?" );
		
	elseif( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		local a = 1;
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 10 );
		surface.DrawText( "Sex" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 40 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 90 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 500 );
		surface.DrawText( "Race" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 540 );
		surface.DrawText( "Face" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 580 );
		surface.DrawText( "Eyes" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 620 );
		surface.DrawText( "Clothes" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 655 ); -- this will fail for resolutions under 1280x720
		surface.DrawText( "Hair" );
		
		if( self.CharCreateSex == MALE ) then
			surface.SetTextPos( ScrW() / 2 + 20, 690 ); -- this will fail for resolutions under 1280x720
			surface.DrawText( "Facial Hair" );
		end
		
	elseif( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
		
		local a = 1;
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 10 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 40 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 450 );
		surface.DrawText( "Model" );
		
	elseif( self.CharCreateMode == CHARCREATE_ANIMAL ) then
		
		local a = 1;
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 * a ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 120 );
		surface.DrawText( "Sex" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 160 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 200 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 610 );
		surface.DrawText( "Face" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 650 );
		surface.DrawText( "Clothes" );

	end
	
	if( self.CharCreateMode and self.CharCreateMode >= CHARCREATE_SURVIVOR ) then
		
		if( GAMEMODE.CharCreateBadStart and CurTime() - GAMEMODE.CharCreateBadStart < 10 ) then
			
			local w, h = surface.GetTextSize( GAMEMODE.CharCreateBad );
			
			local ba = 0;
			
			if( CurTime() - GAMEMODE.CharCreateBadStart < 1 ) then
				
				ba = CurTime() - GAMEMODE.CharCreateBadStart;
				
			elseif( CurTime() - GAMEMODE.CharCreateBadStart < 9 ) then
				
				ba = 1;
				
			else
				
				ba = math.Clamp( 1 - ( CurTime() - GAMEMODE.CharCreateBadStart - 9 ), 0, 1 );
				
			end
			
			surface.SetTextColor( Color( 255, 255, 255, 255 * ba ) );
			
			surface.SetTextPos( ScrW() - 80 - w - 10, ScrH() - 55 );
			surface.DrawText( GAMEMODE.CharCreateBad );
			
		end
		
	end
	
end

GM.HUDFlies = { };

function GM:HUDPaintOthers()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != LocalPlayer() ) then
			
			if( !v.HUDA ) then v.HUDA = 0 end
			
			local pos = v:EyePos();
			local ts = ( pos + Vector( 0, 0, 16 ) ):ToScreen();
			
			if( self.SeeAll or (
				pos:Distance( LocalPlayer():EyePos() ) < 768 and
				LocalPlayer():CanSeePlayer( v ) and
				LocalPlayer():GetEyeTraceNoCursor().Entity == v and
				!v:GetNoDraw() and
				v:Alive() ) ) then
				
				v.HUDA = math.Approach( v.HUDA, 1, FrameTime() );
				
			else
				
				v.HUDA = math.Approach( v.HUDA, 0, FrameTime() );
				
			end
			
			if( v.HUDA > 0 ) then
				
				//draw.DrawText( v:RPName(), "Infected.PlayerName", ts.x, ts.y, Color( 252, 178, 69, 255 * v.HUDA ), 1 );
				draw.DrawTextShadow( v:RPName(), "Infected.PlayerName", ts.x, ts.y,  Color( 252, 178, 69, 255 * v.HUDA ), Color( 0, 0, 0, 255 * v.HUDA ), 1 );
				ts.y = ts.y + 20
				
				local lines, maxW = util.wrapText( v:Desc(), 512, "Infected.ChatNormal" )
				
				for key,line in pairs( lines ) do
				
					if ( key < 3 ) then
					
						//draw.DrawText( line, "Infected.ChatNormal", ts.x, ts.y, Color( 252, 178, 69, 255 * v.HUDA ), 1 );
						draw.DrawTextShadow( line, "Infected.ChatNormal", ts.x, ts.y,  Color( 252, 178, 69, 255 * v.HUDA ), Color( 0, 0, 0, 255 * v.HUDA ), 1 );
						ts.y = ts.y + 16;
						
					else
					
						//draw.DrawText( "...", "Infected.ChatNormal", ts.x, ts.y, Color( 252, 178, 69, 255 * v.HUDA ), 1 );
						draw.DrawTextShadow( "...", "Infected.ChatNormal", ts.x, ts.y,  Color( 252, 178, 69, 255 * v.HUDA ), Color( 0, 0, 0, 255 * v.HUDA ), 1 );
						break;
						
					end
					
				end
				
				if( v:Typing() > 0 ) then
				
					ts.y = ts.y - 48 - ( math.Clamp( #lines, 0, 3 ) * 16 )
					//draw.DrawText( "Typing...", "Infected.PlayerNameSmall", ts.x, ts.y, Color( 252, 178, 69, 255 * v.HUDA ), 1 );
					draw.DrawTextShadow( "Typing...", "Infected.PlayerNameSmall", ts.x, ts.y,  Color( 252, 178, 69, 255 * v.HUDA ), Color( 0, 0, 0, 255 * v.HUDA ), 1 );
					
				end
				
			end
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "inf_item" ) ) do
		
		if( !v.HUDA ) then v.HUDA = 0 end
		
		local a, b = v:GetRotatedAABB( v:OBBMins(), v:OBBMaxs() );
		local pos = v:GetPos() + ( a + b ) / 2;
		local ts = pos:ToScreen();
		
		if( self.SeeAll or ( pos:Distance( LocalPlayer():EyePos() ) < 256 and self:CanSeePos( LocalPlayer():EyePos(), pos, { LocalPlayer(), v } ) ) ) then
			
			v.HUDA = math.Approach( v.HUDA, 1, FrameTime() );
			
		else
			
			v.HUDA = math.Approach( v.HUDA, 0, FrameTime() );
			
		end
		
		if( v.HUDA > 0 ) then
			
			local metaitem = self:GetMetaItem( v:GetItemClass() );
			
			if( metaitem ) then
				
				local col = Color( 255, 255, 255, 255 * v.HUDA );
				if( self.SeeAll ) then
					col = Color( 0, 200, 255, 255 * v.HUDA );
				end
				
				draw.DrawText( metaitem.Name, "Infected.PlayerName", ts.x, ts.y, col, 1 );
				
				if( self.SeeAll and v:GetAutospawn() ) then
					
					draw.DrawText( math.ceil( ( v:GetAutospawnTime() + 600 ) - CurTime() ) .. "s", "Infected.PlayerNameSmall", ts.x, ts.y + 20, Color( 100, 255, 100, 255 * v.HUDA ), 1 );
					
				end
				
			end
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "prop_physics" ) ) do
		
		if( !v.HUDA ) then v.HUDA = 0 end
		
		local a, b = v:GetRotatedAABB( v:OBBMins(), v:OBBMaxs() );
		local pos = v:GetPos() + ( a + b ) / 2;
		local ts = pos:ToScreen();
		
		if( self.SeeAll or (
			pos:Distance( LocalPlayer():EyePos() ) < 256 and
			LocalPlayer():CanSeePlayer( v ) and
			LocalPlayer():GetEyeTraceNoCursor().Entity == v and
			!v:GetNoDraw() ) ) then
			
			v.HUDA = math.Approach( v.HUDA, 1, FrameTime() );
			
		else
			
			v.HUDA = math.Approach( v.HUDA, 0, FrameTime() );
			
		end
		
		if( v.HUDA > 0 ) then
				
			local col = Color( 255, 255, 255, 255 * v.HUDA );
			if( self.SeeAll ) then
				col = Color( 0, 200, 255, 255 * v.HUDA );
			end
			
			local lines, maxW = util.wrapText( v:GetNWString( "desc", "" ), 256, "Infected.ChatNormal" )
			
			for key,line in pairs( lines ) do
				
				draw.DrawText( line, "Infected.ChatNormal", ts.x, ts.y, Color( 255, 255, 255, 255 * v.HUDA ), 1 );
				ts.y = ts.y + 16;
				
			end
			
		end
		
	end
	
end

function GM:HUDPaintHealth()
	
 	if( !PercHealth ) then PercHealth = 1; end
	if( !PercArmor ) then PercArmor = 0; end
	if( !PercStamina ) then PercStamina = 1; end
	
	PercHealth = math.Approach( PercHealth, LocalPlayer():Health() / 100, FrameTime() );
	PercArmor = math.Approach( PercArmor, LocalPlayer():Armor() / 100, FrameTime() );
	PercStamina = math.Approach( PercStamina, PercStamina, FrameTime() );
	
	local barh = 14;
	local y = ScrH() - 20 - barh;
	
	if( PercHealth < 1 ) then
		draw.DrawProgressBar( PercHealth, 20, y, 200, barh, Color( 170, 0, 0, 255 ) );
		y = y - 10 - barh;
	end
	
	if( PercArmor > 0 ) then
		draw.DrawProgressBar( PercArmor, 20, y, 200, barh, Color( 170, 170, 170, 255 ) );
		y = y - 10 - barh;
	end
	
	if( PercStamina < 1 ) then
		draw.DrawProgressBar( PercStamina, 20, y, 200, barh, Color( 170, 170, 0, 255 ) );
		y = y - 10 - barh;
	end
	
end

function GM:HUDPaintWeapon()
 	
	if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() ) then
		
		local wep = LocalPlayer():GetActiveWeapon();
		
		surface.SetFont( "Infected.SubTitle" );
		local w, h = surface.GetTextSize( wep:GetPrintName() );
		
		draw.RoundedBox( 0, ScrW() - w - 10, ScrH() - 10 - h, w, h, Color( 0, 0, 0, 200 ) );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetTextPos( ScrW() - w - 10, ScrH() - 10 - h );
		surface.DrawText( wep:GetPrintName() );
		
		
		
		if( LocalPlayer():Holstered() ) then
			
			
			
		else
			
			if( wep:Clip1() > -1 ) then
				
				surface.SetFont( "Infected.AmmoClip" );
				local w, h = surface.GetTextSize( wep:Clip1() );
				
				local x = ScrW() - 10 - w;
				
				draw.RoundedBox( 0, x, ScrH() - 50 - h, w, h, Color( 0, 0, 0, 200 ) );
				
				surface.SetTextPos( x, ScrH() - 50 - h );
				surface.DrawText( wep:Clip1() );
				
			end
			
		end
		
	end
	
end

function GM:HUDPaintDeath()
	
	if( !LocalPlayer():Alive() and LocalPlayer():CharID() > -1 ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		surface.SetFont( "Infected.MainTitle" );
		local text = "Rest In Peace";
		
		local tw, th = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() / 2 - tw / 2, ScrH() / 2 - th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.DrawText( text );
		
		surface.SetFont( "Infected.SubTitle" );
		local text = "You have died.";
		
		local tw2, th2 = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() / 2 - tw2 / 2, ScrH() / 2 + th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.DrawText( text );
		
		if( !self.deathMusicPlaying ) then
		
			self.deathMusicPlayed = true;
			surface.PlaySound( self.Music.Menus[3][1] );
			
		end
	end
	
end

function GM:HUDPaintDebug()

	if( !GAMEMODE.NotifyLines ) then return end;

	local HUDA = HUDA or 0;
	local h = h or 0;
	
	for _,line in pairs( GAMEMODE.NotifyLines ) do
		
		surface.SetFont( line[4] );
		tw,th = surface.GetTextSize( line[5] );
	
		if ((line[3] + line[2]) >= CurTime()) then
			
			HUDA = math.Approach( HUDA, 1, FrameTime() );
			
		else
		
			HUDA = math.Approach( HUDA, 0, FrameTime() );
			h = h - th;
			GAMEMODE.NotifyLines[_] = nil;
			
		end

		if( HUDA > 0 ) then
		
			draw.DrawText( line[5], line[4], ( ScrW() / 2 ), h + th, Color( line[1].r, line[1].g, line[1].b, 255 ), 1 );
			h = h + th;
			
		end

	end
	
end

local function drawHealthBar(entity)
	local plyHp = entity:Health();
	local maxHp = entity:GetMaxHealth();
	local vecOrigin = entity:GetPos();
	local vecMins = vecOrigin;
	local vecMaxs = Vector(0, 0, entity:OBBMaxs().z) + vecOrigin;

	vecMins.z = vecMins.z - 4;
	vecMaxs.z = vecMaxs.z + 8;
	
	local vScreenTop, vScreenBottom;
	vScreenTop = vecMaxs:ToScreen();
	vScreenBottom = vecMins:ToScreen();

	iH = vScreenBottom.y - vScreenTop.y;
	iW = (iH) / 1.75;
	iX = vScreenBottom.x;
	iY = vScreenBottom.y;
	
	if plyHp > maxHp then
		plyHp = maxHp;
	else 
		plyHp = plyHp;
	end
	
	local sPos = plyHp * iH / maxHp;
	local hDelta = iH - sPos;

	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(iX - iW / 2 - 5, iY - iH - 1, 3, iH + 2)
	surface.SetDrawColor((maxHp - plyHp) * 2.55, plyHp * 2.55, 0)
	surface.DrawRect(iX - iW / 2 - 4, iY - iH + hDelta, 1, sPos)
end

local function drawBoundingBox(entity, color)
	local vecOrigin = entity:GetPos();
	local vecMins = vecOrigin;
	local vecMaxs = Vector(0, 0, entity:OBBMaxs().z) + vecOrigin;

	vecMins.z = vecMins.z - 4;
	vecMaxs.z = vecMaxs.z + 8;
	
	local vScreenTop, vScreenBottom;
	vScreenTop = vecMaxs:ToScreen();
	vScreenBottom = vecMins:ToScreen();

	iH = vScreenBottom.y - vScreenTop.y;
	iW = (iH) / 1.75;
	iX = vScreenBottom.x;
	iY = vScreenBottom.y;

	surface.SetDrawColor(color);
	surface.DrawOutlinedRect(iX - iW / 2, iY - iH, iW, iH);
	surface.SetDrawColor(0,0,0,255);
	surface.DrawOutlinedRect(iX - iW / 2 + 1, iY - iH + 1, iW - 2, iH - 2);
	surface.DrawOutlinedRect(iX - iW / 2 - 1, iY - iH - 1, iW + 2, iH + 2);
end

function GM:HUDPaintAdminESP()
	if( LocalPlayer():IsAdmin() and LocalPlayer():IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
	
		for k,v in next, ents.GetAll() do
		
			if (v:IsPlayer() and (v != LocalPlayer())) then
			
				local color = Color(255,255,255,255);
				local pos = v:GetPos() - Vector(0, 0, 4);
				pos = pos:ToScreen();
				
				draw.DrawText(v:Nick(), "DebugFixed", pos.x, pos.y, color, 1);
				
				pos.y = pos.y + 8;
				if (v:RPName() != "...") then
					color = Color(0,255,0,255);
					draw.DrawText(v:RPName(), "DebugFixed", pos.x, pos.y, color, 1);
				end
				
				drawBoundingBox(v, Color(255,0,0,255));
				drawHealthBar(v);
				
			elseif (v:GetClass() == "inf_item") then
			
				local color = Color(255,255,0,255);
				local pos = v:GetPos() - Vector(0, 0, 4);
				pos = pos:ToScreen();
				
				draw.DrawText(GAMEMODE:GetMetaItem(v:GetItemClass()).Name or "ITEM", "DebugFixed", pos.x, pos.y, color, 1);
				
				drawBoundingBox(v, Color(0,0,255,255));
				
			end
			
		end
	
	end
	
end

function GM:HUDPaint()
	
	self:HUDPaintOthers();
	
	self:HUDPaintHealth();
	self:HUDPaintWeapon();
	self:HUDPaintChat();
	self:HUDPaintDeath();
	
	self:HUDPaintIntro();
	self:HUDPaintCharCreate();
	
	self:HUDPaintDebug();
	self:HUDPaintAdminESP();
	
end

function GM:RenderScreenspaceEffects()
	
	if( self.IntroMode == 1 ) then
		
		DrawToyTown( 5, ScrH() * 0.3 );
		
	end
	
end