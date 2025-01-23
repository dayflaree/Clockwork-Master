PLUGIN.Name = "Core Plugin"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "Configures the gamemode on a deeper level."; -- The description or purpose of the plugin

-- !!!! WARNING !!!! --
-- DO NOT REMOVE ANYTHING IN THIS FILE OR YOUR SERVER WILL CEASE TO FUNCTION.
-- !!!! WARNING !!!! --

LEMON.AddDataField( 1, "characters", { } );
LEMON.AddDataField( 1, "warnings", 0 ) --Warnings
LEMON.AddDataField( 1, "tested", 0 ) --This field determines if the player has taken the RP Quiz before.
-- These fields are what would be the default value, and it also allows the field to actually EXIST.
-- If there is a field in the data and it isn't added, it will automatically be removed.

-- Character Fields
LEMON.AddDataField( 2, "name", "Set Your Name" ); -- Let's hope this never gets used.
LEMON.AddDataField( 2, "model", "models/player/group01/male_07.mdl" );
LEMON.AddDataField( 2, "title", LEMON.ConVars[ "Default_Title" ] ); -- What is their default title.
LEMON.AddDataField( 2, "money", LEMON.ConVars[ "Default_Money" ] ); -- How much money do players start out with.
LEMON.AddDataField( 2, "flags", LEMON.ConVars[ "Default_Flags" ] ); -- What flags do they start with.
LEMON.AddDataField( 2, "inventory", LEMON.ConVars[ "Default_Inventory" ] ); -- What inventory do they start with
LEMON.AddDataField( 2, "rads", 1 )



function GM:PlayerCanPickupWeapon( ply, ent )


	
	if( ply:GetTable().ForceGive ) then
		return true;
	end

	if( ply:KeyDown( IN_USE ) ) then
	
	local tr = ply:GetEyeTrace();

	if( ValidEntity( tr.Entity ) and tr.Entity:IsWeapon() and tr.Entity:GetPos():Distance( ply:EyePos() ) < 70 and tr.Entity == ent ) then

	ply:GetTable().ForceGive = true
	ply:Give( ent:GetClass() );
    ply:GetTable().ForceGive = false
	
	
	tr.Entity:Remove();
	
	end
	
	end
			
	
	return false;

end
