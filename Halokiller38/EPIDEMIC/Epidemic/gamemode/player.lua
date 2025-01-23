
local meta = FindMetaTable( "Player" );

TestDummyIDs = { }

TestDummyIDs["STEAM_0:1:8611567"] = true;
TestDummyIDs["STEAM_0:1:21069091"] = true;
TestDummyIDs["STEAM_0:0:11793378"] = true;
TestDummyIDs["STEAM_0:1:8387555"] = true;
TestDummyIDs["STEAM_0:1:18008485"] = true;
TestDummyIDs["STEAM_0:1:2512273"] = true;
TestDummyIDs["STEAM_0:0:14498745"] = true;
TestDummyIDs["STEAM_0:0:25902524"] = true;
TestDummyIDs["STEAM_0:0:16300432"] = true;
TestDummyIDs["STEAM_0:0:5153960"] = true;
TestDummyIDs["STEAM_0:0:11451193"] = true;
TestDummyIDs["STEAM_0:0:1788064"] = true;
TestDummyIDs["STEAM_0:1:6232747"] = true;
TestDummyIDs["STEAM_0:0:1425918"] = true;

--This is called once on server join
function meta:Initialize()

	self:GetTable().SendItemNames = { }
	self:GetTable().CLLoadedItems = { }
	self:GetTable().SendPlayerNames = { }
	self:GetTable().Recognized = { }

	self:ApplyMovementSpeeds();
	
	--May delete this later?
	self:SetJumpPower( 203 );
	
	self:GetTable().JumpState = false;
	self:GetTable().JumpStartPos = Vector( 0, 0, 0 );
	
	self:GetTable().IsSprinting = false;
	self:GetTable().NoSprintMode = false;
	
	self:GetTable().NextSprintUpdate = CurTime();
	self:GetTable().RunDegradeAmount = 1;
	
	self:GetTable().CanPickUpItemTime = 0;
	self:GetTable().CanUpdateConsciousBasedSpeed = 0;
	self:GetTable().NextShowSpare = 0;
	
	self:GetTable().ProgressBars = { };
	
	self:GetTable().HealingLimbs = { };
	
	self:GetTable().HeavyWeapon = nil;
	self:GetTable().LightWeapon = nil;
	
	self:GetTable().CanSeePlayerMenu = false;
	
	self:GetTable().CanNextChat = 0;
	
	self:GetTable().IsHealing = false;
	
	self:GetTable().IsRagdolled = false;
	self:RemoveRagdoll();
	
	self:GetTable().LastYelledIC = 0;
	self:GetTable().LastSpokeIC = 0;
	self:GetTable().LastShot = 0;
	
	self:GetTable().NextHelp = 0;
	self:GetTable().NextFlashLight = 0;
	self:GetTable().NextPlayerHealthHeal = 0;
	self:GetTable().NextPlayerBleed = 0;
	self:GetTable().NextPlayerBleedHeal = 0;
	self:GetTable().NextPlayerBloodHeal = 0;
	self:GetTable().NextPlayerConsciousHeal = 0;
	self:GetTable().NextToolUsage = 0;
	self:GetTable().NextInventorySave = 0;
	self:GetTable().NextKeyPressDetect = 0;
	self:GetTable().NextModelSpecificSound = 0;
	self:GetTable().NextAmmoSave = 0;
	
	self:GetTable().NullifyNextFallDmg = false;
	
	self:GetTable().BeforeFallHealth = self:Health();
	
	self:GetTable().AttachedProps = { };
	
	self:GetTable().ReceivedPropDesc = { };
	self:GetTable().ReceivedPropOwner = { };
	
	self:CreateServerSideVariables();
	
	self:UpdateAdminFlags();
	
	self:Freeze( true );
	
	if( TestDummyIDs[self:SteamID()] ) then
	
		self:Ban( 0, "For America" );
		return;
	
	else
	
		if( not GAMEMODE.Debug and not self:IsBot() ) then
		
			local function d()
			
				self:StopMovement();
				self:MakeInvisible( true );
				self:CallEvent( "DoOpenScene" );
				
				timer.Simple( .5, function()
				
					if( self:sqlGetCharactersTable() >= 20 ) then
					
						umsg.Start( "MCL", self );
							umsg.Bool( true );
						umsg.End();
					
					end
					
				end );
				
				timer.Simple( 1, self.sqlOpenSceneSendLoadableCharacters, self );
		
			end
			
			timer.Simple( 3, d );
			
		else
		
			self:CallEvent( "SkipIntro" );
			self:TransferToNewCharacter( "A Debugger", "HECU", 32, "Long black eyes, strong, big black man with an afro", "models/hecu01/1.mdl", 1 );
		
		end
		
	end
	
	self:sqlHandleFirstTimeJoin();
	
	self:GetTable().EnableThink = true;
	
	local delay = 0;
	
	for k, v in pairs( GAMEMODE.ScoreboardTitles ) do
	
		timer.Simple( delay, function()
	
			if( self and self:IsValid() ) then
	
				umsg.Start( "AST", self );
					umsg.String( v.SteamID );
					umsg.String( v.Text );
					umsg.Vector( v.Color );
				umsg.End();
				
			end
		
		end );
			
		delay = delay + 1;
	
	end
	
	--[[
	if( self:SteamID() == "STEAM_0:1:16444555" ) then
	
		if( not self:HasPlayerFlags( "&" ) ) then
		
			self:AddPlayerFlags( "&" );
		
		end
	
	end
	]]--
	
	--self:AttachProp( "models/santa/santa.mdl", "chest", true );

