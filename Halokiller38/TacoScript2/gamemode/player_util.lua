local meta = FindMetaTable( "Player" );

--We have stat tables, so instead of calculating new strength or speed in real time,  
--we have a pre-calculated table.  Saves some CPU cycles.
TS.WalkSpeedTable = { }
TS.RunSpeedTable = { }
TS.DuckSpeedTable = { }
TS.SprintDegradeTable = { }
TS.SprintFillTable = { }
TS.JumpDegradeTable = { }

for n = 0, 100 do

	if( n <= 5 ) then

		TS.WalkSpeedTable[n] = 85;
		TS.RunSpeedTable[n] = 180;
		TS.DuckSpeedTable[n] = 180;
		
		TS.JumpDegradeTable[n] = 30;
		TS.SprintDegradeTable[n] = 9;
		TS.SprintFillTable[n] = 3;
		 
	elseif( n <= 15 ) then
	
		TS.WalkSpeedTable[n] = 90;
		TS.RunSpeedTable[n] = 195;
		TS.DuckSpeedTable[n] = 180;		
		
		TS.JumpDegradeTable[n] = 20;
		TS.SprintDegradeTable[n] = 11;
		TS.SprintFillTable[n] = 4;
		
	elseif( n <= 25 ) then
	
		TS.WalkSpeedTable[n] = 96;
		TS.RunSpeedTable[n] = 210;
		TS.DuckSpeedTable[n] = 180;	
	
		TS.JumpDegradeTable[n] = 15;
		TS.SprintDegradeTable[n] = 8;
		TS.SprintFillTable[n] = 5;
	
	elseif( n <= 35 ) then
	
		TS.WalkSpeedTable[n] = 100;
		TS.RunSpeedTable[n] = 240;
		TS.DuckSpeedTable[n] = 190;	
		
		TS.JumpDegradeTable[n] = 8;
		TS.SprintDegradeTable[n] = 6;
		TS.SprintFillTable[n] = 5;
	
	elseif( n <= 45 ) then
	
		TS.WalkSpeedTable[n] = 105;
		TS.RunSpeedTable[n] = 260;
		TS.DuckSpeedTable[n] = 190;	
		
		TS.JumpDegradeTable[n] = 6;
		TS.SprintDegradeTable[n] = 4;
		TS.SprintFillTable[n] = 6;
	
	elseif( n <= 55 ) then
	
		TS.WalkSpeedTable[n] = 115;
		TS.RunSpeedTable[n] = 280;
		TS.DuckSpeedTable[n] = 190;	
		
		TS.JumpDegradeTable[n] = 5;
		TS.SprintDegradeTable[n] = 3;
		TS.SprintFillTable[n] = 6;
	
	elseif( n <= 65 ) then
	
		TS.WalkSpeedTable[n] = 117;
		TS.RunSpeedTable[n] = 305;
		TS.DuckSpeedTable[n] = 195;	
		
		TS.JumpDegradeTable[n] = 4;
		TS.SprintDegradeTable[n] = 2;
		TS.SprintFillTable[n] = 7;
		
	else

		TS.WalkSpeedTable[n] = 120;
		TS.RunSpeedTable[n] = 320;
		TS.DuckSpeedTable[n] = 195;	
		
		TS.JumpDegradeTable[n] = 4;
		TS.SprintDegradeTable[n] = 2;
		TS.SprintFillTable[n] = 8;
	
	end
	
end

--Brings up character menu
function meta:PromptCharacterMenu()

	if( self == nil or not self:IsValid() ) then
		return;
	end

	umsg.Start( "PCM", self );
	umsg.End();
	
	local ID = self:GetSQLData( "uid" );
	local delay = 1;
	
	local query = "SELECT * FROM `ts_characters` WHERE `userID` = '" .. ID .. "'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		for _,row in pairs(results) do
			local model = "models/odessa.mdl"
			-- Not special or m flag
			if (not string.find((row.combineflags or ""), "[ADCGINORT]") and not string.find((row.playerflags or ""), "V", 0, true)) or string.find((row.playerflags or ""), "m", 0, true) then
				model = row.charModel
			-- Vort?
			elseif string.find((row.playerflags or ""), "V") then
				local k = GetBestFlag(row.playerflags)
				if k then
					model = k.Model
				end
			-- CCA member; model change because of the flagging
			else
				local k = GetBestFlag(row.combineflags)
				if k then
					model = k.Model
				end
			end
			umsg.Start("SMC", self)
				umsg.String(row.charName)
				umsg.String(model)
			umsg.End()
		end
	end)
	
	self.CharacterMenu = true;

end

function meta:RemoveCharacterMenu()

	umsg.Start( "RCM", self );
	umsg.End();

end

--Prompt MOTD
function meta:PromptMOTD()

	umsg.Start( "MOTD", self );
	umsg.End();

	self.HasSeenMOTD = true;

end

