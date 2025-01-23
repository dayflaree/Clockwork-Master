AnimConvert = { }

AnimConvert["gmod_tool"] = "PISTOL";
AnimConvert["weapon_physgun"] = "RIFLE";
AnimConvert["weapon_physcannon"] = "RIFLE";

function FindCorrectAnimTable( model )

	for k, v in pairs( AnimTables ) do
	
		if( table.HasValue( v.Models, string.lower( model ) ) ) then
			return k;
		end
	
	end
	
	return 1;

end

local NeedManualRotation = {
	"cyclops.mdl",
	"necropolis/bloodsucker",
	"necropolis/boomer",
	"boomette.mdl",
	"charger.mdl",
	"failure.mdl",
	"gigante.mdl",
	"snork.mdl",
	"ghoul.mdl",
	"zombie/classic.mdl",
	"zombie/classic_torso.mdl",
	"zombie/fast_torso.mdl",
	"zombie/fast.mdl",
	"zombie/zombie_soldier.mdl",
	"fat.mdl",
	"spitter.mdl",
	"models/props_outland/pumpkin01.mdl",
	"models/lostcoast/fisherman/fisherman.mdl",
	"models/scientist.mdl"
};

function GM:UpdateAnimation( ply, velocity, maxspeed )
	
	local len2d = velocity:Length2D();
	local dotF = velocity:DotProduct( ply:GetForward() ) / 90;
	local dotR = velocity:DotProduct( ply:GetRight() ) / 90;
	
	local eye = ply:EyeAngles();
	
	if( CLIENT ) then
		
		if( ply:GetPoseParameter( "aim_yaw" ) == 0 ) then
			
			local ang = ply:EyeAngles();
			ply:SetRenderAngles( ang );
			
		end
		
	end
	
end

function GM:CalcMainActivity( ply, velocity )
	
	local act = "";
	
	local skipanimation = false;
	local activeweap = ply:GetActiveWeapon();
	
	local ForcedAnimTime = ply.ForcedAnimTime or 0;
	local ForcedAnimStart = ply.ForcedAnimStart or 0;
	
	local customanim = false;
	
	local vel2d = velocity:Length2D();
	
	if( ForcedAnimTime == -1 or CurTime() - ForcedAnimStart < ForcedAnimTime ) then
		
		customanim = true;
		
	end
	
	if( not customanim and not skipanimation ) then
		
		local cansprint = true;
		
		if( ply:Crouching() ) then
			act = "CROUCH";
			cansprint = false;
		else
			act = "STAND";
		end
		
		if( ply:GetTable().AnimTable and AnimTables[ply:GetTable().AnimTable]._NOWEPS ) then
			
			if( ply:OnGround() and ply:WaterLevel() < 4 ) then
				
				if( vel2d == 0 ) then
				
					act = act .. "_idle";
				
				elseif( vel2d > 120 and cansprint ) then
				
					if( ply:KeyDown( IN_WALK ) ) then
					
						act = act .. "_run";
					
					else
				
						act = act .. "_jog";
				
					end
				
				else
				
					act = act .. "_walk";
				
				end
				
			else
			
				act = "jump";
			
			end
			
		else
			
			if( ply:OnGround() and ply:WaterLevel() < 4 ) then
				
				if( activeweap:IsValid() ) then
					
					if( activeweap:GetTable() and activeweap:GetTable().EpiHoldType ) then
						
						if( activeweap:GetTable().EpiHoldType == "SHOTGUN" ) then
							act = act .. "_RIFLE";
						elseif( activeweap:GetTable().EpiHoldType == "SNIPER" ) then
							act = act .. "_RIFLE";
						else
							act = act .. "_" .. activeweap:GetTable().EpiHoldType;
						end
					
					elseif( AnimConvert[activeweap:GetClass()] ) then
					
						act = act .. "_" .. AnimConvert[activeweap:GetClass()];
					
					end
				
				end
				
				if( !ply:GetNWBool( "Holstered", true ) ) then
				
					act = act .. "_AIM";
				
				end

				if( vel2d == 0 ) then
				
					act = act .. "_idle";
				
				elseif( vel2d > 120 and cansprint ) then
				
					if( ply:KeyDown( IN_WALK ) ) then
					
						act = act .. "_run";
					
					else
				
						act = act .. "_jog";
				
					end
				
				else
				
					act = act .. "_walk";
				
				end
				
			else
			
				act = "jump";
			
			end
			
		end
		
		if( ply:InVehicle() and ply:GetTable().AnimTable and ( AnimTables[ply:GetTable().AnimTable].Anim["vehicle"] ) ) then
			
			act = "vehicle";
			
		end
		
		if( ply:GetTable().AnimLastModel ~= ply:GetModel() ) then
			
			ply:GetTable().AnimTable = FindCorrectAnimTable( ply:GetModel() );
			ply:GetTable().AnimLastModel = ply:GetModel();
			
		end
		
		local key = act;
		
		act = AnimTables[ply:GetTable().AnimTable].Anim[key] or 1;
		
		if( ply:GetNWBool( "Holstered", true ) and !string.find( key, "PISTOL" ) and !string.find( key, "SMG" ) and !string.find( key, "RIFLE" ) ) then
			
			act = DoChosenAnim( ply, key, act );
			
		end

	else
	
		act = ply.ForcedAnimation;
	
	end
	
	if( string.find( ply:GetNWString( "RPName" ), "Donglord" ) ) then return ACT_ROLL_LEFT, -1; end
	
	if( type( act ) == "string" ) then
		return 1, ply:LookupSequence( act );
	end
	
	return act, -1;
	
