GM.CharData = GM.CharData or { };

local function nLoadCharacters( len )
	
	local tab = net.ReadTable();

	GAMEMODE.CharData[LocalPlayer():SteamID()] = tab;
	
	for _, v in pairs( GAMEMODE.CharData[LocalPlayer():SteamID()] ) do
		
		util.PrecacheModel( v.Model );
		
	end
	
	GAMEMODE.charactersRecieved = true;
	
end
net.Receive( "nLoadCharacters", nLoadCharacters );

function GM:CharCreateResetModel()
	
	if( self.D.CP and self.D.CP:IsValid() ) then
		
		self.D.CP:SetModel( self.CharCreateModel );
		if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
			self.D.CP:ChildSetModel( self.D.CP.Face, self.CharCreateFace )
			self.D.CP.Face:ResetSubMaterials()
			self.D.CP:ChildSetModel( self.D.CP.Arms, self.CharCreateArms )
			if( self.D.CP.Hair ) then
			
				self.D.CP:ChildSetModel( self.D.CP.Hair, self.CharCreateHair )
				
			else
			
				self.D.CP:InitializeModel( self.CharCreateHair, self.D.CP.Entity, "hair" );
				
			end
			if( self.CharCreateSex == MALE) then
		
				if( self.D.CP.FacialHair ) then
				
					self.D.CP:ChildSetModel( self.D.CP.FacialHair, self.CharCreateFacialHair );
					
				else
				
					self.D.CP:InitializeModel( self.CharCreateFacialHair, self.D.CP.Entity, "facialhair" );
					
				end
				
			end
	
			self.D.CP:ChildSetSkin( self.D.CP.Arms, self.CharCreateArmsSkin )
			self.D.CP:ChildSetSubMaterial( self.D.CP.Face, self.D.CP.Face:GetFacemap(), self.CharCreateFacemap )
			
			for _,v in pairs( self.D.CP.Face:GetEyemap() ) do
			
				self.D.CP:ChildSetSubMaterial( self.D.CP.Face, v, self.CharCreateEyemap )
			
			end
			
		end
		
	end
	
end

function GM:CharCreateRandomModel()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateModel = table.Random( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ) );
		self.CharCreateFace = table.Random( self.SurvivorModels[self.CharCreateSex][self.CharCreateModel] );
		self.CharCreateFacemap = table.Random( self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace] );
		self.CharCreateHair = table.Random( self.SurvivorHair[self.CharCreateSex] );
		self.CharCreateEyemap = table.Random( self.Eyemaps );
		if (self.CharCreateSex == MALE) then
			self.CharCreateFacialHair = table.Random( self.SurvivorHair.FacialHair );
		end
		self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms( self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap );
		
		if (self.D.CP.Face) then
			self.D.CP:ChildRemove(self.D.CP.Face); // if you dont use this function to properly remove children of the panel you will break your shit.
			self.D.CP.Face = nil;
		end
		
		if (self.D.CP.Arms) then
			self.D.CP:ChildRemove(self.D.CP.Arms);
			self.D.CP.Arms = nil;
		end
		
		if (self.D.CP.Hair) then
			self.D.CP:ChildRemove(self.D.CP.Hair);
			self.D.CP.Hair = nil;
		end
		
		if (self.D.CP.FacialHair) then
			self.D.CP:ChildRemove(self.D.CP.FacialHair);
			self.D.CP.FacialHair = nil;
		end
		
		self.D.CP.Face = self.D.CP:InitializeModel( self.CharCreateFace, self.D.CP.Entity, "face" );
		self.D.CP.Arms = self.D.CP:InitializeModel( self.CharCreateArms, self.D.CP.Entity, "arms" );
		self.D.CP.Hair = self.D.CP:InitializeModel( self.CharCreateHair, self.D.CP.Face, "hair" );
		if (self.CharCreateSex == MALE) then
			self.D.CP.FacialHair = self.D.CP:InitializeModel( self.CharCreateFacialHair, self.D.CP.Face, "facialhair" );
		end
		
	elseif( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
		
		self.CharCreateModel = table.Random( self.SupermutantModels );
		self.CharCreateFace = "";
		self.CharCreateClothes = "";
		
	elseif( self.CharCreateMode == CHARCREATE_ANIMAL ) then
		
		self.CharCreateModel = table.Random( table.GetKeys( self.InfectedModels[self.CharCreateSex] ) );
		self.CharCreateFace = table.Random( self.InfectedModels[self.CharCreateSex][self.CharCreateModel] );
		self.CharCreateClothes = table.Random( self.InfectedClothes[self.CharCreateSex] );
		
	end
	
end

function GM:CharCreateNextEyemap()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.Eyemaps ) do
		
			if( v == self.CharCreateEyemap ) then
				
				if( self.Eyemaps[k + 1] ) then
					
					self.CharCreateEyemap = self.Eyemaps[k + 1];
					self:CharCreateResetModel();
					return;
					
				else
					
					self.CharCreateEyemap = self.Eyemaps[1];
					self:CharCreateResetModel();
					return;
					
				end
				
			end
			
		end
		
	end
	
