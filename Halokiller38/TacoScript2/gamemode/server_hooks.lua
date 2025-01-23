function ThinkTime()

	for k, v in pairs( player.GetAll() ) do

		if( v.Initialized and v:IsValid() ) then
		
			if( v:Alive() ) then
		
				if( v:GetPlayerConscious() and v:GetPlayerConsciousness() <= 0 ) then
				
					v:Unconscious();
				
				end
				
			end
			
			--Drunk related shit
			if( v:GetPlayerDrunkMul() > 0 ) then
			
				if( CurTime() - v.LastDrunkMulUpdate > 100 ) then
			
					v.LastDrunkMulUpdate = CurTime();
					v:SetPlayerDrunkMul( math.Clamp( v:GetPlayerDrunkMul() - .11, 0, v:GetPlayerDrunkMul() ) );
				
				end
				
				if( CurTime() - v.LastDrunkWalkUpdate > .8 ) then
				
					v.LastDrunkWalkMul = math.random( -35 * v:GetPlayerDrunkMul(), 35 * v:GetPlayerDrunkMul() );
					v.LastDrunkWalkUpdate = CurTime();
		
				end
				
				if( v:KeyDown( IN_FORWARD ) or v:KeyDown( IN_BACKWARD ) ) then
				
					v:SetVelocity( v:GetRight() * v.LastDrunkWalkMul );
					
				end
				
				if( v:GetPlayerDrunkMul() >= 1.6 ) then
				
					v:SetPlayerDrunkMul( .6 );
					v:CallEvent( "HangOver" );
					v:SetPlayerConsciousness( math.Clamp( v:GetPlayerConsciousness() - 80, 0, 100 ) );
					v:Unconscious();
				
				end
				
			end
		
			--Consciousness related shit
			if( v:GetPlayerConscious() ) then
			
				if( CurTime() - v.LastConsciousRecover > 5 and v:GetPlayerConsciousness() < 100 ) then
					v:SetPlayerConsciousness( math.Clamp( v:GetPlayerConsciousness() + 1, 0, 100 ) );
					v.LastConsciousRecover = CurTime();
				end
			
			else
			
				if( CurTime() - v.LastConsciousRecover > 1 and v:GetPlayerConsciousness() < 100 ) then
					v:SetPlayerConsciousness( math.Clamp( v:GetPlayerConsciousness() + 1, 0, 100 ) );
					v.LastConsciousRecover = CurTime();
				end
				
				if( v:Alive() and v:Health() <= 0 ) then
				
					v.BypassUnconscious = true;
					v:Die();
				
				end				
			
			end
			
			--Stance related shit
			if( v.StanceSit ) then
	
				if( ( v.StanceSitPlayerPos - v:GetPos() ):Length() > 3 ) then
	
					v:SnapOutOfStance();
				
				elseif( v.StanceSitEnt:GetClass() ~= "worldspawn" and ( not v.StanceSitEnt or not v.StanceSitEnt:IsValid() ) ) then
	
					v:SnapOutOfStance();
				
				elseif( v.StanceSitEntPos ~= v.StanceSitEnt:GetPos() ) then
	
					v:SnapOutOfStance();
				
				end
	
			elseif( v.StanceGroundSit ) then
	
				if( ( v.StanceGroundSitPos - v:GetPos() ):Length() > 3 ) then
	
					v:SnapOutOfStance();
					
				end
				
			elseif( v.StanceLean ) then
	
				if( ( v.StanceLeanPos - v:GetPos() ):Length() > 3 ) then
	
					v:SnapOutOfStance();
					
				end
				
			elseif( v.StanceATW ) then
			
				if( ( v.StanceATWPlayerPos - v:GetPos() ):Length() > 3 ) then
	
					v:SnapOutOfStance();
				
				elseif( v.StanceATWEnt:GetClass() ~= "worldspawn" and ( not v.StanceATWEnt or not v.StanceATWEnt:IsValid() ) ) then
	
					v:SnapOutOfStance();
				
				elseif( v.StanceATWEntPos ~= v.StanceATWEnt:GetPos() ) then
	
					v:SnapOutOfStance();
				
				end			
			
			end
	
			--Holster/unholster related shit
			local weap = v:GetActiveWeapon();
			
			if( weap:IsValid() ) then
			
				local class = weap:GetClass();
				
				if( v.HandPickUpSent and v.HandPickUpSent:IsValid() ) then
					if( class ~= "ts2_hands" ) then
						v:RemoveHandPickUp();
					end
				end
				
				if( v.RightHandEntity and v.RightHandEntity:IsValid() ) then
				
					if( class ~= "ts2_hands" ) then
						v.RightHandEntity:Remove();
						v.RightHandEntity = nil;
					end
				
				end
			
				if( v.LastWeapon ~= class ) then
				
					v:DropTempWeapon();
		
					v:HandleWeaponChangeTo( class );
				
				end
			
			end
		
			--Process bar related shit
			for n, m in pairs( v.ProcessBars ) do
			
				if( m.ThinkFunc and CurTime() > m.NextThink ) then
				
					local done = false;
					
					if( CurTime() > m.Time + m.TimeDone ) then
						done = true;
					end
				
					m.ThinkFunc( v, done );
				
					m.NextThink = CurTime() + m.ThinkDelay;
				
				end
				
				if( not m.ThinkFunc ) then
				
					if( CurTime() > m.Time + m.TimeDone and not m.Linger ) then
						DestroyProcessBar( n, v );
						player.GetByID( k ).ProcessBars[n] = nil;
					end
				
				end
			
			end
			
			--Bleeding related shit
			if( v:GetPlayerBleeding() and v:Alive() ) then
			
				if( v:Health() <= 10 ) then
				
					v:SetPlayerBleeding( false );
					v.StatusIsInjured = true;
					v.StatusIsCrippled = true;
					
				end
				
				if( CurTime() - v.LastBleedDmg > 5 ) then
				
					local dmg = v.BleedingDmgPerSec;
					local incdmg = v.BleedingIncDmgPerSec;
					
					local mul = .7;
					
					dmg = dmg * mul;
				
					if( dmg < 1 or v.BleedingHealthCatcher > 0 ) then
					
						v.BleedingHealthCatcher = v.BleedingHealthCatcher + dmg;
					
						if( v.BleedingHealthCatcher > 1 ) then
						
							v:SetHealth( v:Health() - math.ceil( v.BleedingHealthCatcher ) );
							v.BleedingHealthCatcher = 0;
						
						end
					
					else
					
						v:SetHealth( v:Health() - dmg );
					
					end
					
					if( v:Health() <= 0 ) then
					
						v.BypassUnconscious = true;
						v:Die();
					
					end
					
					v.LastBleedDmg = CurTime();
				
				end
				
				if( CurTime() - v.LastBleedDecal > 4 ) then
			
					v:BleedOutADecal();
					v.LastBleedDecal = CurTime();
			
				end
			
			end
		
			--Sprint bar related shit
			if( v:KeyDown( IN_SPEED ) and v:GetVelocity():Length() > 60 and v:GetPlayerCanSprint() and not v:InVehicle() and not v.ObserveMode ) then
			
				if( v:GetPlayerSprint() > 0 ) then
			
					if( not v.LastSprintDegrade ) then
					
						v.LastSprintDegrade = CurTime();
					
					elseif( CurTime() - v.LastSprintDegrade > 1 ) then
					
						if( not v:IsCP() ) then
						
							v:SetPlayerSprint( math.Clamp( v:GetPlayerSprint() - TS.SprintDegradeTable[v:GetPlayerEndurance()], 0, 100 ) );
							v.LastSprintDegrade = CurTime();
							
						end
						
						if( CurTime() - v.LastSpeedProgress > 2 ) then
						
							if( math.random( 1, 2 ) == 2 ) then
							
								v:RaiseSpeedProgress( 1 );
								
							end
			
							v.LastSpeedProgress = CurTime();
						
						end
					
					end
					
				else
			
					v:ComputePlayerSpeeds();
				
				end
				
			elseif( v:GetPlayerSprint() < 100 ) then --Regenerate sprint
		
				if( not v.LastSprintFill ) then
				
					v.LastSprintFill = CurTime();
				
				elseif( CurTime() - v.LastSprintFill > 2 ) then
				
					v:SetPlayerSprint( math.Clamp( v:GetPlayerSprint() + TS.SprintFillTable[v:GetPlayerEndurance()], 0, 100 ) );
					v.LastSprintFill = CurTime();
				
					v:ComputePlayerSpeeds();
				
				end
			
			end
			--End sprint bar related shit
			
		end	
	
	end