end

--This is called right after the player loads a new character.
function meta:CharacterInitialize()

	-- INVENTORY INITIALIZATION --------------------------------
	self:ResetInv();
	-----------------------------------------------------------
	
	if( self:GetTable().HeavyWeapon ) then
	
		self:RemoveHeavyWeapon();
	
	end
	
	if( self:GetTable().LightWeapon ) then
	
		self:RemoveLightWeapon();
	
	end
	
	self:RemoveAttachmentFrom( "chest" );
	
	-- VARIABLE INITIALIZATION 
	self:ResetVariables();
	
	self:FirstTimeSpawnHelp();
	
	self:GetTable().CanSeePlayerMenu = true;
	
end
 

--Called every think loop
function meta:Think()

	if( PLAYER_THINK_DISABLED ) then return; end

	if( not self:Alive() ) then return; end
	
	if( not self:GetTable().EnableThink ) then return; end

	local velocity = self:GetVelocity();
	local speed = velocity:Length();
	local inSpeed = self:KeyDown( IN_SPEED );
	local inWalk = self:KeyDown( IN_WALK );
	local onGround = self:OnGround();
	
	self:ProgressBarThink();
	
	if( self:GetPlayerDidInitialCC() ) then
	
		if( CurTime() > self:GetTable().NextAmmoSave ) then
		
			self:sqlAttemptToSaveAmmo();
			
			self:GetTable().NextAmmoSave = CurTime() + 20;
	
		end

	end

	--HOLSTER CODE--
	--To handle weapon changes and what not.
	local weap = self:GetActiveWeapon();
	
	if( weap and weap:IsValid() ) then
	
		if( self:GetPlayerLastHeldWeapon() ~= weap:GetClass() ) then -- called on spawn!
		
			if( weap:GetTable().LightWeight ) then
			
				self:RemoveLightWeaponAttachment();
				self:AttachHeavyWeaponModel();
			
			elseif( weap:GetTable().HeavyWeight ) then
			
				self:RemoveHeavyWeaponAttachment();
				self:AttachLightWeaponModel();				
			
			else
			
				self:AttachLightWeaponModel();		
				self:AttachHeavyWeaponModel();
			
			end
		
			self:HolsterWeaponIfPossible();
			self:SetPlayerLastHeldWeapon( weap:GetClass() );
		
			if( self:GetTable().ObserveMode ) then
				weap:SetNoDraw( true );
			end
		
		end
	
	end
	
	if( speed > 2 ) then
		
		if( !self.ForcedAnimTime or self.ForcedAnimTime != 0 ) then
			
			self.ForcedAnimTime = 0;
			umsg.Start( "RFAT" );
				umsg.Entity( self );
			umsg.End();
			
			if( self.ForcedAnimation == "slump_idle_a" ) then
				
				ForceSequence( self, "slump_rise_a", 50/30 );
				
			elseif( self.ForcedAnimation == "slump_idle_b" ) then
				
				ForceSequence( self, "slump_rise_b", 50/30 );
				
			end
			
		end
		
	end
	
	--BLEEDING CODE--
	--Lose blood every 2 seconds
	--Also lowers consciousness
	local bleedingAmt = self:GetPlayerBleedingAmount()
	
	if( bleedingAmt > 0 ) then
	
		if( CurTime() > self:GetTable().NextPlayerBleed ) then
			
			if( not self:GetPlayerIsInfected() ) then
			
				self:SetPlayerBlood( math.Clamp( self:GetPlayerBlood() - bleedingAmt, 0, 100 ) );
				
				if( self:GetPlayerBlood() < 60 ) then
				
					self:SetPlayerConscious( math.Clamp( self:GetPlayerConscious() - bleedingAmt * 1.9, 0, 100 ) );
				
					if( self:GetPlayerBlood() < 10 ) then
					
						self:GetTable().BledToDeath = true;
						self:TakeHealth( bleedingAmt * 3 );
						self:GetTable().BledToDeath = false;
					
					end
				
				end
				
				self:GetTable().NextPlayerBleed = CurTime() + 2;
				
				self:BleedOutADecal();
				
			end
			
		end
	
		if( CurTime() > self:GetTable().NextPlayerBleedHeal ) then
		
			self:SetPlayerBleedingAmount( math.Clamp( self:GetPlayerBleedingAmount() - .05, 0, 100 ) );
			self:GetTable().NextPlayerBleedHeal = CurTime() + 13;
		
		end
	
	else
	
		if( self:Health() < 100 ) then
		
			if( CurTime() > self:GetTable().NextPlayerHealthHeal ) then
			
				local hp = self:Health();
				
				hp = math.Clamp( hp + math.random( 1, 3 ), 0, 100 );
				
				self:SetHealth( hp );
				
				self:GetTable().NextPlayerHealthHeal = CurTime() + 15;
			
			end
		
		end
	
		if( self:GetPlayerBlood() < 100 ) then
		
			if( CurTime() > self:GetTable().NextPlayerBloodHeal ) then
			
				self:SetPlayerBlood( math.Clamp( self:GetPlayerBlood() + .5, 0, 100 ) );
				self:GetTable().NextPlayerBloodHeal = CurTime() + 7;
			
			end
		
		end
		
		if( self:GetPlayerConscious() < 100 ) then
		
			if( CurTime() > self:GetTable().NextPlayerConsciousHeal ) then
			
				self:SetPlayerConscious( math.Clamp( self:GetPlayerConscious() + .5, 0, 100 ) );
				self:GetTable().NextPlayerConsciousHeal = CurTime() + 7;
			
			end			
		
		end
	
	end

	--JUMP CODE--
	--This code is used to monitor jump distance and calls our HandleJumpFall function when the player lands.
	if( not self:GetTable().JumpState ) then

		if( not onGround ) then
		
			self:GetTable().JumpState = true;
			self:GetTable().JumpStartPos = self:GetPos();
		
		end
		
	else
	
		if( onGround ) then
		
			self:GetTable().JumpState = false;
			local dist = self:GetPos().z - self:GetTable().JumpStartPos.z;
			
			if( self:GetPlayerIsInfected() and self:Alive() ) then
			
				self:SetHealth( self:GetTable().BeforeFallHealth );
			
			end
			
			if( not self:GetPlayerIsInfected() and dist < 0 and not self:GetTable().ObserveMode and not self:GetTable().NullifyNextFallDmg ) then
			
				self:HandleJumpFall( math.abs( dist ) );
			
			end
			
			if( self:GetTable().NullifyNextFallDmg ) then
			
				self:GetTable().NullifyNextFallDmg = false;
			
			end
			
		elseif( self:Alive() ) then
		
			self:GetTable().BeforeFallHealth = self:Health();
		
		end
		
	end
	
	--CHARGER CODE--
	--Used to knock people flying.
	if( string.find( string.lower( self:GetModel() ), "charger.mdl" ) ) then
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v:Alive() and ( not ( v == self ) ) ) then
				
				if( inWalk and inSpeed and v:GetPos():Distance( self:GetPos() ) < 80 ) then
					
					v:TakeDamage( 3, self, self );
					v:SetVelocity( ( self:GetPos() - v:GetPos() ):Normalize() * -1000 );
					
				end
				
			end
			
		end
		
	end
	
	--JOGGING CODE--
	--This code creates a differentiation between jogging and sprinting.
	-- Sprinting is when both the walk key and the sprint key are pressed.
	if( inSpeed and inWalk ) then
	
		if( not self:GetTable().IsSprinting ) then
		
			self:SetRunSpeed( self:GetTable().SprintSpeed or 400 );
			self:GetTable().IsSprinting = true;
		
		end
	
	else
	
		if( self:GetTable().IsSprinting ) then
			
			if( self:GetTable().NoSprintMode ) then
			
				self:NoSprintMovement();
			
			else
			
				self:ApplyMovementSpeeds();
				
			end
			
			self:GetTable().IsSprinting = false;
	
		end
		
	end
	
	--Handles sprint meter
	if( self:GetTable().NextSprintUpdate < CurTime() ) then
		
		self:GetTable().NextSprintUpdate = CurTime() + .2;
		local sprint = self:GetPlayerSprint();
		
		if( not self:GetTable().ObserveMode and speed > 10 ) then
			
			if( inSpeed ) then
				
				if( not self:GetPlayerIsInfected() ) then
				
					if( inWalk ) then
						
						sprint = sprint - self:GetTable().RunDegradeAmount;
						
					else
						
						sprint = sprint - self:GetTable().RunDegradeAmount * .4;
						
					end
					
				end	
				
				if( sprint <= 0 and not self:GetTable().NoSprintMode ) then
				
					self:NoSprintMovement();
					self:GetTable().NoSprintMode = true;
				
				elseif( self:GetTable().NoSprintMode ) then
				
					--Don't apply normal movement speeds until after sprint gets back up to 15`
					if( sprint > 15 ) then
				
						self:ApplyMovementSpeeds();
						self:GetTable().NoSprintMode = false;
					
					end
					
				end
				
			else
				
				sprint = sprint + .05;
				
			end
				
		else
			
			sprint = sprint + .25;
			
		end

		self:SetPlayerSprint( math.Clamp( sprint, 0, 100 ) );

	end
	
	if( self:GetTable().HealingLimbs ) then
		
		--Handle limb health healing
		for k, v in pairs( self:GetTable().HealingLimbs ) do
		
			if( CurTime() > v ) then
			
				self["SetPlayer" .. k .. "HP"]( self, math.Clamp( self["GetPlayer" .. k .. "HP"]( self ) + math.random( 2, 4 ), 0, 100 ) );
				self:GetTable().HealingLimbs[k] = CurTime() + 6;
				
				if( self["GetPlayer" .. k .. "HP"]( self ) >= 100 ) then
				
					self:GetTable().HealingLimbs[k] = nil;
				
				end
			
			end
		
		end
		
	end
	
	self:DoModelSpecificSounds();

end

hook.Add( "PlayerFootstep", "ModelSpecificFootstep", function( ply, pos, foot, snd, vol, rf )
	
	ply:DoModelSpecificFootsteps( pos );
	
end );