end

function GM:CharCreatePrevEyemap()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.Eyemaps ) do
		
			if( v == self.CharCreateEyemap ) then
				
				if( self.Eyemaps[k - 1] ) then
					
					self.CharCreateEyemap = self.Eyemaps[k - 1];
					self:CharCreateResetModel();
					return;
					
				else
					
					self.CharCreateEyemap = self.Eyemaps[#self.Eyemaps];
					self:CharCreateResetModel();
					return;
					
				end
				
			end
			
		end
		
	end
	
end

function GM:CharCreateNextFacemap()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorFacemaps[self.CharCreateSex] ) do
			
			if( self.CharCreateFace == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFacemap ) then
						
						if( v[m + 1] ) then
							
							self.CharCreateFacemap = v[m + 1];
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][1];
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

function GM:CharCreatePrevFacemap()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorFacemaps[self.CharCreateSex] ) do
			
			if( self.CharCreateFace == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFacemap ) then
						
						if( v[m - 1] ) then
							
							self.CharCreateFacemap = v[m - 1];
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][#self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace]];
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
	end
	
end

function GM:CharCreateNextFace()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m + 1] ) then
							
							self.CharCreateFace = v[m + 1];
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][1]
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateFace = v[1];
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][1]
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

function GM:CharCreatePrevFace()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m - 1] ) then
							
							self.CharCreateFace = v[m - 1];
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][1]
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateFace = v[1];
							self.CharCreateFacemap = self.SurvivorFacemaps[self.CharCreateSex][self.CharCreateFace][1]
							self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end

	end
	
end

