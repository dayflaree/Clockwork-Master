PLUGIN.Name = "Limits"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "Limit prop, ragdoll, vehicle, and effect limits on a player by player basis. Useful for donators."; -- The description or purpose of the plugin

local SpawnTable = {};

function LEMON.MaxProps(ply)

	return tonumber(LEMON.ConVars[ "PropLimit" ]) + tonumber(LEMON.GetPlayerField(ply, "extraprops"));
	
end

function LEMON.MaxRagdolls(ply)

	return tonumber(LEMON.ConVars[ "RagdollLimit" ]) + tonumber(LEMON.GetPlayerField(ply, "extraragdolls"));
	
end

function LEMON.MaxVehicles(ply)

	return tonumber(LEMON.ConVars[ "VehicleLimit" ]) + tonumber(LEMON.GetPlayerField(ply, "extravehicles"));
	
end

function LEMON.MaxEffects(ply)

	return tonumber(LEMON.ConVars[ "EffectLimit" ]) + tonumber(LEMON.GetPlayerField(ply, "extraeffects"));
	
end

function LEMON.MaxLetters(ply)

	return tonumber(LEMON.ConVars[ "LetterLimit" ]) + tonumber(LEMON.GetPlayerField(ply, "extraletters"));
	
end

function LEMON.CreateSpawnTable(ply)
	
	SpawnTable[LEMON.FormatSteamID(ply:SteamID())] = {};
	
	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	spawntable.props = {};
	spawntable.ragdolls = {};
	spawntable.vehicles = {};
	spawntable.effects = {};

end