end
timer.Create("ThinkTime", 0.2, 0, ThinkTime);

function GM:PlayerSay( ply, text )
	return OLM_PlayerSay(ply, text);
end

-- We had to un-GM that
function OLM_PlayerSay( ply, text )
	if( not ply.Initialized ) then return ""; end
	
	if #text > OLM_MAXLENGTH then
		text = string.sub(text, 1, OLM_MAXLENGTH)
	end
	
	local correctcmd = nil;
	local crntlen;
	
	for k, v in pairs( TS.ChatCommands ) do
	
		local len = string.len( v.cmd );
		local chatsub = string.sub( text, 1, len );
		
		if( string.lower( chatsub ) == string.lower( v.cmd ) ) then
		
			if( correctcmd ) then
			
				if( crntlen < len ) then
				
					correctcmd = k;
					crntlen = len;
				
				end
			
			else
			
				correctcmd = k;
				crntlen = len;
		
			end
		
		end
	
	end
	
	if( correctcmd ) then
	
		local ret = ( TS.ChatCommands[correctcmd].cb( ply, TS.ChatCommands[correctcmd].cmd, string.sub( text, crntlen + 1 ) ) or "" );	
	
		if( ret ~= "" and ret ~= " " ) then
		
			if( CurTime() < ply.NextTimeCanChat ) then
				return "";
			end	
			
			if( ply.Muted ) then
				return "";
			end
		
			ply.NextTimeCanChat = CurTime() + TS.ChatDelay;
			ply:SayGlobalChat(ret)
			return "";
		
		end
	
	elseif string.sub(text, 1, 1) == "/" or string.sub(text, 1, 1) == "!" then
	
		if string.find(text, " ") then
			local cutcmd = "";
			cutcmd = string.sub(text, 1, string.find(text, " ") - 1);
			ply:PrintMessage( 3, "Invalid chat command '" .. cutcmd .."'!" );
		else
			ply:PrintMessage( 3, "Invalid chat command '" .. text .."'!" );
		end
	
	else
	
		ply:SayLocalChat( text );
	
	end
	
	return "";

