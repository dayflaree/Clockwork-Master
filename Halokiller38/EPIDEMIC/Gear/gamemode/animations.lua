
AnimConvert = { }

AnimConvert["gmod_tool"] = "PISTOL";
AnimConvert["weapon_physgun"] = "RIFLE";
AnimConvert["weapon_physcannon"] = "RIFLE";

function FindCorrectAnimTable( model )

	for k, v in pairs( AnimTables ) do
	
		if( table.HasValue( v.Models, string.lower( model ) ) ) then
			return AnimTables[k];
		end
	
	end
	
	return AnimTables[1];

end

-- Anim could be:
-- PLAYER_RELOAD 
-- PLAYER_JUMP 
-- PLAYER_ATTACK1

function SetPlayerAnimation( ply, anim )

	local act = "";
	
	local skipanimation = false;
	local activeweap = ply:GetActiveWeapon();

	if( not ply:GetTable().ForcedAnimationMode and not skipanimation ) then
	
		if( ply:OnGround() and ply:WaterLevel() < 4 ) then
	
			local cansprint = true;
		
			if( ply:Crouching() ) then
				act = "CROUCH";
				cansprint = false;
			else
				act = "STAND";
			end
			
			
			if( activeweap:IsValid() ) then

				if( activeweap:GetTable().TS2HoldType ) then
				
					act = act .. "_" .. activeweap:GetTable().TS2HoldType;
				
				elseif( AnimConvert[activeweap:GetClass()] ) then
				
					act = act .. "_" .. AnimConvert[activeweap:GetClass()];
				
				end
			
			end
			
			--if( not ply:GetPlayerHolstered() ) then
			
				--act = act .. "_AIM";
			
			--end
			
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
		
		local AnimTable = { }
		
		if( ply:GetTable().AnimLastModel ~= ply:GetModel() ) then
		
			ply:GetTable().AnimTable = FindCorrectAnimTable( ply:GetModel() );
			ply:GetTable().AnimLastModel = ply:GetModel();
			
		end
		
		AnimTable = ply:GetTable().AnimTable;

		act = AnimTable.Anim[act] or 1;

	else
	
		act = ply:GetTable().ForcedAnimation;
	
	end

	local seq;

	if( type( act ) == "string" ) then
		seq = ply:LookupSequence( act );
	else
		seq = ply:SelectWeightedSequence( act );
	end
	
	--If we're already playing this sequence, let's not restart it!
	if( ply:GetSequence() == seq ) then return; end

	ply:SetPlaybackRate( 1 );
	ply:ResetSequence( seq );
	ply:SetCycle( 0 );

end
hook.Add( "SetPlayerAnimation", "GearSetPlayerAnimation", SetPlayerAnimation );
