--Animations originally by Rick Dark
--Fixed by Horsey to work with the latest Garry's Mod update( 76 - 06/May/10 )

AnimConvert = { }

AnimConvert["gmod_tool"] = "PISTOL";
AnimConvert["weapon_physgun"] = "RIFLE";
AnimConvert["weapon_physcannon"] = "RIFLE";

function FindCorrectAnimTable( model )

	for k, v in pairs( TS.AnimTables ) do
	
		if( table.HasValue( v.Models, string.lower( model ) ) ) then
			return TS.AnimTables[k];
		end
	
	end
	
	return TS.AnimTables[1];

end

function GM:UpdateAnimation( ply, vel, maxSpeed )

	if( not ply:IsValid() ) then return; end
	
	local len = vel:Length2D();
	local rate = 1.0;
	
	if( len > 0.5 ) then
		rate = len * 0.8 / maxSpeed;
	end
	
	ply:SetPlaybackRate( math.Clamp( rate, 0, 1.5 ) );

end

function GM:CalcMainActivity( ply, velocity )
	if( not ply:IsValid() ) then return; end

	local act = "";
	local unholstered = ply.Unholstered
	local activeweap = ply:GetActiveWeapon();
	
	if( ply.ForcedAnimationMode ) then
	
		if( ply:OnGround() and ply:WaterLevel() < 4 ) then
			return ply.ForcedAnimation, -1;
			
		end
	
	end
	
	if( ply:OnGround() and ply:WaterLevel() < 4 ) then
		
		local cansprint = true;
		
		if( ply:Crouching() ) then
		
			act = "CROUCH";
			cansprint = false;
			
		else
		
			act = "STAND";
			
		end
		
		if( activeweap and activeweap:IsValid() ) then
			
			local weapon = weapons.GetStored( activeweap:GetClass() );
			
			if( weapon ) then
				
				if( weapon.TS2HoldType ) then
				
					act = act .. "_" .. weapon.TS2HoldType;
					
				end
				
			end
			
			if( AnimConvert[activeweap:GetClass()] ) then
				
				act = act .. "_" .. AnimConvert[activeweap:GetClass()];
			
			end
			
		end

		if( unholstered ) then
			
			act = act .. "_AIM";
			
		end
		
		local vel = ply:GetVelocity():Length();

		if( vel == 0 ) then
			
			act = act .. "_idle";
			
		elseif( vel > 120 and cansprint ) then
			
			act = act .. "_run";
			
		else
			
			act = act .. "_walk";
			
		end
		
	else
		
		act = "jump";
		
	end
	
	if( ply:InVehicle() ) then
		
		act = "CROUCH_idle";
		
	end
	
	local AnimTable = { }
	
	if( ply.AnimLastModel ~= ply:GetModel() ) then
		
		ply.AnimTable = FindCorrectAnimTable( ply:GetModel() );
		ply.AnimLastModel = ply:GetModel();
		
	end
	
	AnimTable = ply.AnimTable;

	ply.CalcIdeal = AnimTable.Anim[act] or 1;

	return ply.CalcIdeal, -1;

end

function _R.Weapon:GetHoldType()

end