end

function GM:ShowSpare1( ply )

	if( not ply.Initialized ) then
		return;
	end

	umsg.Start( "TPM", ply );
	umsg.End();

end

function GM:ShowSpare2( ply )

	if( not ply.Initialized ) then
		return;
	end

	if( CurTime() - ply.LastF4 < 1 ) then
		return;
	end
	
	ply.LastF4 = CurTime();

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 90;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsPlayer() ) then
		
			ply:OpenPlayerMenu( tr.HitPos, tr.Entity );
		
		elseif( tr.Entity:IsDoor() ) then
		
			ply:OpenDoorMenu( tr.HitPos, tr.Entity );
			
		end
	
	end


end

function GM:ShowHelp( ply )

	if( not ply.Initialized ) then
		return;
	end
	
	if( CurTime() - ply.LastHelp < 1 ) then
		return;
	end
	
	ply.LastHelp = CurTime();		
	
	umsg.Start( "SH", ply );
	umsg.End();

end

function GM:PhysgunPickup( ply, ent )

	return ply:CanPhysGunPickup( ent );

end

function GM:PhysgunDrop( ply, ent )
 
	if( ent:IsValid() and not ply:KeyDown( IN_ATTACK2 ) ) then

	local function EnableMotion( ent )
	 
		ent:GetPhysicsObject():EnableMotion( true );

	end

	ent:GetPhysicsObject():EnableMotion( false );
	timer.Simple( .001, EnableMotion, ent );

	end
 
end

function GM:CanTool( ply, tr, mode )

	if( not ply.Initialized ) then return false; end

	return ply:CanToolThis( tr.Entity, mode );
	
end