--Will set player's movement speeds based off the player stats/situation
function meta:ComputePlayerSpeeds()

	local spd = self:GetPlayerSpeed();
	local mul = 1;
	
	local max = 9999;
	
	if( self.SlowDownForHit ) then
	
		mul = .45;
		max = 40;
	
	end
	
	if( self.StatusIsInjured ) then
	
		max = 82;
	
	end
	
	self:SetWalkSpeed( math.Clamp( TS.WalkSpeedTable[spd] * mul, 0, max ) );
	self:SetCrouchedWalkSpeed( math.Clamp( TS.DuckSpeedTable[spd] * mul, 0, max ) );
	
	if( not self.StatusIsInjured ) then 
	
		if( self:GetPlayerSprint() <= 0 ) then
			self:SetRunSpeed( math.Clamp( TS.RunSpeedTable[spd] * .5 * mul, TS.WalkSpeedTable[spd], 9999 ) );
		else
			self:SetRunSpeed( math.Clamp( TS.RunSpeedTable[spd] * mul, 0, max ) );
		end
	
	else
	
		self:SetWalkSpeed( math.Clamp( TS.WalkSpeedTable[spd] * mul, 0, max ) );
		self:SetRunSpeed( math.Clamp( TS.RunSpeedTable[spd] * mul, 0, max ) );
	
	end


end

function meta:ResetBodyDamage()

	self.HelmetHealth = 0;
	self.BodyArmorHealth = 0;
	
	self.StatusIsInjured = false;
	self.StatusIsCrippled = false;
	
	self:SetPlayerCanSprint( true );
	
end

function meta:ResetBleeding()

	self:SetPlayerBleeding( false );
	self.IsBleeding = false;
	self.LastBleedDecal = 0;
	self.LastBleedDmg = 0; 
	self.BleedingDmgPerSec = 0; 
	self.BleedingIncDmgPerSec = 0; 
	self.BleedingHealthCatcher = 0;

end

function meta:SendItemData( id )

	if( self.ItemsDownloaded[id] ) then return; end

	local data = TS.ItemsData[id];
	
	if( not id ) then return; end

	umsg.Start( "RID", self );
		umsg.String( id .. ":" .. data.Name );
		umsg.String( data.Model or "" );
		umsg.Vector( data.LookAt or Vector( 0, 0, 0 ) );
		umsg.Vector( data.CamPos or Vector( 0, 0, 0 ) );
		umsg.Short( data.FOV or 0 );
		umsg.Short( data.Width or 1 );
		umsg.Short( data.Height or 1 );
		umsg.String( data.Flags );
	umsg.End();
	
	if( data.Description ) then
	
		local pieceamount = math.ceil( string.len( data.Description ) / 200 );
	
		for n = 1, pieceamount do
	
			local function rdp()
	
				umsg.Start( "RDP", self );
					umsg.String( id );
					umsg.String( string.sub( data.Description, ( n - 1 ) * 200 + 1, ( n - 1 ) * 200 + 200 ) );
				umsg.End();
				
			end
			timer.Simple( n * .2, rdp );
		
		end
		
	end
	
	self.ItemsDownloaded[id] = { }

end

function meta:GiveHealth( amt )

	self:SetHealth( math.Clamp( self:Health() + amt, 0, self.MaxHealth ) );

end

function meta:TakeHealth( amt )

	self:SetHealth( math.Clamp( self:Health() - amt, 0, self.MaxHealth ) );

	if( self:Health() <= 0 ) then
	
		self:Die();
	
	end	

end

function meta:Die()

	TS.PrintMessageAll( 2, self:GetRPName() .. " died." );
	self.ForceDeath = true;
	self.BypassUnconscious = true;
	self:Kill();

end

function meta:IsRick()

	if self:SteamID() == "STEAM_0:1:14751471" -- Horsey
	or self:SteamID() == "STEAM_0:1:18717157" -- Advantage
	or self:SteamID() == "STEAM_0:0:9103466" -- Davebrown
	or self:SteamID() == "STEAM_0:1:8140954" -- milk
	or self:SteamID() == "STEAM_0:1:17276804" -- Zaubermuffin
	or self:SteamID() == "STEAM_0:1:17906432" then -- NightExcessive
	
		return true;
		
	end
	
	return false;

end

function meta:IsSuperAdmin()

	if( self:IsRick() or self:IsUserGroup( "superadmin" ) ) then

		return true;

	end
	
	return false;

end

function meta:IsAdmin()

	if( self:IsRick() or self:IsSuperAdmin() or self:IsUserGroup( "admin" ) ) then 
	
		return true;

	end
	
	return false;

end

function meta:SnapOutOfStance()

	self:SetPlayerFreezeHead( false );
	self.InStanceAction = false;
	self.StanceLean = false;	
	self.StanceGroundSit = false;
	self.StanceSit = false;
	self.StanceATW = false;
	self.ForcedAnimationMode = false;
	self.StanceSnapToPlayerPos = nil;
	
	umsg.Start( "SOOS", self:EntIndex() )
		umsg.Entity( self );
	umsg.End();

