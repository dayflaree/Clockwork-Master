
local meta = FindMetaTable( "Player" );

function meta:OnUpdateLegHealth( hp )

	if( self:GetPlayerRLegHP() < 60 or
		self:GetPlayerLLegHP() < 60 ) then
		
		self:ApplyLegHealthBasedSpeed();
		
	end

end

function RipToShredsWithChainsaw( ply, target, hitpos )

	if( target:IsPlayer() ) then
	
		target:CallEvent( "HMH" );
	
		local dmg = math.random( 40, 70 );
	
		if( target:Health() - dmg <= 0 ) then
		
			target:GetTable().HitByChainsaw = true;
			
		end
	
		target:TakeHealth( dmg );
		target:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * 30 );
		target:SetPlayerConscious( math.Clamp( target:GetPlayerConscious() - math.random( 60, 80 ), 0, 100 ) );
	
	elseif( target:GetClass() == "ep_commonzombie" ) then
		
		local dmginfo = DamageInfo();
		dmginfo:SetDamage( 120 );
		dmginfo:SetDamagePosition( hitpos );
		dmginfo:SetAttacker( ply );
	
		target:OnTakeDamage( dmginfo, nil, true );
		
	end

end

function HandleMeleeDamage( ply, dmg, force, pos, attacker )

	if( ply:IsPlayer() ) then
		
		if( ply:GetTable().ObserveMode ) then return end
		
		ply:CallEvent( "HMH" );
		ply:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * force );
	
		ply:SetPlayerConscious( math.Clamp( ply:GetPlayerConscious() - force * .85, 0, 100 ) );
		
	elseif( ply:GetClass() == "ep_commonzombie" ) then
		
		local dmginfo = DamageInfo();
		dmginfo:SetDamage( dmg * .4 );
		dmginfo:SetDamagePosition( pos );
		
		if( attacker ) then
		
			dmginfo:SetAttacker( attacker );
	
		end
	
		if( force >= 15 ) then
			ply:OnTakeDamage( dmginfo, nil, nil, true );
		else
			ply:OnTakeDamage( dmginfo, true, nil, true );
		end
	
	end

end

function HandleDoorDamage( door, attacker )
	
	if( !door.DoorHealth ) then
		
		door.DoorHealth = 1;
		
	end
	
	if( attacker:GetClass() == "ep_commonzombie" ) then
		
		if( !attacker.DoorsHit[door:EntIndex()] ) then
			
			attacker.DoorsHit[door:EntIndex()] = 0;
			
		end
		
		if( attacker.DoorsHit[door:EntIndex()] < 4 ) then
			
			attacker.DoorsHit[door:EntIndex()] = attacker.DoorsHit[door:EntIndex()] + 1;
			
		else
			
			return;
			
		end
		
	end
	
	door.DoorHealth = door.DoorHealth + 1;
	
	if( door.DoorHealth >= 10 ) then
		
		local pos = door:GetPos();
		local ang = door:GetAngles();
		local mdl = door:GetModel();
		local skin = door:GetSkin();
	
		door:Remove();
		
		local doorent = ents.Create( "prop_physics" );
		
		doorent:SetPos( pos );
		doorent:SetAngles( ang );
		doorent:SetModel( mdl );
		doorent:SetSkin( skin );
		
		doorent:SetNWInt( "ZombiDoor", 1 );

		doorent:Spawn();
		
		if( attacker:GetClass() == "ep_commonzombie" ) then
			
			local off = ( attacker:GetPos() - doorent:GetPos() ):Normalize();
			doorent:SetVelocity( Vector( off.x * -40000, off.y * -40000, 0 ) );
			
		end

	end
	
end

function HandleChainsawDamage( ply, dmg, force, pos, attacker )

	if( ply:IsPlayer() ) then
	
		if( ply:GetTable().ObserveMode ) then return end
	
		ply:CallEvent( "HMH" );
		ply:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * force );
	
		ply:SetPlayerConscious( math.Clamp( ply:GetPlayerConscious() - force * .85, 0, 100 ) );
	
		if( ply:Health() - dmg <= 0 ) then
			
			ply:GetTable().HitByChainsaw = true;
			
		end
		
		ply:TakeHealth( dmg );
		
	elseif( ply:GetClass() == "ep_commonzombie" ) then
	
		local dmginfo = DamageInfo();
		dmginfo:SetDamage( dmg * .4 );
		dmginfo:SetDamagePosition( pos );
		
		if( attacker ) then
		
			dmginfo:SetAttacker( attacker );
	
		end
	
		ply:OnTakeDamage( dmginfo, nil, true );
	
	end

