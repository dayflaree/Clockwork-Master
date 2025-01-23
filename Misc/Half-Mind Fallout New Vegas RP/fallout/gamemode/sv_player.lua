local meta = FindMetaTable( "Player" );

function GM:PlayerInitialSpawn( ply )
	
	ply:SetTeam( TEAM_SURVIVOR );
	
	if( !ply:IsBot() ) then
		
		ply:Freeze( true );
		
	end
	
end

function GM:PlayerSpray( ply )

	return true

end

--[[ hook.Add( "PrePACConfigApply", "CheckPACFlag", function( ply, outfit_data )

 	if( !ply:HasPAC() ) then
	
		print("pac access denied")
	
		return false, "You don't have PAC access!";
		
	end
	
end ) ]]

function GM:PlayerSpawn( ply )

	ply:SyncOtherPlayers();

 	for _,v in pairs( player.GetAll() ) do
	
		if( v == ply ) then continue end
		if( v:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then continue end
		
		local equippedBonemerge = {};
		
		if( v.Inventory ) then
			
			for m,n in pairs( v.Inventory ) do
			
				if( n.Equipped and n.Headgear ) then
				
					equippedBonemerge[#equippedBonemerge + 1] = n.Class;
					
				end
				
			end
		
			net.Start( "nCharacterUpdateModel" );
				net.WriteEntity( v );
				net.WriteString( v:GetModel() );
				net.WriteTable( equippedBonemerge )
			net.Send( ply );
			
		end
	
	end
	
	player_manager.SetPlayerClass( ply, "player_infected" );
	
	ply:SetDuckSpeed( 0.3 );
	ply:SetUnDuckSpeed( 0.3 );
	
	self:SetPlayerSpeed( ply, 100, 200 );
	
	if( ply:PlayerClass() == PLAYERCLASS_SUPERMUTANT ) then
	
		self:SetPlayerSpeed( ply, 80, 300 );
	
	end
	
	ply:GodDisable();
	ply:SetNoTarget( false );
	ply:SetNoDraw( false );
	ply:SetNotSolid( false );
	
	ply:SetAllowWeaponsInVehicle( true );
	
	ply:SetupHands();
	
	if( !ply.InitialSafeSpawn ) then
		
		ply.InitialSafeSpawn = true;
		self:PlayerInitialSpawnSafe( ply );
		
	end
	
	if( ply:IsBot() ) then
		
		local m = math.random( 0, 1 ) == 0;
		local g = m and MALE or FEMALE;
		
		if( g == MALE ) then
			
			ply:SetRPName( "John Doe" );
			ply:SetDesc( "This bot is in over his head." );
			
		else
			
			ply:SetRPName( "Jane Doe" );
			ply:SetDesc( "This bot is in over her head." );
			
		end
		
		ply:SetModel( table.Random( table.GetKeys( GAMEMODE.SurvivorModels[g] ) ) );

		return;
		
	end
	
	if( ply:CharID() > -1 ) then
		
		ply:ResetSubMaterials();
		
		local data = ply:GetDataByCharID( ply:CharID() );
		
		if( data.LastPos != "0 0 0" and data.LastPos != "" ) then
	
			local vec = string.Explode( " ", data.LastPos )
			ply:SetPos( Vector( vec[1], vec[2], vec[3] ) );
			
		else
		
			ply:SetPos( GAMEMODE:GetFactionSpawnPos( data.Class ) );
		
		end
			
		
		hook.Call( "PlayerSetHandsModel", self, ply, ply:GetHands() );
		
		hook.Call( "PlayerLoadout", self, ply );
		
	end
	
end

function GM:PlayerInitialSpawnSafe( ply )
	
	if( ply:IsBot() ) then return end
	
	ply:SetNotSolid( true );
	ply:SetMoveType( MOVETYPE_NOCLIP );
	ply:SetNoDraw( true );
	
end

function GM:PlayerLoadout( ply )
	
	ply:Give( "weapon_inf_hands" );
	
	if( ply:PhysTrust() or ply:IsAdmin() ) then
		
		ply:Give( "weapon_physgun" );
		
	end
	
	if( ply:ToolTrust() or ply:IsAdmin() ) then
		
		ply:Give( "gmod_tool" );
		
	end
	
	if( ply:CheckInventory() ) then return end
	
	for _, v in pairs( ply.Inventory ) do
		
		if( v.Primary or v.Secondary ) then
			
			ply:Give( v.Class );
			
			local metaitem = GAMEMODE:GetMetaItem( v.Class );
			
			if( metaitem.PrimaryWep ) then
				
				ply:SetPrimaryWeaponModel( metaitem.Model );
				
			else
				
				ply:SetSecondaryWeaponModel( metaitem.Model );
				
			end
			
			if( v.Vars.Clip ) then
				
				ply:GetWeapon( v.Class ):SetClip1( v.Vars.Clip );
				
			end
			
		end
		
	end
	
end

function GM:PlayerDeathSound( ply )
	
	return true;
	
end

function GM:PlayerAuthed( ply, steamid, uid )
	
	ply:PreloadPlayer();
	
end

function GM:SetupPlayerVisibility( ply, viewent )
	
	if( self.MainIntroCams ) then
		
		AddOriginToPVS( self.MainIntroCams[1][1] );
		
	end
	
end

function GM:PlayerSwitchFlashlight( ply, on )
	
	if( !ply.LastFlashlight ) then ply.LastFlashlight = 0; end
	
	if( CurTime() - ply.LastFlashlight > 0.2 ) then
		
		ply.LastFlashlight = CurTime();
		return true;
		
	end
	
end

function GM:GetFallDamage( ply, speed )
	
	return self.BaseClass:GetFallDamage( ply, speed );
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmg )
	
	local attacker = dmg:GetAttacker();
	local inflictor = dmg:GetInflictor();
	
	if( hitgroup == HITGROUP_HEAD ) then
		
		dmg:ScaleDamage( 2 );
		
	end
	
	if( hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		hitgroup == HITGROUP_LEFTLEG or
		hitgroup == HITGROUP_RIGHTLEG or
		hitgroup == HITGROUP_GEAR ) then
		
		dmg:ScaleDamage( 0.25 );
		
	end
	
	if( attacker:IsPlayer() and inflictor:GetClass() != "weapon_inf_hands" ) then
		
		dmg:ScaleDamage( 0.25 );
		
	end
	
end

function GM:PlayerDisconnected( ply )
	
	ply:SetLastPos( tostring( ply:GetPos() ) ); -- probably dont need this, but better safe than sorry. TODO: update lastpos for switching characters
	ply:UpdateCharacterField( "LastPos", tostring( ply:GetPos() ) );
	ply:SaveWeaponClips(); -- No disconnecting to save ammo allowed
	
end

function meta:LoadPlayer( data )
	
	self:SetPhysTrust( tobool( data.PhysTrust ) );
	self:SetToolTrust( tobool( data.ToolTrust ) );
	self:SetCharCreateFlags( data.CharCreateFlags );
	self:SetHasPAC( tobool( data.HasPAC ) );
	self:SetPlayerTitle( data.PlayerTitle );
	self:SetPlayerTitleColor( data.PlayerTitleColor );
	self:SetAdmin( tobool( data.Admin ) );
	self:SetSuperAdmin( tobool( data.SuperAdmin ) );
	
	if( tobool( data.Admin ) ) then
	
		self:SetUserGroup( "admin" );
		
	elseif( tobool( data.SuperAdmin ) ) then
	
		self:SetUserGroup( "superadmin" );
	
	end
	
end

function meta:LoadCharacter( id )
	
	self:SetCharID( id );
	self:LoadCharacterData( self:GetDataByCharID( id ) );
	self:LoadItemData( self:GetItemDataByCharID( id ) );
	self:PostLoadCharacter();
	
end

function meta:LoadCharacterData( data )
	
	self:ResetSubMaterials();
	
	self:SetPlayerClass( data.Class );
	
	self:SetRPName( data.Name );
	self:SetDesc( data.Description );
	if( data.Class == PLAYERCLASS_SURVIVOR ) then
	
		self:SetSex( data.Sex );
		self:SetFace( data.Face );
		self:SetFacemap( data.Facemap );
		self:SetEyemap( data.Eyemap );
		self:SetHair( data.Hair );
		self:SetHairColor( data.HairColor );
		self:SetFacialHair( data.FacialHair );
		
	end
	self:SetLastPos( data.LastPos );
	self:SetIsTrader( tobool( data.IsTrader ) );
	self:SetTraderFlags( data.TraderFlags );
	
	local arms,skin = GAMEMODE:GetModelArms( data.Model, data.Face );
	
	self:SetModel( data.Model );
	
end

function meta:LoadItemData( data )
	
	self:CheckInventory();
	
	for _, v in pairs( self.Inventory ) do
		
		if( v.Primary or v.Secondary ) then
			
			self:StripWeapon( v.Class );
			
		end
		
	end
	
	self:SetPrimaryWeaponModel( "" );
	self:SetSecondaryWeaponModel( "" );
	
	self.Inventory = { };
	net.Start( "nClearInventory" );
	net.Send( self );
	
	GAMEMODE.ItemData[self:SteamID()][self:CharID()] = { };
	
	if( !data ) then return end
	
	for _, v in pairs( data ) do
		
		if( !v.Class ) then continue; end
		
		local item = GAMEMODE:Item( v.Class );
		local metaitem = GAMEMODE:GetMetaItem( v.Class );
		
		item.X = v.X;
		item.Y = v.Y;
		item.Owner = self;
		item.id = v.id;
		
		item.Primary = tobool( v.PrimaryEquipped );
		item.Secondary = tobool( v.SecondaryEquipped );
		item.inTraderInv = tobool( v.InTraderInventory );
		
		if( item.Clothing ) then
		
			item.Equipped = tobool( v.ClothingEquipped );
			
		elseif( item.Headgear ) then -- this sucks but i dont care
		
			item.Equipped = tobool( v.HeadgearEquipped );
			
		end
		
		if( !self.NextItemKey ) then self.NextItemKey = 1 end
		item.Key = self.NextItemKey;
		self.NextItemKey = self.NextItemKey + 1;
		
		for _, n in pairs( string.Explode( ";", v.Vars ) ) do
			
			local kv = string.Explode( "|", n );
			
			if( tonumber( kv[2] ) ) then
				
				item.Vars[kv[1]] = tonumber( kv[2] );
				
			else
				
				item.Vars[kv[1]] = kv[2];
				
			end
			
		end
		
		if( item.Primary or item.Secondary ) then
			
			self:Give( item.Class );
			
			if( item.Vars.Clip ) then
				
				self:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
				
			end
			
		end
		
		if( item.Equipped and item.Clothing ) then -- both of these for models and headgear is gay, i really should redo this net lib shit
		
			local mdlStr = GAMEMODE:GetModelGender( metaitem.PlayerModel, self:Sex() )
			local oldArms,oldSkin = GAMEMODE:GetModelArms( self:GetModel(), self:Face() );
			local newArms,newSkin = GAMEMODE:GetModelArms( mdlStr, self:Face() );
			
			if( metaitem.UseRealModelPath ) then

				mdlStr = metaitem.PlayerModel;
				newArms = metaitem.HandsPath;
				
			end
			
			self:SetModel( mdlStr );
			
			if( metaitem.Bodygroups ) then
			
				for _,v in pairs( metaitem.Bodygroups ) do
				
					self:SetBodygroup( v.a, v.b );
				
				end
				
			end
			
			if( metaitem.Skin ) then

				self:SetSkin( metaitem.Skin );
				
			end
			
			net.Start( "nReceiveDummyItem" );
				net.WriteEntity( self );
				net.WriteInt( item.id, 32 );
				net.WriteString( item.Class );
				net.WriteBool( item.Equipped );
			net.Broadcast();
		
		end
		
		if( item.Equipped and item.Headgear ) then

			net.Start( "nReceiveDummyItem" );
				net.WriteEntity( self );
				net.WriteInt( item.id, 32 );
				net.WriteString( item.Class );
				net.WriteBool( item.Equipped );
			net.Broadcast();
		
		end
		
		net.Start( "nGiveItem" );
			net.WriteTable( item );
		net.Send( self );
		
		self.Inventory[item.Key] = item;
		
	end
	
end

function meta:PostLoadCharacter()
	
	self:Freeze( false );
	
	self:SetNotSolid( false );
	self:SetMoveType( MOVETYPE_WALK );
	self:SetNoDraw( false );
	
	self:Spawn();
	
end

hook.Add( "PlayerUse", "CheckDoor", function( ply, ent )

	if( ent:GetClass() == "func_button" ) then
	
		if( ent:GetName() == "Bunker.Door_button" ) then
		
			if( ply:GetItemsOfType( "bunker_keycard" )[1] ) then
			
				for k,v in pairs( ents.FindByName( "Bunker.Door" ) ) do
				
					v:Fire("unlock")
					v:Fire("open")
					timer.Simple(13, function()
					
						v:Fire("close")
						v:Fire("lock")
					
					end)
					
				end
				
			end
			
		end
		
	end

end )

local function nCreateCharacter( len, ply )
	
	local class = net.ReadFloat();
	local name = net.ReadString();
	local desc = net.ReadString();
	local model = net.ReadString();
	local sex,face,facemap,eyemap,hair,haircolor,facialhair,ret,reason;
	if( class == PLAYERCLASS_SURVIVOR ) then
	
		sex = net.ReadFloat();
		face = net.ReadString();
		facemap = net.ReadString();
		eyemap = net.ReadString(); -- dont get lazy about this, checkvalidcharacter
		hair = net.ReadString();
		haircolor = net.ReadString();
		
		if (sex == MALE) then
		
			facialhair = net.ReadString();
			
		else
		
			facialhair = "";
			
		end
		
		ret, reason = GAMEMODE:CheckValidCharacter( ply, class, name, desc, model, sex, face, facemap, hair, facialhair );
		
	else
	
		ret, reason = GAMEMODE:CheckValidCharacter( ply, class, name, desc, model );
		
	end
	
	if( ret ) then
		
		if( class == PLAYERCLASS_SURVIVOR ) then
		
			ply:SaveNewCharacter( class, name, desc, sex, model, face, facemap, eyemap, hair, haircolor, facialhair );
			
		elseif( class == PLAYERCLASS_SUPERMUTANT ) then
		
			ply:SaveNewCharacter( class, name, desc, sex, model );
		
		end
		
	else
		
		MsgC( COLOR_ERROR, "ERROR: Could not create character (\"" .. reason .. "\").\n" );
		
	end
	
end
net.Receive( "nCreateCharacter", nCreateCharacter );

local function nSelectCharacter( len, ply )
	
	local id = net.ReadFloat();
	ply:LoadCharacter( id );
	
end
net.Receive( "nSelectCharacter", nSelectCharacter );

local function nDeleteCharacter( len, ply )
	
	local id = net.ReadFloat();
	ply:DeleteCharacter( id );
	
end
net.Receive( "nDeleteCharacter", nDeleteCharacter );

local function nChangeName( len, ply )
	
	local name = net.ReadString();
	
	if( string.len( name ) >= GAMEMODE.MinNameLength and string.len( name ) <= GAMEMODE.MaxNameLength ) then
		
		ply:SetRPName( name );
		ply:UpdateCharacterField( "Name", name );
		
	end
	
end
net.Receive( "nChangeName", nChangeName );

local function nChangeDesc( len, ply )
	
	local desc = net.ReadString();
	
	if( string.len( desc ) <= GAMEMODE.MaxDescLength ) then
		
		ply:SetDesc( desc );
		ply:UpdateCharacterField( "Description", desc );
		
	end
	
end
net.Receive( "nChangeDesc", nChangeDesc );

local function nChangePropDesc( len, ply )
	
	local desc = net.ReadString();
	local ent = ply:GetEyeTraceNoCursor().Entity;
	
	if( ent:GetClass() != "prop_physics" or ent:GetClass() != "prop_ragdoll" ) then return end
	
	if( string.len( desc ) <= 199 ) then
		
		ent:SetNWString( "desc", desc );
		
	end
	
end
net.Receive( "nChangePropDesc", nChangePropDesc );

local function nSetTyping( len, ply )
	
	local f = math.floor( net.ReadFloat() );
	
	if( f < 0 or f > 2 ) then return end
	
	ply:SetTyping( f );
	
end
net.Receive( "nSetTyping", nSetTyping );

local function nStartCharacterSync( len, ply )

	ply:SyncOtherPlayers();

end
net.Receive( "nStartCharacterSync", nStartCharacterSync );

local function nCharacterRemoveAllMdl( len, ply ) -- while these are defined on the client, this allows us multiple use cases.

	local targ = net.ReadEntity();

	net.Start( "nCharacterRemoveAllMdl" );
		net.WriteEntity( targ );
	net.Send( ply );

end
net.Receive( "nCharacterRemoveAllMdl", nCharacterRemoveAllMdl );

local function nCharacterUpdateModel( len, ply )

	local targ = net.ReadEntity();
	local equipped = {};
	
	if( !targ.Inventory ) then return end;
	
	for k,v in pairs( targ.Inventory ) do -- you know instead of having the send all this data, we should just network what is equipped. but i dont have time
	
		if( v.Equipped and v.Headgear ) then
		
			equipped[#equipped + 1] = v.Class;
			
		end
	
	end

	net.Start( "nCharacterUpdateModel" );
		net.WriteEntity( targ );
		net.WriteString( targ:GetModel() );
		net.WriteTable( equipped );
	net.Send( ply );

end
net.Receive( "nCharacterUpdateModel", nCharacterUpdateModel );