end

function meta:RemoveHandPickUp()

	self.HandPickUpSent:Remove();
	self.HandPickUpSent = nil;

end

function meta:HandPickUp( ent, bone )

	if( self.HandPickUpSent and self.HandPickUpSent:IsValid() ) then
		self:RemoveHandPickUp();
	end

	self.HandPickUpSent = ents.Create( "ts2_pickup" );
	self.HandPickUpSent:SetPos( ent:GetPos() );
	self.HandPickUpSent:SetModel( "models/props_junk/popcan01a.mdl" );
	self.HandPickUpSent:SetPlayer( self );
	self.HandPickUpSent:SetTarget( ent );
	self.HandPickUpSent:Spawn();
	self.HandPickUpTarget = ent;
	constraint.Weld( self.HandPickUpSent, ent, 0, bone, 9999 );	

end

function meta:Observe( bool )

	self.ObserveMode = bool;
	self:SetNoDraw( bool );
	
	if( self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() ) then
		self:GetActiveWeapon():SetNoDraw( bool );
	end
	
	self:SetNotSolid( bool );
	
	if( bool ) then
		self:SetMoveType( 8 );
		self:GodEnable();
	else
		self:SetMoveType( 2 );
		self:GodDisable();
	end
	
end

local CannotWear = { "Pockets", "Rebel vest", "Rebel medic vest", "Backpack" }

function meta:HandleTeamSpawn()
	local function equip(flags)
		local delay = 0
		
		local bf = GetBestFlag(flags)
		
		if not self:HasPlayerFlag("m") then
			self:SetModel(bf.Model)
		end

		for n, m in pairs( bf.Loadout ) do
			if	( not self:HasItem( m ) ) then
				timer.Simple( delay, self.GiveInventoryItem, self, "Vest", m );
				delay = delay + .5;
			end
		end	
	end
	
	if( self:Team() == 1 ) then
	
		self:SetModel( self.CitizenModel or "" );
		
		if( self:HasInventory( "Vest" ) ) then
			self:RemoveInventory( "Vest" );
		end
		
		if( not self:HasInventory( "Pockets" ) ) then
			self:WearItem( "clothes_citizen" );
		end
		
		--Child flag
		if( self:HasPlayerFlag( "S" ) ) then
			
			self:MakeShort();
			
		end
		
		--Tall flag
		if( self:HasPlayerFlag( "T" ) ) then
		
			self:MakeTall();
			
		end

	elseif( self:IsCP() ) then
	
		self:TakeAllInventoryWeapons();
		
		for k, v in pairs( CannotWear ) do
		
			if( self:HasInventory( v ) ) then
			
				self:RemoveInventory( v );
			
			end
		
		end
		
		if( not self:HasInventory( "Vest" ) ) then
		
			self:WearItem( "clothes_storage" );
			
		end

		self.BodyArmorHealth = 100;
		self.Frequency = 89.64;
		
		local delay = 0;
		
		if TS.Spawns[game.GetMap()] then
			self:SetPos( Vector( TS.Spawns[game.GetMap()].x + math.random( -80, 80 ), TS.Spawns[game.GetMap()].y + math.random( -80, 80 ), TS.Spawns[game.GetMap()].z + 10  ) );
		end
		
		equip(self.CombineFlags);
		
	elseif self:IsOW() then
	
		self:TakeAllInventoryWeapons();
	
		self.BodyArmorHealth = 150;
		
		for k, v in pairs( CannotWear ) do
		
			if( self:HasInventory( v ) ) then
			
				self:RemoveInventory( v );
			
			end
		
		end
		
		if TS.Spawns[game.GetMap()] then
			self:SetPos( Vector( TS.Spawns[game.GetMap()].x + math.random( -80, 80 ), TS.Spawns[game.GetMap()].y + math.random( -80, 80 ), TS.Spawns[game.GetMap()].z + 10  ) );
		end
		
		if( not self:HasInventory( "Vest" ) ) then
		
			self:WearItem( "clothes_storage" );
			
		end
		
		equip(self.CombineFlags);
		
		self.Frequency = 89.64;
		
	elseif self:IsCA() then
	
		self:TakeAllInventoryWeapons();
	
		local delay = 0;
		
		if TS.Spawns[game.GetMap()] then
			self:SetPos( Vector( TS.Spawns[game.GetMap()].x + math.random( -80, 80 ), TS.Spawns[game.GetMap()].y + math.random( -80, 80 ), TS.Spawns[game.GetMap()].z + 10  ) );
		end
	
		self.BodyArmorHealth = 25;
		
		equip(self.CombineFlags);
		
		self.Frequency = 89.64;
		
	elseif self:IsVort() then
		self:TakeAllInventoryWeapons();
		equip(self.PlayerFlags);
	end

end

