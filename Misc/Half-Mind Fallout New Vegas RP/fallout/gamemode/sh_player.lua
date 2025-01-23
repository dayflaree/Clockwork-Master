local meta = FindMetaTable( "Player" );

function GM:SetupMove( ply, mv, cmd )
	
	if( !ply or !ply:IsValid() ) then return end
	
	if( ply:GetActiveWeapon() != NULL and ply:GetActiveWeapon().Holsterable ) then
	
		if( mv:KeyDown( IN_SPEED ) and !ply:GetNW2Bool( "isDown", false ) ) then
		
			ply:SetNW2Bool( "lastHolsteredState", ply:Holstered() );
			ply:SetHolstered( true );
			
		elseif( !mv:KeyDown( IN_SPEED ) and ply:GetNW2Bool( "isDown", false ) and !ply:GetNW2Bool( "lastHolsteredState", false ) ) then
		
			ply:SetHolstered( false );
			
		end
		
		ply:SetNW2Bool( "isDown", mv:KeyDown( IN_SPEED ) );

	end

end

function GM:PlayerFootstep( ply, pos, foot, s, vol, rf ) -- only triggers when +sprint and +walk???

 	if( ply:PlayerClass() == PLAYERCLASS_SUPERMUTANT and ply:GetModel() != "models/fallout/mistergutsy.mdl" ) then
		
		if( ply:GetVelocity():Length2D() > 150 ) then
		
			if( foot == 0 ) then
			
				ply:EmitSound( "Footstep.Supermutant_Left" );
				return true;
				
			else
			
				ply:EmitSound( "Footstep.Supermutant_Right" );
				return true;
				
			end
			
		else
		
			if( foot == 0 ) then
			
				ply:EmitSound( "Footstep.Supermutant_Left" );
				return true;
				
			else
			
				ply:EmitSound( "Footstep.Supermutant_Right" );
				return true;
				
			end
		
		end

		return true;
		
	end
	
	self.BaseClass:PlayerFootstep( ply, pos, foot, s, vol, rf );
	
end

function GM:PlayerSay() return false end

function meta:GetSpecialAnimSet()
	
	if( self:PlayerClass() == PLAYERCLASS_SPECIALINFECTED and self:GetModel() == "models/player/odessa.mdl" ) then
		
		return "FastZombie";
		
	end
	
end

function meta:GetSpecialInfectedType()
	
	if( self:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		if( self:GetModel() == "models/player/odessa.mdl" ) then
			
			return SI_JUMPER;
			
		end
		
		if( self:GetModel() == "models/player/p2_chell.mdl" ) then
			
			return SI_SCREAMER;
			
		end
		
	end
	
end