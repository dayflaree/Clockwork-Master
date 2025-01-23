local PLAYER = { };

PLAYER.DisplayName			= "Infected";
PLAYER.TeammateNoCollide	= false;
PLAYER.AvoidPlayers			= false;
PLAYER.CanUseFlashlight		= true;

function PLAYER:GetHandsModel()
	
	if( self.Player:PlayerClass() == PLAYERCLASS_SUPERMUTANT ) then
		
		return { model = "models/weapons/c_arms_cstrike.mdl", skin = 0, body = "0000000" };
		
	else
		
		local model = self.Player:GetModel();
		local s = 0;
		local arms,armsSkin = GAMEMODE:GetModelArms( model, self.Player:Face(), self.Player:Facemap() );
		
		return { model = "models/thespireroleplay/humans/group100/arms.mdl", skin = (armsSkin or 0), body = "0000000" };
		
	end

end

function PLAYER:StartMove( move )
end

function PLAYER:FinishMove( move )
end

player_manager.RegisterClass( "player_infected", PLAYER, "player_sandbox" );