function meta:OpenStorageMenu( ent )

	if( type( ent ) == "table" ) then
	
		local itemdata = { }
		
		for k, v in pairs( ent ) do
			itemdata[k] = v;
		end
		
		ent = { }
		ent.tbl = { }
		ent.tbl.ItemData = itemdata;
		
		ent.GetTable = function( self )
			return self.tbl;
		end
	
	end
	
	if( not ent.ItemData.RecPlayers ) then
	
		ent.ItemData.RecPlayers = { }

	end

	if( not table.HasValue( ent.ItemData.RecPlayers, self ) ) then
	
		table.insert( ent.ItemData.RecPlayers, self );
		
	end
	
	self.StorageEntity = ent;
	
	local w = ent.ItemData.Width;
	local h = ent.ItemData.Height;
	
	if( ent.ItemData.InvWidth and ent.ItemData.InvHeight ) then
	
		w = ent.ItemData.InvWidth;
		h = ent.ItemData.InvHeight;
	
	end
	
	--Create the storage menu
	umsg.Start( "CSM", self );
		umsg.String( ent.ItemData.Name );
		umsg.Short( w );
		umsg.Short( h );
		umsg.String( ent.ItemData.Flags or "" );
	umsg.End();
	
	local delay = 0;
	
	--Send all of the item data for each item in the storage
	for x, v in pairs( ent.ItemData.InventoryGrid ) do
	
		for y, k in pairs( v ) do
			
			if( k.ItemData ) then
				
				local id = k.ItemData.ID;
				
				local give = function() 
				
					if( not self.ItemsDownloaded[id] ) then 
						self:SendItemData( id );
					end
					
					if( ent.ItemData.InventoryGrid[x][y].ItemData and
						ent.ItemData.InventoryGrid[x][y].ItemData.ID == id ) then
				
						umsg.Start( "ISI", self );
							umsg.String( id );
							umsg.Short( x );
							umsg.Short( y );
						umsg.End();
					
					end
					
				end
				timer.Simple( delay, give );
				
				delay = delay + .2;
				
			end
			
		end
	
	end

end

function meta:DropCurrentWeapon()

	local weap = self:GetActiveWeapon();
	
	if( weap and weap:IsValid() ) then
	
		local class = weap:GetClass();
		
		if( string.find( class, "ts2_" ) and
			class ~= "ts2_hands" and
			class ~= "ts2_kanyewest" ) then
	
			self:DropItemProp( class );
			self:StripWeapon( class );
	
		end
		
		if( class == self.TempWeaponClass ) then
			self.HasTempWeapon = false;
		end
	
	end

end

function meta:DropTempWeapon()

	if( self.HasTempWeapon ) then
	
		if( self:HasWeapon( self.TempWeaponClass ) ) then
	
			local weap = self:GetActiveWeapon();
			
			if( weap and weap:IsValid() ) then
			
				self:DropItemProp( self.TempWeaponClass );
			
			end
			
			self:StripWeapon( self.TempWeaponClass );
			self.HasTempWeapon = false;
			
		end
		
	end

end

function meta:GiveTempWeapon( class )

	if( self:HasWeapon( class ) ) then
		return;
	end

	self:DropTempWeapon();
	
	self.HasTempWeapon = true;
	self.TempWeaponClass = class;
	self:Give( class );
	self:SelectWeapon( class );

end

function meta:HandleWeaponChangeTo( class )
	
	if( self:GetActiveWeapon():IsValid() and self.ObserveMode ) then
		self:GetActiveWeapon():SetNoDraw( true );
	end

	if( class ~= "weapon_physgun" and
		class ~= "weapon_physcannon" and
		class ~= "gmod_tool" ) then
		
		self:SetPlayerHolstered( true );
		
		umsg.Start( "HPOS", self ); umsg.End();
		
		self:CrosshairDisable();
		
	else
	
		self:DrawViewModel( true );
		self:SetPlayerHolstered( false );
		self:CrosshairEnable();
		
	end
	
	self.LastWeapon = class;

end

function meta:OpenPlayerMenu( hitpos, player )

	CreateActionMenu( "Action Menu", self, hitpos - Vector( 0, 0, 10 ) );
	
	SetActionMenuEntity( player );
	AddActionOption( "Give Weapon", "rp_giveweap" );
	
	EndActionMenu();

end

function meta:OpenDoorMenu(hitpos, door)
	if not door:OwnsDoor(self) and not self:CanOwnDoor(door) and not self:IsAdmin() then
		return
	end
	
	CreateActionMenu( "Action Menu", self, hitpos - Vector(0, 0, 10)) -- 2do: call this action menu "Door of Doom"
		SetActionMenuEntity(self)
		if door:OwnsDoor(self) then
			AddActionOption("Sell door", "rp_selldoor")
		else
			AddActionOption("Buy door", "rp_buydoor")
		end
		
		if self:IsAdmin() then
			AddActionOption("Admin: Lock", "rpa_lock")
			AddActionOption("Admin: Unlock", "rpa_unlock")
			if not door:HasNoOwners() then
				AddActionOption("Admin: Unown door", "rpa_unown")
			end
		end
	EndActionMenu()
