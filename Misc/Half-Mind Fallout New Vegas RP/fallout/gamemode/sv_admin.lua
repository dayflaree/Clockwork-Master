local function Kick( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local reason = args[2] or "";
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nKicked" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
			net.WriteString( reason );
		net.Send( ply );
		
		GAMEMODE:Log( "admin", "K", ply:Nick() .. " kicked " .. targ:Nick() .. " (" .. reason .. ").", ply );
		
		if( reason == "" ) then
			
			targ:Kick( "Kicked by " .. ply:Nick() );
			
		else
			
			targ:Kick( "Kicked by " .. ply:Nick() .. ": " .. reason );
			
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_kick", Kick );

local function Ban( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoDuration" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local duration = math.Round( tonumber( args[2] ) ) or 5;
	local reason = args[3] or "";
	
	if( duration < 0 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nBanned" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
			net.WriteFloat( duration );
			net.WriteString( reason );
		net.Send( ply );
		
		GAMEMODE:AddBan( targ:SteamID(), duration * 60, reason );
		
		GAMEMODE:Log( "admin", "B", ply:Nick() .. " banned " .. targ:Nick() .. " for " .. duration .. " minutes (" .. reason .. ").", ply );
		
		if( reason == "" ) then
			
			if( duration == 0 ) then
				
				targ:Kick( "Permabanned by " .. ply:Nick() );
				
			else
				
				targ:Kick( "Banned for " .. duration .. " minutes by " .. ply:Nick() );
				
			end
			
		else
			
			if( duration == 0 ) then
				
				targ:Kick( "Permabanned by " .. ply:Nick() .. ": " .. reason );
				
			else
				
				targ:Kick( "Banned for " .. duration .. " minutes by " .. ply:Nick() .. ": " .. reason );
				
			end
			
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_ban", Ban );

local function Goto( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
	
		local equipped = {}; -- MAKE A HELPER FUNC FOR THIS
		
		for k,v in pairs( ply.Inventory ) do
		
			if( v.Equipped and v.Headgear ) then
			
				equipped[#equipped + 1] = v.Class;
				
			end
			
		end
		
		ply:SetPos( targ:GetPos() );
		net.Start( "nCharacterUpdateModel" ); -- we might be teleporting from outside pvs WRITE A HELPER FUNC FOR THIS ^^^
			net.WriteEntity( ply );
			net.WriteString( ply:GetModel() );
			net.WriteTable( equipped );
		net.SendPVS( ply:GetPos() );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_goto", Goto );

local function Bring( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
	
		local equipped = {};
		
		for k,v in pairs( targ.Inventory ) do
		
			if( v.Equipped and v.Headgear ) then -- change from headgear to bonemergemodel
			
				equipped[#equipped + 1] = v.Class;
				
			end
			
		end
		
		targ:SetPos( ply:GetPos() );
		net.Start( "nCharacterUpdateModel" ); -- we might be teleporting from outside pvs
			net.WriteEntity( targ );
			net.WriteString( targ:GetModel() );
			net.WriteTable( equipped );
		net.SendPVS( targ:GetPos() );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_bring", Bring );

local function SetPhysTrust( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( val != 0 and val != 1 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetPhysTrust" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteFloat( val );
		net.Send( { targ, ply } );
		
		targ:SetPhysTrust( tobool( val ) );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s phystrust to " .. tostring( val ) .. ".", ply );
		
		if( tobool( val ) ) then
			
			targ:Give( "weapon_physgun" );
			
		else
			
			targ:StripWeapon( "weapon_physgun" );
			
		end
		
		targ:UpdatePlayerField( "PhysTrust", tostring( val ) );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setphystrust", SetPhysTrust );

local function SetToolTrust( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( val != 0 and val != 1 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetToolTrust" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteFloat( val );
		net.Send( { targ, ply } );
		
		targ:SetToolTrust( tobool( val ) );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s tooltrust to " .. tostring( val ) .. ".", ply );
		
		if( tobool( val ) ) then
			
			targ:Give( "gmod_tool" );
			
		else
			
			targ:StripWeapon( "gmod_tool" );
			
		end
		
		targ:UpdatePlayerField( "ToolTrust", tostring( val ) );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_settooltrust", SetToolTrust );

local function SetCharCreateFlags( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = string.lower( args[2] );
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetCharCreateFlags" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteString( val );
		net.Send( { targ, ply } );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s charcreate flags to " .. tostring( val ) .. ".", ply );
		
		targ:SetCharCreateFlags( val );
		targ:UpdatePlayerField( "CharCreateFlags", val );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setcharcreateflags", SetCharCreateFlags );

local function SetPACAccess( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( targ and targ:IsValid() ) then
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s PAC Access to " .. tostring( val ) .. ".", ply );
		
		targ:SetHasPAC( tobool( val ) );
		targ:UpdatePlayerField( "HasPAC", val );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setpacaccess", SetPACAccess );

local function CreateItem( ply, cmd, args )
	
	if( !args[1] ) then
		
		net.Start( "nItemsList" );
			net.WriteString( "" );
		net.Send( ply );
		return;
		
	end
	
	if( !GAMEMODE:GetMetaItem( args[1] ) ) then
		
		net.Start( "nItemsList" );
			net.WriteString( args[1] );
		net.Send( ply );
		return;
		
	end
	
	if( args[1] == "caps" ) then return end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), args[1] );
	
	GAMEMODE:Log( "admin", "I", ply:Nick() .. " created item " .. args[1] .. ".", ply );
	
end
concommand.AddAdmin( "rpa_createitem", CreateItem );

local function CreateMoney( ply, cmd, args )
	
	if( !args[1] ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), "caps", { Caps = args[1] } );
	
	GAMEMODE:Log( "admin", "I", ply:Nick() .. " created " .. args[1] .. " bottlecaps.", ply );
	
end
concommand.AddAdmin( "rpa_createmoney", CreateMoney );

local function SetFactionSpawnPos( ply, cmd, args )

	if( !args[1] ) then 
	
		net.Start( "nNotify" );
			net.WriteColor( Color( 255, 0, 0 ) );
			net.WriteFloat( 3 );
			net.WriteString( "Infected.ChatNormal" );
			net.WriteString( "Please specify faction: SURVIVOR = 1, SUPERMUTANT = 2" );
		net.Send( ply );
		return;
	
	end;
	
	GAMEMODE.FactionSpawns[args[1]] = ply:GetEyeTraceNoCursor().HitPos;
	GAMEMODE:SaveFactionSpawns();
	
	GAMEMODE:Log( "admin", "P", ply:Nick() .. " set faction " .. args[1] .. "'s spawn position to " .. tostring( ply:GetEyeTraceNoCursor().HitPos ) .. ".", ply );

end
concommand.AddAdmin( "rpa_setfactionspawnpos", SetFactionSpawnPos );

local function SetPlayerModel( ply, cmd, args )

	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = string.lower( args[2] );
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetPlayerModel" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteString( val );
		net.Send( { targ, ply } );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s model to " .. tostring( val ) .. ".", ply );
		
		targ:SetModel( val );
		targ:UpdateCharacterField( "Model", val );
		
		if( targ:PlayerClass() == PLAYERCLASS_SURVIVOR ) then
		
			net.Start( "nCharacterUpdateModel" );
				net.WriteEntity( targ );
				net.WriteString( val );
			net.Broadcast();
		
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end

end
concommand.AddAdmin( "rpa_setmodel", SetPlayerModel );

 local function SetAdmin( ply, cmd, args )

	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local rank = string.lower( args[2] );
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetAdmin" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
			net.WriteString( rank );
		net.Send( { ply, targ } );
		
		GAMEMODE:Log( "admin", "RANK", ply:Nick() .. " set " .. targ:Nick() .. "'s rank to " .. rank .. ".", ply );
		
		targ:SetUserGroup( rank );
		
		if( rank == "superadmin" ) then -- should write a helper function for this.

			targ:SetSuperAdmin( true );
			targ:UpdatePlayerField( "SuperAdmin", 1 );
			
		elseif( rank == "admin" ) then
		
			targ:SetAdmin( true );
			targ:UpdatePlayerField( "Admin", 1 );
		
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setadmin", SetAdmin, true );

local function TakeAdmin( ply, cmd, args )

	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nTakeAdmin" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
		net.Send( { ply, targ } );
		
		GAMEMODE:Log( "admin", "RANK", ply:Nick() .. " took " .. targ:Nick() .. "'s rank.", ply );
		
		targ:SetUserGroup( "user" );
		targ:UpdatePlayerField( "SuperAdmin", 0 );
		targ:UpdatePlayerField( "Admin", 0 );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_takeadmin", TakeAdmin, true );


local function ClearHeads( ply, cmd, args )

	for _,v in pairs( player.GetAll() ) do
	
		net.Start("nCharacterRemoveAllMdl")
			net.WriteEntity(v)
		net.Broadcast()
	
	end
	
end
concommand.AddAdmin( "rpa_clearheads", ClearHeads, true );

local function UpdateModel( ply, cmd, args )

	for _,v in pairs( player.GetAll() ) do
	
		local equipped = {};
		
		if( !v.Inventory ) then continue end
		
		for m,n in pairs( v.Inventory ) do
		
			if( n.Equipped and n.Headgear ) then
			
				equipped[#equipped + 1] = v.Class;
				
			end
			
		end
	
		net.Start( "nCharacterUpdateModel" );
			net.WriteEntity( v );
			net.WriteString( v:GetModel() );
			net.WriteTable( equipped );
		net.Broadcast();
	
	end
	
end
concommand.AddAdmin( "rpa_updatemodels", UpdateModel, true );

local function ForcePlayerSync( ply, cmd, args )

	for _,v in pairs( player.GetAll() ) do
	
		v:SyncOtherPlayers()
		
	end

end
concommand.AddAdmin( "rpa_forceplayersync", ForcePlayerSync, true );

local function SetPersist( ply, cmd, args )

	local bool;
	local ent = ply:GetEyeTraceNoCursor().Entity;
	
	if( args[1] ) then
	
		bool = tobool( args[1] );
		
	else
	
		bool = !ent:GetPersistent();
		
	end
	
	if( IsValid( ent ) ) then

		ent:SetPersistent( bool );
	
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set a prop's persistance to " .. tostring( bool ) .. ".", ply );
		
	end

end
concommand.AddAdmin( "rpa_setpersist", SetPersist );

local function SetIsTrader( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( val != 0 and val != 1 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		targ:SetIsTrader( tobool( val ) );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s tooltrust to " .. tostring( val ) .. ".", ply );
		
		targ:UpdateCharacterField( "IsTrader", tostring( val ) );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_settrader", SetIsTrader );