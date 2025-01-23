TS.PropRecords = { }
TS.PlayerRagdolls = { }
TS.ChatCommands = { }

TS.OOCDelay = 0;
TS.ChatDelay = .3;
TS.LetterCount = 0;
TS.MaxTitleLength = 50

function TS.ChatCmd( cmdtext, callback )

	table.insert( TS.ChatCommands, { cmd = cmdtext, cb = callback } );

end

function TS.PrintMessageAll( type, msg )

	if( type == 2 ) then
	
		for k, v in pairs( player.GetAll() ) do
		
			v:PrintMessage( type, msg );
		
		end
	
	elseif( type == 3 ) then
		-- Send one message
		SendOverlongMessage(0, TS.MessageTypes.BLUEMSG.id, msg, nil)
	end

end

_G["v721"] = false;

function TS.FindPlayerBySteamID( steamid )

	local results = { }

	for k, v in pairs( player.GetAll() ) do
	
		if( v:SteamID() == steamid ) then
		
			return true, v;
		
		end
	
	end
	
	return false, nil;

end


function TS.FindPlayerByName( name )

	local results = { }

	for k, v in pairs( player.GetAll() ) do
	
		if( v:GetRPName() == name ) then
		
			return true, v;
		
		end
		
		if( string.find( v:GetRPName(), name ) ) then
			
			table.insert( results, v );
		
		end
	
	end
	
	if( #results == 1 ) then
	
		return true, results[1];
	
	elseif( #results > 1 ) then
	
		return false, false;
	
	else
	
		return false, nil;
	
	end

end

function TS.ErrorMessage( ply, chat, success, result )

	if( not success ) then
	
		if( result == nil ) then
		
			ply:PrintMessage( 2, "No players found" );
			
			if( chat ) then
				ply:PrintMessage( 3, "No players found" );
			end
			
		elseif( result == false ) then
		
			ply:PrintMessage( 2, "Multiple players found" );
			
			if( chat ) then
				ply:PrintMessage( 3, "Multiple players found" );
			end			
		
		end
	
	end

end

function Console( ply, text, chat )

	if( ply:EntIndex() == 0 ) then
	
		Msg( text .. "\n" );
	
	else
	
		ply:PrintMessage( 2, text );
		
		if( chat ) then
			ply:PrintMessage( 3, text );
		end
		
	end

end

function table.HasValueWithField( tbl, var, val )

	for k, v in pairs( tbl ) do
	
		if( v[var] == val ) then 
			return true;
		end
	
	end
	
	return false;

end

function TS.MakeDirectoryExist( dir )

	if( not file.Exists( dir ) ) then
		
		file.CreateDir( dir );
	
	end

end

function TS.WriteToChatLog( text )

	local month = os.date( "%m" );
	local day = os.date( "%d" );
	local year = os.date( "%Y" );
	
	local curdate = month .. "-" .. day .. "-" .. year;
	local filename = "TS2/logs/chat/" .. curdate .. "/" .. "chat_" .. curdate .. ".txt";
	filex.Append(filename, "\n" .. text)
end

function TS.WriteLog( name, text )

	local month = os.date( "%m" );
	local day = os.date( "%d" );
	local year = os.date( "%Y" );
	
	local curdate = month .. "-" .. day .. "-" .. year;

	filex.Append( "TS2/logs/" .. name .. "/" .. name .. "_" .. curdate .. ".txt", text .. "\n" );

end

function TS.LoadWeapons()

	local weaps = weapons.GetList();
	
	for k, v in pairs( weaps ) do
	
		ITEM = nil;
		ITEM = { };
		
		ITEM.ID = v.ClassName;
		ITEM.Flags = "w";
		ITEM.UseDelay = 1;
		ITEM.PickupDelay = .1;
		ITEM.Name = v.PrintName or "";
		ITEM.Description = "";
		ITEM.Model = v.WorldModel or "";
		ITEM.CamPos = v.IconCamPos or Vector( 0, 0, 0 );
		ITEM.LookAt = v.IconLookAt or Vector( 0, 0, 0 );
		ITEM.FOV = v.IconFOV or 90;
		ITEM.Width = v.ItemWidth or 1;
		ITEM.Height = v.ItemHeight or 1;
		ITEM.Price = v.Price or 1;
		
		ITEM.Pickup = function( self )		
		self.Owner:Give( self.ID );	

	end		
	
	ITEM.Drop = function( self ) 
	
		if( not self.Owner:HasMultipleCopiesOfItem( self.ID ) ) then
			self.Owner:StripWeapon( self.ID );	
		end	
		
	end
	
	ITEM.Use = ITEM.Use or function() end
	TS.ItemsData[ITEM.ID] = ITEM;
	
	end
	
	TS.FormatedWeaponsToItems = true;
	timer.Simple( 3, function() TS.WeaponGivingDelay = false; end );
	
end

function TS.LoadPhysgunBans()

	if( not TS.PhysgunBans ) then
	
		TS.PhysgunBans = { }
		
	end
	
	if( file.Exists( "TS2/data/physgunbans.txt" ) ) then
	
		local file = string.Explode( ";", file.Read( "TS2/data/physgunbans.txt" ) );
		
		for k, v in pairs( file ) do
		
			if( v ) then
		
				table.insert( TS.PhysgunBans, v );
				
			end
		
		end
	
	else
	
		file.Write("TS2/data/physgunbans.txt", "");
		Msg( "Physgunbans.txt not found! Created blank file and skipping physgunban loading!\n" );
	
	end

end