BannedModels =
{
	
	"models\props_c17\oildrum001_explosive.mdl",
	"models\props_junk\gascan001a.mdl",
	"models\props_junk\propanecanister001a.mdl",
	"models\props_explosive\explosive_butane_can.mdl",
	"models\props_explosive\explosive_butane_can02.mdl",
	"models\props_junk\propane_tank001a.mdl",
	"models\Advisorpod_crash\Advisor_Pod_crash.mdl",
	"models\Combine_Advisor_Pod\combine_advisor_pod.mdl",
	"models\advisorpod.mdl",
	"models\extras\info_speech.mdl",
	"models/props_phx/mk-82.mdl",
	"models/props_phx/oildrum001_explosive.mdl",
	"models/props_phx/rocket1.mdl",
	"models/props_phx/cannonball.mdl",
	"models/props_phx/misc/flakshell_big.mdl",
	"models/props_phx/ww2bomb.mdl",
	"models/props_phx/torpedo.mdl",

}

function PropIsBanned( model )

	model = string.gsub( model, "/", "\\" );

	for k, v in pairs( BannedModels ) do

		if( string.lower(v) == string.lower(string.gsub( model, "\\", "" ))) then
		
			return true;
			
		end
	
	end
	
	return false;

end

TS.GlobalProps = 0;

function GM:PlayerSpawnProp( ply, model ) 

	if( not ply.Initialized ) then return false; end
	
	if( not TS.PropRecords[ply:SteamID()] ) then
		TS.PropRecords[ply:SteamID()] = 0;
	end
	
	if( TS.GlobalPropLimit ) then
	
		if( TS.GlobalProps > TS.GlobalPropLimit ) then
		
			ply:PrintMessage( 3, "The server has reached its global prop limit!" );
			return false;
			
		end
		
	end
	
	--If the prop is banned and he isn't a SA
	if( PropIsBanned( model ) and not ply:IsSuperAdmin() ) then
	
		ply:PrintMessage( 3, "Cannot spawn prop! Prop is banned!" );
		return false;
		
	end
	
	print("PSP: " .. tostring(TS.PropRecords[ply:SteamID()]) .. "; " .. tostring(ply:GetSQLData("group_max_props")));
	if( TS.PropRecords[ply:SteamID()] > ply:GetSQLData( "group_max_props" ) ) then
	
		ply:PrintMessage( 3, "You have reached your prop limit!" );
		return false;
	
	end
	
	return true;

end

function GM:PlayerSpawnedProp( ply, model, ent ) 

	if( not ent or not ent:IsValid() ) then return; end
	
	--If the player has no TT and the prop is too big ( bigger than console screen #2 )
	if( not ply:HasTT() and ent:GetPhysicsObject():GetMass() > 400 ) then
		
		ply:PrintMessage( 3, "Prop is too big" );
		return;
		
	end
	
	TS.GlobalProps = TS.GlobalProps + 1;

	TS.PropRecords[ply:SteamID()] = TS.PropRecords[ply:SteamID()] + 1;
	
	ent.Creator = ply;
	ent.CreatorSteamID = ply:SteamID();
	ent.CreatorIsRick = ply:IsRick();
	ent.CreatorIsSuperAdmin = ply:IsSuperAdmin();
	ent.CreatorHasTT = ply:HasTT();
	
	ent.CS = ent.Creator:GetRPName() .. " (" .. ent.CreatorSteamID .. ")";
	
	TS.PrintMessageAll( 2, "-- " .. ply:GetRPName() .. " [" .. ply:SteamID() .. "] spawned: " .. model );

end

function GM:PlayerSpawnSENT( ply, class ) 

	if( not ply.Initialized ) then return false; end
	
	if( ply:IsSuperAdmin() or ply:IsRick() ) then return true; end
	
	return false;

end

function GM:PlayerSpawnSWEP( ply, class ) 

	if( not ply.Initialized ) then return false; end
	
	if( ply:IsRick() ) then return true; end
	
	return false;

end

function GM:KeyPress( ply, key )

	if( key == IN_JUMP ) then
	
		if( ply:OnGround() and ply:WaterLevel() < 4 ) then
			ply:SetPlayerSprint( math.Clamp( ply:GetPlayerSprint() - TS.JumpDegradeTable[ply:GetPlayerEndurance()], 0, 100 ) );
		end
		
	end
	
	if( key == IN_USE ) then
	
		if( ply:IsTied() ) then return; end
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 90;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() ) then
		
			if( tr.Entity:IsDoor() ) then
			
				if( not tr.Entity.Locked ) then
			
					if( tr.Entity.DoorFlags and string.find( tr.Entity.DoorFlags, "s" ) and tr.Entity.ItemData ) then
					
					if( tr.Entity.Unlocked ) then
						CreateActionMenu( tr.Entity.DoorName or "", ply, tr.HitPos - Vector( 0, 0, 10 ) );
							SetActionMenuEntity( tr.Entity );
							AddActionOption( "Look inside", "eng_lookinsidemapstorage", 1 );
						EndActionMenu();
					end
					
					end	
					
				end
				
				if( tr.Entity.DoorFlags and string.find( tr.Entity.DoorFlags, "n" ) and ply:CanOpenCombineDoors() ) then
					if not tr.Entity.IsSpecialDoor then
						tr.Entity:Fire( "toggle", "", 0 );
					else
						if tr.Entity.DoorOpened then
							tr.Entity:Fire("setanimation", "close", 0)
							tr.Entity.DoorOpened = false
						else
							tr.Entity:Fire("setanimation", "open", 0)
							tr.Entity.DoorOpened = true
							if tr.Entity.DoorCloseTime then
								timer.Simple(tr.Entity.DoorCloseTime, 
									function() 
										if tr.Entity:IsValid() and tr.Entity.DoorOpened then 
											tr.Entity:Fire("setanimation", "close", 0) 
											tr.Entity.DoorOpened = false
										end 
									end
								)
							end
						end
					end
				end
			
			end
		
		end
		
	end