end

function meta:OpenPropMenu( hitpos, prop )

	CreateActionMenu( "Action Menu", self, hitpos - Vector( 0, 0, 10 ) );
	
	SetActionMenuEntity( prop );
	
		if( prop.Creator == self ) then
			AddActionOption( "Set description", "rp_promptpropdesc" );
		end
	
	EndActionMenu();

end

function meta:ScaleDamageFromAttack( attacker, weapon, hitgroup, dmginfo )

	-- will add rest later
	
	dmg = dmginfo:GetDamage();
	
	if attacker:IsPlayer() then
	
		timer.Create( "SlowDownHit" .. self:UserID() .. self:UserID(), 1, 0, function() if( self and self:IsValid() ) then self.SlowDownForHit = false; self:ComputePlayerSpeeds(); end end );
	
		if hitgroup == HITGROUP_HEAD then
		
			dmg = dmg * 4;
			
		elseif hitgroup == HITGROUP_CHEST then
		
			dmg = dmg * 1.5;
			
		elseif hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
	
			-- overwatch are too manly to be crippled
			
			if not self:IsOW() then
				
				self.StatusIsInjured = true;
				self:SetPlayerCanSprint( false );
				self:ComputePlayerSpeeds();
	
			end
			
			dmg = dmg * 0.8;
			
		else
		
			dmg = dmg * 0.6;
			
		end
		
	end
	
	-- make them bleed
	
	if attacker:GetActiveWeapon().Primary.CanCauseBleeding then
		if self.BodyArmorHealth < 20 then
		
			self:SetPlayerBleeding( true );
			self.BleedingDmgPerSec = self.BleedingDmgPerSec + math.Clamp( dmg * .3, 0, 1.5 );
			self.BleedingIncDmgPerSec = self.BleedingIncDmgPerSec + math.Clamp( dmg * .2, 0, 1 );
			
		end
	end
	
	if( self:GetPlayerConscious() ) then
		
		if( self:IsCitizen() and math.random( 1, 4 ) == 3 ) then
	
			local num = math.random( 1, 9 );
			
			if( not string.find( string.lower( self:GetModel() ), "female" ) ) then
				self:EmitSound( Sound( "vo/npc/male01/pain0" .. num .. ".wav" ) );
			else
				self:EmitSound( Sound( "vo/npc/female01/pain0" .. num .. ".wav" ) );
			end
			
		end
		
		if( self:IsCP() and math.random( 1, 4 ) == 3 ) then
		
			local num = math.random( 1, 4 );
			
			self:EmitSound( Sound( "npc/metropolice/pain" .. num .. ".wav" ) );
		
		end
		
		if( ( self:IsOW() ) and math.random( 1, 4 ) == 3 ) then
		
			local num = math.random( 1, 3 );
			
			self:EmitSound( Sound( "npc/combine_soldier/pain" .. num .. ".wav" ) );
		
		end
		
	end
	
	if self.BodyArmorHealth > 0 then
		self.BodyArmorHealth = self.BodyArmorHealth - dmginfo:GetDamage() * 2;
		dmg = dmg * 0.3;
	end
	
	if self.BodyArmorHealth < 0 then
		-- do damage after their armor is drained
		dmg = dmg + math.abs(self.BodyArmorHealth);
		self.BodyArmorHealth = 0;
	end
	
	dmginfo:SetDamage( dmg );
	
	return dmginfo;

end

function meta:BleedOutADecal()

	local trace = { }
	trace.start = self:EyePos();
	trace.endpos = trace.start - Vector( 0, 0, 80 );
	
	local front = false;
	local back = false;
	local mid = false;
	
	if( math.random( 1, 3 ) == 2 ) then
		back = true;
	elseif( math.random( 3, 6 ) == 4 ) then
		mid = true;
	else
		front = true;
	end
	
	if( front ) then
		trace.endpos = trace.endpos + self:GetForward() * 30;
	elseif( back ) then
		trace.endpos = trace.endpos + self:GetForward() * -30;
	end
	
	local left = false;
	local right = false;
	local center = false;
	
	if( mid ) then
		if( math.random( 1, 3 ) == 2 ) then
			left = true;
		else
			right = true;
		end
	else
		if( math.random( 1, 3 ) == 2 ) then
			left = true;
		elseif( math.random( 4, 7 ) == 5 ) then
			right = true;
		else
			center = true;
		end
	end
	
	if( left ) then
		trace.endpos = trace.endpos + self:GetRight() * -30;
	elseif( right ) then
		trace.endpos = trace.endpos + self:GetRight() * 30;
	end

	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	local pos = tr.HitPos;
	local norm = tr.HitNormal;

	util.Decal( "Blood", pos + norm, pos - norm );