function GM:PlayerSpawnProp(ply, mdl)

    if( LEMON.GetPlayerField(ply, "tooltrust" ) != 1 ) then  
	LEMON.SendChat( ply, "[SERVER] Need tooltrust to spawn props, sorry :(." );
	return false;
	end

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.props) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.props[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= LEMON.MaxProps(ply)) then
		
			LEMON.SendChat(ply, "You have reached your limit! (" .. LEMON.MaxProps(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		LEMON.CreateSpawnTable(ply)
		local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
		return true;
		
	end

end

function GM:PlayerSpawnedProp( ply, mdl, prop )
	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.props, ent);

if( table.HasValue( Containers, mdl ) ) then

prop.inventory = { };
if( mdl == "models/props_c17/FurnitureDresser001a.mdl" or mdl == "models/props_c17/FurnitureDrawer003a.mdl" ) then
prop:SetNWInt( "limit", 5 )
elseif( mdl == "models/Items/item_item_crate.mdl" or mdl == "models/props_wasteland/controlroom_filecabinet001a.mdl" or mdl == "models/props_c17/oildrum001.mdl" or mdl == "models/props_interiors/Furniture_Couch01a.mdl" or mdl == "models/props_interiors/Furniture_Couch02a.mdl" or mdl == "models/props_borealis/bluebarrel001.mdl" or mdl == "models/props_interiors/Furniture_Desk01a.mdl" ) then
prop:SetNWInt( "limit", 1 )
elseif( mdl == "models/props_c17/FurnitureDrawer002a.mdl" or mdl == "models/props_trainstation/trashcan_indoor001a.mdl" or mdl == "models/props_trainstation/trashcan_indoor001b.mdl" or mdl == "models/props_junk/wood_crate001a.mdl" or mdl == "models/props_junk/TrashBin01a.mdl" or mdl == "models/props_junk/wood_crate001a_damaged.mdl" or mdl == "models/props_wasteland/controlroom_filecabinet002a.mdl" ) then

prop:SetNWInt( "limit", 3 )

elseif( mdl == "models/props_wasteland/controlroom_storagecloset001b.mdl" or mdl == "models/props_junk/wood_crate002a.mdl" or mdl == "models/props_c17/Lockers001a.mdl" or mdl == "models/props_combine/breendesk.mdl" or mdl == "models\props/CS_militia/footlocker01_closed.mdl" ) then

prop:SetNWInt( "limit", 4 )

elseif( mdl == "models/props_wasteland/controlroom_storagecloset001a.mdl" or mdl == "models/Items/ammocrate_grenade.mdl" or mdl == "models/Items/ammocrate_ar2.mdl" or mdl == "models/Items/ammocrate_smg1.mdl" or mdl == "models/Items/ammoCrate_Rockets.mdl" ) then

prop:SetNWInt( "limit", 7 )

elseif( mdl == "models/props_junk/TrashDumpster01a.mdl" ) then

prop:SetNWInt( "limit", 15 )

end

prop:SetNWBool( "container", true ) 

end

for k,v in pairs( player.GetAll() ) do
	LEMON.SendConsole(v, "\n"..ply:Nick().." Spawned ".. tostring(mdl) )
end

end

function GM:PlayerSpawnRagdoll(ply, mdl)

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.ragdolls) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.ragdolls[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= LEMON.MaxRagdolls(ply)) then
		
			LEMON.SendChat(ply, "You have reached your limit! (" .. LEMON.MaxRagdolls(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		LEMON.CreateSpawnTable(ply)
		local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
		table.insert(spawntable.ragdolls, mdl);
		return true;
		
	end
	
	for k,v in pairs( player.GetAll ) do
	v:PrintMessage( HUD_PRINTCONSOLE, "\n"..ply:Nick().." Spawned ".. tostring(mdl) )
	end
	
end

function GM:PlayerSpawnVehicle(ply)

	 return false;

end

function GM:PlayerSpawnEffect(ply, mdl)

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.effects) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.effects[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= LEMON.MaxEffects(ply)) then
		
			LEMON.SendChat(ply, "You have reached your limit! (" .. LEMON.MaxEffects(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		LEMON.CreateSpawnTable(ply)
		local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
		table.insert(spawntable.effects, mdl);
		return true;
		
	end
	
end

function GM:PlayerSpawnSENT( ply, mdl, ent )

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	if(spawntable != nil) then
	
		local spawned = ply:GetNWInt("maxoletters");
		
		for k, v in pairs(spawntable.letters) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = ply:SetNWInt("maxoletters", ply:GetNWInt("maxoletters") + 1);
			
			else
			
				spawntable.letters[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= LEMON.MaxLetters(ply)) then
		
			LEMON.SendChat(ply, "You have reached your limit! (" .. LEMON.MaxLetters(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		LEMON.CreateSpawnTable(ply)
		local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
		table.insert(spawntable.letters, ent);
		return true;
		
	end
end
function GM:PlayerSpawnedRagdoll(ply, mdl, ent)

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.ragdolls, ent);
	
end

function GM:PlayerSpawnedVehicle(ply, ent)

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.vehicles, ent);
	
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)

	local spawntable = SpawnTable[LEMON.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.effects, ent);
	
end

function Admin_ExtraProps(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin extraprops \"name\" amount )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	LEMON.SetPlayerField(target, "extraprops", tonumber(args[2]));
	LEMON.SendChat( target, "Your extra props has been set to " .. args[2] .. " by " .. ply:Name());
	LEMON.SendChat( ply, target:Name() .. "'s extra prop limit has been set to " .. args[2] );
	
end

function Admin_ExtraRagdolls(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin extraragdolls \"name\" amount )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	LEMON.SetPlayerField(target, "extraragdolls", tonumber(args[2]));
	LEMON.SendChat( target, "Your extra ragdolls has been set to " .. args[2] .. " by " .. ply:Name());
	LEMON.SendChat( ply, target:Name() .. "'s extra ragdolls  has been set to " .. args[2] );
	
end

function Admin_ExtraVehicles(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin extravehicles \"name\" amount )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	LEMON.SetPlayerField(target, "extravehicles", tonumber(args[2]));
	LEMON.SendChat( target, "Your extra vehicles has been set to " .. args[2] .. " by " .. ply:Name());
	LEMON.SendChat( ply, target:Name() .. "'s extra vehicle limit has been set to " .. args[2] );
	
end

function Admin_ExtraEffects(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin extraprops \"name\" amount )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	LEMON.SetPlayerField(target, "extraeffects", tonumber(args[2]));
	LEMON.SendChat( target, "Your extra effects has been set to " .. args[2] .. " by " .. ply:Name());
	LEMON.SendChat( ply, target:Name() .. "'s extra effects limit has been set to " .. args[2] );
	
end

function Admin_ExtraLetters(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin extraletters \"name\" amount )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	LEMON.SetPlayerField(target, "extraletters", tonumber(args[2]));
	LEMON.SendChat( target, "Your extra letters has been set to " .. args[2] .. " by " .. ply:Name());
	LEMON.SendChat( ply, target:Name() .. "'s extra letters limit has been set to " .. args[2] );
	
end

function PLUGIN.Init()

	LEMON.ConVars[ "Default_Extraprops" ] = 0;
	LEMON.ConVars[ "Default_Extraragdolls" ] = 0;
	LEMON.ConVars[ "Default_Extravehicles" ] = 0;
	LEMON.ConVars[ "Default_Extraeffects" ] = 0;
	LEMON.ConVars[ "Default_Extraletters" ] = 0;
	
	LEMON.ConVars[ "PropLimit" ] = 100;
	LEMON.ConVars[ "RagdollLimit" ] = 0;
	LEMON.ConVars[ "VehicleLimit" ] = 0;
	LEMON.ConVars[ "EffectLimit" ] = 0;
	LEMON.ConVars[ "LetterLimit" ] = 3;
	
	LEMON.AddDataField( 1, "extraprops", LEMON.ConVars[ "Default_Extraprops" ] );
	LEMON.AddDataField( 1, "extraragdolls", LEMON.ConVars[ "Default_Extraragdolls" ] );
	LEMON.AddDataField( 1, "extravehicles", LEMON.ConVars[ "Default_Extravehicles" ] );
	LEMON.AddDataField( 1, "extraeffects", LEMON.ConVars[ "Default_Extraeffects" ] );
	LEMON.AddDataField( 1, "extraeffects", LEMON.ConVars[ "Default_Extraletters" ] );
	
	LEMON.AdminCommand( "extraprops", Admin_ExtraProps, "Change someones extra props limit", true, true, false );
	LEMON.AdminCommand( "extraragdolls", Admin_ExtraRagdolls, "Change someones extra ragdolls limit", true, true, false );
	LEMON.AdminCommand( "extravehicles", Admin_ExtraVehicles, "Change someones extra vehicles limit", true, true, false );
	LEMON.AdminCommand( "extraeffects", Admin_ExtraEffects, "Change someones extra effects limit", true, true, false );
	LEMON.AdminCommand( "extraletters", Admin_ExtraLetters, "Change someones extra letters limit", true, true, false );
	
end
