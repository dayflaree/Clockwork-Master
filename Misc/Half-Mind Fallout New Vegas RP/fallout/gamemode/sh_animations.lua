animation = animation or { lists = { } } // nutscript/catherine animation code

function animation.Register( class, mdl )
	animation.lists[ mdl:lower( ) ] = class
end

function animation.RegisterDataTable( class, dataTable )
	animation[ class ] = dataTable
end

function animation.Get( mdl )
	mdl = mdl:lower( )
	
	return animation.lists[ mdl ] or ( mdl:find( "female" ) and "citizen_female" or "citizen_male" )
end

function animation.IsClass( ent, class )
	return animation.lists[ ent:GetModel( ):lower( ) ] == class
end

animation.RegisterDataTable( "citizen_male", {
	normal = {
		idle = { ACT_IDLE, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED }
	},
	pistol = {
		idle = { ACT_IDLE, "shootp1" },
		idle_crouch = { "lookoutidle", "crouch_shoot_pistol" },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = "reload_pistol"
	},
	smg = {
		idle = { ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = "reload_smg1"
	},
	ar2 = {
		idle = { "idle_alert_01", "idle_ar2_aim" },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = "shoot_ar2",
		reload = "reload_smg1"
	},
	shotgun = {
		idle = { ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	grenade = {
		idle = { ACT_IDLE, ACT_IDLE_MANNEDGUN },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		idle = { ACT_IDLE_SUITCASE, ACT_IDLE_ANGRY_MELEE },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH },
		run = { ACT_RUN, ACT_RUN },
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = {
		[ "prop_vehicle_prisoner_pod" ] = { "podpose", Vector( -3, 0, 0 ) },
		[ "prop_vehicle_jeep" ] = { "sitchair1", Vector( 14, 0, -14 ) },
		[ "prop_vehicle_airboat" ] = { "sitchair1", Vector( 8, 0, -20 ) },
		chair = { "sitchair1", Vector( 1, 0, -23 ) }
	},
} )

animation.RegisterDataTable( "citizen_female", {
	normal = {
		idle = { ACT_IDLE, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED }
	},
	pistol = {
		idle = { ACT_IDLE_PISTOL, "shootp1" },
		idle_crouch = { "lookoutidle", "crouch_shoot_pistol" },
		walk = { ACT_WALK, ACT_WALK_AIM_PISTOL },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_PISTOL },
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_RELOAD_PISTOL
	},
	smg = {
		idle = { ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1
	},
	ar2 = {
		idle = { "idle_alert_01", "idle_ar2_aim" },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = "shoot_ar2",
		reload = "reload_smg1"
	},
	shotgun = {
		idle = { ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	grenade = {
		idle = { ACT_IDLE, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		idle = { ACT_IDLE, ACT_IDLE_MANNEDGUN },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH },
		run = { ACT_RUN, ACT_RUN },
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = animation.citizen_male.vehicle
} )

animation.RegisterDataTable( "supermutant", {
	normal = {
		idle = { "mtidle", "h2haim" },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED }
	},
	pistol = {
		idle = { ACT_IDLE, "shootp1" },
		idle_crouch = { "lookoutidle", "crouch_shoot_pistol" },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = "reload_pistol"
	},
	smg = {
		idle = { ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1 },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = "reload_smg1"
	},
	ar2 = {
		idle = { "2haaim", "2haaim" },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { "2haaim_walk", "2haaim_walk" },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { "2haaim_run", "2haaim_run" },
		attack = "shoot_ar2",
		reload = "reload_smg1"
	},
	shotgun = {
		idle = { "2hraim", "2hraim" },
		idle_crouch = { ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW },
		walk = { ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	grenade = {
		idle = { ACT_IDLE, ACT_IDLE_MANNEDGUN },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE },
		run = { ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED },
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		idle = { ACT_IDLE_SUITCASE, ACT_IDLE_ANGRY_MELEE },
		idle_crouch = { ACT_COVER_LOW, ACT_COVER_LOW },
		walk = { ACT_WALK, ACT_WALK_AIM_RIFLE },
		walk_crouch = { ACT_WALK_CROUCH, ACT_WALK_CROUCH },
		run = { ACT_RUN, ACT_RUN },
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = {
		[ "prop_vehicle_prisoner_pod" ] = { "podpose", Vector( -3, 0, 0 ) },
		[ "prop_vehicle_jeep" ] = { "sitchair1", Vector( 14, 0, -14 ) },
		[ "prop_vehicle_airboat" ] = { "sitchair1", Vector( 8, 0, -20 ) },
		chair = { "sitchair1", Vector( 1, 0, -23 ) }
	},
} )

animation.RegisterDataTable( "gutsy", {
	normal = {
		idle = { "mtidle", "1hmaim" },
		idle_crouch = { "mtidle", "1hmaim" },
		walk = { "walk", "walk" },
		walk_crouch = { "walk", "walk" },
		run = { "run", "run" }
	},
	glide = "run",
} )

animation.RegisterDataTable( "player", {
	normal = {
		[ACT_MP_STAND_IDLE] = "idle_all_01",
		[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH,
		[ACT_MP_WALK] = ACT_HL2MP_WALK,
		[ACT_MP_RUN] = "run_all_panicked"
	},
	passive = {
		[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_PASSIVE,
		[ACT_MP_WALK] = ACT_HL2MP_WALK_PASSIVE,
		[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_PASSIVE,
		[ACT_MP_RUN] = ACT_HL2MP_RUN_PASSIVE
	}
} )

animation.Register( "citizen_male", "models/thespireroleplay/humans/group013/male.mdl" )
animation.Register( "gutsy", "models/fallout/mistergutsy.mdl" )
animation.Register( "player", "models/thespireroleplay/humans/group200/male.mdl" )

for _,v in pairs( GM.SupermutantModels ) do

	animation.Register( "supermutant", v );

end

Weapon_HoldType = { }
Weapon_HoldType[ "" ] = "normal"
Weapon_HoldType[ "physgun" ] = "smg"
Weapon_HoldType[ "ar2" ] = "smg"
Weapon_HoldType[ "crossbow" ] = "shotgun"
Weapon_HoldType[ "rpg" ] = "shotgun"
Weapon_HoldType[ "slam" ] = "normal"
Weapon_HoldType[ "grenade" ] = "normal"
Weapon_HoldType[ "fist" ] = "normal"
Weapon_HoldType[ "melee2" ] = "melee"
Weapon_HoldType[ "passive" ] = "normal"
Weapon_HoldType[ "knife" ] = "melee"
Weapon_HoldType[ "duel" ] = "pistol"
Weapon_HoldType[ "camera" ] = "smg"
Weapon_HoldType[ "magic" ] = "normal"
Weapon_HoldType[ "revolver" ] = "pistol"

PlayerHoldType = { }
PlayerHoldType[ "" ] = "normal"
PlayerHoldType[ "fist" ] = "normal"
PlayerHoldType[ "pistol" ] = "normal"
PlayerHoldType[ "grenade" ] = "normal"
PlayerHoldType[ "melee" ] = "normal"
PlayerHoldType[ "slam" ] = "normal"
PlayerHoldType[ "melee2" ] = "normal"
PlayerHoldType[ "passive" ] = "passive"
PlayerHoldType[ "knife" ] = "normal"
PlayerHoldType[ "duel" ] = "normal"
PlayerHoldType[ "bugbait" ] = "normal"

local normalHoldTypes = {
	normal = true,
	fist = true,
	melee = true,
	revolver = true,
	pistol = true,
	slam = true,
	knife = true,
	grenade = true
}
WEAPON_LOWERED = 1
WEAPON_RAISED = 2
local META = FindMetaTable( "Entity" )
local getModel = META.GetModel

local chairs = { }

do
	for k, v in pairs( list.Get( "Vehicles" ) ) do
		if ( v.Category == "Chairs" ) then
			chairs[ v.Model ] = true
		end
	end
end

function META:IsChair( )
	return chairs[ getModel( self ) ]
end

function GM:CalcMainActivity( pl, velo )
	local mdl = pl:GetModel( ):lower( )
	local class = animation.Get( mdl )
	local wep = pl:GetActiveWeapon( )
	local holdType = "normal"
	local status = WEAPON_LOWERED
	local act = "idle"
	
 	if ( velo:Length2D() >= pl:GetRunSpeed() - 10 ) then
		act = "run"
	elseif ( velo:Length2D() >= 5 ) then
		act = "walk"
	end
	
	if ( IsValid( wep ) ) then
		holdType = wep.HoldType
		
		if ( wep:GetClass() == "gmod_tool" or wep:GetClass() == "weapon_physgun" or wep:GetClass() == "weapon_physcannon" ) then
			status = WEAPON_RAISED
		end
	end
	
 	if ( IsValid( wep ) and !(pl:Holstered( )) ) then
		status = WEAPON_RAISED
	end
	
	 
	if ( mdl:find( "/player" ) or mdl:find( "/playermodel" ) or class == "player" ) then
		local calcIdle, calcOver = self.BaseClass:CalcMainActivity( pl, velo )
		
		pl.CalcIdle = calcIdle
		pl.CalcOver = calcOver
		
		return pl.CalcIdle, pl.CalcOver
	end
	
	if ( !(pl:CharID() <= -1) and pl:Alive( ) ) then
		pl.CalcOver = -1
		
		if ( pl:Crouching( ) ) then
			act = act .. "_crouch"
		end
		
		local aniClass = animation[ class ]
		
		if ( !aniClass ) then
			class = "citizen_male"
		end
		
		if ( !aniClass[ holdType ] ) then
			holdType = "normal"
		end
		
		if ( !aniClass[ holdType ][ act ] ) then
			act = "idle"
		end
		
		local ani = aniClass[ holdType ][ act ]
		local val = ACT_IDLE
		
		if ( !pl:OnGround( ) ) then
			pl.CalcIdle = aniClass.glide or ACT_GLIDE
		elseif ( pl:InVehicle( ) ) then
			local vehicleTable = aniClass.vehicle
			local vehicle = pl:GetVehicle( )
			local class = vehicle:IsChair( ) and "chair" or vehicle:GetClass( )
			
			if ( vehicleTable and vehicleTable[ class ] ) then
				local act = vehicleTable[ class ][ 1 ]
				local posFix = vehicleTable[ class ][ 2 ]
				
				pl:ManipulateBonePosition( 0, posFix )
				
				if ( act ) then
					if ( type( act ) == "string" ) then
						pl.CalcOver = pl:LookupSequence( vehicleTable[ class ][ 1 ] )
					else
						pl.CalcIdle = act
					end
				end
			end
		elseif ( ani ) then
			pl:ManipulateBonePosition( 0, vector_origin )
			
			val = ani[ status ]
			
			if ( type( val ) == "string" ) then
				pl.CalcOver = pl:LookupSequence( val )
			else
				pl.CalcIdle = val
			end
		end
		
		if ( CLIENT ) then
			pl:SetIK( false )
		end
		
		pl:SetPoseParameter( "move_yaw", math.NormalizeAngle( velo:Angle( ).yaw - pl:EyeAngles( ).y ) )
		
		return pl.CalcIdle or ACT_IDLE, pl.CalcOver or -1
	end
	
end

GM.ZombieAnimTab = { };
GM.ZombieAnimTab[ACT_MP_STAND_IDLE] = 1703;
GM.ZombieAnimTab[ACT_MP_WALK] = 1628;
GM.ZombieAnimTab[ACT_MP_RUN] = 1621;
GM.ZombieAnimTab[ACT_MP_CROUCH_IDLE] = 1706;
GM.ZombieAnimTab[ACT_MP_CROUCHWALK] = 1633;

function GM:CalcSpecialActivity( ply, vel )
	
	local s = ply:GetSpecialAnimSet();
	
	if( ply:PlayerClass() == PLAYERCLASS_ANIMAL or ( ply:PlayerClass() == PLAYERCLASS_SPECIALINFECTED and !s ) ) then
		
		if( self.ZombieAnimTab[ply.CalcIdeal] ) then
			
			ply.CalcIdeal = self.ZombieAnimTab[ply.CalcIdeal];
			
		end
		
	end
	
	if( s == "FastZombie" ) then
		
		if( self.ZombieAnimTab[ply.CalcIdeal] ) then
			
			ply.CalcIdeal = self.ZombieAnimTab[ply.CalcIdeal];
			
		end
		
		if( ply.CalcIdeal == 1621 ) then
			
			ply.CalcIdeal = 1646;
			
		end
		
		if( ply.CalcIdeal == 1628 ) then
			
			ply.CalcIdeal = 1647;
			
		end
		
		if( ply.CalcIdeal == 1703 ) then
			
			ply.CalcIdeal = 1647;
			
		end
		
	end
	
end