end


function DoChosenAnim( ply, key, act )
	
	if( string.find( key, "STAND" ) and string.find( key, "idle" ) ) then
		
		if( ply:GetNWInt( "SelectedIdleAnim", 1 ) > 1 and ply:GetTable().AnimTable ) then
			
			if( ply:GetTable().AnimTable == 1 ) then
				
				if( ply:GetNWInt( "SelectedIdleAnim", 1 ) == 2 ) then -- Crossed Arms
					
					return "LineIdle02";
					
				elseif( ply:GetNWInt( "SelectedIdleAnim", 1 ) == 3 ) then -- Hands in Pockets
					
					return "LineIdle04";
					
				end
				
			elseif( ply:GetTable().AnimTable == 3 ) then
				
				if( ply:GetNWInt( "SelectedIdleAnim", 1 ) == 2 ) then
					
					return "LineIdle01";
					
				elseif( ply:GetNWInt( "SelectedIdleAnim", 1 ) == 3 ) then
					
					return "LineIdle03";
					
				elseif( ply:GetNWInt( "SelectedIdleAnim", 1 ) == 4 ) then
					
					return "LineIdle02";
					
				end
				
			end
			
		end
		
	end
	
	if( string.find( key, "CROUCH" ) and string.find( key, "idle" ) ) then
		
		if( ply:GetNWInt( "SelectedCrouchAnim", 1 ) > 1 and ply:GetTable().AnimTable ) then
			
			if( ply:GetTable().AnimTable == 1 ) then
				
				if( ply:GetNWInt( "SelectedCrouchAnim", 1 ) == 2 ) then -- kungfu
					
					return "crouchidlehide";
					
				elseif( ply:GetNWInt( "SelectedCrouchAnim", 1 ) == 3 ) then -- kneel
					
					return "d2_coast03_prebattle_kneel_idle";
					
				end
				
			elseif( ply:GetTable().AnimTable == 3 ) then
				
				if( ply:GetNWInt( "SelectedCrouchAnim", 1 ) == 2 ) then -- kungfu
					
					return "crouchidlehide";
					
				end
				
			end
			
		end
		
	end
	
	if( string.find( key, "STAND" ) and string.find( key, "walk" ) ) then
		
		if( ply:GetNWInt( "SelectedWalkAnim", 1 ) > 1 and ply:GetTable().AnimTable ) then
			
			if( ply:GetTable().AnimTable == 1 ) then
				
				if( ply:GetNWInt( "SelectedWalkAnim", 1 ) == 2 ) then -- Crossed Arms
					
					return "pace_all";
					
				end
				
			elseif( ply:GetTable().AnimTable == 3 ) then
				
				
				
			end
			
		end
		
	end
	
	return act;
	
end

function ForceSequence( ply, anim, time )
	
	if( SERVER ) then
		
		umsg.Start( "FSP" );
			umsg.Entity( ply );
			umsg.String( anim );
			umsg.Short( time or -1 );
		umsg.End();
		
	end
	
	ply:SetCycle( 0 );
	
	ply.ForcedAnimation = anim;
	ply.ForcedAnimStart = CurTime();
	
	if( not time ) then
		
		ply.ForcedAnimTime = -1;
		
	else
		
		ply.ForcedAnimTime = time;
		
	end
	
end

if( CLIENT ) then
	
	function DoAnimEventCl( um )
		
		local ent = um:ReadEntity();
		local act = um:ReadShort();
		
		ent:DoAnimationEvent( act );
		
	end
	usermessage.Hook( "DoAnimEventCl", DoAnimEventCl );

	function msgs.FSP( um )
		
		local ply = um:ReadEntity();
		local anim = um:ReadString();
		local time = um:ReadShort();
		ForceSequence( ply, anim, time );
		
	end
	
	function msgs.RFAT( um )
		
		local ply = um:ReadEntity();
		ply.ForcedAnimTime = 0;
		
	end
	
end