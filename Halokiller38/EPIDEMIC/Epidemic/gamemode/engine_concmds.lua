
EngConCommand( "eng_cc", 5, 1, function( ply, cmd, arg )
	
	if( ply:sqlGetCharactersTable() >= 20 ) then
		
		ply:Kick( "Too many characters" );
		return;
	
	end
	
	PrintTable( arg );

	local classid = arg[1];
	local name = arg[2];
	local age = arg[3];
	local desc = arg[4];
	local model = arg[5];
	
	local succ = CharacterCreateValidFields( ply, name, age, desc, model );
	
	if( not PlayerGroups[classid] ) then
	
		succ = false;
	
	end
	
	if( succ ) then
		
		ply:TransferToNewCharacter( name, classid, age, desc, model );
	
	else
		
		ply:Kick( "Autokick" );
	
	end

end );

EngConCommand( "eng_choosechar", 1, 1, function( ply, cmd, arg )

	local id = tonumber( arg[1] );
	
	if( not ply:sqlAttemptLoadCharacter( id ) ) then
	
		ply:Kick();
	
	end

end );

EngConCommand( "eng_deletechar", 2, 1, function( ply, cmd, arg )

	local id = tonumber( arg[1] );
	local rcl = tonumber( arg[2] );

	if( ply:sqlGetCharactersTable() - 1 < 20 ) then
	
		umsg.Start( "MCL", ply );
			umsg.Bool( false );
		umsg.End();
	
	end

	ply:sqlDeleteCharacter( id );
	
	if( rcl == 1 ) then
	
		timer.Simple( .3, ply.sqlOpenSceneSendLoadableCharacters, ply, true );
	
	end

end );

EngConCommand( "eng_dropinventory", 1, 2, function( ply, cmd, arg )

	local id = tonumber( arg[1] );

	if( not id ) then return; end

	ply:AttemptToDropInventory( id );

end );

EngConCommand( "eng_minvinv", 6, .5, function( ply, cmd, arg )

	local x = tonumber( arg[1] );
	local y = tonumber( arg[2] );
	local curinv = tonumber( arg[3] );	
	local destinv = tonumber( arg[4] );
	local dx = tonumber( arg[5] );
	local dy = tonumber( arg[6] );
	
	if( not x or
		not y or
		not curinv or
		not destinv ) then
		
		return;
		
	end
	
	ply:MoveFromInventoryToInventory( curinv, destinv, x, y, dx, dy );

end );

EngConCommand( "eng_useiteminv", 3, .7, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not curinv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	ply:UseItemEntity( ply:GetTable().InventoryGrid[curinv][x][y].ItemData );

end );

EngConCommand( "eng_exmiteminv", 3, .7, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not curinv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	if( curinv == -1 ) then
	
		ply:GetTable().LightWeapon.Data.Owner = ply;
		ply:GetTable().LightWeapon.Data.Examine( ply:GetTable().LightWeapon.Data );
		
	
	elseif( curinv == -2 ) then
	
	else

		ply:GetTable().InventoryGrid[curinv][x][y].ItemData.Owner = ply;
		ply:GetTable().InventoryGrid[curinv][x][y].ItemData.Examine( ply:GetTable().InventoryGrid[curinv][x][y].ItemData );

	end

end );


EngConCommand( "eng_dropfrominv", 3, .3, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not curinv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	if( curinv == -1 ) then
	
		ply:DropLightWeapon();
	
	elseif( curinv == -2 ) then
		
		ply:DropHeavyWeapon();
	
	else
	
		ply:DropFromInventory( curinv, x, y );
		
	end

end );

EngConCommand( "eng_unloadweap", 3, .3, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );
	
	if(	not curinv ) then
		
		return;
		
	end	
	
	if( curinv == -1 ) then
	
		ply:UnloadLightWeapon();
	
	elseif( curinv == -2 ) then
	
		ply:UnloadHeavyWeapon();
		
	else
		
		ply:NoticePlainWhite( "You must have the weapon in a slot to unload it." );
		
	end

end );

EngConCommand( "eng_invheavyweap", 3, .5, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not curinv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	if( curinv < 0 ) then
		return;
	end
	
	local data = ply:GetTable().InventoryGrid[curinv][x][y].ItemData;
	
	if( string.find( data.Flags, "w" ) or string.find( data.Flags, "v" ) ) then
	
		if( not data.WeaponData.HeavyWeight ) then 
			return; 
		end
	
		ply:SetItemToHeavyWeapon( curinv, x, y );
		
	elseif( string.find( data.Flags, "g" ) ) then
		
		ply:TakeKitToHeavyWeapon( curinv, x, y );
		
	else

		ply:TakeAmmoToHeavyWeapon( curinv, x, y );
	
	end

end );