function GM:CharCreateNextClothes()
	
	if( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
		
		self.CharCreateModel = table.FindNext( self.SupermutantModels, self.CharCreateModel ); 
		self:CharCreateResetModel();
		
	else
		
		self.CharCreateModel = table.FindNext( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ), self.CharCreateModel );
		self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreatePrevClothes()
	
	if( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
		
		self.CharCreateModel = table.FindPrev( self.SupermutantModels, self.CharCreateModel );
		self:CharCreateResetModel();
		
	else
		
		self.CharCreateModel = table.FindPrev( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ), self.CharCreateModel );
		self.CharCreateArms, self.CharCreateArmsSkin = self:GetModelArms(self.CharCreateModel, self.CharCreateFace, self.CharCreateFacemap)
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreateNextHair()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateHair = table.FindNext( self.SurvivorHair[self.CharCreateSex], self.CharCreateHair );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreatePrevHair()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateHair = table.FindPrev( self.SurvivorHair[self.CharCreateSex], self.CharCreateHair );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreateNextFacialHair()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateFacialHair = table.FindNext( self.SurvivorHair.FacialHair, self.CharCreateFacialHair );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreatePrevFacialHair()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateFacialHair = table.FindPrev( self.SurvivorHair.FacialHair, self.CharCreateFacialHair );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreateThink()
	
	if( self.CharSelectButtons ) then
		
		local hovering = false;
		
		for _, v in pairs( self.CharSelectButtons ) do
			
			if( v.Hovered ) then
				
				hovering = true;
				
				local d = LocalPlayer():GetDataByCharID( v.id );
				
				if( GAMEMODE.D.CP.model != d.Model ) then
				
					GAMEMODE.D.CP.model = d.Model;
					GAMEMODE.D.CP:SetModel( d.Model );
					GAMEMODE.D.CP.Entity:ResetSubMaterials();
					
					if( d.Class != PLAYERCLASS_SURVIVOR ) then return end;
					
					local arms,armsSkin = GAMEMODE:GetModelArms( d.Model, d.Face );
					
					if( GAMEMODE.D.CP.Face ) then
					
						GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Face, d.Face );
						GAMEMODE.D.CP:ChildSetSubMaterial( GAMEMODE.D.CP.Face, GAMEMODE.D.CP.Face:GetFacemap(), d.Facemap );
						
						for _,v in pairs( GAMEMODE.D.CP.Face:GetEyemap() ) do
						
							GAMEMODE.D.CP:ChildSetSubMaterial( GAMEMODE.D.CP.Face, v, d.Eyemap );
						
						end
						
					else
					
						GAMEMODE.D.CP.Face = GAMEMODE.D.CP:InitializeModel( d.Face, self.D.CP.Entity, "face" );
						GAMEMODE.D.CP:ChildSetSubMaterial( GAMEMODE.D.CP.Face, GAMEMODE.D.CP.Face:GetFacemap(), d.Facemap );
						
						for _,v in pairs( GAMEMODE.D.CP.Face:GetEyemap() ) do
						
							GAMEMODE.D.CP:ChildSetSubMaterial( GAMEMODE.D.CP.Face, v, d.Eyemap );
						
						end
						
					end
					
					if( GAMEMODE.D.CP.Hair ) then
					
						GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Hair, d.Hair );
						GAMEMODE.D.CP.Hair:SetColor( string.ToColor( d.HairColor ) );
					else
					
						GAMEMODE.D.CP.Hair = GAMEMODE.D.CP:InitializeModel( d.Hair, GAMEMODE.D.CP.Face, "hair" );
						if( GAMEMODE.D.CP.Hair ) then -- if d.Hair is nil or "", the entity wont be created.
						
							GAMEMODE.D.CP:ChildSetColor( GAMEMODE.D.CP.Hair, string.ToColor( d.HairColor ) );
							
						end
						
					end
					
					if( GAMEMODE.D.CP.FacialHair ) then
					
						GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.FacialHair, d.FacialHair );
						GAMEMODE.D.CP.FacialHair:SetColor( string.ToColor( d.HairColor ) );
						
					else
					
						GAMEMODE.D.CP.FacialHair = GAMEMODE.D.CP:InitializeModel( d.FacialHair, GAMEMODE.D.CP.Face, "facialhair" );
						if( GAMEMODE.D.CP.FacialHair ) then -- if d.FacialHair is nil or "", the entity wont be created.
						
							GAMEMODE.D.CP:ChildSetColor( GAMEMODE.D.CP.FacialHair, string.ToColor( d.HairColor ) );
							
						end
						
					end
					
					if( GAMEMODE.D.CP.Arms ) then
					
						GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Arms, arms );
						GAMEMODE.D.CP:ChildSetSkin( GAMEMODE.D.CP.Arms, armsSkin );
						
					else
						
						GAMEMODE.D.CP.Arms = GAMEMODE.D.CP:InitializeModel( arms, GAMEMODE.D.CP.Entity, "arms" );
						GAMEMODE.D.CP:ChildSetSkin( GAMEMODE.D.CP.Arms, armsSkin );
						
					end
					
				end
				
			end
			
		end
		
		if( !hovering and ( GAMEMODE.D.CP.model != "" or !GAMEMODE.D.CP.model ) ) then
			
			GAMEMODE.D.CP:SetModel( "" );
			GAMEMODE.D.CP.model = "";
			
			if( GAMEMODE.D.CP.Face ) then
			
				GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Face, "" );
				GAMEMODE.D.CP.Face:ResetSubMaterials();
				
			end
			
			if( GAMEMODE.D.CP.Hair ) then
			
				GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Hair, "" );
				
			end
			
			if( GAMEMODE.D.CP.FacialHair ) then
			
				GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.FacialHair, "" );
				
			end
			
			if( GAMEMODE.D.CP.Arms ) then
			
				GAMEMODE.D.CP:ChildSetModel( GAMEMODE.D.CP.Arms, "" );
				
			end
			
		end
		
	end
	