end

function HandleHeadDamage( ply, dmginfo )

	dmginfo:SetDamage( ply:Health() );
	ply:GetTable().HeadShot = true;
	
	return dmginfo;

end

function HandleChestDamage( ply, dmginfo )

	ply:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * 6 );
	
	local mul = 6;

	if( ply:GetPlayerArmor() > 30 ) then
		
		mul = 4;
		ply:SetPlayerArmor( math.Clamp( ply:GetPlayerArmor() - dmginfo:GetDamage() * mul, 0, 100 ) );
		mul = -100;
	
	elseif( ply:GetPlayerArmor() > 0 ) then
		
		ply:SetPlayerArmor( math.Clamp( ply:GetPlayerArmor() - dmginfo:GetDamage() * mul, 0, 100 ) );
		mul = 2;
	
	end
	
	ply:SetPlayerBleedingAmount( 1.5 * ( ply:GetPlayerBleedingAmount() + dmginfo:GetDamage() * math.Rand( .05, .15 ) ) );
	
	dmginfo:SetDamage( dmginfo:GetDamage() * mul );
	
	return dmginfo;

end

function HandleArmDamage( ply, dmginfo, type )

	ply:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * 3 );
	
	local mul = .3;
	
	if( type == 1 ) then
	
		ply:SetPlayerRArmHP( math.Clamp( ply:GetPlayerRArmHP() - dmginfo:GetDamage() * 3, 0, 100 ) );
	
	else
	
		ply:SetPlayerLArmHP( math.Clamp( ply:GetPlayerLArmHP() - dmginfo:GetDamage() * 3, 0, 100 ) );
	
	end
	
	ply:SetPlayerBleedingAmount( 1 * ( ply:GetPlayerBleedingAmount() + dmginfo:GetDamage() * math.Rand( .01, .05 ) ) );
	
	dmginfo:SetDamage( dmginfo:GetDamage() * mul );
	
	return dmginfo;

end

function HandleLegDamage( ply, dmginfo, type )

	ply:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * 3 );

	local mul = .3;

	if( type == 1 ) then
	
		ply:SetPlayerRLegHP( math.Clamp( ply:GetPlayerRLegHP() - dmginfo:GetDamage() * 3, 0, 100 ) );
	
	else
	
		ply:SetPlayerLLegHP( math.Clamp( ply:GetPlayerLLegHP() - dmginfo:GetDamage() * 3, 0, 100 ) );
	
	end
	
	ply:SetPlayerBleedingAmount( 1 * ( ply:GetPlayerBleedingAmount() + dmginfo:GetDamage() * math.Rand( .01, .1 ) ) );
	
	dmginfo:SetDamage( dmginfo:GetDamage() * mul );
	
	return dmginfo;

end

local DamageFuncs = { }

DamageFuncs[HITGROUP_HEAD] = { Func = HandleHeadDamage };
DamageFuncs[HITGROUP_CHEST] = { Func = HandleChestDamage };
DamageFuncs[HITGROUP_STOMACH] = { Func = HandleChestDamage };
DamageFuncs[HITGROUP_RIGHTARM] = { Func = HandleArmDamage, Spec = 1 };
DamageFuncs[HITGROUP_RIGHTLEG] = { Func = HandleLegDamage, Spec = 1 };
DamageFuncs[HITGROUP_LEFTARM] = { Func = HandleArmDamage, Spec = 2 };
DamageFuncs[HITGROUP_LEFTLEG] = { Func = HandleLegDamage, Spec = 2 };


function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if( ply:GetTable().LastRecodedDmg == dmginfo:GetDamage() ) then
	
		ply:GetTable().LastRecodedDmg = nil;
		return;
	
	end

	if( ply:GetTable().ObserveMode ) then
		dmginfo:SetDamage( -1000 );
		return dmginfo;
	end

	ply:EmitSound( "weapons/crossbow/hitbod2.wav", 100, 170 );

	if( DamageFuncs[hitgroup] ) then

		dmginfo = DamageFuncs[hitgroup].Func( ply, dmginfo, DamageFuncs[hitgroup].Spec );
	
	else
	
		dmginfo = HandleChestDamage( ply, dmginfo );
	
	end
	
	if( dmginfo ) then
	
		ply:GetTable().LastRecodedDmg = dmginfo:GetDamage();
	
	end
	
	ply:CallEvent( "HH" );
	
	return dmginfo;

end