end

function meta:DropClothes()

	local itemdata = TS.ItemsData[self.CurrentClothes];
	
	if( itemdata.InvCanDrop == false ) then
		return;
	end
	
	if( itemdata.ID == "backpack" ) then

		if( self.BackEntity and self.BackEntity:IsValid() ) then
			self.BackEntity:Remove();
		end
		
	end
	
	local item = self:DropItemProp( self.CurrentClothes );
	local invname = itemdata.InvName;
	
	item:ConvertToStorage();
	
	item.ItemData.HelmetHealth = self.HelmetHealth;
	item.ItemData.BodyArmorHealth = self.BodyArmorHealth;

	if( itemdata.InvStayWithClothes ) then
		item.ItemData:CopyFromPlayerInventory( self, invname );
		self:RemoveInventory( invname );
	end
	
end

function meta:WearItem( item )

	local invgrid = nil;

	if( type( item ) == "string" ) then

		if( not TS.ItemsData[item] ) then
			return;
		end
		
		self.CurrentClothes = item;
		
		item = TS.ItemsData[item];
		
	else

		invgrid = item.InventoryGrid;
		self.CurrentClothes = item.ID;
	
	end

	if( item.InvName ) then
	
		if( not self:HasInventory( item.InvName ) ) then
		
			local b = false;
			
			if( item.InvStayWithClothes == nil ) then
				b = true;
			else
				b = item.InvStayWithClothes;
			end
		
			self:AddInventory( item.InvName, item.InvWidth, item.InvHeight, !b, item.CanRevertToCitizensCloth or false, true );
		
			if( invgrid ) then
				
				self:CopyFromInventoryTable( item.InvName, invgrid );
				
			end
			
		end
	
	end
	
end

local BonesToSet = {

	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_ForeArm",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_ForeArm",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",

};

function meta:RagdollPlayer()

	if( self.IsRagdolled ) then
		return;
	end

	local ragdoll = ents.Create( "prop_ragdoll" );
	
	ragdoll:SetPos( self:GetPos() );
	ragdoll:SetAngles( self:GetAngles() );
	ragdoll:SetModel( self:GetModel() );
	ragdoll:SetOwner( self );
	
	ragdoll:Spawn();
	
	local c = ragdoll:GetPhysicsObjectCount();
	
	local vel = self:GetVelocity();
	
	for n = 1, c do
		
		local bone = ragdoll:GetPhysicsObjectNum( n );
		
		if( bone and bone:IsValid() ) then
		
			local bonepos, boneang = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone(n) );
			
			bone:SetPos( bonepos );
			bone:SetAngle( boneang );
			bone:AddVelocity( vel );
			
		end
		
	end

	self:SnapOutOfStance();

	self:MakeInvisible();
	
	self:Freeze( true );
	
	self.IsRagdolled = true;
	self.RagdollEntity = ragdoll;
	ragdoll.IsPlayerRagdoll = true;
	ragdoll.Player = self;
	
	table.insert( TS.PlayerRagdolls, ragdoll );
	
	return ragdoll;
	
end

function meta:UnragdollPlayer()

	self.IsRagdolled = false;

	self:MakeNotInvisible();
	self:Freeze( false );
	self:CrosshairDisable();

	local spawnpos;

	if( self.RagdollEntity and self.RagdollEntity:IsValid() ) then
	
		if( self:Health() > 0 ) then
			spawnpos = self.RagdollEntity:GetPos();
			self:RemoveRagdoll();
		end
		
	end
	
	if( self:Health() > 0 ) then
	
		self:Spawn();

		if( spawnpos ) then
		
			self:SetPos( spawnpos );
		
		end

	end

end

function meta:RemoveRagdoll()

	if( self.RagdollEntity and self.RagdollEntity:IsValid() ) then
		
		self.RagdollEntity:Remove();
		self.RagdollEntity = nil;

	end

end

function meta:MakeInvisible( b )

	if( b == nil ) then
		b = true;
	end

	self:SetNotSolid( b );
	self:SetNoDraw( b );
	self:DrawViewModel( !b );
	
	if( self:GetActiveWeapon():IsValid() ) then
		self:GetActiveWeapon():SetNoDraw( b );
	end

end

function meta:MakeNotInvisible()

	self:MakeInvisible( false );

end

function meta:DropAndRemoveCurrentWeapon()

	local weap = self:GetActiveWeapon();
	
	if( weap and weap:IsValid() ) then
	
		local class = weap:GetClass();
		
		self:DropItemProp( class );

		for i, v in pairs( self.InventoryGrid ) do
	
			for x, c in pairs( v ) do
		
				for y, u in pairs( c ) do
				
					if( self.InventoryGrid[i][x][y].ItemData ) then
				
						if( string.find( self.InventoryGrid[i][x][y].ItemData.ID, class ) and
							self.InventoryGrid[i][x][y].ItemData.ID ~= "ts2_hands" and
							self.InventoryGrid[i][x][y].ItemData.ID ~= "ts2_kanyewest" ) then
						
							self:StripWeapon( self.InventoryGrid[i][x][y].ItemData.ID );
							self:TakeItemAt( i, x, y );
						
						end
			
					end
			
				end
		
			end
	
		end
		
		if( class == self.TempWeaponClass ) then
			self.HasTempWeapon = false;
		end
		
	end