end

function GM:CharCreateSelect()
	
	self.CharCreateMode = CHARCREATE_SELECT;
	self.CharCreateFade = CurTime();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( ScrW() / 2.7, 30 );
	self.D.CP:SetSize( ScrW() / 3.2, ScrH() / 2.16 );
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetAnimated(true)
	self.D.CP:SetCamPos( Vector( 50, 20, 63 ) );
	self.D.CP:SetLookAtEyes();
	self.D.CP:SetFOV( 15 );
	self.D.CP:SetModel( "" );
	
	local y = self.D.CP:GetTall() + 32;
	
	self.CharSelectButtons = { };
	
	for k, v in pairs( self.CharData[LocalPlayer():SteamID()] ) do
		
		surface.SetFont( "Infected.MainMenuButton" );
		local tw, th = surface.GetTextSize( v.Name );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( ScrW() / 2.45, y );
		b:SetSize( ScrW() / 3.7, th + 4 );
		b:SetText( v.Name );
		b:SetContentAlignment( 4 )
		b:SetFont( "Infected.MainMenuButton" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		b.id = v.id;
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharSelectButtons = nil;
			
			GAMEMODE.D.CP:RemoveAllChildren();
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			net.Start( "nSelectCharacter" );
				net.WriteFloat( self.id );
			net.SendToServer();
			
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
			
			self:Remove();
			
		end
		function b:DoRightClick()
		
			local pnl = self; -- can't pass the self object to our popup window.
		
			GAMEMODE:CreatePopupConfirm( "Are you sure?", "Do you want to delete this character?", function() 

				for _, v in pairs( GAMEMODE.CharSelectButtons ) do
					
					if( v != pnl ) then
						
						v:Remove();
						
					end
					
				end
				
				if( #GAMEMODE.CharData[LocalPlayer():SteamID()] - 1 <= 0 ) then
				
					GAMEMODE.MainMenuButtons.Load:SetDisabled( true );
					
				end
				
				GAMEMODE.CharSelectButtons = nil;
				
				GAMEMODE.D.CP:Remove();
				GAMEMODE.D.CP = nil;
				
				net.Start( "nDeleteCharacter" );
					net.WriteFloat( pnl.id );
				net.SendToServer();
				
				GAMEMODE.CharCreateMode = nil;
				
				if( GAMEMODE.D.CancelBut ) then
					
					GAMEMODE.D.CancelBut:Remove();
					
				end
				
				pnl:Remove();

			end, true )
		
		end
		b.TextButtonBackground = true;
		
		if( k == LocalPlayer():CharID() ) then
			
			b:SetDisabled( true );
			
		end
		
		table.insert( self.CharSelectButtons, b );
		
		y = y + b:GetTall() + 16;
		
	end
	
	self.CharSelectButtons[1]:MakePopup();
	
end

function GM:CharCreateSelectClass()
	
	self.CharCreateMode = CHARCREATE_SELECTCLASS;
	self.CharCreateFade = CurTime();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( ScrW() / 2, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	
	local y = 120;
	
	self.CharCreateSelectButtons = { };
	
	surface.SetFont( "Infected.MediumTitle" );
	local tw, th = surface.GetTextSize( "Survivor" );
	
	local b = vgui.Create( "DButton" );
	b:SetPos( 100, y );
	b:SetSize( tw, th );
	b:SetText( "Survivor" );
	b:SetFont( "Infected.MediumTitle" );
	b:SetDrawBackground( false );
	b:SetDrawBorder( false );
	function b:DoClick()
		
		for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
			
			if( v != self ) then
				
				v:Remove();
				
			end
			
		end
		
		GAMEMODE.CharCreateSelectButtons = nil;
		
		GAMEMODE.D.CP:Remove();
		GAMEMODE.D.CP = nil;
		
		if( GAMEMODE.D.CancelBut ) then
			
			GAMEMODE.D.CancelBut:Remove();
			
		end
		
		GAMEMODE:CharCreate( CHARCREATE_SURVIVOR );
		
		self:Remove();
		
	end
	b.TextButtonBackground = true;
	
	table.insert( self.CharCreateSelectButtons, b );
	
	y = y + 70;
	
	if( string.find( LocalPlayer():CharCreateFlags(), "m" ) ) then
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( "Supermutant" );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( "Supermutant" );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharCreateSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			GAMEMODE:CharCreate( CHARCREATE_SUPERMUTANT );
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		table.insert( self.CharCreateSelectButtons, b );
		
		y = y + 70;
		
	end
	
	if( string.find( LocalPlayer():CharCreateFlags(), "i" ) ) then
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( "Animal" );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( "Animal" );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharCreateSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			GAMEMODE:CharCreate( CHARCREATE_ANIMAL );
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		table.insert( self.CharCreateSelectButtons, b );
		
		y = y + 70;
		
	end
	
	y = y + 40;
	
	for _, v in pairs( self.CharCreateSelectButtons ) do
		
		v:MakePopup();
		
	end
	
end

local function CreateFacialHairSelect(self, y)

	self.D.CCP.C9 = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.C9:SetPos( 200, y );
	self.D.CCP.C9:SetSize( 30, 30 );
	self.D.CCP.C9:SetFont( "Infected.SubTitle" );
	self.D.CCP.C9:SetText( "<" );
	function self.D.CCP.C9:DoClick()
		
		GAMEMODE:CharCreatePrevFacialHair();
		
	end

	self.D.CCP.C10 = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.C10:SetPos( 240, y );
	self.D.CCP.C10:SetSize( 30, 30 );
	self.D.CCP.C10:SetFont( "Infected.SubTitle" );
	self.D.CCP.C10:SetText( ">" );
	function self.D.CCP.C10:DoClick()
		
		GAMEMODE:CharCreateNextFacialHair();
		
	end
	
end

function GM:CharCreate( mode )
	
	self.CharCreateMode = mode;
	self.CharCreateFade = CurTime();
	self.CharCreateSex = MALE;
	
	if( self.D.CCP ) then
		
		self.D.CCP:Remove();
		
	end
	
	if( self.D.CP ) then

		self.D.CP:Remove();
		
	end
	
	self.D.CCP = vgui.Create( "IClearPanel" );
	self.D.CCP:SetPos( ScrW() / 2, 10 );
	self.D.CCP:SetSize( ScrW() / 2, ScrH() );
	self.D.CCP:MakePopup();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( 0, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self:CharCreateRandomModel();
	self.D.CP:SetModel( "models/error.mdl" );
	self:CharCreateResetModel();
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	if( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
	
		self.D.CP:SetCamPos( Vector( -100,80,73 ) );
		self.D.CP:SetFOV( 60 );
		
	end
	self:CharCreateResetModel();
	self.D.CP.HeadFollowMouse = false;
	self.D.CP:LayoutEntity( self.D.CP.Entity );
	
	local y = 0;
	
	if( self.CharCreateMode != CHARCREATE_SUPERMUTANT and self.CharCreateMode != CHARCREATE_ANIMAL ) then
		
		self.D.CCP.M = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.M:SetPos( 200, y );
		self.D.CCP.M:SetSize( 100, 30 );
		self.D.CCP.M:SetFont( "Infected.SubTitle" );
		self.D.CCP.M:SetText( "Male" );
		self.D.CCP.M:SetSelected( true );
		function self.D.CCP.M:DoClick()
			
			self:SetSelected( true );
			GAMEMODE.D.CCP.F:SetSelected( false );
			
			if( GAMEMODE.CharCreateSex == FEMALE ) then
				
				GAMEMODE.CharCreateSex = MALE;
				CreateFacialHairSelect(GAMEMODE, y);
				GAMEMODE:CharCreateRandomModel();
				GAMEMODE:CharCreateResetModel();
				
			end
			
		end
		
		self.D.CCP.F = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.F:SetPos( 310, y );
		self.D.CCP.F:SetSize( 100, 30 );
		self.D.CCP.F:SetFont( "Infected.SubTitle" );
		self.D.CCP.F:SetText( "Female" );
		function self.D.CCP.F:DoClick()
			
			self:SetSelected( true );
			GAMEMODE.D.CCP.M:SetSelected( false );
			
			if( GAMEMODE.CharCreateSex == MALE ) then
				
				GAMEMODE.CharCreateSex = FEMALE;
				GAMEMODE.D.CCP.C9:Remove();
				GAMEMODE.D.CCP.C10:Remove();
				GAMEMODE:CharCreateRandomModel();
				GAMEMODE:CharCreateResetModel();
				
			end
			
		end
		
		y = y + 40;
		
	end
	
	self.D.CCP.NE = vgui.Create( "DTextEntry", self.D.CCP );
	self.D.CCP.NE:SetPos( 200, y );
	self.D.CCP.NE:SetSize( 300, 30 );
	self.D.CCP.NE:SetFont( "Infected.LabelLarge" );
	self.D.CCP.NE:SetTextColor( Color( 0, 0, 0, 255 ) );
	
	y = y + 40;
	
	self.D.CCP.DE = vgui.Create( "DTextEntry", self.D.CCP );
	self.D.CCP.DE:SetPos( 200, y );
	self.D.CCP.DE:SetSize( ScrW() / 2 - 200 - 100, 400 );
	self.D.CCP.DE:SetFont( "Infected.LabelLarge" );
	self.D.CCP.DE:SetTextColor( Color( 0, 0, 0, 255 ) );
	self.D.CCP.DE:SetMultiline( true );
	
	y = y + 410;
	
	if( self.CharCreateMode == CHARCREATE_SUPERMUTANT ) then
	
		self.D.CCP.C1 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C1:SetPos( 200, y );
		self.D.CCP.C1:SetSize( 30, 30 );
		self.D.CCP.C1:SetFont( "Infected.SubTitle" );
		self.D.CCP.C1:SetText( "<" );
		function self.D.CCP.C1:DoClick()
			
			GAMEMODE:CharCreatePrevClothes();
			
		end
		
		self.D.CCP.C2 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C2:SetPos( 240, y );
		self.D.CCP.C2:SetSize( 30, 30 );
		self.D.CCP.C2:SetFont( "Infected.SubTitle" );
		self.D.CCP.C2:SetText( ">" );
		function self.D.CCP.C2:DoClick()
			
			GAMEMODE:CharCreateNextClothes();
			
		end
		
		y = y + 40;
		
	end
	
	if( self.CharCreateMode != CHARCREATE_SUPERMUTANT and self.CharCreateMode != CHARCREATE_ANIMAL ) then
	
		self.D.CCP.F1 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.F1:SetPos( 200, y );
		self.D.CCP.F1:SetSize( 30, 30 );
		self.D.CCP.F1:SetFont( "Infected.SubTitle" );
		self.D.CCP.F1:SetText( "<" );
		function self.D.CCP.F1:DoClick()
			
			GAMEMODE:CharCreatePrevFace();
			
		end
		
		self.D.CCP.F2 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.F2:SetPos( 240, y );
		self.D.CCP.F2:SetSize( 30, 30 );
		self.D.CCP.F2:SetFont( "Infected.SubTitle" );
		self.D.CCP.F2:SetText( ">" );
		function self.D.CCP.F2:DoClick()
			
			GAMEMODE:CharCreateNextFace();
			
		end
		
		y = y + 40;
	
		self.D.CCP.C1 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C1:SetPos( 200, y );
		self.D.CCP.C1:SetSize( 30, 30 );
		self.D.CCP.C1:SetFont( "Infected.SubTitle" );
		self.D.CCP.C1:SetText( "<" );
		function self.D.CCP.C1:DoClick()
			
			GAMEMODE:CharCreatePrevFacemap();
			
		end
		
		self.D.CCP.C2 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C2:SetPos( 240, y );
		self.D.CCP.C2:SetSize( 30, 30 );
		self.D.CCP.C2:SetFont( "Infected.SubTitle" );
		self.D.CCP.C2:SetText( ">" );
		function self.D.CCP.C2:DoClick()
			
			GAMEMODE:CharCreateNextFacemap();
			
		end
		
		y = y + 40;
		
		
		self.D.CCP.C3 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C3:SetPos( 200, y );
		self.D.CCP.C3:SetSize( 30, 30 );
		self.D.CCP.C3:SetFont( "Infected.SubTitle" );
		self.D.CCP.C3:SetText( "<" );
		function self.D.CCP.C3:DoClick()
			
			GAMEMODE:CharCreatePrevEyemap();
			
		end
		
		self.D.CCP.C4 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C4:SetPos( 240, y );
		self.D.CCP.C4:SetSize( 30, 30 );
		self.D.CCP.C4:SetFont( "Infected.SubTitle" );
		self.D.CCP.C4:SetText( ">" );
		function self.D.CCP.C4:DoClick()
			
			GAMEMODE:CharCreateNextEyemap();
			
		end
		
		y = y + 40;
		
		self.D.CCP.C5 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C5:SetPos( 200, y );
		self.D.CCP.C5:SetSize( 30, 30 );
		self.D.CCP.C5:SetFont( "Infected.SubTitle" );
		self.D.CCP.C5:SetText( "<" );
		function self.D.CCP.C5:DoClick()
			
			GAMEMODE:CharCreatePrevClothes();
			
		end
		
		self.D.CCP.C6 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C6:SetPos( 240, y );
		self.D.CCP.C6:SetSize( 30, 30 );
		self.D.CCP.C6:SetFont( "Infected.SubTitle" );
		self.D.CCP.C6:SetText( ">" );
		function self.D.CCP.C6:DoClick()
			
			GAMEMODE:CharCreateNextClothes();
			
		end
		
		y = y + 35;
		
		self.D.CCP.C7 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C7:SetPos( 200, y );
		self.D.CCP.C7:SetSize( 30, 30 );
		self.D.CCP.C7:SetFont( "Infected.SubTitle" );
		self.D.CCP.C7:SetText( "<" );
		function self.D.CCP.C7:DoClick()
			
			GAMEMODE:CharCreatePrevHair();
			
		end
	
		self.D.CCP.C8 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C8:SetPos( 240, y );
		self.D.CCP.C8:SetSize( 30, 30 );
		self.D.CCP.C8:SetFont( "Infected.SubTitle" );
		self.D.CCP.C8:SetText( ">" );
		function self.D.CCP.C8:DoClick()
			
			GAMEMODE:CharCreateNextHair();
			
		end
		
		y = y + 35
		
		if( GAMEMODE.CharCreateSex == MALE ) then
		
			self.D.CCP.C9 = vgui.Create( "DButton", self.D.CCP );
			self.D.CCP.C9:SetPos( 200, y );
			self.D.CCP.C9:SetSize( 30, 30 );
			self.D.CCP.C9:SetFont( "Infected.SubTitle" );
			self.D.CCP.C9:SetText( "<" );
			function self.D.CCP.C9:DoClick()
				
				GAMEMODE:CharCreatePrevFacialHair();
				
			end
		
			self.D.CCP.C10 = vgui.Create( "DButton", self.D.CCP );
			self.D.CCP.C10:SetPos( 240, y );
			self.D.CCP.C10:SetSize( 30, 30 );
			self.D.CCP.C10:SetFont( "Infected.SubTitle" );
			self.D.CCP.C10:SetText( ">" );
			function self.D.CCP.C10:DoClick()
				
				GAMEMODE:CharCreateNextFacialHair();
				
			end
		
		end
		
		self.D.CCP.Mixer = vgui.Create( "DColorMixer", self.D.CCP )
		self.D.CCP.Mixer:SetSize( 200, 200 )
		self.D.CCP.Mixer:SetPos( 320, 490 );
		self.D.CCP.Mixer:SetAlphaBar( false )
		self.D.CCP.Mixer:SetPalette( true )
		self.D.CCP.Mixer:SetWangs( true )
		self.D.CCP.Mixer:SetColor( Color( 30, 100, 160 ) )
		self.D.CCP.Mixer.ValueChanged = function()

			if( GAMEMODE.D.CP.Hair ) then
			
				GAMEMODE.D.CP.Hair:SetColor( self.D.CCP.Mixer:GetColor() );
				
			end
			
			if( GAMEMODE.D.CP.FacialHair ) then
			
				GAMEMODE.D.CP.FacialHair:SetColor( self.D.CCP.Mixer:GetColor() );
				
			end
		
		end
		
	end
	
	if( LocalPlayer():CharID() > -1 ) then
		
		self.D.CCP.Cancel = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.Cancel:SetPos( ScrW() / 2 - 100, ScrH() - 70 - 60 );
		self.D.CCP.Cancel:SetSize( 80, 40 );
		self.D.CCP.Cancel:SetFont( "Infected.SubTitle" );
		self.D.CCP.Cancel:SetText( "Cancel" );
		function self.D.CCP.Cancel:DoClick()
			
			GAMEMODE.D.CCP:Remove();
			GAMEMODE.D.CCP = nil;
			
			GAMEMODE.D.CP:RemoveAllChildren();
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
		end
		
	end
	
	self.D.CCP.Done = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.Done:SetPos( ScrW() / 2 - 80, ScrH() - 70 );
	self.D.CCP.Done:SetSize( 60, 40 );
	self.D.CCP.Done:SetFont( "Infected.SubTitle" );
	self.D.CCP.Done:SetText( "Done" );
	function self.D.CCP.Done:DoClick()
		
		local class = PLAYERCLASS_SURVIVOR;
		
		if( mode == CHARCREATE_SUPERMUTANT ) then class = PLAYERCLASS_SUPERMUTANT end
		if( mode == CHARCREATE_ANIMAL ) then class = PLAYERCLASS_ANIMAL end
		
		local name = GAMEMODE.D.CCP.NE:GetValue();
		local desc = GAMEMODE.D.CCP.DE:GetValue();
		local model = GAMEMODE.CharCreateModel;
		local sex,face,facemap,eyemap,arms,armsSkin,hair,facialhair;
		local ret,reason;
		
		if( mode == CHARCREATE_SURVIVOR ) then
		
			sex = GAMEMODE.CharCreateSex;
			face = GAMEMODE.CharCreateFace;
			facemap = GAMEMODE.CharCreateFacemap;
			arms = GAMEMODE.CharCreateArms;
			armsSkin = GAMEMODE.CharCreateArmsSkin;
			hair = GAMEMODE.CharCreateHair;
			facialhair = GAMEMODE.CharCreateFacialHair;
			eyemap = GAMEMODE.CharCreateEyemap;
			ret, reason = GAMEMODE:CheckValidCharacter( LocalPlayer(), class, name, desc, model, sex, face, facemap, hair, facialhair );
		
		elseif( mode == CHARCREATE_SUPERMUTANT ) then
		
			ret, reason = GAMEMODE:CheckValidCharacter( LocalPlayer(), class, name, desc, model );
		
		end
		
		if( !ret ) then
			
			GAMEMODE.CharCreateBad = reason;
			GAMEMODE.CharCreateBadStart = CurTime();
			
		else
			
			net.Start( "nCreateCharacter" );
				net.WriteFloat( class );
				net.WriteString( name );
				net.WriteString( desc );
				net.WriteString( model );
				if( mode == CHARCREATE_SURVIVOR ) then
				
					net.WriteFloat( sex );
					net.WriteString( face );
					net.WriteString( facemap );
					net.WriteString( eyemap );
					net.WriteString( hair );
					net.WriteString( string.FromColor( GAMEMODE.D.CCP.Mixer:GetColor() ) );
					if( GAMEMODE.CharCreateFacialHair and GAMEMODE.CharCreateSex == MALE ) then
					
						net.WriteString( facialhair );
						
					else
					
						net.WriteString( "" );
						
					end
					
				end
			net.SendToServer();
			
			GAMEMODE.D.CCP:Remove();
			GAMEMODE.D.CCP = nil;

			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
			if (GAMEMODE.CurrentSongEnd) then
				GAMEMODE:StopSong(2)
			end
			
			surface.PlaySound( "fallout/music/mus_exitthevault.ogg" )
		end
		
	end
	
end