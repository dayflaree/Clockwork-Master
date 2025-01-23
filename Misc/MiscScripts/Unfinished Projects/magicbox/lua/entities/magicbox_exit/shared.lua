/*-------------------------------------------------------------------------------------------------------------------------
	Magic Box Exit entity information
-------------------------------------------------------------------------------------------------------------------------*/

ENT.Type					= "anim"
ENT.Base					= "base_gmodentity"

ENT.Spawnable			= false
ENT.AdminSpawnable	= false

/*-------------------------------------------------------------------------------------------------------------------------
	Collision trick
-------------------------------------------------------------------------------------------------------------------------*/

hook.Add( "ShouldCollide", "MagicBoxExitCollision", function( ent1, ent2 )
	if ( ent1:IsPlayer() and ent2:GetClass() == "magicbox_exit" ) then
		return ent1:GetVelocity():Angle().y > 250 and ent1:GetVelocity():Angle().y < 280
	elseif ( ent2:IsPlayer() and ent1:GetClass() == "magicbox_exit" ) then
		return ent2:GetVelocity():Angle().y > 250 and ent2:GetVelocity():Angle().y < 280
	end
end )