end

function GM:InitPostEntity()

	TS2InitializedOnce = true;
	
	TS.ConnectToSQL();
	TS.LoadWeapons();
	TS.LoadPhysgunBans();
	TS.LoadMapData();
	

end

function GM:PlayerSpray( ply )

	if( ply:IsAdmin() ) then
	
		return true;
		
	end
	
	return false;
	
end

function GM:PlayerSpawnRagdoll( ply, model )

	return ply:CheckLimit( "ragdolls" );
	
end

function GM:PlayerSpawnEffect( ply, model )

	return ply:CheckLimit( "effects" );

end

function GM:PlayerSpawnVehicle( ply )

	return ply:CheckLimit( "vehicles" );
	
end

function GM:PlayerSpawnSENT( ply, name )
	
	return ply:CheckLimit( "sents" );	
	
end

function GM:PlayerSpawnNPC( ply, npc_type, equipment )

	return ply:CheckLimit( "npcs" );
	
end

function GM:GravGunPunt( ply ) 

	if( ply:IsRick() ) then
	
		return true;
		
	end
	
	return false;
	
end

function GM:EntityRemoved( ent )

	if( ent and ent:IsValid() ) then

		if( ent and ent.CreatorSteamID ) then
	
			if( TS.PropRecords and TS.PropRecords[ent.CreatorSteamID] ) then
		
				TS.PropRecords[ent.CreatorSteamID] = TS.PropRecords[ent.CreatorSteamID] - 1;
				TS.GlobalProps = TS.GlobalProps - 1;
			
			end
			
		end
		
		if( ent:IsNPC() and ent.Owner ) then
		
			if( ent.Owner.SelectedNPCS ) then

				if( ent.Owner.SelectedNPCS[ent:EntIndex()] ) then
			
					ent.Owner.SelectedNPCS[ent:EntIndex()] = nil;
				
				end
		
			end
			
		end
		
	end
	
end

local TerNPCs = {

	"npc_combine_s",
	"npc_strider",
	"npc_turret_floor",
	"npc_manhack",
	"npc_scanner",
	
}

function GM:PlayerSpawnedNPC( ply, npc )

	npc.Owner = ply;
	
	if( table.HasValue( TerNPCs, npc:GetClass() ) ) then
		
		for k, v in ipairs( player.GetAll() ) do
		
			if( v:IsCP() or v.ObserveMode or npc.Owner == v ) then
			
				npc:AddEntityRelationship( v, D_LI, 99 );
			
			end
			
		end
		
		if( npc:GetClass() ~= "npc_manhack" ) then
		
			npc:SetMaxHealth( 800 );
			npc:SetHealth( npc:GetMaxHealth() );
			
		end
	
	end
	
end