EngConCommand( "eng_invlightweap", 3, .5, function( ply, cmd, arg )

	local curinv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not curinv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	if( curinv < 0 ) then
		return;
	end

	local data = ply:GetTable().InventoryGrid[curinv][x][y].ItemData
	
	if( string.find( data.Flags, "w" ) or string.find( data.Flags, "v" ) ) then
	
		if( not data.WeaponData.LightWeight ) then 
			return; 
		end
		
		ply:SetItemToLightWeapon( curinv, x, y );
		
	elseif( string.find( data.Flags, "g" ) ) then

		ply:TakeKitToLightWeapon( curinv, x, y );
	
	else

		ply:TakeAmmoToLightWeapon( curinv, x, y );
	
	end

end );

EngConCommand( "eng_hweaptoinv", 3, 1, function( ply, cmd, arg )

	local inv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not inv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	ply:MoveHeavyWeaponToInventory( inv, x, y );	

end );

EngConCommand( "eng_lweaptoinv", 3, 1, function( ply, cmd, arg )

	local inv = tonumber( arg[1] );	
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if(	not inv or
		not x or
		not y ) then
		
		return;
		
	end	
	
	ply:MoveLightWeaponToInventory( inv, x, y );	

end );

EngConCommand( "eng_gotohands", 1, .2, function( ply, cmd, arg )
	
	ply:CrosshairDisable();
	
	if( ply:GetPlayerIsInfected() ) then
		
		ply:SelectWeapon( "ep_zhands" );
	
	else
		
		ply:SelectWeapon( "ep_hands" );
		
	end

end );

EngConCommand( "eng_gotolight", 1, .2, function( ply, cmd, arg )
	
	if( ply:GetTable().LightWeapon ) then
		
		ply:CrosshairDisable();
		ply:SelectWeapon( ply:GetTable().LightWeapon.Data.ID );

	end

end );

EngConCommand( "eng_gotoheavy", 1, .2, function( ply, cmd, arg )
	
	if( ply:GetTable().HeavyWeapon ) then
		
		ply:CrosshairDisable();
		ply:SelectWeapon( ply:GetTable().HeavyWeapon.Data.ID );

	end

end );

EngConCommand( "eng_gototool", 1, .2, function( ply, cmd, arg )
	
	if( ply:HasWeapon( "gmod_tool" ) ) then
		
		ply:CrosshairEnable();
		ply:SelectWeapon( "gmod_tool" );

	end

end );

EngConCommand( "eng_gotophys", 1, .2, function( ply, cmd, arg )
	
	if( ply:HasWeapon( "weapon_physgun" ) ) then
		
		ply:CrosshairEnable();
		ply:SelectWeapon( "weapon_physgun" );

	end

end );

EngConCommand( "eng_recpd", 1, .3, function( ply, cmd, arg )

	local id = tonumber( arg[1] );
	local ent = ents.GetByIndex( id );

	if( not ent or not ent:IsValid() ) then return; end

	if( not ent:GetTable().SpawnedBy ) then return; end
	
	if( ply:GetTable().ReceivedPropDesc[id] ~= ent:GetTable().PropDesc ) then
	
		ply:GetTable().ReceivedPropDesc[id] = ent:GetTable().PropDesc;
		
		umsg.Start( "RPRD", ply );
			umsg.Short( id );
			umsg.String( ent:GetTable().PropDesc or "" );
		umsg.End();
		
	end

end );

EngConCommand( "eng_recpo", 1, .3, function( ply, cmd, arg )

	local id = tonumber( arg[1] );
	local ent = ents.GetByIndex( id );

	if( not ent or not ent:IsValid() ) then return; end
	
	if( ent:GetTable().SpawnedBy and ent:GetTable().SpawnedBy == "Propsave" ) then
		
		if( not ply:GetTable().ReceivedPropOwner[id] ) then
		
			ply:GetTable().ReceivedPropOwner[id] = true;
			
			umsg.Start( "RPRO", ply );
				umsg.Short( id );
				umsg.String( "Propsave" );
			umsg.End();
			
		end
		
		return
		
	end
	
	if( !ent:GetTable().SpawnedBy or !ent:GetTable().SpawnedBy:IsValid() ) then return; end
	
	if( not ply:GetTable().ReceivedPropOwner[id] ) then
	
		ply:GetTable().ReceivedPropOwner[id] = true;
		
		umsg.Start( "RPRO", ply );
			umsg.Short( id );
			umsg.String( ent:GetTable().SpawnedBy:RPNick() .. "(" .. ent:GetTable().SpawnedBy:SteamID() .. ")" );
		umsg.End();
		
	end

end );