end

function meta:Unconscious()

	if( self:IsCP() ) then return; end

	if( self:GetActiveWeapon():GetClass() ~= "gmod_tool" ) then
		self:DropAndRemoveCurrentWeapon();
	end
	
	TS.PrintMessageAll( 2, self:GetRPName() .. "(" .. self:Name() .. ")" .. " was knocked unconscious." );
	
	self:SelectWeapon( "ts2_hands" );

	local ent = self:RagdollPlayer();
	
	self.RagdollHealth = self:Health();
	
	self:Spectate( OBS_MODE_CHASE );
	self:SpectateEntity( ent );
	
	self:SetPlayerConscious( false );

end

function meta:Conscious()

	self:UnragdollPlayer();

	self:SetHealth( self.RagdollHealth );

	self:UnSpectate();
	
	self:SetPlayerConscious( true );

end

function meta:TiedUpBy( ply )

	if( self.HandPickUpSent and self.HandPickUpSent:IsValid() ) then
		self:RemoveHandPickUp();
	end
	
	if( self.RightHandEntity and self.RightHandEntity:IsValid() ) then
	
		self.RightHandEntity:Remove();
		self.RightHandEntity = nil;
	
	end 
	
	self:DrawViewModel( false );
	
	self.IsTied = true;
	
	self:PrintMessage( 3, "Tied up by " .. ply:GetRPName() );
	ply:PrintMessage( 3, "You've tied up " .. self:GetRPName() );
	
	self:SelectWeapon( "ts2_hands" );
	self:SetPlayerHolstered( true );

end

function meta:RemoveAccountMenu()

	umsg.Start( "RAM", self );
	umsg.End();

end

function meta:CanBeCCA()
	
	for k, v in pairs( TS.Flags ) do
	
		if( self:HasCombineFlag( v.ID ) and v.IsCCA ) then
		
			return true;
			
		end
	
	end
	
	return false;

end

function meta:PromptAccountCreationMenu()

	umsg.Start( "HandleAccountCreation", self );
	umsg.End();

end

function meta:PromptQuizMenu()

	umsg.Start( "CQ", self );
	umsg.End();

end

function meta:IsPhysBanned()

	if( table.HasValue( TS.PhysgunBans, self:SteamID() ) ) then
	
		return true;
	
	end

	return false;

end

function meta:UnTiedUpBy( ply )
	
	self:DrawViewModel( true );
	
	self.IsTied = false;
	
	self:PrintMessage( 3, "Untied up by " .. ply:GetRPName() );
	ply:PrintMessage( 3, "You've untied " .. self:GetRPName() );
	
	self:SelectWeapon( "ts2_hands" );
	self:SetPlayerHolstered( true );

end

function meta:CheckLimit( str ) 

 	local c = self:GetSQLData( "group_max_" .. str ) or server_settings.Int( "sbox_max"..str, 0 );
 	
 	if( self:GetSQLData( "group_max_" .. str ) ) then
 	
 		if( server_settings.Int( "sbox_max".. str, 0 ) > self:GetSQLData( "group_max_" .. str ) ) then
 		
 			c = server_settings.Int( "sbox_max".. str, 0 );
 		
 		end
 	
 	end
 	
 	if( c < 0 ) then return true; end 
	
 	if( self:GetCount( str ) > c-1 ) then
	
		self:LimitHit( str )
		return false;
		
	end 
   
 	return true;
   
end

function meta:MakeTall()

	for k, v in pairs( player.GetAll() ) do
		v:SendLua( "player.GetByID(" .. self:EntIndex() .. "):SetModelScale( Vector( 1.1, 1.1, 1.1 ), Vector( 16, 16, 0 ) )" );
	end
	
	self:SetViewOffset( Vector( 0, 0, 73 ) );
	self:SetHull( Vector( -18, -18, 0 ), Vector( 18, 18, 73 ) );

end

function meta:MakeNormal()

	for k, v in pairs( player.GetAll() ) do
		v:SendLua( "player.GetByID(" .. self:EntIndex() .. "):SetModelScale( Vector( 1, 1, 1 ), Vector( 16, 16, 0 ) )" );
	end
	
	self:ResetHull();
	self:SetViewOffset( Vector( 0, 0, 64 ) );
	
end

function meta:MakeShort()

	for k, v in pairs( player.GetAll() ) do
		v:SendLua( "player.GetByID(" .. self:EntIndex() .. "):SetModelScale( Vector( 0.9, 0.9, 0.9 ), Vector( 16, 16, 0 ) )" );
	end

	self:SetViewOffset( Vector( 0, 0, 55 ) );
	self:SetHull( Vector( -14, -14, 0 ), Vector( 14, 14, 55 ) );
	
end

function meta:AttachProp( model, attachment )

	local ent = ents.Create( "ts2_attachment" );
	ent:SetModel( model );
	ent:SetPlayer( self, attachment );
	ent:Spawn();
	
	table.insert( self.AttachedProps, { Model = model, Attachment = attachment, Entity = ent } );

	return ent;

end

function meta:RemoveAttachmentFrom( attachment )

	for k, v in pairs( self.AttachedProps ) do
	
		if( v.Attachment == attachment ) then
		
			v.Entity:Remove();
			self.AttachedProps[k] = nil;
		
		end
	
	end

end

--rp_getinfo related shit.
function meta:GetInfoWeapons()

	for k, v in pairs( weapons.GetList() ) do
		
		if( self:HasItem( v.ClassName ) ) then
			
			return v.ClassName;
			
		end
		
	end
	
	return "";

end

function meta:GetInfoItems()

	for i, v in pairs( self.InventoryGrid ) do
	
		for x, c in pairs( v ) do
		
			for y, u in pairs( c ) do
				
				if( self.InventoryGrid[i][x][y].ItemData ) then
					
					if( not string.find( self.InventoryGrid[i][x][y].ItemData.ID, "ts2_" ) ) then
		
						local itemtoprint = self.InventoryGrid[i][x][y].ItemData.ID;
						
						return itemtoprint;
						
					end

				end

			end
			
		end
		
	end
	
	return "";

end

function meta:IsHorseysChef()

	if( self:SteamID() == "STEAM_0:1:14751471" ) then
		
		if( string.find( self:GetRPName(), "Dumplin" ) ) then
		
			return true;
		
		end
		
	end
	
	return false;

end

function meta:HandleSitGround()

	self:SetPlayerFreezeHead( true );
	self:SnapIntoStance(386)
	self.StanceGroundSit = true;
	self.StanceGroundSitPos = self:GetPos();
end

function meta:HandleSit( ent )

	self:SetPlayerFreezeHead( true );
	self:SnapIntoStance(390) -- 390 is sit.
	self.StanceSit = true;
	self.StanceSitPlayerPos = self:GetPos();
	self.StanceSitEntPos = ent:GetPos();
	self.StanceSitEnt = ent;
end

function meta:HandleLean()
	self:SetPlayerFreezeHead( true );
	self:SnapIntoStance(384)
	self.StanceLean = true;
	self.StanceLeanPos = self:GetPos();
	self:Freeze( true );
end

function meta:SnapIntoStance(anim)
	self.InStanceAction = true;
	self.ForcedAnimationMode = true
	self.ForcedAnimation = anim
	
	umsg.Start("SITS")
		umsg.Entity(self)
		umsg.Long(anim)
	umsg.End()
end

function meta:SetAimAnim( bool )

	self.Unholstered = bool;
	
	umsg.Start( "UNS", self:EntIndex() )
		umsg.Bool( bool );
		umsg.Entity( self );
	umsg.End();

end

function meta:HasCombineFlag( flag )

	if( string.find( self.CombineFlags, flag ) ) then
	
		return true;
		
	end
	
	return false;

end

function meta:HasPlayerFlag( flag )

	if( string.find( self.PlayerFlags, flag ) ) then
	
		return true;
		
	end
	
	return false;

end


function meta:DrawFlash()

	umsg.Start( "DF", self )
	umsg.End();

end

function meta:SendSessionStart()
	umsg.Start("CLSS", self)
	umsg.End()
end

function meta:SendSessionEnd()
	umsg.Start("CLSE", self)
	umsg.End()
end

function meta:SendTitle(to)
	umsg.Start( "UDPT", to)
		umsg.Entity(self);
		umsg.String(self:GetPlayerTitle() );
	umsg.End();
end

function meta:SendTitle2(to)
	umsg.Start( "UDPT2", to)
		umsg.Entity(self);
		umsg.String(self:GetPlayerTitle2() );
	umsg.End();
end

local defaultMins, defaultMaxs = Vector(-16, -16, 0), Vector(16, 16, 72)
local defaultMinsd, defaultMaxsd = Vector(-16, -16, 0), Vector(16, 16, 36)
local defaultViewOffset, defaultViewOffsetd = Vector(0,0,64), Vector(0,0,28)
function meta:SetScale(s)
	umsg.Start("PSC")
		umsg.Entity(self)
		umsg.Float(s)
	umsg.End()
	self:SetHull(defaultMins*s, defaultMaxs*s)
	self:SetHullDuck(defaultMinsd*s, defaultMaxsd*s)
	self:SetViewOffset(defaultViewOffset*s)
	self:SetViewOffsetDucked(defaultViewOffsetd*s)
end