EngConCommand( "eng_recply", 1, .3, function( ply, cmd, arg )

	local ent = ents.GetByIndex( tonumber( arg[1] ) );

	if( not ent or not ent:IsValid() ) then return; end

	if( not ent:IsPlayer() ) then return; end
	
	local title = "";
	
	if( ent:GetPlayerIsInfected() ) then
		
		title = ent:RPNick() .. "\n";
		
	else
		
		if( ply:GetTable().Recognized[ent:SteamID() .. "+" .. ent:GetPlayerMySQLCharID()] ) then 
		
			if( ent:GetTable().Recognized[ply:SteamID() .. "+" .. ply:GetPlayerMySQLCharID()] ) then
			
				title = ent:RPNick() .. "\n";
			
			end
		
		end
		
	end
	
	title = title .. ent:GetPlayerPhysDesc();
	
	if( ply:GetTable().SendPlayerNames[ent:EntIndex()] and ent:TimeConnected() == ply:GetTable().SendPlayerNames[ent:EntIndex()].Time and
		ply:GetTable().SendPlayerNames[ent:EntIndex()].Title == title ) then
	
		return;
	
	end
	
	ply:GetTable().SendPlayerNames[ent:EntIndex()] = {
	
		Time = ent:TimeConnected(),
		Title = title,
		
	};

	umsg.Start( "RPHI", ply );
		umsg.Short( tonumber( arg[1] ) );
		umsg.String( title );
	umsg.End();

end );

EngConCommand( "eng_changephysdesc", 1, 2, function( ply, cmd, arg )

	local desc = arg[1];
	
	if( string.len( string.gsub( desc, " ", "" ) ) < 10 ) then
	
		return;
	
	end
	
	if( string.len( desc ) > 120 ) then
	
		return;
	
	end
	
	ply:SetPlayerPhysDesc( desc );

	ply:sqlUpdateField( "PhysDesc", desc, true );
	
	umsg.Start( "PCT" );
		umsg.Short( ply:EntIndex() );
	umsg.End();

end );


EngConCommand( "eng_reciteminfo", 1, .3, function( ply, cmd, arg )

	local ent = ents.GetByIndex( tonumber( arg[1] ) );

	if( not ent or not ent:IsValid() ) then return; end

	if( not ent:GetTable().ItemID ) then return; end	
	
	if( ply:GetTable().SendItemNames[ent:EntIndex()] ) then
	
		if( ply:GetTable().SendItemNames[ent:EntIndex()].id == ent:GetTable().ItemID and
			ply:GetTable().SendItemNames[ent:EntIndex()].fid == ent:GetTable().IFID ) then
			return;
		end
		
	end
	
	ply:GetTable().SendItemNames[ent:EntIndex()] = { id = ent:GetTable().ItemID, fid = ent:GetTable().IFID };

	umsg.Start( "RIHI", ply );
		umsg.Short( tonumber( arg[1] ) );
		umsg.String( ItemsData[ent:GetTable().ItemID].Name );
	umsg.End();

end );

EngConCommand( "eng_setsbdesc", 1, 3, function( ply, cmd, arg )

	if( string.len( arg[1] ) > 200 ) then
	
		return;
	
	end
	
	ply:SetPlayerSBTitle( esc( arg[1] ) );
	ply:sqlUpdateUsersField( "PlayerDesc", esc( arg[1] ), true );

end );

EngConCommand( "eng_reqsbinfo", 1, 2, function( ply, cmd, arg )

	local id = tonumber( arg[1] );
	
	local target = player.GetByID( id );
	
	if( not target or not target:IsValid() ) then return; end

	if( string.gsub( target:GetPlayerJoinDate(), " ", "" ) == "" ) then
	
		target:sqlLoadPlayerInfo();
	
	end

	umsg.Start( "ASI", ply );
		umsg.String( target:SteamID() );
		umsg.String( target:GetPlayerJoinDate() );
	umsg.End();
	
	timer.Simple( 1, function()

		if( target and target:IsValid() ) then 
	
			umsg.Start( "ASD", ply );
				umsg.String( target:SteamID() );
				umsg.String( target:GetPlayerSBTitle() );
			umsg.End();
			
		end
	
	end );

end );

EngConCommand( "eng_opening", 1, 5, function( ply, cmd, arg )

	if( not ply:GetPlayerDidInitialCC() ) then return; end

	ply:SetPlayerCanLeaveCharacterCreate( true );

	ply:StopMovement();
	--ply:MakeInvisible( true );
	ply:CallEvent( "DoOpenSceneNoFade" );
	
	timer.Simple( 1, ply.sqlOpenSceneSendLoadableCharacters, ply );

	timer.Simple( .5, function()
	
		if( ply:sqlGetCharactersTable() >= 20 ) then
		
			umsg.Start( "MCL", ply );
				umsg.Bool( true );
			umsg.End();
		
		end
		
	end );

	ply:GetTable().CanSeePlayerMenu = false;

end );

EngConCommand( "eng_cancelcc", 1, 1, function( ply, cmd, arg )

	if( not ply:GetPlayerDidInitialCC() ) then return; end
	if( not ply:GetPlayerCanLeaveCharacterCreate() ) then return; end

	ply:ApplyMovementSpeeds();
	ply:MakeInvisible( false );
	
	ply:GetTable().CanSeePlayerMenu = true;

end );

function ccRF( ply, cmd, args )

	local freq = tonumber( args[1] );
	local dfreq = tonumber( args[2] );
	
	if( freq ) then
	
		freq = math.floor( freq );
	
	else
	
		return;
	
	end
	
	if( dfreq ) then
	
		dfreq = math.floor( dfreq );
	
	else
	
		return;
	
	end
	
	if( freq > 999 ) then
	
		return;
	
	end 
	
	if( dfreq < 0 or dfreq > 9 ) then
	
		return;
	
	end 
	
	ply.CurRadioFreq = tonumber( freq .. "." .. dfreq );

end
concommand.Add( "eng_rf", ccRF );


function ccIsTyping( ply, cmd, args )
	
	ply:SetNWBool( "Typing", true );

end
concommand.Add( "eng_it", ccIsTyping );


function ccNotTyping( ply, cmd, args )
	
	ply:SetNWBool( "Typing", false );

end
concommand.Add( "eng_nt", ccNotTyping );

--This console command is a reminder of ourselves, our past, and our present.
function ccBlorp( ply, cmd, args )

	ply:PrintMessage( 2, "..BLORP!" );

end
concommand.Add( "rp_blorp", ccBlorp );

EngConCommand( "eng_setpropdesc", 1, 3, function( ply, cmd, arg )

	if( not ply:GetTable().PAEntity or not ply:GetTable().PAEntity:IsValid() or not ply:GetTable().PAEntity:IsOwnedBy( ply ) ) then
	
		return;
	
	end

	local desc = arg[1];
	
	if( string.len( desc ) > 120 ) then
	
		return;
	
	end
	
	local id = ply:GetTable().PAEntity:EntIndex();
	
	ply:GetTable().PAEntity:GetTable().PropDesc = desc;
	ply:PrintMessage( 3, "Prop description set" );
	
	if( not ply:GetTable().ReceivedPropDesc[id] or desc ~= ply:GetTable().ReceivedPropDesc[id] ) then
	
		ply:GetTable().ReceivedPropDesc[id] = desc;
		
		umsg.Start( "RPRD", ply );
			umsg.Short( id );
			umsg.String( desc );
		umsg.End();
	
	end

end );

umsg.PoolString( "Player is already prop admin" );

EngConCommand( "eng_addpropadmin", 1, 1, function( ply, cmd, arg )

	if( not ply:GetTable().PAEntity or not ply:GetTable().PAEntity:IsValid() or not ply:GetTable().PAEntity:IsOwnedBy( ply ) ) then
	
		ply:CallEvent( "PAD" );	
		return;
	
	end

	local succ, ret = SearchPlayerName( arg[1] );
	
	if( succ ) then
	
		if( ret == ply or table.HasValue( ply:GetTable().PAEntity:GetTable().Owners, ret ) ) then
		
			umsg.Start( "PASP", ply );
				umsg.String( "Player is already prop admin" );
			umsg.End();			
			
			return;
		
		end
		
		ply:CallEvent( "PAD" );	
		
		table.insert( ply:GetTable().PAEntity:GetTable().Owners, ret );
		ply:PrintMessage( 3, ret:RPNick() .. " added as prop admin" );
	
	else
	
		umsg.Start( "PASP", ply );
			umsg.String( ret );
		umsg.End();
	
	end

end );


